import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onepanel_client/data/models/mcp_models.dart';
import 'package:onepanel_client/features/ai/mcp_server_provider.dart';
import 'package:onepanel_client/features/ai/mcp_server_service.dart';

class MockMcpServerService extends Mock implements McpServerService {}

class FakeMcpServerCreate extends Fake implements McpServerCreate {}

class FakeMcpServerUpdate extends Fake implements McpServerUpdate {}

class FakeMcpBindDomain extends Fake implements McpBindDomain {}

class FakeMcpBindDomainUpdate extends Fake implements McpBindDomainUpdate {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeMcpServerCreate());
    registerFallbackValue(FakeMcpServerUpdate());
    registerFallbackValue(FakeMcpBindDomain());
    registerFallbackValue(FakeMcpBindDomainUpdate());
  });

  group('McpServerProvider behavior', () {
    late MockMcpServerService service;
    late McpServerProvider provider;

    McpServerSnapshot snapshot({
      List<McpServerDTO> servers = const <McpServerDTO>[],
      McpBindDomainRes binding = const McpBindDomainRes(),
    }) {
      return McpServerSnapshot(servers: servers, binding: binding);
    }

    setUp(() {
      service = MockMcpServerService();
      provider = McpServerProvider(service: service);
      when(() => service.loadSnapshot(keyword: null))
          .thenAnswer((_) async => snapshot());
    });

    test('load failure keeps previous servers and exposes error', () async {
      when(() => service.loadSnapshot(keyword: null)).thenAnswer(
        (_) async => snapshot(servers: const [
          McpServerDTO(
            id: 1,
            name: 'kept-server',
            status: 'Running',
            port: 8080,
            outputTransport: 'sse',
          ),
        ]),
      );
      await provider.load();
      expect(provider.servers, hasLength(1));

      when(() => service.loadSnapshot(keyword: null))
          .thenThrow(Exception('mcp load failed'));
      await provider.load();

      expect(provider.error, contains('mcp load failed'));
      expect(provider.servers, hasLength(1));
      expect(provider.servers.first.name, 'kept-server');
      expect(provider.isLoading, isFalse);
    });

    test('recovered load clears previous error', () async {
      when(() => service.loadSnapshot(keyword: null))
          .thenThrow(Exception('mcp load failed'));
      await provider.load();
      expect(provider.error, isNotNull);

      when(() => service.loadSnapshot(keyword: null))
          .thenAnswer((_) async => snapshot());
      await provider.load();

      expect(provider.error, isNull);
      expect(provider.servers, isEmpty);
    });

    test('load with blank keyword passes null to service', () async {
      await provider.load(keyword: '   ');
      expect(provider.searchQuery, '   ');
      verify(() => service.loadSnapshot(keyword: null)).called(1);
    });

    test('saveServer creates when id is missing and updates when provided',
        () async {
      when(() => service.createServer(any())).thenAnswer((_) async {});
      when(() => service.updateServer(any())).thenAnswer((_) async {});

      expect(
        await provider.saveServer(
          name: 'new-server',
          command: 'npx',
          type: 'stdio',
          outputTransport: 'sse',
          port: 8080,
        ),
        isTrue,
      );
      verify(() => service.createServer(any())).called(1);
      verifyNever(() => service.updateServer(any()));

      expect(
        await provider.saveServer(
          id: 3,
          name: 'existing-server',
          command: 'npx',
          type: 'stdio',
          outputTransport: 'sse',
          port: 8080,
        ),
        isTrue,
      );
      verify(() => service.updateServer(any())).called(1);
    });

    test('saveServer trims optional fields and drops blank ones', () async {
      when(() => service.createServer(captureAny())).thenAnswer((_) async {});

      await provider.saveServer(
        name: 'server',
        command: 'npx',
        type: 'stdio',
        outputTransport: 'sse',
        port: 8080,
        baseUrl: '  ',
        hostIP: ' 10.0.0.2 ',
      );

      final captured =
          verify(() => service.createServer(captureAny())).captured.single
              as McpServerCreate;
      expect(captured.baseUrl, isNull);
      expect(captured.hostIP, '10.0.0.2');
    });

    test('saveServer failure exposes error and stops mutating', () async {
      when(() => service.createServer(any()))
          .thenThrow(Exception('save failed'));

      expect(
        await provider.saveServer(
          name: 'server',
          command: 'npx',
          type: 'stdio',
          outputTransport: 'sse',
          port: 8080,
        ),
        isFalse,
      );
      expect(provider.error, contains('save failed'));
      expect(provider.isMutating, isFalse);
    });

    test('deleteServer failure exposes error and keeps servers', () async {
      when(() => service.loadSnapshot(keyword: null)).thenAnswer(
        (_) async => snapshot(servers: const [
          McpServerDTO(
            id: 9,
            name: 'victim',
            status: 'Running',
            port: 8080,
            outputTransport: 'sse',
          ),
        ]),
      );
      await provider.load();

      when(() => service.deleteServer(9)).thenThrow(Exception('delete failed'));
      expect(await provider.deleteServer(9), isFalse);
      expect(provider.error, contains('delete failed'));
      expect(provider.servers, hasLength(1));
    });

    test('operateServer success reloads snapshot', () async {
      when(() => service.operateServer(id: 4, operate: 'stop'))
          .thenAnswer((_) async {});

      expect(await provider.operateServer(id: 4, operate: 'stop'), isTrue);
      expect(provider.error, isNull);
      verify(() => service.loadSnapshot(keyword: null)).called(1);
    });

    test('saveDomainBinding binds when no website binding exists yet',
        () async {
      when(() => service.bindDomain(any())).thenAnswer((_) async {});

      expect(
        await provider.saveDomainBinding(
          domain: 'mcp.example.com',
          ipList: '  ',
        ),
        isTrue,
      );
      verify(() => service.bindDomain(any())).called(1);
      verifyNever(() => service.updateDomain(any()));
    });

    test('buildExternalUrl appends sse path for sse transport', () {
      const server = McpServerDTO(
        id: 1,
        name: 'sse-server',
        status: 'Running',
        port: 8080,
        outputTransport: 'SSE',
        baseUrl: 'http://host:8080',
        ssePath: '/sse',
      );
      expect(provider.buildExternalUrl(server), 'http://host:8080/sse');
    });

    test('buildExternalUrl appends streamable path otherwise', () {
      const server = McpServerDTO(
        id: 2,
        name: 'stream-server',
        status: 'Running',
        port: 8080,
        outputTransport: 'streamable_http',
        baseUrl: 'http://host:8080',
        streamableHttpPath: '/mcp',
      );
      expect(provider.buildExternalUrl(server), 'http://host:8080/mcp');
    });

    test('buildExternalUrl returns empty when baseUrl is missing', () {
      const server = McpServerDTO(
        id: 3,
        name: 'no-base',
        status: 'Running',
        port: 8080,
        outputTransport: 'sse',
        ssePath: '/sse',
      );
      expect(provider.buildExternalUrl(server), isEmpty);
    });

    test('buildConfigPreview wraps server url in mcpServers map', () {
      const server = McpServerDTO(
        id: 4,
        name: 'preview-server',
        status: 'Running',
        port: 8080,
        outputTransport: 'sse',
        baseUrl: 'http://host:8080',
        ssePath: '/sse',
      );

      final preview = provider.buildConfigPreview(server);

      final servers = preview['mcpServers'] as Map<String, dynamic>;
      final entry = servers['preview-server'] as Map<String, dynamic>;
      expect(entry['url'], 'http://host:8080/sse');
    });
  });
}
