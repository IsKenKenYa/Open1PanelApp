import 'dart:convert';

import 'package:onepanel_client/api/v2/database_v2.dart';
import 'package:onepanel_client/core/network/api_client_manager.dart';
import 'package:onepanel_client/data/models/database_models.dart';

class DatabaseUserRepository {
  DatabaseUserRepository({ApiClientManager? clientManager})
      : _clientManager = clientManager ?? ApiClientManager.instance;

  final ApiClientManager _clientManager;

  Future<DatabaseV2Api> _getApi() => _clientManager.getDatabaseApi();

  /// V2 新体系：MySQL 用户创建走 /databases/users（旧 /databases/bind 已删除）。
  /// password 与前端 encodeBase64Fields 一致，需 base64 编码。
  Future<void> createMysqlUser(
    DatabaseListItem item, {
    required String username,
    required String password,
    String host = '%',
  }) async {
    final api = await _getApi();
    await api.createDatabaseUser(<String, dynamic>{
      'database': item.lookupName,
      'dbs': <String>[item.name],
      'username': username,
      'password': base64.encode(utf8.encode(password)),
      'host': host,
      'description': '',
    });
  }

  Future<List<Map<String, dynamic>>> searchMysqlUsers(
    DatabaseListItem item,
  ) async {
    final api = await _getApi();
    final response = await api.searchDatabaseUsers(item.lookupName);
    return response.data ?? const <Map<String, dynamic>>[];
  }

  Future<void> deleteMysqlUser(
    DatabaseListItem item, {
    required String username,
    required String host,
  }) async {
    final api = await _getApi();
    await api.deleteDatabaseUser(<String, dynamic>{
      'database': item.lookupName,
      'username': username,
      'host': host,
    });
  }

  Future<void> changeMysqlUserPassword(
    DatabaseListItem item, {
    required String username,
    required String host,
    required String password,
  }) async {
    final api = await _getApi();
    await api.updateDatabaseUserPassword(<String, dynamic>{
      'database': item.lookupName,
      'username': username,
      'host': host,
      'password': base64.encode(utf8.encode(password)),
    });
  }

  Future<void> bindPostgresqlUser(
    DatabaseListItem item, {
    required String username,
    required String password,
    required bool superUser,
  }) async {
    final api = await _getApi();
    await api.bindPostgresqlUser({
      'name': item.name,
      'database': item.lookupName,
      'username': username,
      'password': password,
      'superUser': superUser,
    });
  }

  Future<void> updatePostgresqlPrivileges(
    DatabaseListItem item, {
    required String username,
    required bool superUser,
  }) async {
    final api = await _getApi();
    await api.changePostgresqlPrivileges({
      'name': item.name,
      'database': item.lookupName,
      'username': username,
      'superUser': superUser,
    });
  }
}
