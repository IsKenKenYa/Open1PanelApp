import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import '../../core/config/api_constants.dart';
import '../../data/models/firewall_models.dart';
import '../../data/models/common_models.dart';

class FirewallV2Api {
  final DioClient _client;

  FirewallV2Api(this._client);

  /// 获取防火墙状态
  ///
  /// 获取防火墙的当前状态
  /// @return 防火墙状态
  Future<Response<FirewallStatus>> getFirewallStatus() async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/hosts/firewall/status'),
    );
    return Response(
      data: FirewallStatus.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 启动防火墙
  ///
  /// 启动防火墙服务
  /// @return 启动结果
  Future<Response> startFirewall() async {
    return await _client.post(
      ApiConstants.buildApiPath('/hosts/firewall/start'),
    );
  }

  /// 停止防火墙
  ///
  /// 停止防火墙服务
  /// @return 停止结果
  Future<Response> stopFirewall() async {
    return await _client.post(
      ApiConstants.buildApiPath('/hosts/firewall/stop'),
    );
  }

  /// 重启防火墙
  ///
  /// 重启防火墙服务
  /// @return 重启结果
  Future<Response> restartFirewall() async {
    return await _client.post(
      ApiConstants.buildApiPath('/hosts/firewall/restart'),
    );
  }

  /// 创建防火墙规则
  ///
  /// 创建一个新的防火墙规则
  /// @param rule 防火墙规则配置信息
  /// @return 创建结果
  Future<Response> createFirewallRule(FirewallRuleCreate rule) async {
    return await _client.post(
      ApiConstants.buildApiPath('/hosts/firewall/rules'),
      data: rule.toJson(),
    );
  }

  /// 删除防火墙规则
  ///
  /// 删除指定的防火墙规则
  /// @param ids 规则ID列表
  /// @return 删除结果
  Future<Response> deleteFirewallRule(List<int> ids) async {
    final operation = BatchDelete(ids: ids);
    return await _client.post(
      ApiConstants.buildApiPath('/hosts/firewall/rules/del'),
      data: operation.toJson(),
    );
  }

  /// 更新防火墙规则
  ///
  /// 更新指定的防火墙规则
  /// @param rule 更新的规则信息
  /// @return 更新结果
  Future<Response> updateFirewallRule(FirewallRuleUpdate rule) async {
    return await _client.post(
      ApiConstants.buildApiPath('/hosts/firewall/rules/${rule.id}/update'),
      data: rule.toJson(),
    );
  }

  /// 获取防火墙规则列表
  ///
  /// 获取所有防火墙规则列表
  /// @param search 搜索关键词（可选）
  /// @param type 规则类型（可选）
  /// @param enabled 启用状态（可选）
  /// @param page 页码（可选，默认为1）
  /// @param pageSize 每页数量（可选，默认为10）
  /// @return 防火墙规则列表
  Future<Response<PageResult<FirewallRule>>> getFirewallRules({
    String? search,
    String? type,
    bool? enabled,
    int page = 1,
    int pageSize = 10,
  }) async {
    final request = FirewallRuleSearch(
      page: page,
      pageSize: pageSize,
      search: search,
      type: type,
      enabled: enabled,
    );
    final response = await _client.post(
      ApiConstants.buildApiPath('/hosts/firewall/rules/search'),
      data: request.toJson(),
    );
    return Response(
      data: PageResult.fromJson(
        response.data as Map<String, dynamic>,
        (json) => FirewallRule.fromJson(json as Map<String, dynamic>),
      ),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取防火墙规则详情
  ///
  /// 获取指定防火墙规则的详细信息
  /// @param id 规则ID
  /// @return 规则详情
  Future<Response<FirewallRule>> getFirewallRuleDetail(int id) async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/hosts/firewall/rules/$id'),
    );
    return Response(
      data: FirewallRule.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 启用防火墙规则
  ///
  /// 启用指定的防火墙规则
  /// @param ids 规则ID列表
  /// @return 启用结果
  Future<Response> enableFirewallRule(List<int> ids) async {
    final operation = BatchDelete(ids: ids);
    return await _client.post(
      ApiConstants.buildApiPath('/hosts/firewall/rules/enable'),
      data: operation.toJson(),
    );
  }

  /// 禁用防火墙规则
  ///
  /// 禁用指定的防火墙规则
  /// @param ids 规则ID列表
  /// @return 禁用结果
  Future<Response> disableFirewallRule(List<int> ids) async {
    final operation = BatchDelete(ids: ids);
    return await _client.post(
      ApiConstants.buildApiPath('/hosts/firewall/rules/disable'),
      data: operation.toJson(),
    );
  }

  /// 获取防火墙端口列表
  ///
  /// 获取所有防火墙端口列表
  /// @param search 搜索关键词（可选）
  /// @param protocol 协议（可选）
  /// @param strategy 策略（可选）
  /// @param enabled 启用状态（可选）
  /// @param page 页码（可选，默认为1）
  /// @param pageSize 每页数量（可选，默认为10）
  /// @return 防火墙端口列表
  Future<Response<PageResult<FirewallPort>>> getFirewallPorts({
    String? search,
    String? protocol,
    String? strategy,
    bool? enabled,
    int page = 1,
    int pageSize = 10,
  }) async {
    final request = FirewallPortSearch(
      page: page,
      pageSize: pageSize,
      search: search,
      protocol: protocol,
      strategy: strategy,
      enabled: enabled,
    );
    final response = await _client.post(
      ApiConstants.buildApiPath('/hosts/firewall/ports/search'),
      data: request.toJson(),
    );
    return Response(
      data: PageResult.fromJson(
        response.data as Map<String, dynamic>,
        (json) => FirewallPort.fromJson(json as Map<String, dynamic>),
      ),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 开放防火墙端口
  ///
  /// 开放指定的防火墙端口
  /// @param portCreate 端口创建配置
  /// @return 开放结果
  Future<Response> openFirewallPort(FirewallPortCreate portCreate) async {
    return await _client.post(
      ApiConstants.buildApiPath('/hosts/firewall/ports/open'),
      data: portCreate.toJson(),
    );
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
    return await _client.post(
      ApiConstants.buildApiPath('/hosts/firewall/ports/close'),
      data: data,
    );
  }

  /// 获取防火墙日志
  ///
  /// 获取防火墙日志
  /// @param search 搜索关键词（可选）
  /// @param action 操作类型（可选）
  /// @param source 源地址（可选）
  /// @param protocol 协议（可选）
  /// @param startTime 开始时间（可选）
  /// @param endTime 结束时间（可选）
  /// @param page 页码（可选，默认为1）
  /// @param pageSize 每页数量（可选，默认为10）
  /// @return 防火墙日志
  Future<Response<PageResult<FirewallLog>>> getFirewallLogs({
    String? search,
    String? action,
    String? source,
    String? protocol,
    String? startTime,
    String? endTime,
    int page = 1,
    int pageSize = 10,
  }) async {
    final request = FirewallLogSearch(
      page: page,
      pageSize: pageSize,
      search: search,
      action: action,
      source: source,
      protocol: protocol,
      startTime: startTime,
      endTime: endTime,
    );
    final response = await _client.post(
      ApiConstants.buildApiPath('/hosts/firewall/logs/search'),
      data: request.toJson(),
    );
    return Response(
      data: PageResult.fromJson(
        response.data as Map<String, dynamic>,
        (json) => FirewallLog.fromJson(json as Map<String, dynamic>),
      ),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }
}
