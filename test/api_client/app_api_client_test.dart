import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import '../api_client_test_base.dart';
import '../core/test_config_manager.dart';
import 'package:onepanelapp_app/api/v2/app_v2.dart';
import 'package:onepanelapp_app/core/network/dio_client.dart';
import 'package:onepanelapp_app/data/models/app_models.dart';

void main() {
  late Dio dio;
  late AppV2Api api;
  bool hasApiKey = false;

  setUpAll(() async {
    await TestEnvironment.initialize();
    hasApiKey = TestEnvironment.apiKey.isNotEmpty && TestEnvironment.apiKey != 'your_api_key_here';
    
    if (hasApiKey) {
      final client = DioClient(
        baseUrl: TestEnvironment.baseUrl,
        apiKey: TestEnvironment.apiKey,
      );
      dio = client.dio;
      api = AppV2Api(dio);
    }
  });

  group('App API客户端测试', () {
    test('配置验证 - API密钥已配置', () {
      debugPrint('\n========================================');
      debugPrint('App API测试配置');
      debugPrint('========================================');
      debugPrint('服务器地址: ${TestEnvironment.baseUrl}');
      debugPrint('API密钥: ${hasApiKey ? "已配置" : "未配置"}');
      debugPrint('========================================\n');
      
      expect(hasApiKey, isTrue, reason: 'API密钥应该已配置');
    });

    group('getAppList - 获取应用列表', () {
      test('应该成功获取应用列表', () async {
        if (!hasApiKey) {
          debugPrint('⚠️  跳过测试: API密钥未配置');
          return;
        }

        final response = await api.getAppList();

        expect(response, isNotNull);
        expect(response, isA<AppListResponse>());

        debugPrint('\n========================================');
        debugPrint('✅ 应用列表测试成功');
        debugPrint('========================================');
        debugPrint('应用数量: ${response.apps.length}');
        if (response.apps.isNotEmpty) {
          debugPrint('\n应用列表:');
          for (var i = 0; i < (response.apps.length > 5 ? 5 : response.apps.length); i++) {
            final app = response.apps[i];
            debugPrint('  - ${app.appName} (${app.status})');
          }
        }
        debugPrint('========================================\n');
      });
    });

    group('searchApps - 搜索应用', () {
      test('应该成功搜索应用', () async {
        if (!hasApiKey) {
          debugPrint('⚠️  跳过测试: API密钥未配置');
          return;
        }

        final request = AppSearchRequest(
          page: 1,
          pageSize: 10,
        );
        final response = await api.searchApps(request);

        expect(response, isNotNull);
        expect(response, isA<AppSearchResponse>());

        debugPrint('\n========================================');
        debugPrint('✅ 应用搜索测试成功');
        debugPrint('========================================');
        debugPrint('总数: ${response.total}');
        debugPrint('当前页: ${response.items.length} 个应用');
        debugPrint('========================================\n');
      });

      test('应该成功按名称搜索应用', () async {
        if (!hasApiKey) {
          debugPrint('⚠️  跳过测试: API密钥未配置');
          return;
        }

        final request = AppSearchRequest(
          page: 1,
          pageSize: 10,
          name: 'nginx',
        );
        final response = await api.searchApps(request);

        expect(response, isNotNull);
        debugPrint('搜索"nginx"结果: ${response.items.length} 个应用');
      });
    });

    group('getInstalledApps - 获取已安装应用列表', () {
      test('应该成功获取已安装应用列表', () async {
        if (!hasApiKey) {
          debugPrint('⚠️  跳过测试: API密钥未配置');
          return;
        }

        final response = await api.getInstalledApps();

        expect(response, isNotNull);
        expect(response, isA<List<AppInstallInfo>>());

        debugPrint('\n========================================');
        debugPrint('✅ 已安装应用列表测试成功');
        debugPrint('========================================');
        debugPrint('已安装应用数量: ${response.length}');
        if (response.isNotEmpty) {
          debugPrint('\n已安装应用:');
          for (var i = 0; i < (response.length > 5 ? 5 : response.length); i++) {
            final app = response[i];
            debugPrint('  - ${app.appName} (${app.status})');
          }
        }
        debugPrint('========================================\n');
      });
    });

    group('searchInstalledApps - 搜索已安装应用', () {
      test('应该成功搜索已安装应用', () async {
        if (!hasApiKey) {
          debugPrint('⚠️  跳过测试: API密钥未配置');
          return;
        }

        final request = AppInstalledSearchRequest(
          page: 1,
          pageSize: 10,
        );
        final response = await api.searchInstalledApps(request);

        expect(response, isNotNull);
        expect(response.total, isNotNull);

        debugPrint('\n========================================');
        debugPrint('✅ 已安装应用搜索测试成功');
        debugPrint('========================================');
        debugPrint('总数: ${response.total}');
        debugPrint('当前页: ${response.items.length} 个应用');
        debugPrint('========================================\n');
      });
    });

    group('getAppstoreConfig - 获取应用商店配置', () {
      test('应该成功获取应用商店配置', () async {
        if (!hasApiKey) {
          debugPrint('⚠️  跳过测试: API密钥未配置');
          return;
        }

        final response = await api.getAppstoreConfig();

        expect(response, isNotNull);
        expect(response, isA<AppstoreConfigResponse>());

        debugPrint('\n========================================');
        debugPrint('✅ 应用商店配置测试成功');
        debugPrint('========================================');
        debugPrint('默认域名: ${response.defaultDomain}');
        debugPrint('========================================\n');
      });
    });

    group('checkAppUpdate - 检查应用更新', () {
      test('应该成功检查应用更新', () async {
        if (!hasApiKey) {
          debugPrint('⚠️  跳过测试: API密钥未配置');
          return;
        }

        final response = await api.checkAppUpdate();

        expect(response, isNotNull);
        expect(response, isA<AppUpdateResponse>());

        debugPrint('\n========================================');
        debugPrint('✅ 应用更新检查测试成功');
        debugPrint('========================================');
        debugPrint('可更新应用数量: ${response.updates.length}');
        debugPrint('========================================\n');
      });
    });

    group('getIgnoredApps - 获取忽略更新的应用列表', () {
      test('应该成功获取忽略更新的应用列表', () async {
        if (!hasApiKey) {
          debugPrint('⚠️  跳过测试: API密钥未配置');
          return;
        }

        final response = await api.getIgnoredApps();

        expect(response, isNotNull);
        expect(response, isA<List<AppInstallInfo>>());

        debugPrint('\n========================================');
        debugPrint('✅ 忽略更新应用列表测试成功');
        debugPrint('========================================');
        debugPrint('忽略更新应用数量: ${response.length}');
        debugPrint('========================================\n');
      });
    });

    group('syncAppStatus - 同步应用状态', () {
      test('应该成功同步应用状态', () async {
        if (!hasApiKey) {
          debugPrint('⚠️  跳过测试: API密钥未配置');
          return;
        }

        await api.syncAppStatus();

        debugPrint('\n========================================');
        debugPrint('✅ 应用状态同步测试成功');
        debugPrint('========================================\n');
      });
    });
  });

  group('App API性能测试', () {
    test('getAppList响应时间应该小于3秒', () async {
      if (!hasApiKey) {
        debugPrint('⚠️  跳过测试: API密钥未配置');
        return;
      }

      final timer = TestPerformanceTimer('getAppList');
      timer.start();
      await api.getAppList();
      timer.stop();
      timer.logResult();
      expect(timer.duration.inMilliseconds, lessThan(3000));
    });

    test('getInstalledApps响应时间应该小于3秒', () async {
      if (!hasApiKey) {
        debugPrint('⚠️  跳过测试: API密钥未配置');
        return;
      }

      final timer = TestPerformanceTimer('getInstalledApps');
      timer.start();
      await api.getInstalledApps();
      timer.stop();
      timer.logResult();
      expect(timer.duration.inMilliseconds, lessThan(3000));
    });

    test('searchApps响应时间应该小于3秒', () async {
      if (!hasApiKey) {
        debugPrint('⚠️  跳过测试: API密钥未配置');
        return;
      }

      final timer = TestPerformanceTimer('searchApps');
      timer.start();
      await api.searchApps(AppSearchRequest(page: 1, pageSize: 10));
      timer.stop();
      timer.logResult();
      expect(timer.duration.inMilliseconds, lessThan(3000));
    });
  });
}
