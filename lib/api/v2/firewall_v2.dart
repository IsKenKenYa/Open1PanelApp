/// 1Panel V2 API - Firewall 相关接口
/// 
/// 此文件包含与防火墙管理相关的所有API接口，
/// 包括防火墙规则的创建、删除、更新、查询等操作。

import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../models/firewall_models.dart';

class FirewallV2Api {
  final ApiClient _client;

  FirewallV2Api(this._client);

  /// 获取防火墙状态
  /// 
  /// 获取防火墙的当前状态
  /// @return 防火墙状态
  Future<Response> getFirewallStatus() async {
    return await _client.get('/firewall/status');
  }

  /// 启动防火墙
  /// 
  /// 启动防火墙服务
  /// @return 启动结果
  Future<Response> startFirewall() async {
    return await _client.post('/firewall/start');
  }

  /// 停止防火墙
  /// 
  /// 停止防火墙服务
  /// @return 停止结果
  Future<Response> stopFirewall() async {
    return await _client.post('/firewall/stop');
  }

  /// 重启防火墙
  /// 
  /// 重启防火墙服务
  /// @return 重启结果
  Future<Response> restartFirewall() async {
    return await _client.post('/firewall/restart');
  }

  /// 创建防火墙规则
  /// 
  /// 创建一个新的防火墙规则
  /// @param rule 防火墙规则配置信息
  /// @return 创建结果
  Future<Response> createFirewallRule(Map<String, dynamic> rule) async {
    return await _client.post('/firewall/rules', data: rule);
  }

  /// 删除防火墙规则
  /// 
  /// 删除指定的防火墙规则
  /// @param ids 规则ID列表
  /// @return 删除结果
  Future<Response> deleteFirewallRule(List<int> ids) async {
    final data = {
      'ids': ids,
    };
    return await _client.post('/firewall/rules/del', data: data);
  }

  /// 更新防火墙规则
  /// 
  /// 更新指定的防火墙规则
  /// @param id 规则ID
  /// @param rule 更新的规则信息
  /// @return 更新结果
  Future<Response> updateFirewallRule(int id, Map<String, dynamic> rule) async {
    return await _client.post('/firewall/rules/$id/update', data: rule);
  }

  /// 获取防火墙规则列表
  /// 
  /// 获取所有防火墙规则列表
  /// @param search 搜索关键词（可选）
  /// @param type 规则类型（可选）
  /// @param page 页码（可选，默认为1）
  /// @param pageSize 每页数量（可选，默认为10）
  /// @return 防火墙规则列表
  Future<Response> getFirewallRules({
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
    return await _client.post('/firewall/rules/search', data: data);
  }

  /// 获取防火墙规则详情
  /// 
  /// 获取指定防火墙规则的详细信息
  /// @param id 规则ID
  /// @return 规则详情
  Future<Response> getFirewallRuleDetail(int id) async {
    return await _client.get('/firewall/rules/$id');
  }

  /// 启用防火墙规则
  /// 
  /// 启用指定的防火墙规则
  /// @param ids 规则ID列表
  /// @return 启用结果
  Future<Response> enableFirewallRule(List<int> ids) async {
    final data = {
      'ids': ids,
    };
    return await _client.post('/firewall/rules/enable', data: data);
  }

  /// 禁用防火墙规则
  /// 
  /// 禁用指定的防火墙规则
  /// @param ids 规则ID列表
  /// @return 禁用结果
  Future<Response> disableFirewallRule(List<int> ids) async {
    final data = {
      'ids': ids,
    };
    return await _client.post('/firewall/rules/disable', data: data);
  }

  /// 获取防火墙端口列表
  /// 
  /// 获取所有防火墙端口列表
  /// @param search 搜索关键词（可选）
  /// @param page 页码（可选，默认为1）
  /// @param pageSize 每页数量（可选，默认为10）
  /// @return 防火墙端口列表
  Future<Response> getFirewallPorts({
    String? search,
    int page = 1,
    int pageSize = 10,
  }) async {
    final data = {
      'page': page,
      'pageSize': pageSize,
      if (search != null) 'search': search,
    };
    return await _client.post('/firewall/ports/search', data: data);
  }

  /// 开放防火墙端口
  /// 
  /// 开放指定的防火墙端口
  /// @param port 端口号
  /// @param protocol 协议（tcp/udp）
  /// @param strategy 策略（accept/drop）
  /// @return 开放结果
  Future<Response> openFirewallPort(int port, String protocol, String strategy) async {
    final data = {
      'port': port,
      'protocol': protocol,
      'strategy': strategy,
    };
    return await _client.post('/firewall/ports/open', data: data);
  }

  /// 关闭防火墙端口
  /// 
  /// 关闭指定的防火墙端口
  /// @param port 端口号
  /// @param protocol 协议（tcp/udp）
  /// @return 关闭结果
  Future<Response> closeFirewallPort(int port, String protocol) async {
    final data = {
      'port': port,
      'protocol': protocol,
    };
    return await _client.post('/firewall/ports/close', data: data);
  }

  /// 获取防火墙日志
  /// 
  /// 获取防火墙日志
  /// @param search 搜索关键词（可选）
  /// @param page 页码（可选，默认为1）
  /// @param pageSize 每页数量（可选，默认为10）
  /// @return 防火墙日志
  Future<Response> getFirewallLogs({
    String? search,
    int page = 1,
    int pageSize = 10,
  }) async {
    final data = {
      'page': page,
      'pageSize': pageSize,
      if (search != null) 'search': search,
    };
    return await _client.post('/firewall/logs/search', data: data);
  }
}