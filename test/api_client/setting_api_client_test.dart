import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import '../api_client_test_base.dart';
import '../core/test_config_manager.dart';
import 'package:onepanelapp_app/api/v2/setting_v2.dart';
import 'package:onepanelapp_app/core/network/dio_client.dart';
import 'package:onepanelapp_app/data/models/setting_models.dart';

void main() {
  late DioClient client;
  late SettingV2Api api;
  bool hasApiKey = false;

  setUpAll(() async {
    await TestEnvironment.initialize();
    hasApiKey = TestEnvironment.apiKey.isNotEmpty && TestEnvironment.apiKey != 'your_api_key_here';
    
    if (hasApiKey) {
      client = DioClient(
        baseUrl: TestEnvironment.baseUrl,
        apiKey: TestEnvironment.apiKey,
      );
      api = SettingV2Api(client);
    }
  });

  group('Setting API客户端测试', () {
    test('配置验证 - API密钥已配置', () {
      debugPrint('\n========================================');
      debugPrint('Setting API测试配置');
      debugPrint('========================================');
      debugPrint('服务器地址: ${TestEnvironment.baseUrl}');
      debugPrint('API密钥: ${hasApiKey ? "已配置" : "未配置"}');
      debugPrint('========================================\n');
      
      expect(hasApiKey, isTrue, reason: 'API密钥应该已配置');
    });

    group('getSystemSettings - 获取系统设置', () {
      test('应该成功获取系统设置', () async {
        if (!hasApiKey) {
          debugPrint('⚠️  跳过测试: API密钥未配置');
          return;
        }

        final response = await api.getSystemSettings();

        expect(response.statusCode, equals(200));
        expect(response.data, isNotNull);
        expect(response.data, isA<SettingInfo>());

        debugPrint('\n========================================');
        debugPrint('✅ 系统设置测试成功');
        debugPrint('========================================');
        debugPrint('系统设置已获取');
        debugPrint('========================================\n');
      });
    });

    group('getTerminalSettings - 获取终端设置', () {
      test('应该成功获取终端设置', () async {
        if (!hasApiKey) {
          debugPrint('⚠️  跳过测试: API密钥未配置');
          return;
        }

        final response = await api.getTerminalSettings();

        expect(response.statusCode, equals(200));
        expect(response.data, isNotNull);
        expect(response.data, isA<TerminalInfo>());

        debugPrint('\n========================================');
        debugPrint('✅ 终端设置测试成功');
        debugPrint('========================================');
        debugPrint('终端设置已获取');
        debugPrint('========================================\n');
      });
    });

    group('getInterfaceSettings - 获取界面设置', () {
      test('应该成功获取界面设置', () async {
        if (!hasApiKey) {
          debugPrint('⚠️  跳过测试: API密钥未配置');
          return;
        }

        final response = await api.getInterfaceSettings();

        expect(response.statusCode, equals(200));
        expect(response.data, isNotNull);
        expect(response.data, isA<InterfaceInfo>());

        debugPrint('\n========================================');
        debugPrint('✅ 界面设置测试成功');
        debugPrint('========================================\n');
      });
    });

    group('MFA相关API', () {
      test('loadMfaInfo - 应该成功加载MFA信息', () async {
        if (!hasApiKey) {
          debugPrint('⚠️  跳过测试: API密钥未配置');
          return;
        }

        final request = MfaCredential(
          code: '',
          interval: '30',
          secret: '',
        );
        
        final response = await api.loadMfaInfo(request);

        expect(response.statusCode, equals(200));
        expect(response.data, isNotNull);
        expect(response.data, isA<MfaOtp>());

        final otp = response.data!;
        debugPrint('\n========================================');
        debugPrint('✅ MFA信息加载成功');
        debugPrint('========================================');
        debugPrint('Secret: ${otp.secret}');
        debugPrint('QR Image: ${otp.qrImage != null ? "已生成" : "未生成"}');
        debugPrint('========================================\n');
      });
    });

    group('generateApiKey - 生成API密钥', () {
      test('应该成功生成API密钥', () async {
        if (!hasApiKey) {
          debugPrint('⚠️  跳过测试: API密钥未配置');
          return;
        }

        final response = await api.generateApiKey();

        expect(response.statusCode, equals(200));
        expect(response.data, isNotNull);

        debugPrint('\n========================================');
        debugPrint('✅ API密钥生成测试成功');
        debugPrint('========================================\n');
      });
    });
  });

  group('Setting API性能测试', () {
    test('getSystemSettings响应时间应该小于3秒', () async {
      if (!hasApiKey) {
        debugPrint('⚠️  跳过测试: API密钥未配置');
        return;
      }

      final timer = TestPerformanceTimer('getSystemSettings');
      timer.start();
      await api.getSystemSettings();
      timer.stop();
      timer.logResult();
      expect(timer.duration.inMilliseconds, lessThan(3000));
    });

    test('getTerminalSettings响应时间应该小于3秒', () async {
      if (!hasApiKey) {
        debugPrint('⚠️  跳过测试: API密钥未配置');
        return;
      }

      final timer = TestPerformanceTimer('getTerminalSettings');
      timer.start();
      await api.getTerminalSettings();
      timer.stop();
      timer.logResult();
      expect(timer.duration.inMilliseconds, lessThan(3000));
    });
  });
}
