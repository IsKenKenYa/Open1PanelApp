/// 1Panel V2 API - SSL 相关接口
/// 
/// 此文件包含与SSL证书管理相关的所有API接口，
/// 包括证书的创建、删除、更新、查询等操作。

import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../models/ssl_models.dart';

class SSLV2Api {
  final ApiClient _client;

  SSLV2Api(this._client);

  /// 创建SSL证书
  /// 
  /// 创建一个新的SSL证书
  /// @param ssl 证书配置信息
  /// @return 创建结果
  Future<Response> createSSL(Map<String, dynamic> ssl) async {
    return await _client.post('/ssl', data: ssl);
  }

  /// 删除SSL证书
  /// 
  /// 删除指定的SSL证书
  /// @param ids 证书ID列表
  /// @return 删除结果
  Future<Response> deleteSSL(List<int> ids) async {
    final data = {
      'ids': ids,
    };
    return await _client.post('/ssl/del', data: data);
  }

  /// 更新SSL证书
  /// 
  /// 更新指定的SSL证书
  /// @param id 证书ID
  /// @param ssl 更新的证书信息
  /// @return 更新结果
  Future<Response> updateSSL(int id, Map<String, dynamic> ssl) async {
    return await _client.post('/ssl/$id/update', data: ssl);
  }

  /// 获取SSL证书列表
  /// 
  /// 获取所有SSL证书列表
  /// @param search 搜索关键词（可选）
  /// @param page 页码（可选，默认为1）
  /// @param pageSize 每页数量（可选，默认为10）
  /// @return SSL证书列表
  Future<Response> getSSLs({
    String? search,
    int page = 1,
    int pageSize = 10,
  }) async {
    final data = {
      'page': page,
      'pageSize': pageSize,
      if (search != null) 'search': search,
    };
    return await _client.post('/ssl/search', data: data);
  }

  /// 获取SSL证书详情
  /// 
  /// 获取指定SSL证书的详细信息
  /// @param id 证书ID
  /// @return SSL证书详情
  Future<Response> getSSLDetail(int id) async {
    return await _client.get('/ssl/$id');
  }

  /// 申请SSL证书
  /// 
  /// 申请新的SSL证书
  /// @param domain 域名
  /// @param email 邮箱
  /// @param type 申请类型（可选，默认为dns）
  /// @return 申请结果
  Future<Response> applySSL(String domain, String email, {String type = 'dns'}) async {
    final data = {
      'domain': domain,
      'email': email,
      'type': type,
    };
    return await _client.post('/ssl/apply', data: data);
  }

  /// 续签SSL证书
  /// 
  /// 续签指定的SSL证书
  /// @param id 证书ID
  /// @return 续签结果
  Future<Response> renewSSL(int id) async {
    return await _client.post('/ssl/$id/renew');
  }

  /// 验证SSL证书
  /// 
  /// 验证指定的SSL证书
  /// @param id 证书ID
  /// @return 验证结果
  Future<Response> verifySSL(int id) async {
    return await _client.post('/ssl/$id/verify');
  }

  /// 获取SSL证书申请记录
  /// 
  /// 获取SSL证书的申请记录
  /// @param id 证书ID
  /// @return 申请记录
  Future<Response> getSSLApplyRecord(int id) async {
    return await _client.get('/ssl/$id/apply/record');
  }

  /// 获取SSL证书DNS验证配置
  /// 
  /// 获取SSL证书DNS验证的配置信息
  /// @param id 证书ID
  /// @return DNS验证配置
  Future<Response> getSSLDnsConfig(int id) async {
    return await _client.get('/ssl/$id/dns/config');
  }

  /// 更新SSL证书DNS验证配置
  /// 
  /// 更新SSL证书DNS验证的配置信息
  /// @param id 证书ID
  /// @param config DNS验证配置
  /// @return 更新结果
  Future<Response> updateSSLDnsConfig(int id, Map<String, dynamic> config) async {
    return await _client.post('/ssl/$id/dns/config', data: config);
  }
}