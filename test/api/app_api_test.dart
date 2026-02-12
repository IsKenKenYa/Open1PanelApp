/// App API 单元测试
///
/// 测试App模块的所有数据模型

import 'package:flutter_test/flutter_test.dart';
import '../core/test_config_manager.dart';
import '../core/mock_api_responses.dart';
import '../../lib/data/models/app_models.dart';

void main() {
  setUpAll(() async {
    await TestEnvironment.initialize();
  });

  group('App数据模型测试', () {
    group('AppSearchRequest模型测试', () {
      test('应该正确创建实例', () {
        final model = AppSearchRequest(
          page: 1,
          pageSize: 10,
          name: 'nginx',
          type: 'web-server',
          recommend: true,
        );

        expect(model.page, equals(1));
        expect(model.pageSize, equals(10));
        expect(model.name, equals('nginx'));
        expect(model.type, equals('web-server'));
        expect(model.recommend, isTrue);
      });

      test('应该正确序列化为JSON', () {
        final model = AppSearchRequest(
          page: 1,
          pageSize: 20,
          name: 'mysql',
          tags: ['database', 'sql'],
        );

        final json = model.toJson();

        expect(json['page'], equals(1));
        expect(json['pageSize'], equals(20));
        expect(json['name'], equals('mysql'));
        expect(json['tags'], equals(['database', 'sql']));
      });

      test('应该正确从JSON反序列化', () {
        final json = {
          'page': 1,
          'pageSize': 10,
          'name': 'redis',
          'type': 'cache',
        };

        final model = AppSearchRequest.fromJson(json);

        expect(model.page, equals(1));
        expect(model.pageSize, equals(10));
        expect(model.name, equals('redis'));
        expect(model.type, equals('cache'));
      });
    });

    group('AppItem模型测试', () {
      test('应该正确创建实例', () {
        final model = AppItem(
          id: 1,
          key: 'nginx',
          name: 'Nginx',
          description: '高性能HTTP服务器',
          icon: 'nginx.png',
          type: 'web-server',
          status: 'active',
          resource: 'official',
          recommend: 5,
          limit: 0,
          gpuSupport: false,
          installed: true,
          versions: ['1.24.0', '1.25.0'],
          tags: [
            TagDTO(id: 1, key: 'web', name: 'Web服务器'),
          ],
        );

        expect(model.id, equals(1));
        expect(model.key, equals('nginx'));
        expect(model.name, equals('Nginx'));
        expect(model.installed, isTrue);
        expect(model.versions, hasLength(2));
        expect(model.tags, hasLength(1));
      });

      test('应该正确序列化和反序列化', () {
        final json = {
          'id': 1,
          'key': 'mysql',
          'name': 'MySQL',
          'description': '关系型数据库',
          'icon': 'mysql.png',
          'type': 'database',
          'status': 'active',
          'resource': 'official',
          'recommend': 5,
          'limit': 0,
          'gpuSupport': false,
          'installed': false,
          'versions': ['8.0', '5.7'],
          'tags': [
            {'id': 1, 'key': 'db', 'name': '数据库'},
          ],
        };

        final model = AppItem.fromJson(json);
        final restoredJson = model.toJson();

        expect(model.id, equals(1));
        expect(model.key, equals('mysql'));
        expect(model.installed, isFalse);
        expect(restoredJson['key'], equals('mysql'));
      });
    });

    group('TagDTO模型测试', () {
      test('应该正确创建实例', () {
        final model = TagDTO(
          id: 1,
          key: 'web',
          name: 'Web服务器',
        );

        expect(model.id, equals(1));
        expect(model.key, equals('web'));
        expect(model.name, equals('Web服务器'));
      });

      test('应该正确序列化和反序列化', () {
        final model = TagDTO(id: 2, key: 'db', name: '数据库');
        final json = model.toJson();
        final restored = TagDTO.fromJson(json);

        expect(restored.id, equals(2));
        expect(restored.key, equals('db'));
        expect(restored.name, equals('数据库'));
      });
    });

    group('AppInstallCreateRequest模型测试', () {
      test('应该正确创建实例', () {
        final model = AppInstallCreateRequest(
          appDetailId: 1,
          name: 'my-nginx',
          params: {'port': 8080},
          containerName: 'nginx-container',
          cpuQuota: 1.0,
          memoryLimit: 512.0,
          memoryUnit: 'MB',
        );

        expect(model.appDetailId, equals(1));
        expect(model.name, equals('my-nginx'));
        expect(model.params?['port'], equals(8080));
        expect(model.cpuQuota, equals(1.0));
        expect(model.memoryLimit, equals(512.0));
      });

      test('应该正确序列化和反序列化', () {
        final model = AppInstallCreateRequest(
          appDetailId: 1,
          name: 'my-mysql',
          params: {'root_password': 'secret123'},
        );

        final json = model.toJson();
        final restored = AppInstallCreateRequest.fromJson(json);

        expect(restored.appDetailId, equals(1));
        expect(restored.name, equals('my-mysql'));
        expect(restored.params?['root_password'], equals('secret123'));
      });
    });

    group('AppInstallInfo模型测试', () {
      test('应该正确创建实例', () {
        final model = AppInstallInfo(
          id: 1,
          appId: '1',
          appName: 'Nginx',
          appVersion: '1.24.0',
          icon: 'nginx.png',
          status: 'running',
          createdAt: '2024-01-01T00:00:00Z',
        );

        expect(model.id, equals(1));
        expect(model.appId, equals('1'));
        expect(model.appName, equals('Nginx'));
        expect(model.appVersion, equals('1.24.0'));
        expect(model.status, equals('running'));
      });

      test('应该正确序列化和反序列化', () {
        final json = {
          'id': 1,
          'appId': '1',
          'appName': 'MySQL',
          'appVersion': '8.0',
          'icon': 'mysql.png',
          'status': 'running',
          'createdAt': '2024-01-01T00:00:00Z',
        };

        final model = AppInstallInfo.fromJson(json);
        final restoredJson = model.toJson();

        expect(model.id, equals(1));
        expect(model.appName, equals('MySQL'));
        expect(restoredJson['status'], equals('running'));
      });
    });

    group('AppInstalledSearchRequest模型测试', () {
      test('应该正确创建实例', () {
        final model = AppInstalledSearchRequest(
          page: 1,
          pageSize: 10,
          name: 'nginx',
          type: 'web-server',
        );

        expect(model.page, equals(1));
        expect(model.pageSize, equals(10));
        expect(model.name, equals('nginx'));
        expect(model.type, equals('web-server'));
      });
    });

    group('AppInstalledOperateRequest模型测试', () {
      test('应该正确创建实例', () {
        final model = AppInstalledOperateRequest(
          installId: 1,
          operate: 'restart',
        );

        expect(model.installId, equals(1));
        expect(model.operate, equals('restart'));
      });
    });

    group('AppVersion模型测试', () {
      test('应该正确创建实例', () {
        final model = AppVersion(
          version: '1.25.0',
          description: 'Latest stable version',
          releaseDate: '2024-01-01',
          isPrerelease: false,
        );

        expect(model.version, equals('1.25.0'));
        expect(model.description, equals('Latest stable version'));
        expect(model.isPrerelease, isFalse);
      });
    });

    group('AppstoreConfigResponse模型测试', () {
      test('应该正确创建实例', () {
        final model = AppstoreConfigResponse(
          defaultDomain: 'https://apps.1panel.cn',
        );

        expect(model.defaultDomain, equals('https://apps.1panel.cn'));
      });
    });

    group('AppInstalledCheckResponse模型测试', () {
      test('应该正确创建实例', () {
        final model = AppInstalledCheckResponse(
          exist: true,
          message: '应用已安装',
        );

        expect(model.exist, isTrue);
        expect(model.message, equals('应用已安装'));
      });
    });

    group('AppServiceResponse模型测试', () {
      test('应该正确创建实例', () {
        final model = AppServiceResponse(
          config: {'port': 3306},
          from: 'env',
          label: 'MySQL服务',
          status: 'running',
          value: 'mysql-service',
        );

        expect(model.label, equals('MySQL服务'));
        expect(model.status, equals('running'));
        expect(model.from, equals('env'));
      });
    });
  });

  group('边界条件测试', () {
    test('空字符串应该正确处理', () {
      final model = AppSearchRequest(page: 1, pageSize: 10, name: '');
      expect(model.name, isEmpty);
    });

    test('空列表应该正确处理', () {
      final model = AppItem(
        id: 1,
        key: 'test',
        name: 'Test',
        description: '',
        icon: '',
        type: '',
        status: '',
        resource: '',
        recommend: 0,
        limit: 0,
        gpuSupport: false,
        installed: false,
        versions: [],
        tags: [],
      );

      expect(model.versions, isEmpty);
      expect(model.tags, isEmpty);
    });

    test('特殊字符应该正确处理', () {
      final model = AppInstallCreateRequest(
        appDetailId: 1,
        name: r'app@#$%^&*()',
      );
      expect(model.name, equals(r'app@#$%^&*()'));
    });

    test('Unicode字符应该正确处理', () {
      final model = AppInstallInfo(
        id: 1,
        appName: '测试应用',
        appVersion: '1.0.0',
      );

      expect(model.appName, equals('测试应用'));
    });
  });

  group('JSON兼容性测试', () {
    test('Mock响应数据应该符合模型结构', () {
      final mockResponse = MockAppResponses.appList();
      expect(mockResponse['code'], equals(200));
      expect(mockResponse['data'], isNotNull);
      expect(mockResponse['data']['items'], isA<List>());
    });

    test('已安装应用Mock响应数据应该符合模型结构', () {
      final mockResponse = MockAppResponses.installedList();
      expect(mockResponse['code'], equals(200));
      expect(mockResponse['data'], isA<List>());
    });
  });
}
