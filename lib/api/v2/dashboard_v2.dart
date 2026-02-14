import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import '../../core/config/api_constants.dart';
import '../../data/models/monitoring_models.dart';
import '../../data/models/common_models.dart';

/// API响应解析帮助类
class ApiResponseParser {
  /// 从1Panel API响应中提取data字段
  static T extractData<T>(Response<Map<String, dynamic>> response, T Function(Map<String, dynamic>) fromJson) {
    final body = response.data!;
    if (body.containsKey('data') && body['data'] != null) {
      return fromJson(body['data'] as Map<String, dynamic>);
    }
    throw Exception('API响应格式错误: 缺少data字段');
  }

  /// 从1Panel API响应中提取data字段（Map类型）
  static Map<String, dynamic> extractMapData(Response<Map<String, dynamic>> response) {
    final body = response.data!;
    if (body.containsKey('data') && body['data'] != null) {
      return body['data'] as Map<String, dynamic>;
    }
    return {};
  }
}

class DashboardV2Api {
  final DioClient _client;

  DashboardV2Api(this._client);

  /// 获取仪表板基础指标
  ///
  /// 获取仪表板基础监控指标
  /// @param ioOption IO选项
  /// @param netOption 网络选项
  /// @return 基础指标数据
  Future<Response<Map<String, dynamic>>> getDashboardBase({
    String? ioOption,
    String? netOption,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiConstants.buildApiPath('/dashboard/base/${ioOption ?? 'default'}/${netOption ?? 'default'}'),
    );
    return Response(
      data: ApiResponseParser.extractMapData(response),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取操作系统信息
  ///
  /// 获取操作系统详细信息
  /// @return 操作系统信息
  Future<Response<SystemInfo>> getOperatingSystemInfo() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiConstants.buildApiPath('/dashboard/base/os'),
    );
    return Response(
      data: ApiResponseParser.extractData(response, SystemInfo.fromJson),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取当前指标
  ///
  /// 获取当前系统性能指标
  /// @param ioOption IO选项
  /// @param netOption 网络选项
  /// @return 当前指标数据
  Future<Response<SystemMetrics>> getCurrentMetrics({
    String? ioOption,
    String? netOption,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiConstants.buildApiPath('/dashboard/current/${ioOption ?? 'default'}/${netOption ?? 'default'}'),
    );
    return Response(
      data: ApiResponseParser.extractData(response, SystemMetrics.fromJson),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取当前节点信息
  ///
  /// 获取当前节点详细信息
  /// @return 节点信息
  Future<Response<Map<String, dynamic>>> getCurrentNode() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiConstants.buildApiPath('/dashboard/current/node'),
    );
    return Response(
      data: ApiResponseParser.extractMapData(response),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 系统重启操作
  ///
  /// 执行系统重启操作
  /// @param operation 操作类型
  /// @return 操作结果
  Future<Response<Map<String, dynamic>>> systemRestart(String operation) async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiConstants.buildApiPath('/dashboard/system/restart/$operation'),
    );
    return Response(
      data: ApiResponseParser.extractMapData(response),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取系统负载信息
  ///
  /// 获取系统负载详细信息
  /// @return 系统负载信息
  Future<Response<Map<String, dynamic>>> getSystemLoad() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiConstants.buildApiPath('/dashboard/load'),
    );
    return Response(
      data: ApiResponseParser.extractMapData(response),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取网络统计信息
  ///
  /// 获取网络接口统计信息
  /// @param interface 网络接口名称（可选）
  /// @return 网络统计信息
  Future<Response<Map<String, dynamic>>> getNetworkStats({String? interface}) async {
    final path = interface != null
        ? '/dashboard/network/stats/$interface'
        : '/dashboard/network/stats';
    final response = await _client.get<Map<String, dynamic>>(
      ApiConstants.buildApiPath(path),
    );
    return Response(
      data: ApiResponseParser.extractMapData(response),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取磁盘使用情况
  ///
  /// 获取磁盘分区使用情况
  /// @return 磁盘使用信息
  Future<Response<Map<String, dynamic>>> getDiskUsage() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiConstants.buildApiPath('/dashboard/disk/usage'),
    );
    return Response(
      data: ApiResponseParser.extractMapData(response),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取内存使用情况
  ///
  /// 获取内存使用详细信息
  /// @return 内存使用信息
  Future<Response<MemoryMetrics>> getMemoryUsage() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiConstants.buildApiPath('/dashboard/memory/usage'),
    );
    return Response(
      data: ApiResponseParser.extractData(response, MemoryMetrics.fromJson),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取CPU使用情况
  ///
  /// 获取CPU使用详细信息
  /// @return CPU使用信息
  Future<Response<CPUMetrics>> getCPUUsage() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiConstants.buildApiPath('/dashboard/cpu/usage'),
    );
    return Response(
      data: ApiResponseParser.extractData(response, CPUMetrics.fromJson),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取进程信息
  ///
  /// 获取系统进程信息
  /// @param limit 限制数量（可选）
  /// @return 进程信息列表
  Future<Response<Map<String, dynamic>>> getProcesses({int? limit}) async {
    final path = limit != null
        ? '/dashboard/processes/$limit'
        : '/dashboard/processes';
    final response = await _client.get<Map<String, dynamic>>(
      ApiConstants.buildApiPath(path),
    );
    return Response(
      data: ApiResponseParser.extractMapData(response),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取服务状态
  ///
  /// 获取系统服务状态
  /// @return 服务状态信息
  Future<Response<Map<String, dynamic>>> getServiceStatus() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiConstants.buildApiPath('/dashboard/services/status'),
    );
    return Response(
      data: ApiResponseParser.extractMapData(response),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取端口使用情况
  ///
  /// 获取端口使用统计信息
  /// @return 端口使用信息
  Future<Response<Map<String, dynamic>>> getPortUsage() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiConstants.buildApiPath('/dashboard/ports/usage'),
    );
    return Response(
      data: ApiResponseParser.extractMapData(response),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取系统时间信息
  ///
  /// 获取系统时间和时区信息
  /// @return 系统时间信息
  Future<Response<Map<String, dynamic>>> getSystemTime() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiConstants.buildApiPath('/dashboard/time/info'),
    );
    return Response(
      data: ApiResponseParser.extractMapData(response),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取系统更新信息
  ///
  /// 获取系统可用更新信息
  /// @return 系统更新信息
  Future<Response<Map<String, dynamic>>> getSystemUpdates() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiConstants.buildApiPath('/dashboard/updates/info'),
    );
    return Response(
      data: ApiResponseParser.extractMapData(response),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取安全状态
  ///
  /// 获取系统安全状态信息
  /// @return 安全状态信息
  Future<Response<Map<String, dynamic>>> getSecurityStatus() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiConstants.buildApiPath('/dashboard/security/status'),
    );
    return Response(
      data: ApiResponseParser.extractMapData(response),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取备份状态
  ///
  /// 获取系统备份状态信息
  /// @return 备份状态信息
  Future<Response<Map<String, dynamic>>> getBackupStatus() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiConstants.buildApiPath('/dashboard/backup/status'),
    );
    return Response(
      data: ApiResponseParser.extractMapData(response),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取应用状态
  ///
  /// 获取应用程序状态信息
  /// @return 应用状态信息
  Future<Response<Map<String, dynamic>>> getApplicationStatus() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiConstants.buildApiPath('/dashboard/applications/status'),
    );
    return Response(
      data: ApiResponseParser.extractMapData(response),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }
}
