
/// 1Panel V2 API - System Group 相关接口
///
/// 此文件包含与系统组管理相关的所有API接口，
/// 包括组的创建、删除、查询和更新操作。

import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/config/api_constants.dart';
import '../../data/models/system_group_models.dart';

class SystemGroupV2Api {
  final ApiClient _client;

  SystemGroupV2Api(this._client);

  /// 创建组
  ///
  /// 创建一个新的系统组
  /// @param request 创建组请求
  /// @return 创建结果
  Future<Response> createGroup(GroupCreate request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/agent/groups'),
      data: request.toJson(),
    );
  }

  /// 删除组
  ///
  /// 根据ID删除指定的系统组
  /// @param request 删除请求
  /// @return 删除结果
  Future<Response> deleteGroup(OperateByID request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/agent/groups/del'),
      data: request.toJson(),
    );
  }

  /// 查询组列表
  ///
  /// 获取系统组列表
  /// @param request 搜索请求
  /// @return 组列表
  Future<Response<List<OperateByType>>> searchGroups(GroupSearch request) async {
    final response = await _client.post(
      ApiConstants.buildApiPath('/agent/groups/search'),
      data: request.toJson(),
    );
    return Response(
      data: (response.data as List?)
          ?.map((item) => OperateByType.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 更新组信息
  ///
  /// 更新指定系统组的信息
  /// @param request 更新组请求
  /// @return 更新结果
  Future<Response> updateGroup(GroupUpdate request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/agent/groups/update'),
      data: request.toJson(),
    );
  }

  /// 获取组详情
  ///
  /// 获取指定组的详细信息
  /// @param id 组ID
  /// @return 组详情
  Future<Response<GroupInfo>> getGroupById(int id) async {
    final request = OperateByID(id: id);
    final response = await _client.post(
      ApiConstants.buildApiPath('/agent/groups/search'),
      data: request.toJson(),
    );
    return Response(
      data: GroupInfo.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 检查组是否存在
  ///
  /// 检查指定名称和类型的组是否已存在
  /// @param name 组名称
  /// @param type 组类型
  /// @return 检查结果
  Future<Response<bool>> checkGroupExists(String name, String type) async {
    final request = GroupSearch(type: type);
    final response = await searchGroups(request);

    final groups = response.data ?? [];
    final exists = groups.any((group) => group.type == type);

    return Response(
      data: exists,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }
}