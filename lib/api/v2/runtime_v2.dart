/// 1Panel V2 API - Runtime 相关接口
/// 
/// 此文件包含与运行环境管理相关的所有API接口，
/// 包括运行环境的创建、删除、更新、查询等操作。

import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../models/runtime_models.dart';

class RuntimeV2Api {
  final ApiClient _client;

  RuntimeV2Api(this._client);

  /// 获取运行环境列表
  /// 
  /// 获取所有运行环境列表
  /// @param search 搜索关键词（可选）
  /// @param type 运行环境类型（可选）
  /// @param page 页码（可选，默认为1）
  /// @param pageSize 每页数量（可选，默认为10）
  /// @return 运行环境列表
  Future<Response> getRuntimes({
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
    return await _client.post('/runtimes', data: data);
  }

  /// 获取运行环境详情
  /// 
  /// 获取指定运行环境的详细信息
  /// @param id 运行环境ID
  /// @return 运行环境详情
  Future<Response> getRuntimeDetail(int id) async {
    return await _client.get('/runtimes/$id');
  }

  /// 创建运行环境
  /// 
  /// 创建一个新的运行环境
  /// @param runtime 运行环境配置信息
  /// @return 创建结果
  Future<Response> createRuntime(Map<String, dynamic> runtime) async {
    return await _client.post('/runtimes/create', data: runtime);
  }

  /// 删除运行环境
  /// 
  /// 删除指定的运行环境
  /// @param ids 运行环境ID列表
  /// @return 删除结果
  Future<Response> deleteRuntime(List<int> ids) async {
    final data = {
      'ids': ids,
    };
    return await _client.post('/runtimes/del', data: data);
  }

  /// 更新运行环境
  /// 
  /// 更新指定的运行环境
  /// @param id 运行环境ID
  /// @param runtime 更新的运行环境信息
  /// @return 更新结果
  Future<Response> updateRuntime(int id, Map<String, dynamic> runtime) async {
    return await _client.post('/runtimes/$id/update', data: runtime);
  }

  /// 启动运行环境
  /// 
  /// 启动指定的运行环境
  /// @param ids 运行环境ID列表
  /// @return 启动结果
  Future<Response> startRuntime(List<int> ids) async {
    final data = {
      'ids': ids,
    };
    return await _client.post('/runtimes/start', data: data);
  }

  /// 停止运行环境
  /// 
  /// 停止指定的运行环境
  /// @param ids 运行环境ID列表
  /// @return 停止结果
  Future<Response> stopRuntime(List<int> ids) async {
    final data = {
      'ids': ids,
    };
    return await _client.post('/runtimes/stop', data: data);
  }

  /// 重启运行环境
  /// 
  /// 重启指定的运行环境
  /// @param ids 运行环境ID列表
  /// @return 重启结果
  Future<Response> restartRuntime(List<int> ids) async {
    final data = {
      'ids': ids,
    };
    return await _client.post('/runtimes/restart', data: data);
  }

  /// 获取运行环境日志
  /// 
  /// 获取指定运行环境的日志
  /// @param id 运行环境ID
  /// @param lines 日志行数（可选，默认为100）
  /// @return 运行环境日志
  Future<Response> getRuntimeLogs(int id, {int lines = 100}) async {
    final data = {
      'lines': lines,
    };
    return await _client.post('/runtimes/$id/logs', data: data);
  }

  /// 获取运行环境配置
  /// 
  /// 获取指定运行环境的配置
  /// @param id 运行环境ID
  /// @return 运行环境配置
  Future<Response> getRuntimeConfig(int id) async {
    return await _client.get('/runtimes/$id/config');
  }

  /// 更新运行环境配置
  /// 
  /// 更新指定运行环境的配置
  /// @param id 运行环境ID
  /// @param config 运行环境配置
  /// @return 更新结果
  Future<Response> updateRuntimeConfig(int id, Map<String, dynamic> config) async {
    return await _client.post('/runtimes/$id/config', data: config);
  }

  /// 获取运行环境状态
  /// 
  /// 获取指定运行环境的状态
  /// @param id 运行环境ID
  /// @return 运行环境状态
  Future<Response> getRuntimeStatus(int id) async {
    return await _client.get('/runtimes/$id/status');
  }

  /// 获取运行环境资源使用情况
  /// 
  /// 获取指定运行环境的资源使用情况
  /// @param id 运行环境ID
  /// @return 资源使用情况
  Future<Response> getRuntimeResourceUsage(int id) async {
    return await _client.get('/runtimes/$id/resource');
  }

  /// 获取运行环境依赖
  /// 
  /// 获取指定运行环境的依赖
  /// @param id 运行环境ID
  /// @return 运行环境依赖
  Future<Response> getRuntimeDependencies(int id) async {
    return await _client.get('/runtimes/$id/dependencies');
  }

  /// 安装运行环境依赖
  /// 
  /// 为指定运行环境安装依赖
  /// @param id 运行环境ID
  /// @param dependencies 依赖列表
  /// @return 安装结果
  Future<Response> installRuntimeDependencies(int id, List<String> dependencies) async {
    final data = {
      'dependencies': dependencies,
    };
    return await _client.post('/runtimes/$id/dependencies/install', data: data);
  }

  /// 卸载运行环境依赖
  /// 
  /// 为指定运行环境卸载依赖
  /// @param id 运行环境ID
  /// @param dependencies 依赖列表
  /// @return 卸载结果
  Future<Response> uninstallRuntimeDependencies(int id, List<String> dependencies) async {
    final data = {
      'dependencies': dependencies,
    };
    return await _client.post('/runtimes/$id/dependencies/uninstall', data: data);
  }
}