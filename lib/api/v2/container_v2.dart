/// 1Panel V2 API - Container 相关接口
/// 
/// 此文件包含与容器管理相关的所有API接口，
/// 包括容器的创建、删除、启动、停止、查询等操作。

import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../models/container_models.dart';

class ContainerV2Api {
  final ApiClient _client;

  ContainerV2Api(this._client);

  /// 创建容器
  /// 
  /// 创建一个新的容器
  /// @param container 容器配置信息
  /// @return 创建结果
  Future<Response> createContainer(Map<String, dynamic> container) async {
    return await _client.post('/containers/create', data: container);
  }

  /// 删除容器
  /// 
  /// 删除指定的容器
  /// @param ids 容器ID列表
  /// @param force 是否强制删除
  /// @return 删除结果
  Future<Response> deleteContainer(List<String> ids, {bool force = false}) async {
    final data = {
      'ids': ids,
      'force': force,
    };
    return await _client.post('/containers/del', data: data);
  }

  /// 启动容器
  /// 
  /// 启动指定的容器
  /// @param ids 容器ID列表
  /// @return 启动结果
  Future<Response> startContainer(List<String> ids) async {
    final data = {
      'ids': ids,
    };
    return await _client.post('/containers/start', data: data);
  }

  /// 停止容器
  /// 
  /// 停止指定的容器
  /// @param ids 容器ID列表
  /// @param force 是否强制停止
  /// @return 停止结果
  Future<Response> stopContainer(List<String> ids, {bool force = false}) async {
    final data = {
      'ids': ids,
      'force': force,
    };
    return await _client.post('/containers/stop', data: data);
  }

  /// 重启容器
  /// 
  /// 重启指定的容器
  /// @param ids 容器ID列表
  /// @return 重启结果
  Future<Response> restartContainer(List<String> ids) async {
    final data = {
      'ids': ids,
    };
    return await _client.post('/containers/restart', data: data);
  }

  /// 暂停容器
  /// 
  /// 暂停指定的容器
  /// @param ids 容器ID列表
  /// @return 暂停结果
  Future<Response> pauseContainer(List<String> ids) async {
    final data = {
      'ids': ids,
    };
    return await _client.post('/containers/pause', data: data);
  }

  /// 恢复容器
  /// 
  /// 恢复指定的容器
  /// @param ids 容器ID列表
  /// @return 恢复结果
  Future<Response> unpauseContainer(List<String> ids) async {
    final data = {
      'ids': ids,
    };
    return await _client.post('/containers/unpause', data: data);
  }

  /// 获取容器列表
  /// 
  /// 获取所有容器列表
  /// @param search 搜索关键词（可选）
  /// @param status 容器状态（可选）
  /// @param page 页码（可选，默认为1）
  /// @param pageSize 每页数量（可选，默认为10）
  /// @return 容器列表
  Future<Response> getContainers({
    String? search,
    String? status,
    int page = 1,
    int pageSize = 10,
  }) async {
    final data = {
      'page': page,
      'pageSize': pageSize,
      if (search != null) 'search': search,
      if (status != null) 'status': status,
    };
    return await _client.post('/containers/search', data: data);
  }

  /// 获取容器详情
  /// 
  /// 获取指定容器的详细信息
  /// @param id 容器ID
  /// @return 容器详情
  Future<Response> getContainerDetail(String id) async {
    return await _client.get('/containers/$id');
  }

  /// 获取容器日志
  /// 
  /// 获取指定容器的日志
  /// @param id 容器ID
  /// @param lines 日志行数（可选，默认为100）
  /// @return 容器日志
  Future<Response> getContainerLogs(String id, {int lines = 100}) async {
    final data = {
      'lines': lines,
    };
    return await _client.post('/containers/$id/logs', data: data);
  }

  /// 获取容器统计信息
  /// 
  /// 获取指定容器的资源使用统计信息
  /// @param id 容器ID
  /// @return 容器统计信息
  Future<Response> getContainerStats(String id) async {
    return await _client.get('/containers/$id/stats');
  }

  /// 获取容器进程列表
  /// 
  /// 获取指定容器内运行的进程列表
  /// @param id 容器ID
  /// @return 容器进程列表
  Future<Response> getContainerProcesses(String id) async {
    return await _client.get('/containers/$id/top');
  }

  /// 执行容器命令
  /// 
  /// 在指定容器内执行命令
  /// @param id 容器ID
  /// @param command 要执行的命令
  /// @return 命令执行结果
  Future<Response> execContainerCommand(String id, String command) async {
    final data = {
      'command': command,
    };
    return await _client.post('/containers/$id/exec', data: data);
  }
}