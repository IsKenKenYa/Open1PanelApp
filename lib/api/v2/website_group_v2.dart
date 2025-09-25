/// 1Panel V2 API - WebsiteGroup 相关接口
/// 
/// 此文件包含与网站分组管理相关的所有API接口，
/// 包括网站分组的创建、删除、更新、查询等操作。

import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../models/website_group_models.dart';

class WebsiteGroupV2Api {
  final ApiClient _client;

  WebsiteGroupV2Api(this._client);

  /// 获取网站分组列表
  /// 
  /// 获取所有网站分组列表
  /// @param search 搜索关键词（可选）
  /// @param page 页码（可选，默认为1）
  /// @param pageSize 每页数量（可选，默认为10）
  /// @return 网站分组列表
  Future<Response> getWebsiteGroups({
    String? search,
    int page = 1,
    int pageSize = 10,
  }) async {
    final data = {
      'page': page,
      'pageSize': pageSize,
      if (search != null) 'search': search,
    };
    return await _client.post('/website/groups/search', data: data);
  }

  /// 创建网站分组
  /// 
  /// 创建新的网站分组
  /// @param name 分组名称
  /// @param description 分组描述（可选）
  /// @param sort 排序（可选）
  /// @return 创建结果
  Future<Response> createWebsiteGroup({
    required String name,
    String? description,
    int? sort,
  }) async {
    final data = {
      'name': name,
      if (description != null) 'description': description,
      if (sort != null) 'sort': sort,
    };
    return await _client.post('/website/groups', data: data);
  }

  /// 获取网站分组详情
  /// 
  /// 获取指定网站分组的详细信息
  /// @param id 分组ID
  /// @return 网站分组详情
  Future<Response> getWebsiteGroupDetail(int id) async {
    return await _client.get('/website/groups/$id');
  }

  /// 更新网站分组
  /// 
  /// 更新网站分组信息
  /// @param id 分组ID
  /// @param name 分组名称（可选）
  /// @param description 分组描述（可选）
  /// @param sort 排序（可选）
  /// @return 更新结果
  Future<Response> updateWebsiteGroup({
    required int id,
    String? name,
    String? description,
    int? sort,
  }) async {
    final data = {
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (sort != null) 'sort': sort,
    };
    return await _client.post('/website/groups/$id', data: data);
  }

  /// 删除网站分组
  /// 
  /// 删除指定的网站分组
  /// @param id 分组ID
  /// @return 删除结果
  Future<Response> deleteWebsiteGroup(int id) async {
    return await _client.delete('/website/groups/$id');
  }

  /// 批量删除网站分组
  /// 
  /// 批量删除指定的网站分组
  /// @param ids 分组ID列表
  /// @return 删除结果
  Future<Response> deleteWebsiteGroups(List<int> ids) async {
    final data = {
      'ids': ids,
    };
    return await _client.post('/website/groups/batch/delete', data: data);
  }

  /// 获取分组下的网站列表
  /// 
  /// 获取指定分组下的网站列表
  /// @param id 分组ID
  /// @param search 搜索关键词（可选）
  /// @param status 网站状态（可选）
  /// @param page 页码（可选，默认为1）
  /// @param pageSize 每页数量（可选，默认为10）
  /// @return 网站列表
  Future<Response> getWebsitesByGroup({
    required int id,
    String? search,
    String? status,
    int page = 1,
    int pageSize = 10,
  }) async {
    final data = {
      'page': page,
      'pageSize': pageSize,
      if (search != null) 'search': search,
      if (status != null) 'status': status,
    };
    return await _client.post('/website/groups/$id/websites', data: data);
  }

  /// 将网站添加到分组
  /// 
  /// 将指定的网站添加到分组
  /// @param groupId 分组ID
  /// @param websiteIds 网站ID列表
  /// @return 添加结果
  Future<Response> addWebsitesToGroup({
    required int groupId,
    required List<int> websiteIds,
  }) async {
    final data = {
      'websiteIds': websiteIds,
    };
    return await _client.post('/website/groups/$groupId/websites/add', data: data);
  }

  /// 从分组中移除网站
  /// 
  /// 从指定的分组中移除网站
  /// @param groupId 分组ID
  /// @param websiteIds 网站ID列表
  /// @return 移除结果
  Future<Response> removeWebsitesFromGroup({
    required int groupId,
    required List<int> websiteIds,
  }) async {
    final data = {
      'websiteIds': websiteIds,
    };
    return await _client.post('/website/groups/$groupId/websites/remove', data: data);
  }

  /// 获取网站分组统计信息
  /// 
  /// 获取网站分组统计信息
  /// @return 统计信息
  Future<Response> getWebsiteGroupStats() async {
    return await _client.get('/website/groups/stats');
  }

  /// 获取网站分组排序
  /// 
  /// 获取网站分组排序
  /// @return 分组排序
  Future<Response> getWebsiteGroupSort() async {
    return await _client.get('/website/groups/sort');
  }

  /// 更新网站分组排序
  /// 
  /// 更新网站分组排序
  /// @param sort 排序信息
  /// @return 更新结果
  Future<Response> updateWebsiteGroupSort(Map<String, dynamic> sort) async {
    return await _client.post('/website/groups/sort', data: sort);
  }

  /// 获取网站分组配置
  /// 
  /// 获取网站分组配置信息
  /// @return 分组配置
  Future<Response> getWebsiteGroupConfig() async {
    return await _client.get('/website/groups/config');
  }

  /// 更新网站分组配置
  /// 
  /// 更新网站分组配置
  /// @param config 分组配置
  /// @return 更新结果
  Future<Response> updateWebsiteGroupConfig(Map<String, dynamic> config) async {
    return await _client.post('/website/groups/config', data: config);
  }

  /// 导入网站分组
  /// 
  /// 导入网站分组
  /// @param filePath 文件路径
  /// @return 导入结果
  Future<Response> importWebsiteGroups(String filePath) async {
    final data = {
      'filePath': filePath,
    };
    return await _client.post('/website/groups/import', data: data);
  }

  /// 导出网站分组
  /// 
  /// 导出网站分组
  /// @param ids 分组ID列表（可选）
  /// @return 导出结果
  Future<Response> exportWebsiteGroups({List<int>? ids}) async {
    final data = {
      if (ids != null) 'ids': ids,
    };
    return await _client.post('/website/groups/export', data: data);
  }

  /// 复制网站分组
  /// 
  /// 复制指定的网站分组
  /// @param id 分组ID
  /// @param name 新分组名称
  /// @param description 新分组描述（可选）
  /// @return 复制结果
  Future<Response> copyWebsiteGroup({
    required int id,
    required String name,
    String? description,
  }) async {
    final data = {
      'name': name,
      if (description != null) 'description': description,
    };
    return await _client.post('/website/groups/$id/copy', data: data);
  }

  /// 获取网站分组操作日志
  /// 
  /// 获取网站分组操作日志
  /// @param id 分组ID（可选）
  /// @param startTime 开始时间（可选）
  /// @param endTime 结束时间（可选）
  /// @param page 页码（可选，默认为1）
  /// @param pageSize 每页数量（可选，默认为10）
  /// @return 操作日志
  Future<Response> getWebsiteGroupOperationLogs({
    int? id,
    String? startTime,
    String? endTime,
    int page = 1,
    int pageSize = 10,
  }) async {
    final data = {
      'page': page,
      'pageSize': pageSize,
      if (id != null) 'id': id,
      if (startTime != null) 'startTime': startTime,
      if (endTime != null) 'endTime': endTime,
    };
    return await _client.post('/website/groups/operation/logs', data: data);
  }
}