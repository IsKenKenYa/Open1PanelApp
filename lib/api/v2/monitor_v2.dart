/// 1Panel V2 API - Monitor 相关接口
/// 
/// 此文件包含与系统监控相关的所有API接口，
/// 包括主机监控、资源监控、性能监控等操作。

import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../models/monitor_models.dart';

class MonitorV2Api {
  final ApiClient _client;

  MonitorV2Api(this._client);

  /// 获取主机监控数据
  /// 
  /// 获取主机的监控数据
  /// @param timeRange 时间范围（可选，默认为1h）
  /// @return 监控数据
  Future<Response> getHostMonitorData({String timeRange = '1h'}) async {
    final data = {
      'timeRange': timeRange,
    };
    return await _client.post('/hosts/monitor', data: data);
  }

  /// 获取主机监控设置
  /// 
  /// 获取主机的监控设置
  /// @return 监控设置
  Future<Response> getHostMonitorSetting() async {
    return await _client.get('/hosts/monitor/setting');
  }

  /// 更新主机监控设置
  /// 
  /// 更新主机的监控设置
  /// @param setting 监控设置
  /// @return 更新结果
  Future<Response> updateHostMonitorSetting(Map<String, dynamic> setting) async {
    return await _client.post('/hosts/monitor/setting', data: setting);
  }

  /// 搜索主机监控数据
  /// 
  /// 搜索主机监控数据
  /// @param search 搜索关键词（可选）
  /// @param page 页码（可选，默认为1）
  /// @param pageSize 每页数量（可选，默认为10）
  /// @return 监控搜索结果
  Future<Response> searchHostMonitor({
    String? search,
    int page = 1,
    int pageSize = 10,
  }) async {
    final data = {
      'page': page,
      'pageSize': pageSize,
      if (search != null) 'search': search,
    };
    return await _client.post('/hosts/monitor/search', data: data);
  }

  /// 获取系统资源使用情况
  /// 
  /// 获取系统资源使用情况
  /// @return 资源使用情况
  Future<Response> getSystemResourceUsage() async {
    return await _client.get('/monitor/system/resource');
  }

  /// 获取CPU使用情况
  /// 
  /// 获取CPU使用情况
  /// @param timeRange 时间范围（可选，默认为1h）
  /// @return CPU使用情况
  Future<Response> getCpuUsage({String timeRange = '1h'}) async {
    final data = {
      'timeRange': timeRange,
    };
    return await _client.post('/monitor/cpu', data: data);
  }

  /// 获取内存使用情况
  /// 
  /// 获取内存使用情况
  /// @param timeRange 时间范围（可选，默认为1h）
  /// @return 内存使用情况
  Future<Response> getMemoryUsage({String timeRange = '1h'}) async {
    final data = {
      'timeRange': timeRange,
    };
    return await _client.post('/monitor/memory', data: data);
  }

  /// 获取磁盘使用情况
  /// 
  /// 获取磁盘使用情况
  /// @param timeRange 时间范围（可选，默认为1h）
  /// @return 磁盘使用情况
  Future<Response> getDiskUsage({String timeRange = '1h'}) async {
    final data = {
      'timeRange': timeRange,
    };
    return await _client.post('/monitor/disk', data: data);
  }

  /// 获取网络使用情况
  /// 
  /// 获取网络使用情况
  /// @param timeRange 时间范围（可选，默认为1h）
  /// @return 网络使用情况
  Future<Response> getNetworkUsage({String timeRange = '1h'}) async {
    final data = {
      'timeRange': timeRange,
    };
    return await _client.post('/monitor/network', data: data);
  }

  /// 获取进程监控数据
  /// 
  /// 获取进程监控数据
  /// @param search 搜索关键词（可选）
  /// @param page 页码（可选，默认为1）
  /// @param pageSize 每页数量（可选，默认为10）
  /// @return 进程监控数据
  Future<Response> getProcessMonitor({
    String? search,
    int page = 1,
    int pageSize = 10,
  }) async {
    final data = {
      'page': page,
      'pageSize': pageSize,
      if (search != null) 'search': search,
    };
    return await _client.post('/monitor/process/search', data: data);
  }

  /// 获取服务监控数据
  /// 
  /// 获取服务监控数据
  /// @param search 搜索关键词（可选）
  /// @param page 页码（可选，默认为1）
  /// @param pageSize 每页数量（可选，默认为10）
  /// @return 服务监控数据
  Future<Response> getServiceMonitor({
    String? search,
    int page = 1,
    int pageSize = 10,
  }) async {
    final data = {
      'page': page,
      'pageSize': pageSize,
      if (search != null) 'search': search,
    };
    return await _client.post('/monitor/service/search', data: data);
  }

  /// 获取监控告警规则
  /// 
  /// 获取监控告警规则
  /// @param search 搜索关键词（可选）
  /// @param page 页码（可选，默认为1）
  /// @param pageSize 每页数量（可选，默认为10）
  /// @return 告警规则列表
  Future<Response> getAlertRules({
    String? search,
    int page = 1,
    int pageSize = 10,
  }) async {
    final data = {
      'page': page,
      'pageSize': pageSize,
      if (search != null) 'search': search,
    };
    return await _client.post('/monitor/alert/rules/search', data: data);
  }

  /// 创建监控告警规则
  /// 
  /// 创建一个新的监控告警规则
  /// @param rule 告警规则配置信息
  /// @return 创建结果
  Future<Response> createAlertRule(Map<String, dynamic> rule) async {
    return await _client.post('/monitor/alert/rules', data: rule);
  }

  /// 更新监控告警规则
  /// 
  /// 更新指定的监控告警规则
  /// @param id 规则ID
  /// @param rule 更新的规则信息
  /// @return 更新结果
  Future<Response> updateAlertRule(int id, Map<String, dynamic> rule) async {
    return await _client.post('/monitor/alert/rules/$id/update', data: rule);
  }

  /// 删除监控告警规则
  /// 
  /// 删除指定的监控告警规则
  /// @param ids 规则ID列表
  /// @return 删除结果
  Future<Response> deleteAlertRule(List<int> ids) async {
    final data = {
      'ids': ids,
    };
    return await _client.post('/monitor/alert/rules/del', data: data);
  }

  /// 获取监控告警历史
  /// 
  /// 获取监控告警历史
  /// @param search 搜索关键词（可选）
  /// @param page 页码（可选，默认为1）
  /// @param pageSize 每页数量（可选，默认为10）
  /// @return 告警历史
  Future<Response> getAlertHistory({
    String? search,
    int page = 1,
    int pageSize = 10,
  }) async {
    final data = {
      'page': page,
      'pageSize': pageSize,
      if (search != null) 'search': search,
    };
    return await _client.post('/monitor/alert/history/search', data: data);
  }
}