/// 1Panel V2 API - Database 相关接口
/// 
/// 此文件包含与数据库管理相关的所有API接口，
/// 包括数据库的创建、删除、备份、恢复、查询等操作。

import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../models/database_models.dart';

class DatabaseV2Api {
  final ApiClient _client;

  DatabaseV2Api(this._client);

  /// 创建数据库
  /// 
  /// 创建一个新的数据库
  /// @param database 数据库配置信息
  /// @return 创建结果
  Future<Response> createDatabase(Map<String, dynamic> database) async {
    return await _client.post('/databases', data: database);
  }

  /// 删除数据库
  /// 
  /// 删除指定的数据库
  /// @param ids 数据库ID列表
  /// @param force 是否强制删除
  /// @return 删除结果
  Future<Response> deleteDatabase(List<int> ids, {bool force = false}) async {
    final data = {
      'ids': ids,
      'force': force,
    };
    return await _client.post('/databases/del', data: data);
  }

  /// 更新数据库
  /// 
  /// 更新指定的数据库
  /// @param id 数据库ID
  /// @param database 更新的数据库信息
  /// @return 更新结果
  Future<Response> updateDatabase(int id, Map<String, dynamic> database) async {
    return await _client.post('/databases/$id/update', data: database);
  }

  /// 获取数据库列表
  /// 
  /// 获取所有数据库列表
  /// @param search 搜索关键词（可选）
  /// @param type 数据库类型（可选）
  /// @param page 页码（可选，默认为1）
  /// @param pageSize 每页数量（可选，默认为10）
  /// @return 数据库列表
  Future<Response> getDatabases({
    String? search,
    String? type,
    int page = 1,
    int pageSize = 10,
  }) async {
    final data = {
      'page': page,
      'pageSize': pageSize,
      if (search != null) 'search': search,
      if (type != null) 'type': type,
    };
    return await _client.post('/databases/search', data: data);
  }

  /// 获取数据库详情
  /// 
  /// 获取指定数据库的详细信息
  /// @param id 数据库ID
  /// @return 数据库详情
  Future<Response> getDatabaseDetail(int id) async {
    return await _client.get('/databases/$id');
  }

  /// 备份数据库
  /// 
  /// 备份指定的数据库
  /// @param id 数据库ID
  /// @return 备份结果
  Future<Response> backupDatabase(int id) async {
    return await _client.post('/databases/$id/backup');
  }

  /// 恢复数据库
  /// 
  /// 从备份恢复数据库
  /// @param id 数据库ID
  /// @param backupId 备份ID
  /// @return 恢复结果
  Future<Response> restoreDatabase(int id, int backupId) async {
    final data = {
      'backupId': backupId,
    };
    return await _client.post('/databases/$id/restore', data: data);
  }

  /// 获取数据库备份列表
  /// 
  /// 获取指定数据库的备份列表
  /// @param id 数据库ID
  /// @param page 页码（可选，默认为1）
  /// @param pageSize 每页数量（可选，默认为10）
  /// @return 备份列表
  Future<Response> getDatabaseBackups(int id, {
    int page = 1,
    int pageSize = 10,
  }) async {
    final data = {
      'page': page,
      'pageSize': pageSize,
    };
    return await _client.post('/databases/$id/backups', data: data);
  }

  /// 删除数据库备份
  /// 
  /// 删除指定的数据库备份
  /// @param id 数据库ID
  /// @param backupIds 备份ID列表
  /// @return 删除结果
  Future<Response> deleteDatabaseBackup(int id, List<int> backupIds) async {
    final data = {
      'backupIds': backupIds,
    };
    return await _client.post('/databases/$id/backups/del', data: data);
  }

  /// 获取数据库连接信息
  /// 
  /// 获取指定数据库的连接信息
  /// @param id 数据库ID
  /// @return 连接信息
  Future<Response> getDatabaseConnection(int id) async {
    return await _client.get('/databases/$id/connection');
  }

  /// 重置数据库密码
  /// 
  /// 重置指定数据库的密码
  /// @param id 数据库ID
  /// @param password 新密码
  /// @return 重置结果
  Future<Response> resetDatabasePassword(int id, String password) async {
    final data = {
      'password': password,
    };
    return await _client.post('/databases/$id/password/reset', data: data);
  }

  /// 获取数据库权限列表
  /// 
  /// 获取指定数据库的权限列表
  /// @param id 数据库ID
  /// @return 权限列表
  Future<Response> getDatabasePrivileges(int id) async {
    return await _client.get('/databases/$id/privileges');
  }

  /// 更新数据库权限
  /// 
  /// 更新指定数据库的权限
  /// @param id 数据库ID
  /// @param privileges 权限信息
  /// @return 更新结果
  Future<Response> updateDatabasePrivileges(int id, Map<String, dynamic> privileges) async {
    return await _client.post('/databases/$id/privileges', data: privileges);
  }
}