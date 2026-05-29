import 'package:flutter_test/flutter_test.dart';
import 'package:onepanel_client/data/models/openresty_models.dart';
import 'package:onepanel_client/features/openresty/providers/openresty_provider.dart';
import 'package:onepanel_client/features/openresty/services/openresty_service.dart';
import 'package:onepanel_client/shared/security_gateway/security_gateway_snapshot_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeOpenRestyService extends OpenRestyService {
  OpenRestySnapshot snapshot = const OpenRestySnapshot(
    status: <String, dynamic>{'active': 0},
    modules: <String, dynamic>{
      'mirror': '',
      'modules': <Map<String, dynamic>>[
        <String, dynamic>{
          'name': 'http-cache',
          'enable': false,
          'packages': '',
          'params': '',
          'script': '',
        },
      ],
    },
    https: <String, dynamic>{'https': false, 'sslRejectHandshake': false},
    configContent: 'worker_processes 1;',
  );

  final List<Map<String, dynamic>> httpsUpdates = <Map<String, dynamic>>[];
  final List<Map<String, dynamic>> moduleUpdates = <Map<String, dynamic>>[];
  final List<String> configUpdates = <String>[];
  final List<OpenrestyBuildRequest> buildRequests = <OpenrestyBuildRequest>[];

  @override
  Future<OpenRestySnapshot> loadSnapshot() async => snapshot;

  @override
  Future<void> updateHttps(Map<String, dynamic> request) async {
    httpsUpdates.add(request);
    snapshot = OpenRestySnapshot(
      status: snapshot.status,
      modules: snapshot.modules,
      https: <String, dynamic>{
        'https': request['operate'] == 'enable',
        'sslRejectHandshake': request['sslRejectHandshake'] == true,
      },
      configContent: snapshot.configContent,
    );
  }

  @override
  Future<void> updateModules(Map<String, dynamic> request) async {
    moduleUpdates.add(request);
    final modules = List<Map<String, dynamic>>.from(
      (snapshot.modules['modules'] as List?)
              ?.whereType<Map<String, dynamic>>()
              .toList() ??
          <Map<String, dynamic>>[],
    );
    final name = request['name']?.toString();
    final idx = modules.indexWhere((m) => m['name'] == name);
    if (idx >= 0) {
      modules[idx] = Map<String, dynamic>.from(modules[idx])
        ..addAll(request);
    }
    snapshot = OpenRestySnapshot(
      status: snapshot.status,
      modules: <String, dynamic>{
        'mirror': snapshot.modules['mirror'],
        'modules': modules,
      },
      https: snapshot.https,
      configContent: snapshot.configContent,
    );
  }

  @override
  Future<void> updateConfigSource(String content) async {
    configUpdates.add(content);
    snapshot = OpenRestySnapshot(
      status: snapshot.status,
      modules: snapshot.modules,
      https: snapshot.https,
      configContent: content,
    );
  }

  @override
  Future<void> buildOpenResty({
    required String mirror,
    required String taskId,
  }) async {
    buildRequests.add(OpenrestyBuildRequest(mirror: mirror, taskId: taskId));
  }

  @override
  Future<List<OpenrestyParam>> loadScope({
    required NginxKey scope,
    int? websiteId,
  }) async {
    return const <OpenrestyParam>[
      OpenrestyParam(name: 'index', params: <String>['root', 'index']),
    ];
  }
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    SecurityGatewaySnapshotStore.instance.resetForTest();
  });

  test(
      'OpenRestyProvider loads snapshot and supports https draft apply/rollback',
      () async {
    final service = _FakeOpenRestyService();
    final provider = OpenRestyProvider(
      service: service,
      snapshotStore: SecurityGatewaySnapshotStore.instance,
    );

    await provider.loadAll();

    expect(provider.hasData, isTrue);
    expect(provider.httpsEnabled, isFalse);
    expect(provider.riskNotices, isNotEmpty);

    provider.stageHttpsUpdate(
      httpsEnabled: true,
      sslRejectHandshake: false,
    );
    expect(provider.httpsDraft?.hasChanges, isTrue);

    final applied = await provider.applyHttpsDraft();

    expect(applied, isTrue);
    expect(provider.httpsEnabled, isTrue);
    expect(service.httpsUpdates, hasLength(1));
    expect(provider.httpsRollbackSnapshot, isNotNull);

    final rollback = await provider.rollbackHttps();

    expect(rollback, isTrue);
    expect(service.httpsUpdates, hasLength(2));
  });

  test('OpenRestyProvider loadScope stores params', () async {
    final provider = OpenRestyProvider(
      service: _FakeOpenRestyService(),
      snapshotStore: SecurityGatewaySnapshotStore.instance,
    );

    await provider.loadScope(scope: NginxKey.indexKey);

    expect(provider.scopeParams, hasLength(1));
    expect(provider.scopeParams.first.name, 'index');
  });

  test('OpenRestyProvider module draft apply/rollback', () async {
    final service = _FakeOpenRestyService();
    final provider = OpenRestyProvider(
      service: service,
      snapshotStore: SecurityGatewaySnapshotStore.instance,
    );

    await provider.loadAll();

    final module = provider.moduleList.first;
    expect(module.enable, isFalse);

    provider.stageModuleUpdate(module: module, enable: true);
    expect(provider.moduleDraft?.hasChanges, isTrue);

    final applied = await provider.applyModuleDraft();
    expect(applied, isTrue);
    expect(service.moduleUpdates, hasLength(1));
    expect(provider.moduleRollbackSnapshot, isNotNull);

    final rollback = await provider.rollbackModules();
    expect(rollback, isTrue);
    expect(service.moduleUpdates, hasLength(2));
  });

  test('OpenRestyProvider config draft apply/rollback', () async {
    final service = _FakeOpenRestyService();
    final provider = OpenRestyProvider(
      service: service,
      snapshotStore: SecurityGatewaySnapshotStore.instance,
    );

    await provider.loadAll();

    const newConfig = 'http { server { listen 80; } }';
    provider.stageConfigUpdate(newConfig);
    expect(provider.configDraft?.hasChanges, isTrue);

    final applied = await provider.applyConfigDraft();
    expect(applied, isTrue);
    expect(service.configUpdates, hasLength(1));
    expect(provider.configContent, newConfig);
    expect(provider.configRollbackSnapshot, isNotNull);

    final rollback = await provider.rollbackConfig();
    expect(rollback, isTrue);
    expect(service.configUpdates, hasLength(2));
    expect(provider.configContent, 'worker_processes 1;');
  });

  test('OpenRestyProvider riskNotices includes all expected categories', () async {
    final service = _FakeOpenRestyService();
    final provider = OpenRestyProvider(
      service: service,
      snapshotStore: SecurityGatewaySnapshotStore.instance,
    );

    await provider.loadAll();

    final titles = provider.riskNotices.map((n) => n.title).toList();

    expect(titles, contains('Gateway inactive'));
    expect(titles, contains('HTTPS disabled'));
    expect(titles, contains('Build mirror missing'));
  });

  test('OpenRestyProvider buildOpenResty sets lastBuildMessage', () async {
    final service = _FakeOpenRestyService();
    final provider = OpenRestyProvider(
      service: service,
      snapshotStore: SecurityGatewaySnapshotStore.instance,
    );

    await provider.loadAll();

    expect(provider.lastBuildMessage, isNull);

    await provider.buildOpenResty(mirror: '', taskId: 'task-1');
    expect(provider.lastBuildMessage, isNotNull);
    expect(service.buildRequests, hasLength(1));
  });

  test('OpenRestyProvider discard clears drafts', () async {
    final service = _FakeOpenRestyService();
    final provider = OpenRestyProvider(
      service: service,
      snapshotStore: SecurityGatewaySnapshotStore.instance,
    );

    await provider.loadAll();

    provider.stageHttpsUpdate(httpsEnabled: true, sslRejectHandshake: false);
    expect(provider.httpsDraft, isNotNull);
    provider.discardHttpsDraft();
    expect(provider.httpsDraft, isNull);

    final module = provider.moduleList.first;
    provider.stageModuleUpdate(module: module, enable: true);
    expect(provider.moduleDraft, isNotNull);
    provider.discardModuleDraft();
    expect(provider.moduleDraft, isNull);

    provider.stageConfigUpdate('new config');
    expect(provider.configDraft, isNotNull);
    provider.discardConfigDraft();
    expect(provider.configDraft, isNull);
  });

  test('OpenRestyProvider moduleList returns empty for missing modules key',
      () async {
    final service = _FakeOpenRestyService();
    service.snapshot = const OpenRestySnapshot(
      status: <String, dynamic>{'active': 1},
      modules: <String, dynamic>{},
      https: <String, dynamic>{'https': true},
      configContent: 'http {}',
    );
    final provider = OpenRestyProvider(
      service: service,
      snapshotStore: SecurityGatewaySnapshotStore.instance,
    );

    await provider.loadAll();

    expect(provider.moduleList, isEmpty);
    expect(provider.isRunning, isTrue);
    expect(provider.httpsEnabled, isTrue);
  });

  test('OpenRestyProvider config risk detection flags empty config', () async {
    final service = _FakeOpenRestyService();
    final provider = OpenRestyProvider(
      service: service,
      snapshotStore: SecurityGatewaySnapshotStore.instance,
    );

    await provider.loadAll();

    provider.stageConfigUpdate('');
    expect(provider.configDraft?.risks, isNotEmpty);
    expect(
      provider.configDraft?.risks.first.title,
      'Empty config',
    );
  });

  test('OpenRestyProvider applyHttpsDraft returns false when no draft',
      () async {
    final service = _FakeOpenRestyService();
    final provider = OpenRestyProvider(
      service: service,
      snapshotStore: SecurityGatewaySnapshotStore.instance,
    );

    await provider.loadAll();

    final result = await provider.applyHttpsDraft();
    expect(result, isFalse);
  });
}
