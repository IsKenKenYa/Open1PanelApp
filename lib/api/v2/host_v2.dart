import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import '../../core/config/api_constants.dart';
import '../../data/models/host_models.dart';
import '../../data/models/common_models.dart';

class HostV2Api {
  final DioClient _client;

  HostV2Api(this._client);

  /// 创建主机
  ///
  /// 创建一个新的主机
  /// @param request 主机创建请求
  /// @return 创建结果
  Future<Response> createHost(HostCreate request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/core/hosts'),
      data: request.toJson(),
    );
  }

  /// 删除主机
  ///
  /// 删除指定的主机
  /// @param request 删除请求
  /// @return 删除结果
  Future<Response> deleteHost(OperateByID request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/core/hosts/del'),
      data: request.toJson(),
    );
  }

  /// 更新主机信息
  ///
  /// 更新指定主机的信息
  /// @param request 主机更新请求
  /// @return 更新结果
  Future<Response> updateHost(HostUpdate request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/core/hosts/${request.id}/update'),
      data: request.toJson(),
    );
  }

  /// 获取主机列表
  ///
  /// 获取所有主机列表
  /// @param request 主机搜索请求
  /// @return 主机列表
  Future<Response<PageResult<HostInfo>>> getHosts(HostSearch request) async {
    final response = await _client.post(
      ApiConstants.buildApiPath('/core/hosts/search'),
      data: request.toJson(),
    );
    return Response(
      data: PageResult.fromJson(
        response.data as Map<String, dynamic>,
        (json) => HostInfo.fromJson(json as Map<String, dynamic>),
      ),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取主机详情
  ///
  /// 获取指定主机的详细信息
  /// @param id 主机ID
  /// @return 主机详情
  Future<Response<HostInfo>> getHostDetail(int id) async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/core/hosts/$id'),
    );
    return Response(
      data: HostInfo.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取主机监控数据
  ///
  /// 获取指定主机的监控数据
  /// @param id 主机ID
  /// @param timeRange 时间范围（可选，默认为1h）
  /// @return 监控数据
  Future<Response<HostMonitor>> getHostMonitorData(int id, {String timeRange = '1h'}) async {
    final data = {
      'timeRange': timeRange,
    };
    final response = await _client.post(
      ApiConstants.buildApiPath('/core/hosts/$id/monitor'),
      data: data,
    );
    return Response(
      data: HostMonitor.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取主机监控设置
  ///
  /// 获取指定主机的监控设置
  /// @param id 主机ID
  /// @return 监控设置
  Future<Response<HostMonitorSetting>> getHostMonitorSetting(int id) async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/core/hosts/$id/monitor/setting'),
    );
    return Response(
      data: HostMonitorSetting.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 更新主机监控设置
  ///
  /// 更新指定主机的监控设置
  /// @param request 主机监控设置更新请求
  /// @return 更新结果
  Future<Response> updateHostMonitorSetting(HostMonitorSetting request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/core/hosts/${request.hostId}/monitor/setting'),
      data: request.toJson(),
    );
  }

  /// 获取主机监控搜索结果
  ///
  /// 搜索主机监控数据
  /// @param id 主机ID
  /// @param request 搜索请求
  /// @return 监控搜索结果
  Future<Response<PageResult<HostMonitor>>> searchHostMonitor(int id, HostSearch request) async {
    final response = await _client.post(
      ApiConstants.buildApiPath('/core/hosts/$id/monitor/search'),
      data: request.toJson(),
    );
    return Response(
      data: PageResult.fromJson(
        response.data as Map<String, dynamic>,
        (json) => HostMonitor.fromJson(json as Map<String, dynamic>),
      ),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }
}
