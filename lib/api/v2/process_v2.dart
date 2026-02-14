import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import '../../core/config/api_constants.dart';
import '../../data/models/process_models.dart';
import '../../data/models/common_models.dart';

class ProcessV2Api {
  final DioClient _client;

  ProcessV2Api(this._client);

  /// 停止进程
  ///
  /// 停止指定的进程
  /// @param request 进程操作请求
  /// @return 停止结果
  Future<Response> stopProcess(ProcessRequest request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/process/stop'),
      data: request.toJson(),
    );
  }

  /// 启动进程
  ///
  /// 启动指定的进程
  /// @param request 进程操作请求
  /// @return 启动结果
  Future<Response> startProcess(ProcessRequest request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/process/start'),
      data: request.toJson(),
    );
  }

  /// 重启进程
  ///
  /// 重启指定的进程
  /// @param request 进程操作请求
  /// @return 重启结果
  Future<Response> restartProcess(ProcessRequest request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/process/restart'),
      data: request.toJson(),
    );
  }

  /// 杀死进程
  ///
  /// 强制终止指定的进程
  /// @param request 进程操作请求
  /// @return 终止结果
  Future<Response> killProcess(ProcessRequest request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/process/kill'),
      data: request.toJson(),
    );
  }

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
      ApiConstants.buildApiPath('/process/search'),
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
      ApiConstants.buildApiPath('/process/$pid'),
    );
    return Response(
      data: ProcessInfo.fromJson(response.data as Map<String, dynamic>),
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
      ApiConstants.buildApiPath('/process/stats'),
    );
    return Response(
      data: ProcessStats.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }
}

/// 进程操作请求
class ProcessRequest {
  final String? name;
  final int? pid;
  final List<int>? pids;

  const ProcessRequest({
    this.name,
    this.pid,
    this.pids,
  });

  Map<String, dynamic> toJson() => {
        if (name != null) 'name': name,
        if (pid != null) 'pid': pid,
        if (pids != null) 'pids': pids,
      };
}
