/// 1Panel V2 API - Website 相关接口
///
/// 此文件包含与网站管理相关的所有API接口，
/// 包括网站的创建、删除、更新、查询等操作。

import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/config/api_constants.dart';
import '../../data/models/website_models.dart';
import '../../data/models/common_models.dart';

class WebsiteV2Api {
  final ApiClient _client;

  WebsiteV2Api(this._client);

  /// 创建网站
  ///
  /// 创建一个新的网站
  /// @param website 网站配置信息
  /// @return 创建结果
  Future<Response> createWebsite(WebsiteCreate website) async {
    return await _client.post(
      ApiConstants.buildApiPath('/websites'),
      data: website.toJson(),
    );
  }

  /// 删除网站
  ///
  /// 删除指定的网站
  /// @param ids 网站ID列表
  /// @return 删除结果
  Future<Response> deleteWebsite(List<int> ids) async {
    final operation = OperateByID(ids: ids);
    return await _client.post(
      ApiConstants.buildApiPath('/websites/del'),
      data: operation.toJson(),
    );
  }

  /// 更新网站
  ///
  /// 更新指定的网站
  /// @param id 网站ID
  /// @param website 更新的网站信息
  /// @return 更新结果
  Future<Response> updateWebsite(int id, WebsiteCreate website) async {
    return await _client.post(
      ApiConstants.buildApiPath('/websites/$id/update'),
      data: website.toJson(),
    );
  }

  /// 获取网站列表
  ///
  /// 获取所有网站列表
  /// @param search 搜索关键词（可选）
  /// @param type 网站类型（可选）
  /// @param status 网站状态（可选）
  /// @param page 页码（可选，默认为1）
  /// @param pageSize 每页数量（可选，默认为10）
  /// @return 网站列表
  Future<Response<PageResult<WebsiteInfo>>> getWebsites({
    String? search,
    String? type,
    String? status,
    int page = 1,
    int pageSize = 10,
  }) async {
    final request = WebsiteSearch(
      page: page,
      pageSize: pageSize,
      search: search,
      type: type,
      status: status,
    );
    final response = await _client.post(
      ApiConstants.buildApiPath('/websites/search'),
      data: request.toJson(),
    );
    return Response(
      data: PageResult.fromJson(
        response.data as Map<String, dynamic>,
        (json) => WebsiteInfo.fromJson(json as Map<String, dynamic>),
      ),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取网站详情
  ///
  /// 获取指定网站的详细信息
  /// @param id 网站ID
  /// @return 网站详情
  Future<Response<WebsiteInfo>> getWebsiteDetail(int id) async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/websites/$id'),
    );
    return Response(
      data: WebsiteInfo.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 启动网站
  ///
  /// 启动指定的网站
  /// @param ids 网站ID列表
  /// @return 启动结果
  Future<Response> startWebsite(List<int> ids) async {
    final operation = OperateByID(ids: ids);
    return await _client.post(
      ApiConstants.buildApiPath('/websites/start'),
      data: operation.toJson(),
    );
  }

  /// 停止网站
  ///
  /// 停止指定的网站
  /// @param ids 网站ID列表
  /// @return 停止结果
  Future<Response> stopWebsite(List<int> ids) async {
    final operation = OperateByID(ids: ids);
    return await _client.post(
      ApiConstants.buildApiPath('/websites/stop'),
      data: operation.toJson(),
    );
  }

  /// 重启网站
  ///
  /// 重启指定的网站
  /// @param ids 网站ID列表
  /// @return 重启结果
  Future<Response> restartWebsite(List<int> ids) async {
    final operation = OperateByID(ids: ids);
    return await _client.post(
      ApiConstants.buildApiPath('/websites/restart'),
      data: operation.toJson(),
    );
  }

  /// 获取网站SSL证书
  ///
  /// 获取指定网站的SSL证书
  /// @param id 网站ID
  /// @return SSL证书
  Future<Response<SSLCertificateInfo>> getWebsiteSSL(int id) async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/websites/$id/ssl'),
    );
    return Response(
      data: SSLCertificateInfo.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
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
    return await _client.post(
      ApiConstants.buildApiPath('/websites/$id/ssl'),
      data: data,
    );
  }

  /// 删除网站SSL证书
  ///
  /// 删除指定网站的SSL证书
  /// @param id 网站ID
  /// @return 删除结果
  Future<Response> deleteWebsiteSSL(int id) async {
    return await _client.post(
      ApiConstants.buildApiPath('/websites/$id/ssl/del'),
    );
  }

  /// 获取网站配置
  ///
  /// 获取指定网站的配置
  /// @param id 网站ID
  /// @return 网站配置
  Future<Response<WebsiteConfig>> getWebsiteConfig(int id) async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/websites/$id/config'),
    );
    return Response(
      data: WebsiteConfig.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 更新网站配置
  ///
  /// 更新指定网站的配置
  /// @param id 网站ID
  /// @param config 网站配置
  /// @return 更新结果
  Future<Response> updateWebsiteConfig(int id, WebsiteConfig config) async {
    return await _client.post(
      ApiConstants.buildApiPath('/websites/$id/config'),
      data: config.toJson(),
    );
  }

  /// 获取网站伪静态规则
  ///
  /// 获取指定网站的伪静态规则
  /// @param id 网站ID
  /// @return 伪静态规则
  Future<Response<WebsiteRewrite>> getWebsiteRewrite(int id) async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/websites/$id/rewrite'),
    );
    return Response(
      data: WebsiteRewrite.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 更新网站伪静态规则
  ///
  /// 更新指定网站的伪静态规则
  /// @param id 网站ID
  /// @param rewrite 伪静态规则
  /// @return 更新结果
  Future<Response> updateWebsiteRewrite(int id, WebsiteRewrite rewrite) async {
    return await _client.post(
      ApiConstants.buildApiPath('/websites/$id/rewrite'),
      data: rewrite.toJson(),
    );
  }

  /// 获取网站代理配置
  ///
  /// 获取指定网站的代理配置
  /// @param id 网站ID
  /// @return 代理配置
  Future<Response<WebsiteProxy>> getWebsiteProxy(int id) async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/websites/$id/proxy'),
    );
    return Response(
      data: WebsiteProxy.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 更新网站代理配置
  ///
  /// 更新指定网站的代理配置
  /// @param id 网站ID
  /// @param proxy 代理配置
  /// @return 更新结果
  Future<Response> updateWebsiteProxy(int id, WebsiteProxy proxy) async {
    return await _client.post(
      ApiConstants.buildApiPath('/websites/$id/proxy'),
      data: proxy.toJson(),
    );
  }

  /// 获取网站流量统计
  ///
  /// 获取指定网站的流量统计
  /// @param id 网站ID
  /// @param timeRange 时间范围（可选，默认为1d）
  /// @return 流量统计
  Future<Response<WebsiteTraffic>> getWebsiteStatistics(int id, {String timeRange = '1d'}) async {
    final data = {
      'timeRange': timeRange,
    };
    final response = await _client.post(
      ApiConstants.buildApiPath('/websites/$id/statistics'),
      data: data,
    );
    return Response(
      data: WebsiteTraffic.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取域名列表
  ///
  /// 获取指定网站的域名列表
  /// @param id 网站ID
  /// @return 域名列表
  Future<Response<List<WebsiteDomain>>> getWebsiteDomains(int id) async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/websites/$id/domains'),
    );
    return Response(
      data: (response.data as List?)
          ?.map((item) => WebsiteDomain.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 添加域名
  ///
  /// 为指定网站添加域名
  /// @param id 网站ID
  /// @param domain 域名信息
  /// @return 添加结果
  Future<Response> addWebsiteDomain(int id, WebsiteDomain domain) async {
    return await _client.post(
      ApiConstants.buildApiPath('/websites/$id/domains'),
      data: domain.toJson(),
    );
  }

  /// 删除域名
  ///
  /// 删除指定网站的域名
  /// @param id 网站ID
  /// @param domainId 域名ID
  /// @return 删除结果
  Future<Response> deleteWebsiteDomain(int id, int domainId) async {
    return await _client.post(
      ApiConstants.buildApiPath('/websites/$id/domains/$domainId/del'),
    );
  }
}