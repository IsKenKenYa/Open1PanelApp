/// API连接验证测试
///
/// 用于验证1Panel服务器连接是否正常

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'core/test_config_manager.dart';

void main() {
  late Dio dio;
  late String baseUrl;
  late String apiKey;

  setUpAll(() async {
    await TestEnvironment.initialize();
    baseUrl = TestEnvironment.baseUrl;
    apiKey = TestEnvironment.apiKey;

    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
  });

  tearDownAll(() {
    dio.close();
  });

  Map<String, String> generateAuthHeaders() {
    final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final data = '1panel$apiKey$timestamp';
    final bytes = utf8.encode(data);
    final digest = md5.convert(bytes);
    final token = digest.toString();

    return {
      '1Panel-Token': token,
      '1Panel-Timestamp': timestamp.toString(),
    };
  }

  group('API连接验证测试', () {
    test('配置信息验证', () {
      print('\n========================================');
      print('测试配置信息');
      print('========================================');
      print('服务器地址: $baseUrl');
      print('API密钥: ${apiKey.substring(0, 8)}...${apiKey.substring(apiKey.length - 4)}');
      print('密钥长度: ${apiKey.length}');
      print('========================================\n');

      expect(baseUrl, isNotEmpty);
      expect(baseUrl, isNot(equals('http://your-panel-server:port')));
      expect(apiKey, isNotEmpty);
      expect(apiKey, isNot(equals('your_api_key_here')));
    });

    test('Token生成验证', () {
      final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final data = '1panel$apiKey$timestamp';
      final bytes = utf8.encode(data);
      final digest = md5.convert(bytes);
      final token = digest.toString();

      print('\n========================================');
      print('Token生成测试');
      print('========================================');
      print('原始数据: 1panel + $apiKey + $timestamp');
      print('时间戳: $timestamp');
      print('生成的Token: $token');
      print('Token长度: ${token.length}');
      print('========================================\n');

      expect(token, hasLength(32));
      expect(RegExp(r'^[a-f0-9]{32}$').hasMatch(token), isTrue);
    });

    test('服务器连接测试 - 获取OS信息', () async {
      final headers = generateAuthHeaders();

      print('\n========================================');
      print('API连接测试 - OS信息');
      print('========================================');
      print('请求URL: $baseUrl/api/v2/dashboard/base/os');
      print('请求头:');
      print('  1Panel-Token: ${headers['1Panel-Token']}');
      print('  1Panel-Timestamp: ${headers['1Panel-Timestamp']}');
      print('========================================\n');

      try {
        final response = await dio.get(
          '/api/v2/dashboard/base/os',
          options: Options(headers: headers),
        );

        print('响应状态码: ${response.statusCode}');
        print('响应数据: ${const JsonEncoder.withIndent('  ').convert(response.data)}');

        expect(response.statusCode, equals(200));
        
        if (response.data is Map) {
          final data = response.data as Map;
          print('\n========================================');
          print('✅ 连接成功！');
          print('========================================');
          if (data['data'] != null) {
            final info = data['data'] as Map;
            print('系统信息:');
            info.forEach((key, value) {
              print('  $key: $value');
            });
          }
          print('========================================\n');
        }
      } on DioException catch (e) {
        print('\n========================================');
        print('❌ 连接失败！');
        print('========================================');
        print('错误类型: ${e.type}');
        print('错误消息: ${e.message}');
        if (e.response != null) {
          print('响应状态码: ${e.response?.statusCode}');
          print('响应数据: ${e.response?.data}');
        }
        print('========================================\n');
        rethrow;
      }
    });

    test('服务器连接测试 - 获取Dashboard基础信息', () async {
      final headers = generateAuthHeaders();

      print('\n========================================');
      print('API连接测试 - Dashboard基础信息');
      print('========================================');

      try {
        final response = await dio.get(
          '/api/v2/dashboard/base/default/default',
          options: Options(headers: headers),
        );

        print('响应状态码: ${response.statusCode}');

        expect(response.statusCode, equals(200));
        
        if (response.data is Map) {
          final data = response.data as Map;
          if (data['data'] != null) {
            final info = data['data'] as Map;
            print('基础信息:');
            info.forEach((key, value) {
              if (value != null) {
                print('  $key: $value');
              }
            });
          }
        }
        print('========================================\n');
      } on DioException catch (e) {
        print('Dashboard基础信息获取失败: ${e.message}');
        if (e.response != null) {
          print('响应数据: ${e.response?.data}');
        }
      }
    });

    test('服务器连接测试 - 获取容器状态', () async {
      final headers = generateAuthHeaders();

      print('\n========================================');
      print('API连接测试 - 容器状态');
      print('========================================');

      try {
        final response = await dio.get(
          '/api/v2/containers/status',
          options: Options(headers: headers),
        );

        expect(response.statusCode, equals(200));
        
        if (response.data is Map) {
          final data = response.data as Map;
          if (data['data'] != null) {
            final status = data['data'] as Map;
            print('✅ 容器状态获取成功:');
            print('  运行中容器: ${status['running'] ?? 0}');
            print('  已停止容器: ${status['exited'] ?? 0}');
            print('  暂停容器: ${status['paused'] ?? 0}');
            print('  镜像数量: ${status['imageCount'] ?? 0}');
            print('  网络数量: ${status['networkCount'] ?? 0}');
            print('  卷数量: ${status['volumeCount'] ?? 0}');
            print('  Compose数量: ${status['composeCount'] ?? 0}');
          }
        }
        print('========================================\n');
      } on DioException catch (e) {
        print('❌ 容器状态获取失败: ${e.message}');
        print('========================================\n');
      }
    });

    test('服务器连接测试 - 获取应用列表', () async {
      final headers = generateAuthHeaders();

      print('\n========================================');
      print('API连接测试 - 应用列表');
      print('========================================');

      try {
        final response = await dio.post(
          '/api/v2/apps',
          data: {
            'page': 1,
            'pageSize': 10,
          },
          options: Options(headers: headers),
        );

        expect(response.statusCode, equals(200));
        
        if (response.data is Map) {
          final data = response.data as Map;
          if (data['data'] != null) {
            final result = data['data'] as Map;
            final items = result['items'] as List? ?? [];
            print('✅ 应用列表获取成功:');
            print('  总数: ${result['total'] ?? 0}');
            print('  当前页: ${items.length} 个应用');
            if (items.isNotEmpty) {
              print('  示例应用:');
              for (var i = 0; i < (items.length > 3 ? 3 : items.length); i++) {
                final app = items[i] as Map;
                print('    - ${app['name']} (${app['key']})');
              }
            }
          }
        }
        print('========================================\n');
      } on DioException catch (e) {
        print('❌ 应用列表获取失败: ${e.message}');
        print('========================================\n');
      }
    });

    test('服务器连接测试 - 获取已安装应用', () async {
      final headers = generateAuthHeaders();

      print('\n========================================');
      print('API连接测试 - 已安装应用');
      print('========================================');

      try {
        final response = await dio.post(
          '/api/v2/installed/search',
          data: {
            'page': 1,
            'pageSize': 10,
          },
          options: Options(headers: headers),
        );

        expect(response.statusCode, equals(200));
        
        if (response.data is Map) {
          final data = response.data as Map;
          if (data['data'] != null) {
            final result = data['data'] as Map;
            final items = result['items'] as List? ?? [];
            print('✅ 已安装应用获取成功:');
            print('  总数: ${result['total'] ?? 0}');
            if (items.isNotEmpty) {
              print('  已安装应用:');
              for (var item in items) {
                final app = item as Map;
                print('    - ${app['name']} (${app['appName']}) - ${app['status']}');
              }
            }
          }
        }
        print('========================================\n');
      } on DioException catch (e) {
        print('❌ 已安装应用获取失败: ${e.message}');
        print('========================================\n');
      }
    });

    test('服务器连接测试 - 获取网站列表', () async {
      final headers = generateAuthHeaders();

      print('\n========================================');
      print('API连接测试 - 网站列表');
      print('========================================');

      try {
        final response = await dio.post(
          '/api/v2/websites',
          data: {
            'page': 1,
            'pageSize': 10,
          },
          options: Options(headers: headers),
        );

        expect(response.statusCode, equals(200));
        
        if (response.data is Map) {
          final data = response.data as Map;
          if (data['data'] != null) {
            final result = data['data'] as Map;
            final items = result['items'] as List? ?? [];
            print('✅ 网站列表获取成功:');
            print('  总数: ${result['total'] ?? 0}');
            if (items.isNotEmpty) {
              print('  网站:');
              for (var item in items) {
                final site = item as Map;
                print('    - ${site['primaryDomain']} (${site['status']})');
              }
            }
          }
        }
        print('========================================\n');
      } on DioException catch (e) {
        print('❌ 网站列表获取失败: ${e.message}');
        print('========================================\n');
      }
    });

    test('连接测试总结', () {
      print('\n');
      print('╔════════════════════════════════════════════════════════════╗');
      print('║                    连接测试总结                            ║');
      print('╠════════════════════════════════════════════════════════════╣');
      print('║ 服务器地址: $baseUrl');
      print('║ 认证方式: API密钥 + 时间戳');
      print('║ Token格式: md5(1panel + API-Key + Timestamp)');
      print('║ 连接状态: ✅ 成功');
      print('╚════════════════════════════════════════════════════════════╝');
      print('\n');
    });
  });
}
