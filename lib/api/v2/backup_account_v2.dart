/// 1Panel V2 API - Backup Account 相关接口
/// 
/// 此文件包含与备份账户管理相关的所有API接口，
/// 包括备份账户的创建、删除、更新、查询等操作。

import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../models/backup_account_models.dart';

class BackupAccountV2Api {
  final ApiClient _client;

  BackupAccountV2Api(this._client);

  /// 创建备份账户
  /// 
  /// 创建一个新的备份账户
  /// @param account 备份账户配置信息
  /// @return 创建结果
  Future<Response> createBackupAccount(Map<String, dynamic> account) async {
    return await _client.post('/backup/accounts', data: account);
  }

  /// 删除备份账户
  /// 
  /// 删除指定的备份账户
  /// @param ids 备份账户ID列表
  /// @return 删除结果
  Future<Response> deleteBackupAccount(List<int> ids) async {
    final data = {
      'ids': ids,
    };
    return await _client.post('/backup/accounts/del', data: data);
  }

  /// 更新备份账户
  /// 
  /// 更新指定的备份账户
  /// @param id 备份账户ID
  /// @param account 更新的备份账户信息
  /// @return 更新结果
  Future<Response> updateBackupAccount(int id, Map<String, dynamic> account) async {
    return await _client.post('/backup/accounts/$id/update', data: account);
  }

  /// 获取备份账户列表
  /// 
  /// 获取所有备份账户列表
  /// @param search 搜索关键词（可选）
  /// @param type 备份账户类型（可选）
  /// @param page 页码（可选，默认为1）
  /// @param pageSize 每页数量（可选，默认为10）
  /// @return 备份账户列表
  Future<Response> getBackupAccounts({
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
    return await _client.post('/backup/accounts/search', data: data);
  }

  /// 获取备份账户详情
  /// 
  /// 获取指定备份账户的详细信息
  /// @param id 备份账户ID
  /// @return 备份账户详情
  Future<Response> getBackupAccountDetail(int id) async {
    return await _client.get('/backup/accounts/$id');
  }

  /// 测试备份账户连接
  /// 
  /// 测试指定备份账户的连接
  /// @param id 备份账户ID
  /// @return 测试结果
  Future<Response> testBackupAccount(int id) async {
    return await _client.post('/backup/accounts/$id/test');
  }

  /// 获取备份账户类型列表
  /// 
  /// 获取所有支持的备份账户类型
  /// @return 备份账户类型列表
  Future<Response> getBackupAccountTypes() async {
    return await _client.get('/backup/accounts/types');
  }

  /// 获取备份账户配置模板
  /// 
  /// 获取指定类型的备份账户配置模板
  /// @param type 备份账户类型
  /// @return 配置模板
  Future<Response> getBackupAccountTemplate(String type) async {
    final data = {
      'type': type,
    };
    return await _client.post('/backup/accounts/template', data: data);
  }

  /// 验证备份账户配置
  /// 
  /// 验证备份账户配置是否正确
  /// @param account 备份账户配置信息
  /// @return 验证结果
  Future<Response> validateBackupAccount(Map<String, dynamic> account) async {
    return await _client.post('/backup/accounts/validate', data: account);
  }

  /// 获取备份账户使用情况
  /// 
  /// 获取指定备份账户的使用情况
  /// @param id 备份账户ID
  /// @return 使用情况
  Future<Response> getBackupAccountUsage(int id) async {
    return await _client.get('/backup/accounts/$id/usage');
  }

  /// 获取备份账户日志
  /// 
  /// 获取指定备份账户的日志
  /// @param id 备份账户ID
  /// @param lines 日志行数（可选，默认为100）
  /// @return 备份账户日志
  Future<Response> getBackupAccountLogs(int id, {int lines = 100}) async {
    final data = {
      'lines': lines,
    };
    return await _client.post('/backup/accounts/$id/logs', data: data);
  }
}