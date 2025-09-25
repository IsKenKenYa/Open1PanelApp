/// 1Panel V2 API - User 相关接口
/// 
/// 此文件包含与用户管理相关的所有API接口，
/// 包括用户的创建、删除、更新、查询等操作。

import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../models/user_models.dart';

class UserV2Api {
  final ApiClient _client;

  UserV2Api(this._client);

  /// 获取用户列表
  /// 
  /// 获取所有用户列表
  /// @param search 搜索关键词（可选）
  /// @param role 用户角色（可选）
  /// @param status 用户状态（可选）
  /// @param page 页码（可选，默认为1）
  /// @param pageSize 每页数量（可选，默认为10）
  /// @return 用户列表
  Future<Response> getUsers({
    String? search,
    String? role,
    String? status,
    int page = 1,
    int pageSize = 10,
  }) async {
    final data = {
      'page': page,
      'pageSize': pageSize,
      if (search != null) 'search': search,
      if (role != null) 'role': role,
      if (status != null) 'status': status,
    };
    return await _client.post('/users/search', data: data);
  }

  /// 创建用户
  /// 
  /// 创建新用户
  /// @param username 用户名
  /// @param password 密码
  /// @param role 用户角色
  /// @param email 电子邮箱（可选）
  /// @param phone 手机号码（可选）
  /// @param description 用户描述（可选）
  /// @return 创建结果
  Future<Response> createUser({
    required String username,
    required String password,
    required String role,
    String? email,
    String? phone,
    String? description,
  }) async {
    final data = {
      'username': username,
      'password': password,
      'role': role,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (description != null) 'description': description,
    };
    return await _client.post('/users', data: data);
  }

  /// 获取用户详情
  /// 
  /// 获取指定用户的详细信息
  /// @param id 用户ID
  /// @return 用户详情
  Future<Response> getUserDetail(int id) async {
    return await _client.get('/users/$id');
  }

  /// 更新用户
  /// 
  /// 更新用户信息
  /// @param id 用户ID
  /// @param username 用户名（可选）
  /// @param password 密码（可选）
  /// @param role 用户角色（可选）
  /// @param email 电子邮箱（可选）
  /// @param phone 手机号码（可选）
  /// @param description 用户描述（可选）
  /// @param status 用户状态（可选）
  /// @return 更新结果
  Future<Response> updateUser({
    required int id,
    String? username,
    String? password,
    String? role,
    String? email,
    String? phone,
    String? description,
    String? status,
  }) async {
    final data = {
      if (username != null) 'username': username,
      if (password != null) 'password': password,
      if (role != null) 'role': role,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (description != null) 'description': description,
      if (status != null) 'status': status,
    };
    return await _client.post('/users/$id', data: data);
  }

  /// 删除用户
  /// 
  /// 删除指定的用户
  /// @param id 用户ID
  /// @return 删除结果
  Future<Response> deleteUser(int id) async {
    return await _client.delete('/users/$id');
  }

  /// 批量删除用户
  /// 
  /// 批量删除指定的用户
  /// @param ids 用户ID列表
  /// @return 删除结果
  Future<Response> deleteUsers(List<int> ids) async {
    final data = {
      'ids': ids,
    };
    return await _client.post('/users/batch/delete', data: data);
  }

  /// 启用用户
  /// 
  /// 启用指定的用户
  /// @param id 用户ID
  /// @return 启用结果
  Future<Response> enableUser(int id) async {
    return await _client.post('/users/$id/enable');
  }

  /// 禁用用户
  /// 
  /// 禁用指定的用户
  /// @param id 用户ID
  /// @return 禁用结果
  Future<Response> disableUser(int id) async {
    return await _client.post('/users/$id/disable');
  }

  /// 重置用户密码
  /// 
  /// 重置指定用户的密码
  /// @param id 用户ID
  /// @param password 新密码
  /// @return 重置结果
  Future<Response> resetUserPassword({
    required int id,
    required String password,
  }) async {
    final data = {
      'password': password,
    };
    return await _client.post('/users/$id/password/reset', data: data);
  }

  /// 修改用户密码
  /// 
  /// 修改当前用户的密码
  /// @param oldPassword 旧密码
  /// @param newPassword 新密码
  /// @return 修改结果
  Future<Response> changeUserPassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final data = {
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    };
    return await _client.post('/users/password/change', data: data);
  }

  /// 获取当前用户信息
  /// 
  /// 获取当前登录用户的信息
  /// @return 当前用户信息
  Future<Response> getCurrentUser() async {
    return await _client.get('/users/current');
  }

  /// 更新当前用户信息
  /// 
  /// 更新当前登录用户的信息
  /// @param email 电子邮箱（可选）
  /// @param phone 手机号码（可选）
  /// @param description 用户描述（可选）
  /// @return 更新结果
  Future<Response> updateCurrentUser({
    String? email,
    String? phone,
    String? description,
  }) async {
    final data = {
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (description != null) 'description': description,
    };
    return await _client.post('/users/current', data: data);
  }

  /// 获取用户角色列表
  /// 
  /// 获取所有用户角色列表
  /// @return 角色列表
  Future<Response> getUserRoles() async {
    return await _client.get('/users/roles');
  }

  /// 获取用户权限列表
  /// 
  /// 获取所有用户权限列表
  /// @param role 用户角色（可选）
  /// @return 权限列表
  Future<Response> getUserPermissions({String? role}) async {
    final data = {
      if (role != null) 'role': role,
    };
    return await _client.post('/users/permissions', data: data);
  }

  /// 获取用户权限详情
  /// 
  /// 获取指定用户的权限详情
  /// @param id 用户ID
  /// @return 权限详情
  Future<Response> getUserPermissionsDetail(int id) async {
    return await _client.get('/users/$id/permissions');
  }

  /// 更新用户权限
  /// 
  /// 更新指定用户的权限
  /// @param id 用户ID
  /// @param permissions 权限列表
  /// @return 更新结果
  Future<Response> updateUserPermissions({
    required int id,
    required List<String> permissions,
  }) async {
    final data = {
      'permissions': permissions,
    };
    return await _client.post('/users/$id/permissions', data: data);
  }

  /// 获取用户登录历史
  /// 
  /// 获取用户登录历史记录
  /// @param id 用户ID（可选）
  /// @param page 页码（可选，默认为1）
  /// @param pageSize 每页数量（可选，默认为10）
  /// @return 登录历史
  Future<Response> getUserLoginHistory({
    int? id,
    int page = 1,
    int pageSize = 10,
  }) async {
    final data = {
      'page': page,
      'pageSize': pageSize,
      if (id != null) 'id': id,
    };
    return await _client.post('/users/login/history', data: data);
  }

  /// 获取用户操作日志
  /// 
  /// 获取用户操作日志
  /// @param id 用户ID（可选）
  /// @param startTime 开始时间（可选）
  /// @param endTime 结束时间（可选）
  /// @param page 页码（可选，默认为1）
  /// @param pageSize 每页数量（可选，默认为10）
  /// @return 操作日志
  Future<Response> getUserOperationLogs({
    int? id,
    String? startTime,
    String? endTime,
    int page = 1,
    int pageSize = 10,
  }) async {
    final data = {
      'page': page,
      'pageSize': pageSize,
      if (id != null) 'id': id,
      if (startTime != null) 'startTime': startTime,
      if (endTime != null) 'endTime': endTime,
    };
    return await _client.post('/users/operation/logs', data: data);
  }

  /// 获取用户统计信息
  /// 
  /// 获取用户统计信息
  /// @return 统计信息
  Future<Response> getUserStats() async {
    return await _client.get('/users/stats');
  }

  /// 获取用户在线状态
  /// 
  /// 获取用户在线状态
  /// @param id 用户ID（可选）
  /// @return 在线状态
  Future<Response> getUserOnlineStatus({int? id}) async {
    final data = {
      if (id != null) 'id': id,
    };
    return await _client.post('/users/online/status', data: data);
  }

  /// 强制用户下线
  /// 
  /// 强制指定用户下线
  /// @param id 用户ID
  /// @return 下线结果
  Future<Response> forceUserOffline(int id) async {
    return await _client.post('/users/$id/offline');
  }

  /// 批量强制用户下线
  /// 
  /// 批量强制指定用户下线
  /// @param ids 用户ID列表
  /// @return 下线结果
  Future<Response> forceUsersOffline(List<int> ids) async {
    final data = {
      'ids': ids,
    };
    return await _client.post('/users/batch/offline', data: data);
  }
}