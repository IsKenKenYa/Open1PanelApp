/// 1Panel V2 API - Monitor 相关接口
///
/// 此文件包含与系统监控相关的所有API接口，
/// 包括主机监控、资源监控、性能监控等操作。

import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/config/api_constants.dart';
import '../../data/models/monitoring_models.dart';
import '../../data/models/common_models.dart';

class MonitorV2Api {
  final ApiClient _client;

  MonitorV2Api(this._client);

  /// 获取系统指标
  ///
  /// 获取系统监控指标数据
  /// @param metricType 指标类型（可选）
  /// @param timeRange 时间范围（可选，默认为1h）
  /// @return 系统指标数据
  Future<Response<SystemMetrics>> getSystemMetrics({
    MetricType? metricType,
    String timeRange = '1h',
  }) async {
    final data = {
      'metricType': metricType?.value,
      'timeRange': timeRange,
    };
    final response = await _client.post(
      ApiConstants.buildApiPath('/monitoring/system'),
      data: data,
    );
    return Response(
      data: SystemMetrics.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取CPU指标
  ///
  /// 获取CPU监控指标数据
  /// @param timeRange 时间范围（可选，默认为1h）
  /// @return CPU指标数据
  Future<Response<CPUMetrics>> getCPUMetrics({String timeRange = '1h'}) async {
    final data = {
      'timeRange': timeRange,
    };
    final response = await _client.post(
      ApiConstants.buildApiPath('/monitoring/cpu'),
      data: data,
    );
    return Response(
      data: CPUMetrics.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取内存指标
  ///
  /// 获取内存监控指标数据
  /// @param timeRange 时间范围（可选，默认为1h）
  /// @return 内存指标数据
  Future<Response<MemoryMetrics>> getMemoryMetrics({String timeRange = '1h'}) async {
    final data = {
      'timeRange': timeRange,
    };
    final response = await _client.post(
      ApiConstants.buildApiPath('/monitoring/memory'),
      data: data,
    );
    return Response(
      data: MemoryMetrics.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取磁盘指标
  ///
  /// 获取磁盘监控指标数据
  /// @param device 磁盘设备（可选）
  /// @param timeRange 时间范围（可选，默认为1h）
  /// @return 磁盘指标数据
  Future<Response<List<DiskMetrics>>> getDiskMetrics({
    String? device,
    String timeRange = '1h',
  }) async {
    final data = {
      if (device != null) 'device': device,
      'timeRange': timeRange,
    };
    final response = await _client.post(
      ApiConstants.buildApiPath('/monitoring/disk'),
      data: data,
    );
    return Response(
      data: (response.data as List?)
          ?.map((item) => DiskMetrics.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取网络指标
  ///
  /// 获取网络监控指标数据
  /// @param interface 网络接口（可选）
  /// @param timeRange 时间范围（可选，默认为1h）
  /// @return 网络指标数据
  Future<Response<List<NetworkMetrics>>> getNetworkMetrics({
    String? interface,
    String timeRange = '1h',
  }) async {
    final data = {
      if (interface != null) 'interface': interface,
      'timeRange': timeRange,
    };
    final response = await _client.post(
      ApiConstants.buildApiPath('/monitoring/network'),
      data: data,
    );
    return Response(
      data: (response.data as List?)
          ?.map((item) => NetworkMetrics.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取告警规则列表
  ///
  /// 获取所有告警规则
  /// @param search 搜索关键词（可选）
  /// @param metricType 指标类型（可选）
  /// @param level 告警级别（可选）
  /// @param page 页码（可选，默认为1）
  /// @param pageSize 每页数量（可选，默认为10）
  /// @return 告警规则列表
  Future<Response<PageResult<AlertRule>>> getAlertRules({
    String? search,
    MetricType? metricType,
    AlertLevel? level,
    int page = 1,
    int pageSize = 10,
  }) async {
    final data = {
      'page': page,
      'pageSize': pageSize,
      if (search != null) 'search': search,
      'metricType': metricType?.value,
      'level': level?.value,
    };
    final response = await _client.post(
      ApiConstants.buildApiPath('/monitoring/alerts/rules/search'),
      data: data,
    );
    return Response(
      data: PageResult.fromJson(
        response.data as Map<String, dynamic>,
        (json) => AlertRule.fromJson(json as Map<String, dynamic>),
      ),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 创建告警规则
  ///
  /// 创建新的告警规则
  /// @param rule 告警规则信息
  /// @return 创建结果
  Future<Response> createAlertRule(AlertRule rule) async {
    return await _client.post(
      ApiConstants.buildApiPath('/monitoring/alerts/rules'),
      data: rule.toJson(),
    );
  }

  /// 更新告警规则
  ///
  /// 更新指定的告警规则
  /// @param rule 告警规则更新信息
  /// @return 更新结果
  Future<Response> updateAlertRule(AlertRule rule) async {
    return await _client.post(
      ApiConstants.buildApiPath('/monitoring/alerts/rules/${rule.id}'),
      data: rule.toJson(),
    );
  }

  /// 删除告警规则
  ///
  /// 删除指定的告警规则
  /// @param ids 规则ID列表
  /// @return 删除结果
  Future<Response> deleteAlertRules(List<int> ids) async {
    final operation = OperateByID(ids: ids);
    return await _client.post(
      ApiConstants.buildApiPath('/monitoring/alerts/rules/del'),
      data: operation.toJson(),
    );
  }

  /// 启用告警规则
  ///
  /// 启用指定的告警规则
  /// @param ids 规则ID列表
  /// @return 启用结果
  Future<Response> enableAlertRules(List<int> ids) async {
    final operation = OperateByID(ids: ids);
    return await _client.post(
      ApiConstants.buildApiPath('/monitoring/alerts/rules/enable'),
      data: operation.toJson(),
    );
  }

  /// 禁用告警规则
  ///
  /// 禁用指定的告警规则
  /// @param ids 规则ID列表
  /// @return 禁用结果
  Future<Response> disableAlertRules(List<int> ids) async {
    final operation = OperateByID(ids: ids);
    return await _client.post(
      ApiConstants.buildApiPath('/monitoring/alerts/rules/disable'),
      data: operation.toJson(),
    );
  }

  /// 获取告警通知列表
  ///
  /// 获取告警通知列表
  /// @param search 搜索关键词（可选）
  /// @param level 告警级别（可选）
  /// @param acknowledged 是否已确认（可选）
  /// @param page 页码（可选，默认为1）
  /// @param pageSize 每页数量（可选，默认为10）
  /// @return 告警通知列表
  Future<Response<PageResult<AlertNotification>>> getAlertNotifications({
    String? search,
    AlertLevel? level,
    bool? acknowledged,
    int page = 1,
    int pageSize = 10,
  }) async {
    final data = {
      'page': page,
      'pageSize': pageSize,
      if (search != null) 'search': search,
      'level': level?.value,
      'acknowledged': acknowledged,
    };
    final response = await _client.post(
      ApiConstants.buildApiPath('/monitoring/alerts/notifications/search'),
      data: data,
    );
    return Response(
      data: PageResult.fromJson(
        response.data as Map<String, dynamic>,
        (json) => AlertNotification.fromJson(json as Map<String, dynamic>),
      ),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 确认告警通知
  ///
  /// 确认指定的告警通知
  /// @param ids 通知ID列表
  /// @return 确认结果
  Future<Response> acknowledgeAlertNotifications(List<int> ids) async {
    final operation = OperateByID(ids: ids);
    return await _client.post(
      ApiConstants.buildApiPath('/monitoring/alerts/notifications/acknowledge'),
      data: operation.toJson(),
    );
  }

  /// 获取监控配置
  ///
  /// 获取系统监控配置
  /// @return 监控配置
  Future<Response> getMonitoringConfig() async {
    return await _client.get(
      ApiConstants.buildApiPath('/monitoring/config'),
    );
  }

  /// 更新监控配置
  ///
  /// 更新系统监控配置
  /// @param config 监控配置
  /// @return 更新结果
  Future<Response> updateMonitoringConfig(SecurityConfig config) async {
    return await _client.post(
      ApiConstants.buildApiPath('/monitoring/config'),
      data: config.toJson(),
    );
  }

  /// 获取监控统计信息
  ///
  /// 获取监控统计信息
  /// @return 统计信息
  Future<Response> getMonitoringStats() async {
    return await _client.get(
      ApiConstants.buildApiPath('/monitoring/stats'),
    );
  }

  /// 测试告警规则
  ///
  /// 测试告警规则的有效性
  /// @param rule 告警规则
  /// @return 测试结果
  Future<Response<Map<String, dynamic>>> testAlertRule(AlertRule rule) async {
    return await _client.post(
      ApiConstants.buildApiPath('/monitoring/alerts/rules/test'),
      data: rule.toJson(),
    );
  }

  /// 获取监控仪表板数据
  ///
  /// 获取监控仪表板数据
  /// @return 仪表板数据
  Future<Response<Map<String, dynamic>>> getMonitoringDashboard() async {
    return await _client.get(
      ApiConstants.buildApiPath('/monitoring/dashboard'),
    );
  }

  /// 导出监控数据
  ///
  /// 导出监控数据
  /// @param metricType 指标类型
  /// @param startTime 开始时间
  /// @param endTime 结束时间
  /// @param format 导出格式（可选，默认为json）
  /// @return 导出结果
  Future<Response> exportMonitoringData({
    required MetricType metricType,
    required String startTime,
    required String endTime,
    String format = 'json',
  }) async {
    final data = {
      'metricType': metricType.value,
      'startTime': startTime,
      'endTime': endTime,
      'format': format,
    };
    return await _client.post(
      ApiConstants.buildApiPath('/monitoring/export'),
      data: data,
    );
  }
}