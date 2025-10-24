/// 1Panel V2 API - Container 相关接口
///
/// 此文件包含与容器管理相关的所有API接口，
/// 包括容器的创建、删除、启动、停止、查询等操作。

import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/config/api_constants.dart';
import '../../data/models/container_models.dart';
import '../../data/models/common_models.dart';

class ContainerV2Api {
  final ApiClient _client;

  ContainerV2Api(this._client);

  /// 创建容器
  ///
  /// 创建一个新的容器
  /// @param request 容器操作请求
  /// @return 创建结果
  Future<Response> createContainer(ContainerOperate request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/containers'),
      data: request.toJson(),
    );
  }

  /// 操作容器（启动/停止/重启等）
  ///
  /// 对指定容器执行操作
  /// @param request 容器操作请求
  /// @return 操作结果
  Future<Response> operateContainer(ContainerOperation request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/containers/operate'),
      data: request.toJson(),
    );
  }

  /// 启动容器
  ///
  /// 启动指定的容器
  /// @param names 容器名称列表
  /// @return 启动结果
  Future<Response> startContainer(List<String> names) async {
    return await operateContainer(ContainerOperation(
      names: names,
      operation: ContainerOperationType.start.value,
    ));
  }

  /// 停止容器
  ///
  /// 停止指定的容器
  /// @param names 容器名称列表
  /// @param force 是否强制停止
  /// @return 停止结果
  Future<Response> stopContainer(List<String> names, {bool force = false}) async {
    return await operateContainer(ContainerOperation(
      names: names,
      operation: force ? ContainerOperationType.kill.value : ContainerOperationType.stop.value,
    ));
  }

  /// 重启容器
  ///
  /// 重启指定的容器
  /// @param names 容器名称列表
  /// @return 重启结果
  Future<Response> restartContainer(List<String> names) async {
    return await operateContainer(ContainerOperation(
      names: names,
      operation: ContainerOperationType.restart.value,
    ));
  }

  /// 暂停容器
  ///
  /// 暂停指定的容器
  /// @param names 容器名称列表
  /// @return 暂停结果
  Future<Response> pauseContainer(List<String> names) async {
    return await operateContainer(ContainerOperation(
      names: names,
      operation: ContainerOperationType.pause.value,
    ));
  }

  /// 恢复容器
  ///
  /// 恢复指定的容器
  /// @param names 容器名称列表
  /// @return 恢复结果
  Future<Response> unpauseContainer(List<String> names) async {
    return await operateContainer(ContainerOperation(
      names: names,
      operation: ContainerOperationType.unpause.value,
    ));
  }

  /// 删除容器
  ///
  /// 删除指定的容器
  /// @param names 容器名称列表
  /// @param force 是否强制删除
  /// @return 删除结果
  Future<Response> deleteContainer(List<String> names, {bool force = false}) async {
    return await operateContainer(ContainerOperation(
      names: names,
      operation: ContainerOperationType.remove.value,
    ));
  }

  /// 搜索容器
  ///
  /// 分页搜索容器列表
  /// @param request 分页搜索请求
  /// @return 容器列表
  Future<Response<PageResult<ContainerInfo>>> searchContainers(PageContainer request) async {
    final response = await _client.post(
      ApiConstants.buildApiPath('/containers/search'),
      data: request.toJson(),
    );
    return Response(
      data: PageResult.fromJson(
        response.data as Map<String, dynamic>,
        (json) => ContainerInfo.fromJson(json as Map<String, dynamic>),
      ),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取容器列表
  ///
  /// 获取所有容器列表
  /// @return 容器列表
  Future<Response<List<ContainerInfo>>> listContainers() async {
    final response = await _client.post(
      ApiConstants.buildApiPath('/containers/list'),
    );
    return Response(
      data: (response.data as List?)
          ?.map((item) => ContainerInfo.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取容器详情
  ///
  /// 获取指定容器的详细信息
  /// @param id 容器ID
  /// @return 容器详情
  Future<Response<ContainerInfo>> getContainerDetail(String id) async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/containers/$id'),
    );
    return Response(
      data: ContainerInfo.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取容器统计信息
  ///
  /// 获取指定容器的资源使用统计信息
  /// @param id 容器ID
  /// @return 容器统计信息
  Future<Response<ContainerStats>> getContainerStats(String id) async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/containers/stats/$id'),
    );
    return Response(
      data: ContainerStats.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取容器列表统计信息
  ///
  /// 批量获取容器统计信息
  /// @return 容器列表统计
  Future<Response<List<ContainerListStats>>> listContainerStats() async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/containers/list/stats'),
    );
    return Response(
      data: (response.data as List?)
          ?.map((item) => ContainerListStats.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取容器状态统计
  ///
  /// 获取容器状态统计信息
  /// @return 容器状态统计
  Future<Response<ContainerStatus>> getContainerStatus() async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/containers/status'),
    );
    return Response(
      data: ContainerStatus.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 升级容器
  ///
  /// 升级指定容器到新镜像
  /// @param request 容器升级请求
  /// @return 升级结果
  Future<Response> upgradeContainer(ContainerUpgrade request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/containers/upgrade'),
      data: request.toJson(),
    );
  }

  /// 重命名容器
  ///
  /// 重命名指定容器
  /// @param request 容器重命名请求
  /// @return 重命名结果
  Future<Response> renameContainer(ContainerRename request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/containers/rename'),
      data: request.toJson(),
    );
  }

  /// 提交容器为镜像
  ///
  /// 将指定容器提交为镜像
  /// @param request 容器提交请求
  /// @return 提交结果
  Future<Response> commitContainer(ContainerCommit request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/containers/commit'),
      data: request.toJson(),
    );
  }

  /// 清理容器资源
  ///
  /// 清理容器、镜像、卷等资源
  /// @param request 清理请求
  /// @return 清理结果
  Future<Response> pruneContainers(ContainerPrune request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/containers/prune'),
      data: request.toJson(),
    );
  }
}