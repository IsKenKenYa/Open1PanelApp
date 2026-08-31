import 'package:flutter_test/flutter_test.dart';

import 'package:onepanel_client/data/models/database_models.dart';
import 'package:onepanel_client/features/databases/providers/database_users_provider.dart';
import 'package:onepanel_client/features/databases/services/database_user_service.dart';

class _FakeDatabaseUserService extends DatabaseUserService {
  _FakeDatabaseUserService({
    required this.context,
    this.throwOnBind = false,
    this.throwOnPrivilege = false,
  });

  final DatabaseUserContext context;
  bool throwOnBind;
  final bool throwOnPrivilege;

  int bindCallCount = 0;
  int privilegeCallCount = 0;

  @override
  Future<DatabaseUserContext> loadContext(DatabaseListItem item) async =>
      context;

  @override
  Future<List<Map<String, dynamic>>> listMysqlUsers(DatabaseListItem item) async =>
      const <Map<String, dynamic>>[];

  @override
  Future<void> bindUser(
    DatabaseListItem item, {
    required String username,
    required String password,
    String permission = '%',
    bool superUser = false,
  }) async {
    bindCallCount += 1;
    if (throwOnBind) {
      throw Exception('bind failed');
    }
  }

  @override
  Future<void> updatePrivileges(
    DatabaseListItem item, {
    required String username,
    required bool superUser,
  }) async {
    privilegeCallCount += 1;
    if (throwOnPrivilege) {
      throw Exception('privilege failed');
    }
  }
}

void main() {
  const pgItem = DatabaseListItem(
    scope: DatabaseScope.postgresql,
    name: 'app_db',
    engine: 'pg-main',
    source: 'local',
    username: 'db_user',
  );

  const mysqlItem = DatabaseListItem(
    scope: DatabaseScope.mysql,
    name: 'web_db',
    engine: 'mysql-main',
    source: 'local',
    username: 'root',
  );

  test('DatabaseUsersProvider load sets context on success', () async {
    final service = _FakeDatabaseUserService(
      context: const DatabaseUserContext(
        supportsBinding: true,
        supportsPrivileges: true,
        currentUsername: 'db_user',
      ),
    );
    final provider = DatabaseUsersProvider(item: pgItem, service: service);

    expect(provider.state.isLoading, isFalse);
    await provider.load();

    expect(provider.state.isLoading, isFalse);
    expect(provider.state.error, isNull);
    expect(provider.state.context?.currentUsername, 'db_user');
    expect(provider.state.context?.supportsBinding, isTrue);
    expect(provider.state.context?.supportsPrivileges, isTrue);
  });

  test('DatabaseUsersProvider load sets error on failure', () async {
    final service = _ThrowingLoadService();
    final provider = DatabaseUsersProvider(item: pgItem, service: service);

    await provider.load();

    expect(provider.state.error, isNotNull);
    expect(provider.state.context, isNull);
  });

  test('DatabaseUsersProvider bindUser updates current username', () async {
    final service = _FakeDatabaseUserService(
      context: const DatabaseUserContext(
        supportsBinding: true,
        supportsPrivileges: true,
      ),
    );
    final provider = DatabaseUsersProvider(item: pgItem, service: service);

    await provider.load();
    final ok = await provider.bindUser(
      username: 'next_user',
      password: 'secret',
      superUser: true,
    );

    expect(ok, isTrue);
    expect(service.bindCallCount, 1);
    expect(provider.state.context?.currentUsername, 'next_user');
    expect(provider.state.context?.superUser, isTrue);
    expect(provider.state.isSubmitting, isFalse);
  });

  test('DatabaseUsersProvider bindUser with mysql passes permission', () async {
    final service = _FakeDatabaseUserService(
      context: const DatabaseUserContext(
        supportsBinding: true,
        supportsPrivileges: false,
      ),
    );
    final provider = DatabaseUsersProvider(item: mysqlItem, service: service);

    await provider.load();
    final ok = await provider.bindUser(
      username: 'app_user',
      password: 'pass123',
      permission: '192.168.1.%',
    );

    expect(ok, isTrue);
    expect(service.bindCallCount, 1);
    expect(provider.state.context?.currentUsername, 'app_user');
    expect(provider.state.error, isNull);
  });

  test('DatabaseUsersProvider updatePrivileges reports failures', () async {
    final service = _FakeDatabaseUserService(
      context: const DatabaseUserContext(
        supportsBinding: true,
        supportsPrivileges: true,
        currentUsername: 'db_user',
      ),
      throwOnPrivilege: true,
    );
    final provider = DatabaseUsersProvider(item: pgItem, service: service);

    await provider.load();
    final ok = await provider.updatePrivileges(superUser: false);

    expect(ok, isFalse);
    expect(service.privilegeCallCount, 1);
    expect(provider.state.error, contains('privilege failed'));
  });

  test('DatabaseUsersProvider updatePrivileges returns false when no user',
      () async {
    final service = _FakeDatabaseUserService(
      context: const DatabaseUserContext(
        supportsBinding: true,
        supportsPrivileges: true,
      ),
    );
    final provider = DatabaseUsersProvider(item: pgItem, service: service);

    await provider.load();
    final ok = await provider.updatePrivileges(superUser: true);

    expect(ok, isFalse);
    expect(service.privilegeCallCount, 0);
  });

  test('DatabaseUsersProvider bindUser reports failures', () async {
    final service = _FakeDatabaseUserService(
      context: const DatabaseUserContext(
        supportsBinding: true,
        supportsPrivileges: true,
      ),
      throwOnBind: true,
    );
    final provider = DatabaseUsersProvider(item: pgItem, service: service);

    await provider.load();
    final ok = await provider.bindUser(
      username: 'next_user',
      password: 'secret',
    );

    expect(ok, isFalse);
    expect(service.bindCallCount, 1);
    expect(provider.state.error, contains('bind failed'));
  });

  test('DatabaseUsersProvider clears error after successful mutation', () async {
    final service = _FakeDatabaseUserService(
      context: const DatabaseUserContext(
        supportsBinding: true,
        supportsPrivileges: true,
        currentUsername: 'db_user',
      ),
      throwOnBind: true,
    );
    final provider = DatabaseUsersProvider(item: pgItem, service: service);

    await provider.load();
    await provider.bindUser(username: 'fail', password: 'fail');
    expect(provider.state.error, isNotNull);

    service.throwOnBind = false;
    final ok = await provider.bindUser(
      username: 'success',
      password: 'ok',
    );
    expect(ok, isTrue);
    expect(provider.state.error, isNull);
  });

  test('DatabaseUsersContext copyWith preserves unchanged fields', () {
    const ctx = DatabaseUserContext(
      supportsBinding: true,
      supportsPrivileges: false,
      currentUsername: 'admin',
      superUser: true,
    );
    final updated = ctx.copyWith(superUser: false);

    expect(updated.supportsBinding, isTrue);
    expect(updated.supportsPrivileges, isFalse);
    expect(updated.currentUsername, 'admin');
    expect(updated.superUser, isFalse);
  });
}

class _ThrowingLoadService extends DatabaseUserService {
  @override
  Future<DatabaseUserContext> loadContext(DatabaseListItem item) async {
    throw Exception('load failed');
  }
}
