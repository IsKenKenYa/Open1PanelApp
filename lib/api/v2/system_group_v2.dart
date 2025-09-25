
/// 1Panel V2 API - System Group 相关接口
/// 
/// 此文件包含与系统组管理相关的所有API接口，
/// 包括组的创建、删除、查询和更新操作。

import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../models/system_group_models.dart';

class SystemGroupV2Api {
  final ApiClient _client;

  SystemGroupV2Api(this._client);

  /// 创建组
  /// 
  /// 创建一个新的系统组
  /// @param name 组名称
  /// @param type 组类型
  /// @return 创建结果
  Future<Response> createGroup(String name, String type) async {
    final data = {
      'name': name,
      'type': type,
    };
    return await _client.post('/agent/groups', data: data);
  }

  /// 删除组
  /// 
  /// 根据ID删除指定的系统组
  /// @param id 要删除的组ID
  /// @return 删除结果
  Future<Response> deleteGroup(int id) async {
    final data = {
      'id': id,
    };
    return await _client.post('/agent/groups/del', data: data);
  }

  /// 查询组列表
  /// 
  /// 获取系统组列表，支持分页和搜索
  /// @param search 搜索关键词（可选）
  /// @param page 页码（可选，默认为1）
  /// @param pageSize 每页数量（可选，默认为10）
  /// @return 组列表
  Future<Response> searchGroups({String? search, int page = 1, int pageSize = 10}) async {
    final data = {
      'page': page,
      'pageSize': pageSize,
      if (search != null) 'search': search,
    };
    return await _client.post('/agent/groups/search', data: data);
  }

  /// 更新组信息
  /// 
  /// 更新指定系统组的信息
  /// @param id 组ID
  /// @param name 新的组名称
  /// @param type 新的组类型
  /// @return 更新结果
  Future<Response> updateGroup(int id, String name, String type) async {
    final data = {
      'id': id,
      'name': name,
      'type': type,
    };
    return await _client.post('/agent/groups/update', data: data);
  }
}