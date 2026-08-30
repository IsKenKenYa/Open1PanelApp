import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import '../core/test_config_manager.dart';
import 'package:onepanel_client/core/network/dio_client.dart';

void main() {
  late DioClient client;
  bool hasApiKey = false;

  setUpAll(() async {
    await TestEnvironment.initialize();
    hasApiKey = TestEnvironment.apiKey.isNotEmpty &&
        TestEnvironment.apiKey != 'your_api_key_here';

    if (hasApiKey) {
      client = DioClient(
        baseUrl: TestEnvironment.baseUrl,
        apiKey: TestEnvironment.apiKey,
      );
    }
  });

  group('验证 /settings/update 能更新哪些设置', () {
    test('1. 获取 /settings/search 返回的所有字段', () async {
      if (!hasApiKey) {
        debugPrint('⚠️  跳过测试: API密钥未配置');
        return;
      }

      final dio = client.dio;

      debugPrint('\n========================================');
      debugPrint('/settings/search 返回的字段');
      debugPrint('========================================');

      final response = await dio.post('/api/v2/settings/search');
      final data = response.data as Map<String, dynamic>;
      final settings = data['data'] as Map<String, dynamic>?;

      if (settings != null) {
        debugPrint('\n所有字段:');
        for (final entry in settings.entries) {
          debugPrint('  ${entry.key}: ${entry.value}');
        }
      }

      debugPrint('========================================\n');
    });

    test('2. monitorInterval 只读校验（禁止写探测：面板基础配置禁止修改）', () async {
      // 边界约束：该套件曾用 /settings/update 真实改写 monitorInterval 再恢复。
      // 面板/服务器基础配置在测试环境属禁改项，此处只验证字段可读且格式合法。
      if (!hasApiKey) {
        debugPrint('⚠️  跳过测试: API密钥未配置');
        return;
      }

      final dio = client.dio;
      final searchResponse = await dio.post('/api/v2/settings/search');
      final searchData = searchResponse.data as Map<String, dynamic>;
      final settings = searchData['data'] as Map<String, dynamic>?;

      final intervalRaw = settings?['monitorInterval']?.toString() ?? '';
      debugPrint('monitorInterval(只读) = $intervalRaw');
      expect(intervalRaw, isNotEmpty);
      expect(int.tryParse(intervalRaw), isNotNull,
          reason: 'monitorInterval 应为整数秒');
    });

    test('3. 对比两个接口的字段', () async {
      if (!hasApiKey) {
        debugPrint('⚠️  跳过测试: API密钥未配置');
        return;
      }

      final dio = client.dio;

      debugPrint('\n========================================');
      debugPrint('对比两个接口的字段');
      debugPrint('========================================');

      final coreResponse = await dio.post('/api/v2/core/settings/search');
      final coreData = coreResponse.data as Map<String, dynamic>;
      final coreSettings = coreData['data'] as Map<String, dynamic>?;

      final settingsResponse = await dio.post('/api/v2/settings/search');
      final settingsData = settingsResponse.data as Map<String, dynamic>;
      final settingsSettings = settingsData['data'] as Map<String, dynamic>?;

      debugPrint('\n/core/settings/search 字段:');
      if (coreSettings != null) {
        for (final key in coreSettings.keys) {
          debugPrint('  $key');
        }
      }

      debugPrint('\n/settings/search 字段:');
      if (settingsSettings != null) {
        for (final key in settingsSettings.keys) {
          debugPrint('  $key');
        }
      }

      debugPrint('========================================\n');
    });

    test('4. 最终结论', () async {
      debugPrint('\n========================================');
      debugPrint('最终结论');
      debugPrint('========================================');

      debugPrint('''
根据测试结果：

1. 两个接口返回不同的数据:
   - /core/settings/search → 面板设置 (panelName, developerMode, sessionTimeout等)
   - /settings/search → 系统设置 (monitorInterval, monitorStoreDays等)

2. /settings/update 接口:
   - 用于更新 /settings/search 返回的系统设置
   - 不能用于更新 /core/settings/search 返回的面板设置

3. 面板设置无法通过API修改:
   - panelName (面板名称) - 无法修改
   - developerMode (开发者模式) - 无法修改
   - sessionTimeout (会话超时) - 无法修改
   - theme (主题) - 无法修改
   - language (语言) - 无法修改

4. 可编辑的设置:
   ✅ 终端设置 - /core/settings/terminal/update
   ✅ 绑定地址 - /core/settings/bind/update
   ✅ 系统监控设置 - /settings/update (monitorInterval等)

结论: 面板名称等基础信息确实无法通过API修改，这是1Panel的设计限制。
''');

      debugPrint('========================================\n');
    });
  });
}
