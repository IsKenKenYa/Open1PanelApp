/// 1Panel V2 API - Container Compose 相关接口
///
/// 此文件包含与容器编排相关的所有API接口，
/// 包括Compose项目的创建、删除、启动、停止、查询等操作。

import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/config/api_constants.dart';
import '../../data/models/container_models.dart';
import '../../data/models/common_models.dart';

class ContainerComposeV2Api {
  final ApiClient _client;

  ContainerComposeV2Api(this._client);

  /// 创建Compose项目
  ///
  /// 创建一个新的Compose项目
  /// @param compose Compose项目配置信息
  /// @return 创建结果
  Future<Response<ContainerCompose>> createCompose(ContainerComposeCreate compose) async {
    final response = await _client.post(
      ApiConstants.buildApiPath('/containers/compose/create'),
      data: compose.toJson(),
    );
    return Response(
      data: ContainerCompose.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 删除Compose项目
  ///
  /// 删除指定的Compose项目
  /// @param ids Compose项目ID列表
  /// @param force 是否强制删除
  /// @return 删除结果
  Future<Response> deleteCompose(List<int> ids, {bool force = false}) async {
    final operation = ContainerComposeOperate(ids: ids, operation: 'delete', force: force);
    return await _client.post(
      ApiConstants.buildApiPath('/containers/compose/del'),
      data: operation.toJson(),
    );
  }

  /// 启动Compose项目
  ///
  /// 启动指定的Compose项目
  /// @param ids Compose项目ID列表
  /// @return 启动结果
  Future<Response> startCompose(List<int> ids) async {
    final operation = ContainerComposeOperate(ids: ids, operation: 'start');
    return await _client.post(
      ApiConstants.buildApiPath('/containers/compose/start'),
      data: operation.toJson(),
    );
  }

  /// 停止Compose项目
  ///
  /// 停止指定的Compose项目
  /// @param ids Compose项目ID列表
  /// @return 停止结果
  Future<Response> stopCompose(List<int> ids) async {
    final operation = ContainerComposeOperate(ids: ids, operation: 'stop');
    return await _client.post(
      ApiConstants.buildApiPath('/containers/compose/stop'),
      data: operation.toJson(),
    );
  }

  /// 重启Compose项目
  ///
  /// 重启指定的Compose项目
  /// @param ids Compose项目ID列表
  /// @return 重启结果
  Future<Response> restartCompose(List<int> ids) async {
    final operation = ContainerComposeOperate(ids: ids, operation: 'restart');
    return await _client.post(
      ApiConstants.buildApiPath('/containers/compose/restart'),
      data: operation.toJson(),
    );
  }

  /// 获取Compose项目列表
  ///
  /// 获取所有Compose项目列表
  /// @param search 搜索关键词（可选）
  /// @param page 页码（可选，默认为1）
  /// @param pageSize 每页数量（可选，默认为10）
  /// @return Compose项目列表
  Future<Response<PageResult<ContainerCompose>>> getComposes({
    String? search,
    int page = 1,
    int pageSize = 10,
  }) async {
    final request = ContainerComposeSearch(
      page: page,
      pageSize: pageSize,
      search: search,
    );
    final response = await _client.post(
      ApiConstants.buildApiPath('/containers/compose/search'),
      data: request.toJson(),
    );
    return Response(
      data: PageResult.fromJson(
        response.data as Map<String, dynamic>,
        (json) => ContainerCompose.fromJson(json as Map<String, dynamic>),
      ),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取Compose项目详情
  ///
  /// 获取指定Compose项目的详细信息
  /// @param id Compose项目ID
  /// @return Compose项目详情
  Future<Response<ContainerCompose>> getComposeDetail(int id) async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/containers/compose/$id'),
    );
    return Response(
      data: ContainerCompose.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 更新Compose项目
  ///
  /// 更新指定的Compose项目
  /// @param compose Compose项目更新信息
  /// @return 更新结果
  Future<Response<ContainerCompose>> updateCompose(ContainerComposeUpdate compose) async {
    final response = await _client.post(
      ApiConstants.buildApiPath('/containers/compose/${compose.id}/update'),
      data: compose.toJson(),
    );
    return Response(
      data: ContainerCompose.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取Compose项目日志
  ///
  /// 获取指定Compose项目的日志
  /// @param id Compose项目ID
  /// @param lines 日志行数（可选，默认为100）
  /// @return Compose项目日志
  Future<Response<List<ContainerComposeLog>>> getComposeLogs(int id, {int lines = 100}) async {
    final request = ContainerComposeLogSearch(composeId: id, lines: lines);
    final response = await _client.post(
      ApiConstants.buildApiPath('/containers/compose/$id/logs'),
      data: request.toJson(),
    );
    return Response(
      data: (response.data as List?)
          ?.map((item) => ContainerComposeLog.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取Compose项目配置
  ///
  /// 获取指定Compose项目的配置文件内容
  /// @param id Compose项目ID
  /// @return Compose项目配置
  Future<Response<ContainerComposeConfig>> getComposeConfig(int id) async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/containers/compose/$id/config'),
    );
    return Response(
      data: ContainerComposeConfig.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 更新Compose项目配置
  ///
  /// 更新指定Compose项目的配置文件内容
  /// @param config Compose项目配置更新
  /// @return 更新结果
  Future<Response<ContainerComposeConfig>> updateComposeConfig(ContainerComposeConfigUpdate config) async {
    final response = await _client.post(
      ApiConstants.buildApiPath('/containers/compose/${config.id}/config'),
      data: config.toJson(),
    );
    return Response(
      data: ContainerComposeConfig.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 拉取Compose项目镜像
  ///
  /// 拉取指定Compose项目的所有镜像
  /// @param ids Compose项目ID列表
  /// @return 拉取结果
  Future<Response> pullComposeImages(List<int> ids) async {
    final operation = ContainerComposeOperate(ids: ids, operation: 'pull');
    return await _client.post(
      ApiConstants.buildApiPath('/containers/compose/pull'),
      data: operation.toJson(),
    );
  }

  /// 查看Compose项目状态
  ///
  /// 获取指定Compose项目的运行状态
  /// @param id Compose项目ID
  /// @return 项目状态
  Future<Response<ContainerComposeStatus>> getComposeStatus(int id) async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/containers/compose/$id/status'),
    );
    return Response(
      data: ContainerComposeStatus.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 导入Compose项目
  ///
  /// 从配置文件导入Compose项目
  /// @param importCompose 导入配置
  /// @return 导入结果
  Future<Response<ContainerCompose>> importCompose(ContainerComposeImport importCompose) async {
    final response = await _client.post(
      ApiConstants.buildApiPath('/containers/compose/import'),
      data: importCompose.toJson(),
    );
    return Response(
      data: ContainerCompose.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 导出Compose项目
  ///
  /// 导出指定Compose项目的配置文件
  /// @param id Compose项目ID
  /// @return 导出结果
  Future<Response<ContainerComposeExport>> exportCompose(int id) async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/containers/compose/$id/export'),
    );
    return Response(
      data: ContainerComposeExport.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }
}