/// 1Panel V2 API - Website 相关接口
/// 
/// 此文件包含与网站管理相关的所有API接口，
/// 包括网站的创建、删除、更新、查询等操作。

import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../models/website_models.dart';

class WebsiteV2Api {
  final ApiClient _client;

  WebsiteV2Api(this._client);

  /// 创建网站
  /// 
  /// 创建一个新的网站
  /// @param website 网站配置信息
  /// @return 创建结果
  Future<Response> createWebsite(Map<String, dynamic> website) async {
    return await _client.post('/websites', data: website);
  }

  /// 删除网站
  /// 
  /// 删除指定的网站
  /// @param ids 网站ID列表
  /// @param force 是否强制删除
  /// @return 删除结果
  Future<Response> deleteWebsite(List<int> ids, {bool force = false}) async {
    final data = {
      'ids': ids,
      'force': force,
    };
    return await _client.post('/websites/del', data: data);
  }

  /// 更新网站
  /// 
  /// 更新指定的网站
  /// @param id 网站ID
  /// @param website 更新的网站信息
  /// @return 更新结果
  Future<Response> updateWebsite(int id, Map<String, dynamic> website) async {
    return await _client.post('/websites/$id/update', data: website);
  }

  /// 获取网站列表
  /// 
  /// 获取所有网站列表
  /// @param search 搜索关键词（可选）
  /// @param type 网站类型（可选）
  /// @param page 页码（可选，默认为1）
  /// @param pageSize 每页数量（可选，默认为10）
  /// @return 网站列表
  Future<Response> getWebsites({
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
    return await _client.post('/websites/search', data: data);
  }

  /// 获取网站详情
  /// 
  /// 获取指定网站的详细信息
  /// @param id 网站ID
  /// @return 网站详情
  Future<Response> getWebsiteDetail(int id) async {
    return await _client.get('/websites/$id');
  }

  /// 启动网站
  /// 
  /// 启动指定的网站
  /// @param ids 网站ID列表
  /// @return 启动结果
  Future<Response> startWebsite(List<int> ids) async {
    final data = {
      'ids': ids,
    };
    return await _client.post('/websites/start', data: data);
  }

  /// 停止网站
  /// 
  /// 停止指定的网站
  /// @param ids 网站ID列表
  /// @return 停止结果
  Future<Response> stopWebsite(List<int> ids) async {
    final data = {
      'ids': ids,
    };
    return await _client.post('/websites/stop', data: data);
  }

  /// 重启网站
  /// 
  /// 重启指定的网站
  /// @param ids 网站ID列表
  /// @return 重启结果
  Future<Response> restartWebsite(List<int> ids) async {
    final data = {
      'ids': ids,
    };
    return await _client.post('/websites/restart', data: data);
  }

  /// 获取网站日志
  /// 
  /// 获取指定网站的日志
  /// @param id 网站ID
  /// @param lines 日志行数（可选，默认为100）
  /// @return 网站日志
  Future<Response> getWebsiteLogs(int id, {int lines = 100}) async {
    final data = {
      'lines': lines,
    };
    return await _client.post('/websites/$id/logs', data: data);
  }

  /// 获取网站SSL证书
  /// 
  /// 获取指定网站的SSL证书
  /// @param id 网站ID
  /// @return SSL证书
  Future<Response> getWebsiteSSL(int id) async {
    return await _client.get('/websites/$id/ssl');
  }

  /// 为网站设置SSL证书
  /// 
  /// 为指定网站设置SSL证书
  /// @param id 网站ID
  /// @param sslId SSL证书ID
  /// @return 设置结果
  Future<Response> setWebsiteSSL(int id, int sslId) async {
    final data = {
      'sslId': sslId,
    };
    return await _client.post('/websites/$id/ssl', data: data);
  }

  /// 删除网站SSL证书
  /// 
  /// 删除指定网站的SSL证书
  /// @param id 网站ID
  /// @return 删除结果
  Future<Response> deleteWebsiteSSL(int id) async {
    return await _client.post('/websites/$id/ssl/del');
  }

  /// 获取网站配置
  /// 
  /// 获取指定网站的配置
  /// @param id 网站ID
  /// @return 网站配置
  Future<Response> getWebsiteConfig(int id) async {
    return await _client.get('/websites/$id/config');
  }

  /// 更新网站配置
  /// 
  /// 更新指定网站的配置
  /// @param id 网站ID
  /// @param config 网站配置
  /// @return 更新结果
  Future<Response> updateWebsiteConfig(int id, Map<String, dynamic> config) async {
    return await _client.post('/websites/$id/config', data: config);
  }

  /// 获取网站目录权限
  /// 
  /// 获取指定网站的目录权限
  /// @param id 网站ID
  /// @return 目录权限
  Future<Response> getWebsitePermission(int id) async {
    return await _client.get('/websites/$id/permission');
  }

  /// 更新网站目录权限
  /// 
  /// 更新指定网站的目录权限
  /// @param id 网站ID
  /// @param permission 权限信息
  /// @return 更新结果
  Future<Response> updateWebsitePermission(int id, Map<String, dynamic> permission) async {
    return await _client.post('/websites/$id/permission', data: permission);
  }

  /// 获取网站伪静态规则
  /// 
  /// 获取指定网站的伪静态规则
  /// @param id 网站ID
  /// @return 伪静态规则
  Future<Response> getWebsiteRewrite(int id) async {
    return await _client.get('/websites/$id/rewrite');
  }

  /// 更新网站伪静态规则
  /// 
  /// 更新指定网站的伪静态规则
  /// @param id 网站ID
  /// @param rewrite 伪静态规则
  /// @return 更新结果
  Future<Response> updateWebsiteRewrite(int id, String rewrite) async {
    final data = {
      'rewrite': rewrite,
    };
    return await _client.post('/websites/$id/rewrite', data: data);
  }

  /// 获取网站访问限制
  /// 
  /// 获取指定网站的访问限制
  /// @param id 网站ID
  /// @return 访问限制
  Future<Response> getWebsiteAccess(int id) async {
    return await _client.get('/websites/$id/access');
  }

  /// 更新网站访问限制
  /// 
  /// 更新指定网站的访问限制
  /// @param id 网站ID
  /// @param access 访问限制
  /// @return 更新结果
  Future<Response> updateWebsiteAccess(int id, Map<String, dynamic> access) async {
    return await _client.post('/websites/$id/access', data: access);
  }

  /// 获取网站流量统计
  /// 
  /// 获取指定网站的流量统计
  /// @param id 网站ID
  /// @param timeRange 时间范围（可选，默认为1d）
  /// @return 流量统计
  Future<Response> getWebsiteStatistics(int id, {String timeRange = '1d'}) async {
    final data = {
      'timeRange': timeRange,
    };
    return await _client.post('/websites/$id/statistics', data: data);
  }
}