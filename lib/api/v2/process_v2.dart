/// 1Panel V2 API - Process 相关接口
/// 
/// 此文件包含与进程管理相关的所有API接口，
/// 包括进程的查询、启动、停止、重启等操作。

import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../models/process_models.dart';

class ProcessV2Api {
  final ApiClient _client;

  ProcessV2Api(this._client);

  /// 获取进程列表
  /// 
  /// 获取所有进程列表
  /// @param search 搜索关键词（可选）
  /// @param page 页码（可选，默认为1）
  /// @param pageSize 每页数量（可选，默认为10）
  /// @return 进程列表
  Future<Response> getProcesses({
    String? search,
    int page = 1,
    int pageSize = 10,
  }) async {
    final data = {
      'page': page,
      'pageSize': pageSize,
      if (search != null) 'search': search,
    };
    return await _client.post('/processes/search', data: data);
  }

  /// 获取进程详情
  /// 
  /// 获取指定进程的详细信息
  /// @param pid 进程ID
  /// @return 进程详情
  Future<Response> getProcessDetail(int pid) async {
    return await _client.get('/processes/$pid');
  }

  /// 停止进程
  /// 
  /// 停止指定的进程
  /// @param pids 进程ID列表
  /// @param force 是否强制停止
  /// @return 停止结果
  Future<Response> stopProcess(List<int> pids, {bool force = false}) async {
    final data = {
      'pids': pids,
      'force': force,
    };
    return await _client.post('/processes/stop', data: data);
  }

  /// 启动进程
  /// 
  /// 启动指定的进程
  /// @param command 启动命令
  /// @param workingDir 工作目录（可选）
  /// @return 启动结果
  Future<Response> startProcess(String command, {String? workingDir}) async {
    final data = {
      'command': command,
      if (workingDir != null) 'workingDir': workingDir,
    };
    return await _client.post('/processes/start', data: data);
  }

  /// 重启进程
  /// 
  /// 重启指定的进程
  /// @param pids 进程ID列表
  /// @return 重启结果
  Future<Response> restartProcess(List<int> pids) async {
    final data = {
      'pids': pids,
    };
    return await _client.post('/processes/restart', data: data);
  }

  /// 获取进程树
  /// 
  /// 获取进程树结构
  /// @param pid 根进程ID（可选，默认为1）
  /// @return 进程树
  Future<Response> getProcessTree({int pid = 1}) async {
    final data = {
      'pid': pid,
    };
    return await _client.post('/processes/tree', data: data);
  }

  /// 获取进程资源使用情况
  /// 
  /// 获取指定进程的资源使用情况
  /// @param pid 进程ID
  /// @return 资源使用情况
  Future<Response> getProcessResourceUsage(int pid) async {
    return await _client.get('/processes/$pid/resource');
  }

  /// 获取进程网络连接
  /// 
  /// 获取指定进程的网络连接信息
  /// @param pid 进程ID
  /// @return 网络连接信息
  Future<Response> getProcessNetwork(int pid) async {
    return await _client.get('/processes/$pid/network');
  }

  /// 获取进程打开的文件
  /// 
  /// 获取指定进程打开的文件列表
  /// @param pid 进程ID
  /// @return 打开的文件列表
  Future<Response> getProcessFiles(int pid) async {
    return await _client.get('/processes/$pid/files');
  }

  /// 获取进程环境变量
  /// 
  /// 获取指定进程的环境变量
  /// @param pid 进程ID
  /// @return 环境变量
  Future<Response> getProcessEnv(int pid) async {
    return await _client.get('/processes/$id/env');
  }

  /// 获取进程命令行参数
  /// 
  /// 获取指定进程的命令行参数
  /// @param pid 进程ID
  /// @return 命令行参数
  Future<Response> getProcessArgs(int pid) async {
    return await _client.get('/processes/$id/args');
  }

  /// 获取进程状态
  /// 
  /// 获取指定进程的状态
  /// @param pid 进程ID
  /// @return 进程状态
  Future<Response> getProcessStatus(int pid) async {
    return await _client.get('/processes/$id/status');
  }

  /// 获取进程统计信息
  /// 
  /// 获取进程统计信息
  /// @return 进程统计信息
  Future<Response> getProcessStats() async {
    return await _client.get('/processes/stats');
  }

  /// 获取进程监控数据
  /// 
  /// 获取进程监控数据
  /// @param timeRange 时间范围（可选，默认为1h）
  /// @return 进程监控数据
  Future<Response> getProcessMonitor({String timeRange = '1h'}) async {
    final data = {
      'timeRange': timeRange,
    };
    return await _client.post('/processes/monitor', data: data);
  }
}