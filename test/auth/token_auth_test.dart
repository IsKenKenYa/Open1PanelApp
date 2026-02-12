/// Token认证机制白盒测试
///
/// 测试1Panel自定义Token的生成和验证机制
/// Token格式: md5('1panel' + API-Key + UnixTimestamp)

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import '../test_helper.dart';

void main() {
  group('Token认证机制测试', () {
    late String testApiKey;
    late int testTimestamp;

    setUp(() {
      testApiKey = 'test_api_key_12345';
      testTimestamp = 1704067200; // 2024-01-01 00:00:00 UTC
    });

    group('Token生成测试', () {
      test('应该正确生成Token格式', () {
        // 手动计算期望的Token
        final expectedData = '1panel$testApiKey$testTimestamp';
        final expectedBytes = utf8.encode(expectedData);
        final expectedDigest = md5.convert(expectedBytes);
        final expectedToken = expectedDigest.toString();

        // 使用TokenGenerator生成
        final generatedToken = TokenGenerator.generateToken(testApiKey, testTimestamp);

        expect(generatedToken, equals(expectedToken));
        expect(generatedToken.length, equals(32));
        expect(RegExp(r'^[a-f0-9]{32}$').hasMatch(generatedToken), isTrue);
      });

      test('相同输入应该生成相同Token', () {
        final token1 = TokenGenerator.generateToken(testApiKey, testTimestamp);
        final token2 = TokenGenerator.generateToken(testApiKey, testTimestamp);

        expect(token1, equals(token2));
      });

      test('不同时间戳应该生成不同Token', () {
        final token1 = TokenGenerator.generateToken(testApiKey, testTimestamp);
        final token2 = TokenGenerator.generateToken(testApiKey, testTimestamp + 1);

        expect(token1, isNot(equals(token2)));
      });

      test('不同API密钥应该生成不同Token', () {
        final token1 = TokenGenerator.generateToken(testApiKey, testTimestamp);
        final token2 = TokenGenerator.generateToken('different_key', testTimestamp);

        expect(token1, isNot(equals(token2)));
      });

      test('空API密钥应该生成有效Token', () {
        final token = TokenGenerator.generateToken('', testTimestamp);

        expect(token.length, equals(32));
        expect(TokenGenerator.validateTokenFormat(token), isTrue);
      });
    });

    group('认证头生成测试', () {
      test('应该生成包含Token和Timestamp的头信息', () {
        final headers = TokenGenerator.generateAuthHeaders(testApiKey);

        expect(headers.containsKey('1Panel-Token'), isTrue);
        expect(headers.containsKey('1Panel-Timestamp'), isTrue);
        expect(headers['1Panel-Token']?.length, equals(32));
        expect(int.tryParse(headers['1Panel-Timestamp']!), isNotNull);
      });

      test('生成的Timestamp应该是当前时间', () {
        final beforeTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        final headers = TokenGenerator.generateAuthHeaders(testApiKey);
        final afterTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;

        final timestamp = int.parse(headers['1Panel-Timestamp']!);

        expect(timestamp, greaterThanOrEqualTo(beforeTime));
        expect(timestamp, lessThanOrEqualTo(afterTime));
      });

      test('多次调用应该生成不同的Timestamp', () async {
        final headers1 = TokenGenerator.generateAuthHeaders(testApiKey);
        await Future.delayed(Duration(milliseconds: 1100)); // 等待1秒以上
        final headers2 = TokenGenerator.generateAuthHeaders(testApiKey);

        final timestamp1 = int.parse(headers1['1Panel-Timestamp']!);
        final timestamp2 = int.parse(headers2['1Panel-Timestamp']!);

        expect(timestamp2, greaterThan(timestamp1));
      });
    });

    group('Token格式验证测试', () {
      test('有效的32位十六进制字符串应该通过验证', () {
        expect(TokenGenerator.validateTokenFormat('a1b2c3d4e5f6789012345678abcdef00'), isTrue);
        expect(TokenGenerator.validateTokenFormat('12345678901234567890123456789012'), isTrue);
        expect(TokenGenerator.validateTokenFormat('abcdefabcdefabcdefabcdefabcdefab'), isTrue);
      });

      test('非32位字符串应该验证失败', () {
        expect(TokenGenerator.validateTokenFormat(''), isFalse);
        expect(TokenGenerator.validateTokenFormat('short'), isFalse);
        expect(TokenGenerator.validateTokenFormat('a' * 31), isFalse);
        expect(TokenGenerator.validateTokenFormat('a' * 33), isFalse);
      });

      test('包含非十六进制字符应该验证失败', () {
        expect(TokenGenerator.validateTokenFormat('g1b2c3d4e5f6789012345678abcdef00'), isFalse);
        expect(TokenGenerator.validateTokenFormat('A1B2C3D4E5F6789012345678ABCDEF00'), isFalse); // 大写
        expect(TokenGenerator.validateTokenFormat('a1b2c3d4e5f6789012345678abcde!00'), isFalse);
        expect(TokenGenerator.validateTokenFormat('a1b2c3d4e5f6789012345678abcdef 0'), isFalse);
      });
    });

    group('边界条件测试', () {
      test('超长API密钥应该正常工作', () {
        final longKey = 'a' * 1000;
        final token = TokenGenerator.generateToken(longKey, testTimestamp);

        expect(token.length, equals(32));
        expect(TokenGenerator.validateTokenFormat(token), isTrue);
      });

      test('特殊字符API密钥应该正常工作', () {
        final specialKey = '!@#\$%^&*()_+-=[]{}|;:,.<>?';
        final token = TokenGenerator.generateToken(specialKey, testTimestamp);

        expect(token.length, equals(32));
        expect(TokenGenerator.validateTokenFormat(token), isTrue);
      });

      test('Unicode字符API密钥应该正常工作', () {
        final unicodeKey = '测试密钥🔐日本語';
        final token = TokenGenerator.generateToken(unicodeKey, testTimestamp);

        expect(token.length, equals(32));
        expect(TokenGenerator.validateTokenFormat(token), isTrue);
      });

      test('零时间戳应该生成有效Token', () {
        final token = TokenGenerator.generateToken(testApiKey, 0);

        expect(token.length, equals(32));
        expect(TokenGenerator.validateTokenFormat(token), isTrue);
      });

      test('未来时间戳应该生成有效Token', () {
        final futureTimestamp = 4102444800; // 2100-01-01
        final token = TokenGenerator.generateToken(testApiKey, futureTimestamp);

        expect(token.length, equals(32));
        expect(TokenGenerator.validateTokenFormat(token), isTrue);
      });
    });

    group('安全性测试', () {
      test('相同API密钥不同时间戳的Token应该完全不同', () {
        final tokens = <String>{};

        for (int i = 0; i < 100; i++) {
          final token = TokenGenerator.generateToken(testApiKey, testTimestamp + i);
          tokens.add(token);
        }

        // 所有100个Token都应该是唯一的
        expect(tokens.length, equals(100));
      });

      test('Token应该对输入敏感（雪崩效应）', () {
        final baseToken = TokenGenerator.generateToken(testApiKey, testTimestamp);

        // 修改API密钥的一个字符
        final modifiedKey = testApiKey.substring(0, testApiKey.length - 1) +
            (testApiKey.codeUnitAt(testApiKey.length - 1) == 97 ? 'b' : 'a');
        final modifiedToken = TokenGenerator.generateToken(modifiedKey, testTimestamp);

        // 两个Token应该完全不同
        int diffCount = 0;
        for (int i = 0; i < 32; i++) {
          if (baseToken[i] != modifiedToken[i]) diffCount++;
        }

        // 至少有一半的字符不同
        expect(diffCount, greaterThan(16));
      });
    });

    group('实际验证逻辑测试', () {
      test('模拟服务器端验证应该通过', () {
        // 客户端生成Token
        final headers = TokenGenerator.generateAuthHeaders(testApiKey);
        final token = headers['1Panel-Token']!;
        final timestamp = headers['1Panel-Timestamp']!;

        // 服务器端验证
        final expectedToken = TokenGenerator.generateToken(testApiKey, int.parse(timestamp));

        expect(token, equals(expectedToken));
      });

      test('错误的Token应该验证失败', () {
        final headers = TokenGenerator.generateAuthHeaders(testApiKey);
        final wrongToken = headers['1Panel-Token']!.substring(0, 31) + 'x';
        final timestamp = headers['1Panel-Timestamp']!;

        final expectedToken = TokenGenerator.generateToken(testApiKey, int.parse(timestamp));

        expect(wrongToken, isNot(equals(expectedToken)));
      });

      test('错误的时间戳应该验证失败', () {
        final headers = TokenGenerator.generateAuthHeaders(testApiKey);
        final token = headers['1Panel-Token']!;
        final wrongTimestamp = (int.parse(headers['1Panel-Timestamp']!) + 1).toString();

        final expectedToken = TokenGenerator.generateToken(testApiKey, int.parse(wrongTimestamp));

        expect(token, isNot(equals(expectedToken)));
      });
    });
  });
}
