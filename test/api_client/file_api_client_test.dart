import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import '../api_client_test_base.dart';
import '../core/test_config_manager.dart';
import 'package:onepanelapp_app/api/v2/file_v2.dart';
import 'package:onepanelapp_app/core/network/dio_client.dart';
import 'package:onepanelapp_app/data/models/file_models.dart';

void main() {
  late DioClient client;
  late FileV2Api api;
  bool hasApiKey = false;

  setUpAll(() async {
    await TestEnvironment.initialize();
    hasApiKey = TestEnvironment.apiKey.isNotEmpty && TestEnvironment.apiKey != 'your_api_key_here';
    
    if (hasApiKey) {
      client = DioClient(
        baseUrl: TestEnvironment.baseUrl,
        apiKey: TestEnvironment.apiKey,
      );
      api = FileV2Api(client);
    }
  });

  group('File API客户端测试', () {
    test('配置验证 - API密钥已配置', () {
      debugPrint('\n========================================');
      debugPrint('File API测试配置');
      debugPrint('========================================');
      debugPrint('服务器地址: ${TestEnvironment.baseUrl}');
      debugPrint('API密钥: ${hasApiKey ? "已配置" : "未配置"}');
      debugPrint('========================================\n');
      
      expect(hasApiKey, isTrue, reason: 'API密钥应该已配置');
    });

    group('getFiles - 获取文件列表', () {
      test('应该成功获取根目录文件列表', () async {
        if (!hasApiKey) {
          debugPrint('⚠️  跳过测试: API密钥未配置');
          return;
        }

        final request = FileSearch(path: '/');
        final response = await api.getFiles(request);

        expect(response.statusCode, equals(200));
        expect(response.data, isNotNull);
        expect(response.data, isA<List<FileInfo>>());

        final files = response.data!;
        debugPrint('\n========================================');
        debugPrint('✅ 文件列表测试成功');
        debugPrint('========================================');
        debugPrint('文件数量: ${files.length}');
        
        if (files.isNotEmpty) {
          debugPrint('\n文件列表:');
          for (var i = 0; i < (files.length > 10 ? 10 : files.length); i++) {
            final file = files[i];
            final type = file.isDir ? '📁' : '📄';
            debugPrint('  $type ${file.name}');
          }
        }
        debugPrint('========================================\n');
      });

      test('应该成功获取指定目录文件列表', () async {
        if (!hasApiKey) {
          debugPrint('⚠️  跳过测试: API密钥未配置');
          return;
        }

        final request = FileSearch(path: '/opt');
        final response = await api.getFiles(request);

        expect(response.statusCode, equals(200));
        expect(response.data, isNotNull);

        final files = response.data!;
        debugPrint('✅ /opt目录文件数量: ${files.length}');
      });
    });

    group('getFileTree - 获取文件树', () {
      test('应该成功获取文件树结构', () async {
        if (!hasApiKey) {
          debugPrint('⚠️  跳过测试: API密钥未配置');
          return;
        }

        final request = FileTreeRequest(path: '/');
        final response = await api.getFileTree(request);

        expect(response.statusCode, equals(200));
        expect(response.data, isNotNull);

        debugPrint('\n========================================');
        debugPrint('✅ 文件树测试成功');
        debugPrint('========================================\n');
      });
    });

    group('getRecycleBinStatus - 获取回收站状态', () {
      test('应该成功获取回收站状态', () async {
        if (!hasApiKey) {
          debugPrint('⚠️  跳过测试: API密钥未配置');
          return;
        }

        final response = await api.getRecycleBinStatus();

        expect(response.statusCode, equals(200));
        expect(response.data, isNotNull);

        final status = response.data!;
        debugPrint('\n========================================');
        debugPrint('✅ 回收站状态测试成功');
        debugPrint('========================================');
        debugPrint('回收站大小: ${status.totalSize}');
        debugPrint('文件数量: ${status.fileCount}');
        debugPrint('========================================\n');
      });
    });
  });

  group('File API性能测试', () {
    test('getFiles响应时间应该小于3秒', () async {
      if (!hasApiKey) {
        debugPrint('⚠️  跳过测试: API密钥未配置');
        return;
      }

      final timer = TestPerformanceTimer('getFiles');
      timer.start();
      await api.getFiles(FileSearch(path: '/'));
      timer.stop();
      timer.logResult();
      expect(timer.duration.inMilliseconds, lessThan(3000));
    });
  });
}
