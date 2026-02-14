import 'package:flutter_test/flutter_test.dart';
import '../test_helper.dart';
import 'package:onepanelapp_app/data/models/mcp_models.dart';

void main() {
  setUpAll(() async {
    await setupTestEnvironment();
  });

  tearDownAll(() async {
    await teardownTestEnvironment();
  });

  group('MCP数据模型测试', () {
    group('McpEnvironment测试', () {
      test('应该正确序列化和反序列化', () {
        final model = McpEnvironment(
          key: 'API_KEY',
          value: 'secret_value_123',
        );

        final json = model.toJson();
        final restored = McpEnvironment.fromJson(json);

        expect(restored.key, equals(model.key));
        expect(restored.value, equals(model.value));
      });

      test('应该处理null值', () {
        final model = McpEnvironment();

        final json = model.toJson();
        final restored = McpEnvironment.fromJson(json);

        expect(restored.key, isNull);
        expect(restored.value, isNull);
      });
    });

    group('McpVolume测试', () {
      test('应该正确序列化和反序列化', () {
        final model = McpVolume(
          source: '/host/data',
          target: '/container/data',
        );

        final json = model.toJson();
        final restored = McpVolume.fromJson(json);

        expect(restored.source, equals(model.source));
        expect(restored.target, equals(model.target));
      });

      test('应该处理null值', () {
        final model = McpVolume();

        final json = model.toJson();
        final restored = McpVolume.fromJson(json);

        expect(restored.source, isNull);
        expect(restored.target, isNull);
      });
    });

    group('McpBindDomain测试', () {
      test('应该正确序列化和反序列化', () {
        final model = McpBindDomain(
          domain: 'mcp.example.com',
          ipList: '192.168.1.1,192.168.1.2',
          sslID: 1,
        );

        final json = model.toJson();
        final restored = McpBindDomain.fromJson(json);

        expect(restored.domain, equals(model.domain));
        expect(restored.ipList, equals(model.ipList));
        expect(restored.sslID, equals(model.sslID));
      });

      test('domain是必填字段', () {
        final model = McpBindDomain(
          domain: 'test.example.com',
        );

        final json = model.toJson();
        expect(json['domain'], equals('test.example.com'));
        // toJson() 会包含所有字段，包括null值
        expect(json.containsKey('ipList'), isTrue);
        expect(json['ipList'], isNull);
      });
    });

    group('McpBindDomainUpdate测试', () {
      test('应该正确序列化和反序列化', () {
        final model = McpBindDomainUpdate(
          websiteID: 1,
          ipList: '10.0.0.1',
          sslID: 2,
        );

        final json = model.toJson();
        final restored = McpBindDomainUpdate.fromJson(json);

        expect(restored.websiteID, equals(model.websiteID));
        expect(restored.ipList, equals(model.ipList));
        expect(restored.sslID, equals(model.sslID));
      });
    });

    group('McpServerCreate测试', () {
      test('应该正确序列化和反序列化', () {
        final model = McpServerCreate(
          name: '测试服务器',
          type: 'stdio',
          command: 'npx -y @modelcontextprotocol/server-filesystem /tmp',
          port: 8080,
          outputTransport: 'sse',
          baseUrl: 'http://localhost:8080',
          containerName: 'mcp-server-1',
          hostIP: '0.0.0.0',
          ssePath: '/sse',
          streamableHttpPath: '/stream',
          environments: [
            McpEnvironment(key: 'ENV1', value: 'value1'),
            McpEnvironment(key: 'ENV2', value: 'value2'),
          ],
          volumes: [
            McpVolume(source: '/host/path', target: '/container/path'),
          ],
        );

        final json = model.toJson();
        final restored = McpServerCreate.fromJson(json);

        expect(restored.name, equals(model.name));
        expect(restored.type, equals(model.type));
        expect(restored.command, equals(model.command));
        expect(restored.port, equals(model.port));
        expect(restored.environments?.length, equals(2));
        expect(restored.volumes?.length, equals(1));
      });

      test('必填字段验证', () {
        final model = McpServerCreate(
          name: '最小配置',
          command: 'echo test',
          port: 3000,
          outputTransport: 'stdio',
          type: 'stdio',
        );

        final json = model.toJson();
        expect(json['name'], equals('最小配置'));
        expect(json['command'], equals('echo test'));
        expect(json['port'], equals(3000));
      });
    });

    group('McpServerUpdate测试', () {
      test('应该正确序列化和反序列化', () {
        final model = McpServerUpdate(
          id: 1,
          name: '更新后的服务器',
          port: 9090,
        );

        final json = model.toJson();
        final restored = McpServerUpdate.fromJson(json);

        expect(restored.id, equals(model.id));
        expect(restored.name, equals(model.name));
        expect(restored.port, equals(model.port));
      });

      test('可以部分更新', () {
        final model = McpServerUpdate(
          id: 1,
          name: '部分更新',
        );

        final json = model.toJson();
        expect(json['id'], equals(1));
        expect(json['name'], equals('部分更新'));
        // toJson() 会包含所有字段，包括null值
        expect(json.containsKey('port'), isTrue);
        expect(json['port'], isNull);
      });
    });

    group('McpServerDelete测试', () {
      test('应该正确序列化和反序列化', () {
        final model = McpServerDelete(id: 1);

        final json = model.toJson();
        final restored = McpServerDelete.fromJson(json);

        expect(restored.id, equals(model.id));
      });
    });

    group('McpServerOperate测试', () {
      test('应该正确序列化和反序列化', () {
        final model = McpServerOperate(
          id: 1,
          operate: 'start',
        );

        final json = model.toJson();
        final restored = McpServerOperate.fromJson(json);

        expect(restored.id, equals(model.id));
        expect(restored.operate, equals(model.operate));
      });
    });

    group('McpServerSearch测试', () {
      test('应该正确序列化和反序列化', () {
        final model = McpServerSearch(
          name: 'test',
          page: 1,
          pageSize: 20,
          sync: true,
        );

        final json = model.toJson();
        final restored = McpServerSearch.fromJson(json);

        expect(restored.name, equals(model.name));
        expect(restored.page, equals(model.page));
        expect(restored.pageSize, equals(model.pageSize));
        expect(restored.sync, equals(model.sync));
      });
    });

    group('McpBindDomainRes测试', () {
      test('应该正确序列化和反序列化', () {
        final model = McpBindDomainRes(
          acmeAccountID: 1,
          allowIPs: ['192.168.1.1', '10.0.0.1'],
          connUrl: 'http://mcp.example.com',
          domain: 'mcp.example.com',
          sslID: 1,
          websiteID: 1,
        );

        final json = model.toJson();
        final restored = McpBindDomainRes.fromJson(json);

        expect(restored.domain, equals(model.domain));
        expect(restored.connUrl, equals(model.connUrl));
        expect(restored.allowIPs?.length, equals(2));
      });
    });

    group('McpServerDTO测试', () {
      test('应该正确序列化和反序列化', () {
        final model = McpServerDTO(
          id: 1,
          name: '完整服务器',
          type: 'stdio',
          command: 'npx server',
          status: 'running',
          port: 8080,
          baseUrl: 'http://localhost:8080',
          containerName: 'mcp-1',
          createdAt: '2024-01-01T00:00:00Z',
          updatedAt: '2024-01-01T00:00:00Z',
          environments: [McpEnvironment(key: 'KEY', value: 'value')],
          volumes: [McpVolume(source: '/host', target: '/container')],
        );

        final json = model.toJson();
        final restored = McpServerDTO.fromJson(json);

        expect(restored.id, equals(model.id));
        expect(restored.name, equals(model.name));
        expect(restored.status, equals(model.status));
        expect(restored.environments?.length, equals(1));
      });
    });

    group('McpServersRes测试', () {
      test('应该正确序列化和反序列化', () {
        final model = McpServersRes(
          items: [
            McpServerDTO(id: 1, name: 'Server 1'),
            McpServerDTO(id: 2, name: 'Server 2'),
          ],
          total: 2,
        );

        final json = model.toJson();
        final restored = McpServersRes.fromJson(json);

        expect(restored.items?.length, equals(2));
        expect(restored.total, equals(2));
      });

      test('应该处理空列表', () {
        final model = McpServersRes(
          items: [],
          total: 0,
        );

        final json = model.toJson();
        final restored = McpServersRes.fromJson(json);

        expect(restored.items, isEmpty);
        expect(restored.total, equals(0));
      });
    });
  });

  group('MCP模型边界条件测试', () {
    test('环境变量列表应该正确处理', () {
      final model = McpServerCreate(
        name: '多环境变量',
        command: 'test',
        port: 3000,
        outputTransport: 'stdio',
        type: 'stdio',
        environments: List.generate(
          100,
          (i) => McpEnvironment(key: 'KEY_$i', value: 'value_$i'),
        ),
      );

      final json = model.toJson();
      final restored = McpServerCreate.fromJson(json);

      expect(restored.environments?.length, equals(100));
    });

    test('卷挂载列表应该正确处理', () {
      final model = McpServerCreate(
        name: '多卷挂载',
        command: 'test',
        port: 3000,
        outputTransport: 'stdio',
        type: 'stdio',
        volumes: [
          McpVolume(source: '/host1', target: '/container1'),
          McpVolume(source: '/host2', target: '/container2'),
          McpVolume(source: '/host3', target: '/container3'),
        ],
      );

      final json = model.toJson();
      final restored = McpServerCreate.fromJson(json);

      expect(restored.volumes?.length, equals(3));
    });

    test('特殊字符应该正确处理', () {
      final model = McpServerCreate(
        name: '特殊字符测试 !@#\$%',
        command: 'echo "hello world" && ls -la | grep test',
        port: 3000,
        outputTransport: 'stdio',
        type: 'stdio',
        environments: [
          McpEnvironment(key: 'SPECIAL_KEY', value: 'value with spaces & symbols'),
        ],
      );

      final json = model.toJson();
      final restored = McpServerCreate.fromJson(json);

      expect(restored.name, equals('特殊字符测试 !@#\$%'));
      expect(restored.command, equals('echo "hello world" && ls -la | grep test'));
    });

    test('Unicode字符应该正确处理', () {
      final model = McpServerCreate(
        name: '🚀 MCP服务器 日本語',
        command: 'echo "你好世界"',
        port: 3000,
        outputTransport: 'stdio',
        type: 'stdio',
      );

      final json = model.toJson();
      final restored = McpServerCreate.fromJson(json);

      expect(restored.name, equals('🚀 MCP服务器 日本語'));
    });

    test('长命令应该正确处理', () {
      final longCommand = 'echo "${'a' * 5000}"';
      final model = McpServerCreate(
        name: '长命令测试',
        command: longCommand,
        port: 3000,
        outputTransport: 'stdio',
        type: 'stdio',
      );

      final json = model.toJson();
      final restored = McpServerCreate.fromJson(json);

      expect(restored.command.length, equals(longCommand.length));
    });

    test('空列表应该正确处理', () {
      final model = McpServerCreate(
        name: '空列表测试',
        command: 'test',
        port: 3000,
        outputTransport: 'stdio',
        type: 'stdio',
        environments: [],
        volumes: [],
      );

      final json = model.toJson();
      final restored = McpServerCreate.fromJson(json);

      expect(restored.environments, isEmpty);
      expect(restored.volumes, isEmpty);
    });

    test('null值应该正确处理', () {
      final model = McpServerCreate(
        name: 'null测试',
        command: 'test',
        port: 3000,
        outputTransport: 'stdio',
        type: 'stdio',
      );

      final json = model.toJson();
      final restored = McpServerCreate.fromJson(json);

      expect(restored.baseUrl, isNull);
      expect(restored.containerName, isNull);
    });
  });
}
