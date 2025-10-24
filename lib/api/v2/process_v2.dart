/// 1Panel V2 API - Process 相关接口
///
/// 此文件包含与进程管理相关的所有API接口，
/// 包括进程的查询、启动、停止、重启等操作。

import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/config/api_constants.dart';
import '../../data/models/process_models.dart';
import '../../data/models/common_models.dart';

class ProcessV2Api {
  final ApiClient _client;

  ProcessV2Api(this._client);

  /// 获取进程列表
  ///
  /// 获取所有进程列表
  /// @param search 搜索关键词（可选）
  /// @param user 用户名（可选）
  /// @param status 进程状态（可选）
  /// @param sortBy 排序字段（可选）
  /// @param sortOrder 排序顺序（可选）
  /// @param page 页码（可选，默认为1）
  /// @param pageSize 每页数量（可选，默认为10）
  /// @return 进程列表
  Future<Response<PageResult<ProcessInfo>>> getProcesses({
    String? search,
    String? user,
    ProcessStatus? status,
    String? sortBy,
    String? sortOrder,
    int page = 1,
    int pageSize = 10,
  }) async {
    final request = ProcessSearch(
      page: page,
      pageSize: pageSize,
      search: search,
      user: user,
      status: status,
      sortBy: sortBy,
      sortOrder: sortOrder,
    );
    final response = await _client.post(
      ApiConstants.buildApiPath('/processes/search'),
      data: request.toJson(),
    );
    return Response(
      data: PageResult.fromJson(
        response.data as Map<String, dynamic>,
        (json) => ProcessInfo.fromJson(json as Map<String, dynamic>),
      ),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取进程详情
  ///
  /// 获取指定进程的详细信息
  /// @param pid 进程ID
  /// @return 进程详情
  Future<Response<ProcessInfo>> getProcessDetail(int pid) async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/processes/$pid'),
    );
    return Response(
      data: ProcessInfo.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 停止进程
  ///
  /// 停止指定的进程
  /// @param operation 进程操作
  /// @return 停止结果
  Future<Response> operateProcess(ProcessOperation operation) async {
    return await _client.post(
      ApiConstants.buildApiPath('/processes/operate'),
      data: operation.toJson(),
    );
  }

  /// 停止进程
  ///
  /// 停止指定的进程
  /// @param pids 进程ID列表
  /// @param force 是否强制停止
  /// @return 停止结果
  Future<Response> stopProcess(List<int> pids, {bool force = false}) async {
    final operation = ProcessOperation(
      pids: pids,
      operation: force ? 'kill' : 'stop',
    );
    return await operateProcess(operation);
  }

  /// 启动进程
  ///
  /// 启动指定的进程
  /// @param pids 进程ID列表
  /// @return 启动结果
  Future<Response> startProcess(List<int> pids) async {
    final operation = ProcessOperation(
      pids: pids,
      operation: 'start',
    );
    return await operateProcess(operation);
  }

  /// 重启进程
  ///
  /// 重启指定的进程
  /// @param pids 进程ID列表
  /// @return 重启结果
  Future<Response> restartProcess(List<int> pids) async {
    final operation = ProcessOperation(
      pids: pids,
      operation: 'restart',
    );
    return await operateProcess(operation);
  }

  /// 暂停进程
  ///
  /// 暂停指定的进程
  /// @param pids 进程ID列表
  /// @return 暂停结果
  Future<Response> pauseProcess(List<int> pids) async {
    final operation = ProcessOperation(
      pids: pids,
      operation: 'pause',
    );
    return await operateProcess(operation);
  }

  /// 恢复进程
  ///
  /// 恢复指定的进程
  /// @param pids 进程ID列表
  /// @return 恢复结果
  Future<Response> resumeProcess(List<int> pids) async {
    final operation = ProcessOperation(
      pids: pids,
      operation: 'resume',
    );
    return await operateProcess(operation);
  }

  /// 杀死进程
  ///
  /// 强制终止指定的进程
  /// @param pids 进程ID列表
  /// @return 终止结果
  Future<Response> killProcess(List<int> pids) async {
    final operation = ProcessOperation(
      pids: pids,
      operation: 'kill',
    );
    return await operateProcess(operation);
  }

  /// 获取进程树
  ///
  /// 获取进程树结构
  /// @param pid 根进程ID（可选）
  /// @return 进程树
  Future<Response<List<ProcessTreeNode>>> getProcessTree({int? pid}) async {
    final data = {
      if (pid != null) 'pid': pid,
    };
    final response = await _client.post(
      ApiConstants.buildApiPath('/processes/tree'),
      data: data,
    );
    return Response(
      data: (response.data as List?)
          ?.map((item) => ProcessTreeNode.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取进程统计信息
  ///
  /// 获取进程统计信息
  /// @return 统计信息
  Future<Response<ProcessStats>> getProcessStats() async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/processes/stats'),
    );
    return Response(
      data: ProcessStats.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取进程资源使用情况
  ///
  /// 获取指定进程的资源使用情况
  /// @param pid 进程ID
  /// @return 资源使用情况
  Future<Response<Map<String, dynamic>>> getProcessResources(int pid) async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/processes/$pid/resources'),
    );
    return Response(
      data: response.data as Map<String, dynamic>,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取进程环境变量
  ///
  /// 获取指定进程的环境变量
  /// @param pid 进程ID
  /// @return 环境变量
  Future<Response<Map<String, String>>> getProcessEnvironment(int pid) async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/processes/$pid/environment'),
    );
    return Response(
      data: response.data as Map<String, String>,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取进程网络连接
  ///
  /// 获取指定进程的网络连接
  /// @param pid 进程ID
  /// @return 网络连接
  Future<Response<List<Map<String, dynamic>>>> getProcessConnections(int pid) async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/processes/$pid/connections'),
    );
    return Response(
      data: (response.data as List?)?.cast<Map<String, dynamic>>() ?? [],
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取进程打开的文件
  ///
  /// 获取指定进程打开的文件列表
  /// @param pid 进程ID
  /// @return 打开的文件列表
  Future<Response<List<String>>> getProcessOpenFiles(int pid) async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/processes/$pid/open-files'),
    );
    return Response(
      data: (response.data as List?)?.cast<String>() ?? [],
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }
}