/// 1Panel V2 API - Update 相关接口
/// 
/// 此文件包含与系统更新相关的所有API接口，
/// 包括系统更新、应用更新、版本管理等操作。

import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../models/update_models.dart';

class UpdateV2Api {
  final ApiClient _client;

  UpdateV2Api(this._client);

  /// 获取系统更新信息
  /// 
  /// 获取系统更新信息
  /// @return 系统更新信息
  Future<Response> getSystemUpdateInfo() async {
    return await _client.get('/update/system');
  }

  /// 检查系统更新
  /// 
  /// 检查系统是否有可用更新
  /// @return 检查结果
  Future<Response> checkSystemUpdate() async {
    return await _client.post('/update/system/check');
  }

  /// 更新系统
  /// 
  /// 更新系统到最新版本
  /// @param version 目标版本（可选）
  /// @param force 是否强制更新（可选，默认为false）
  /// @return 更新结果
  Future<Response> updateSystem({
    String? version,
    bool force = false,
  }) async {
    final data = {
      if (version != null) 'version': version,
      'force': force,
    };
    return await _client.post('/update/system', data: data);
  }

  /// 获取应用更新信息
  /// 
  /// 获取应用更新信息
  /// @param appName 应用名称（可选）
  /// @return 应用更新信息
  Future<Response> getAppUpdateInfo({String? appName}) async {
    final data = {
      if (appName != null) 'appName': appName,
    };
    return await _client.post('/update/app', data: data);
  }

  /// 检查应用更新
  /// 
  /// 检查应用是否有可用更新
  /// @param appName 应用名称（可选）
  /// @return 检查结果
  Future<Response> checkAppUpdate({String? appName}) async {
    final data = {
      if (appName != null) 'appName': appName,
    };
    return await _client.post('/update/app/check', data: data);
  }

  /// 更新应用
  /// 
  /// 更新应用到最新版本
  /// @param appName 应用名称
  /// @param version 目标版本（可选）
  /// @param force 是否强制更新（可选，默认为false）
  /// @return 更新结果
  Future<Response> updateApp({
    required String appName,
    String? version,
    bool force = false,
  }) async {
    final data = {
      'appName': appName,
      if (version != null) 'version': version,
      'force': force,
    };
    return await _client.post('/update/app', data: data);
  }

  /// 批量更新应用
  /// 
  /// 批量更新应用到最新版本
  /// @param appNames 应用名称列表
  /// @param force 是否强制更新（可选，默认为false）
  /// @return 更新结果
  Future<Response> updateApps({
    required List<String> appNames,
    bool force = false,
  }) async {
    final data = {
      'appNames': appNames,
      'force': force,
    };
    return await _client.post('/update/apps', data: data);
  }

  /// 获取更新历史
  /// 
  /// 获取更新历史记录
  /// @param type 更新类型（可选，system/app）
  /// @param page 页码（可选，默认为1）
  /// @param pageSize 每页数量（可选，默认为10）
  /// @return 更新历史
  Future<Response> getUpdateHistory({
    String? type,
    int page = 1,
    int pageSize = 10,
  }) async {
    final data = {
      'page': page,
      'pageSize': pageSize,
      if (type != null) 'type': type,
    };
    return await _client.post('/update/history', data: data);
  }

  /// 获取更新日志
  /// 
  /// 获取更新日志
  /// @param type 更新类型（可选，system/app）
  /// @param version 版本（可选）
  /// @return 更新日志
  Future<Response> getUpdateChangelog({
    String? type,
    String? version,
  }) async {
    final data = {
      if (type != null) 'type': type,
      if (version != null) 'version': version,
    };
    return await _client.post('/update/changelog', data: data);
  }

  /// 获取更新设置
  /// 
  /// 获取更新设置信息
  /// @return 更新设置
  Future<Response> getUpdateSettings() async {
    return await _client.get('/update/settings');
  }

  /// 更新更新设置
  /// 
  /// 更新更新设置
  /// @param settings 更新设置
  /// @return 更新结果
  Future<Response> updateUpdateSettings(Map<String, dynamic> settings) async {
    return await _client.post('/update/settings', data: settings);
  }

  /// 设置自动更新
  /// 
  /// 设置自动更新
  /// @param autoUpdate 是否自动更新
  /// @param type 更新类型（可选，system/app）
  /// @return 设置结果
  Future<Response> setAutoUpdate({
    required bool autoUpdate,
    String? type,
  }) async {
    final data = {
      'autoUpdate': autoUpdate,
      if (type != null) 'type': type,
    };
    return await _client.post('/update/auto', data: data);
  }

  /// 设置更新源
  /// 
  /// 设置更新源
  /// @param source 更新源
  /// @param type 更新类型（可选，system/app）
  /// @return 设置结果
  Future<Response> setUpdateSource({
    required String source,
    String? type,
  }) async {
    final data = {
      'source': source,
      if (type != null) 'type': type,
    };
    return await _client.post('/update/source', data: data);
  }

  /// 获取更新源列表
  /// 
  /// 获取可用的更新源列表
  /// @param type 更新类型（可选，system/app）
  /// @return 更新源列表
  Future<Response> getUpdateSources({String? type}) async {
    final data = {
      if (type != null) 'type': type,
    };
    return await _client.post('/update/sources', data: data);
  }

  /// 测试更新源
  /// 
  /// 测试更新源是否可用
  /// @param source 更新源
  /// @param type 更新类型（可选，system/app）
  /// @return 测试结果
  Future<Response> testUpdateSource({
    required String source,
    String? type,
  }) async {
    final data = {
      'source': source,
      if (type != null) 'type': type,
    };
    return await _client.post('/update/source/test', data: data);
  }

  /// 获取更新进度
  /// 
  /// 获取更新进度
  /// @param taskId 任务ID
  /// @return 更新进度
  Future<Response> getUpdateProgress(String taskId) async {
    return await _client.get('/update/progress/$taskId');
  }

  /// 取消更新
  /// 
  /// 取消正在进行的更新
  /// @param taskId 任务ID
  /// @return 取消结果
  Future<Response> cancelUpdate(String taskId) async {
    return await _client.post('/update/cancel/$taskId');
  }

  /// 获取更新统计
  /// 
  /// 获取更新统计信息
  /// @return 统计信息
  Future<Response> getUpdateStats() async {
    return await _client.get('/update/stats');
  }

  /// 清理更新缓存
  /// 
  /// 清理更新缓存
  /// @return 清理结果
  Future<Response> cleanUpdateCache() async {
    return await _client.post('/update/cache/clean');
  }

  /// 获取版本信息
  /// 
  /// 获取版本信息
  /// @param type 版本类型（可选，current/latest）
  /// @return 版本信息
  Future<Response> getVersionInfo({String? type}) async {
    final data = {
      if (type != null) 'type': type,
    };
    return await _client.post('/update/version', data: data);
  }

  /// 获取版本列表
  /// 
  /// 获取版本列表
  /// @param type 版本类型（可选，system/app）
  /// @param appName 应用名称（可选，当type为app时需要）
  /// @return 版本列表
  Future<Response> getVersions({
    String? type,
    String? appName,
  }) async {
    final data = {
      if (type != null) 'type': type,
      if (appName != null) 'appName': appName,
    };
    return await _client.post('/update/versions', data: data);
  }

  /// 回滚版本
  /// 
  /// 回滚到指定版本
  /// @param version 目标版本
  /// @param type 版本类型（可选，system/app）
  /// @param appName 应用名称（可选，当type为app时需要）
  /// @return 回滚结果
  Future<Response> rollbackVersion({
    required String version,
    String? type,
    String? appName,
  }) async {
    final data = {
      'version': version,
      if (type != null) 'type': type,
      if (appName != null) 'appName': appName,
    };
    return await _client.post('/update/rollback', data: data);
  }
}