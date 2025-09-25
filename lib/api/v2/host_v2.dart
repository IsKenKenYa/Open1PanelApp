/// 1Panel V2 API - Host 相关接口
/// 
/// 此文件包含与主机管理相关的所有API接口，
/// 包括主机的创建、删除、更新、查询等操作。

import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../models/host_models.dart';

class HostV2Api {
  final ApiClient _client;

  HostV2Api(this._client);

  /// 创建主机
  /// 
  /// 创建一个新的主机
  /// @param host 主机配置信息
  /// @return 创建结果
  Future<Response> createHost(Map<String, dynamic> host) async {
    return await _client.post('/hosts', data: host);
  }

  /// 删除主机
  /// 
  /// 删除指定的主机
  /// @param ids 主机ID列表
  /// @return 删除结果
  Future<Response> deleteHost(List<int> ids) async {
    final data = {
      'ids': ids,
    };
    return await _client.post('/hosts/del', data: data);
  }

  /// 更新主机信息
  /// 
  /// 更新指定主机的信息
  /// @param id 主机ID
  /// @param host 更新的主机信息
  /// @return 更新结果
  Future<Response> updateHost(int id, Map<String, dynamic> host) async {
    return await _client.post('/hosts/$id/update', data: host);
  }

  /// 获取主机列表
  /// 
  /// 获取所有主机列表
  /// @param search 搜索关键词（可选）
  /// @param page 页码（可选，默认为1）
  /// @param pageSize 每页数量（可选，默认为10）
  /// @return 主机列表
  Future<Response> getHosts({
    String? search,
    int page = 1,
    int pageSize = 10,
  }) async {
    final data = {
      'page': page,
      'pageSize': pageSize,
      if (search != null) 'search': search,
    };
    return await _client.post('/hosts/search', data: data);
  }

  /// 获取主机详情
  /// 
  /// 获取指定主机的详细信息
  /// @param id 主机ID
  /// @return 主机详情
  Future<Response> getHostDetail(int id) async {
    return await _client.get('/hosts/$id');
  }

  /// 获取主机监控数据
  /// 
  /// 获取指定主机的监控数据
  /// @param id 主机ID
  /// @param timeRange 时间范围（可选，默认为1h）
  /// @return 监控数据
  Future<Response> getHostMonitorData(int id, {String timeRange = '1h'}) async {
    final data = {
      'timeRange': timeRange,
    };
    return await _client.post('/hosts/$id/monitor', data: data);
  }

  /// 获取主机监控设置
  /// 
  /// 获取指定主机的监控设置
  /// @param id 主机ID
  /// @return 监控设置
  Future<Response> getHostMonitorSetting(int id) async {
    return await _client.get('/hosts/$id/monitor/setting');
  }

  /// 更新主机监控设置
  /// 
  /// 更新指定主机的监控设置
  /// @param id 主机ID
  /// @param setting 监控设置
  /// @return 更新结果
  Future<Response> updateHostMonitorSetting(int id, Map<String, dynamic> setting) async {
    return await _client.post('/hosts/$id/monitor/setting', data: setting);
  }

  /// 获取主机监控搜索结果
  /// 
  /// 搜索主机监控数据
  /// @param id 主机ID
  /// @param search 搜索关键词（可选）
  /// @param page 页码（可选，默认为1）
  /// @param pageSize 每页数量（可选，默认为10）
  /// @return 监控搜索结果
  Future<Response> searchHostMonitor(int id, {
    String? search,
    int page = 1,
    int pageSize = 10,
  }) async {
    final data = {
      'page': page,
      'pageSize': pageSize,
      if (search != null) 'search': search,
    };
    return await _client.post('/hosts/$id/monitor/search', data: data);
  }
}