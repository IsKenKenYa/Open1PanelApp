/// 1Panel V2 API - Runtime 相关接口
///
/// 此文件包含与运行环境管理相关的所有API接口，
/// 包括运行环境的创建、删除、更新、查询等操作。

import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/config/api_constants.dart';
import '../../data/models/runtime_models.dart';
import '../../data/models/common_models.dart';

class RuntimeV2Api {
  final ApiClient _client;

  RuntimeV2Api(this._client);

  /// 获取运行环境列表
  ///
  /// 获取所有运行环境列表
  /// @param search 搜索关键词（可选）
  /// @param type 运行环境类型（可选）
  /// @param status 运行环境状态（可选）
  /// @param page 页码（可选，默认为1）
  /// @param pageSize 每页数量（可选，默认为10）
  /// @return 运行环境列表
  Future<Response<PageResult<RuntimeInfo>>> getRuntimes({
    String? search,
    String? type,
    RuntimeStatus? status,
    int page = 1,
    int pageSize = 10,
  }) async {
    final request = RuntimeSearch(
      page: page,
      pageSize: pageSize,
      search: search,
      type: type,
      status: status,
    );
    final response = await _client.post(
      ApiConstants.buildApiPath('/runtimes/search'),
      data: request.toJson(),
    );
    return Response(
      data: PageResult.fromJson(
        response.data as Map<String, dynamic>,
        (json) => RuntimeInfo.fromJson(json as Map<String, dynamic>),
      ),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取运行环境详情
  ///
  /// 获取指定运行环境的详细信息
  /// @param id 运行环境ID
  /// @return 运行环境详情
  Future<Response<RuntimeInfo>> getRuntimeDetail(int id) async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/runtimes/$id'),
    );
    return Response(
      data: RuntimeInfo.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 创建运行环境
  ///
  /// 创建一个新的运行环境
  /// @param runtime 运行环境配置信息
  /// @return 创建结果
  Future<Response<RuntimeInfo>> createRuntime(RuntimeCreate runtime) async {
    final response = await _client.post(
      ApiConstants.buildApiPath('/runtimes/create'),
      data: runtime.toJson(),
    );
    return Response(
      data: RuntimeInfo.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 删除运行环境
  ///
  /// 删除指定的运行环境
  /// @param ids 运行环境ID列表
  /// @return 删除结果
  Future<Response> deleteRuntime(List<int> ids) async {
    final operation = OperateByID(ids: ids);
    return await _client.post(
      ApiConstants.buildApiPath('/runtimes/del'),
      data: operation.toJson(),
    );
  }

  /// 更新运行环境
  ///
  /// 更新指定的运行环境
  /// @param runtime 运行环境更新信息
  /// @return 更新结果
  Future<Response<RuntimeInfo>> updateRuntime(RuntimeUpdate runtime) async {
    final response = await _client.post(
      ApiConstants.buildApiPath('/runtimes/${runtime.id}/update'),
      data: runtime.toJson(),
    );
    return Response(
      data: RuntimeInfo.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 启动运行环境
  ///
  /// 启动指定的运行环境
  /// @param ids 运行环境ID列表
  /// @return 启动结果
  Future<Response> startRuntime(List<int> ids) async {
    final operation = RuntimeOperate(ids: ids, operation: 'start');
    return await _client.post(
      ApiConstants.buildApiPath('/runtimes/start'),
      data: operation.toJson(),
    );
  }

  /// 停止运行环境
  ///
  /// 停止指定的运行环境
  /// @param ids 运行环境ID列表
  /// @return 停止结果
  Future<Response> stopRuntime(List<int> ids) async {
    final operation = RuntimeOperate(ids: ids, operation: 'stop');
    return await _client.post(
      ApiConstants.buildApiPath('/runtimes/stop'),
      data: operation.toJson(),
    );
  }

  /// 重启运行环境
  ///
  /// 重启指定的运行环境
  /// @param ids 运行环境ID列表
  /// @return 重启结果
  Future<Response> restartRuntime(List<int> ids) async {
    final operation = RuntimeOperate(ids: ids, operation: 'restart');
    return await _client.post(
      ApiConstants.buildApiPath('/runtimes/restart'),
      data: operation.toJson(),
    );
  }

  /// 获取运行环境日志
  ///
  /// 获取指定运行环境的日志
  /// @param id 运行环境ID
  /// @param lines 日志行数（可选，默认为100）
  /// @return 运行环境日志
  Future<Response<List<RuntimeLog>>> getRuntimeLogs(int id, {int lines = 100}) async {
    final request = RuntimeLogSearch(runtimeId: id, lines: lines);
    final response = await _client.post(
      ApiConstants.buildApiPath('/runtimes/$id/logs/search'),
      data: request.toJson(),
    );
    return Response(
      data: (response.data as List?)
          ?.map((item) => RuntimeLog.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取运行环境配置
  ///
  /// 获取指定运行环境的配置
  /// @param id 运行环境ID
  /// @return 运行环境配置
  Future<Response<RuntimeConfig>> getRuntimeConfig(int id) async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/runtimes/$id/config'),
    );
    return Response(
      data: RuntimeConfig.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 更新运行环境配置
  ///
  /// 更新指定运行环境的配置
  /// @param config 运行环境配置
  /// @return 更新结果
  Future<Response> updateRuntimeConfig(RuntimeConfig config) async {
    return await _client.post(
      ApiConstants.buildApiPath('/runtimes/${config.id}/config'),
      data: config.toJson(),
    );
  }

  /// 获取运行环境状态
  ///
  /// 获取指定运行环境的状态
  /// @param id 运行环境ID
  /// @return 运行环境状态
  Future<Response<RuntimeStatusInfo>> getRuntimeStatus(int id) async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/runtimes/$id/status'),
    );
    return Response(
      data: RuntimeStatusInfo.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取运行环境资源使用情况
  ///
  /// 获取指定运行环境的资源使用情况
  /// @param id 运行环境ID
  /// @return 资源使用情况
  Future<Response<RuntimeResourceUsage>> getRuntimeResourceUsage(int id) async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/runtimes/$id/resource'),
    );
    return Response(
      data: RuntimeResourceUsage.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取运行环境依赖
  ///
  /// 获取指定运行环境的依赖
  /// @param id 运行环境ID
  /// @return 运行环境依赖
  Future<Response<List<RuntimeDependency>>> getRuntimeDependencies(int id) async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/runtimes/$id/dependencies'),
    );
    return Response(
      data: (response.data as List?)
          ?.map((item) => RuntimeDependency.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 安装运行环境依赖
  ///
  /// 为指定运行环境安装依赖
  /// @param id 运行环境ID
  /// @param dependencies 依赖安装请求
  /// @return 安装结果
  Future<Response> installRuntimeDependencies(int id, RuntimeDependencyInstall dependencies) async {
    return await _client.post(
      ApiConstants.buildApiPath('/runtimes/$id/dependencies/install'),
      data: dependencies.toJson(),
    );
  }

  /// 卸载运行环境依赖
  ///
  /// 为指定运行环境卸载依赖
  /// @param id 运行环境ID
  /// @param dependencies 依赖卸载请求
  /// @return 卸载结果
  Future<Response> uninstallRuntimeDependencies(int id, RuntimeDependencyUninstall dependencies) async {
    return await _client.post(
      ApiConstants.buildApiPath('/runtimes/$id/dependencies/uninstall'),
      data: dependencies.toJson(),
    );
  }

  /// 获取运行环境统计信息
  ///
  /// 获取运行环境的统计信息
  /// @return 统计信息
  Future<Response<RuntimeStats>> getRuntimeStats() async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/runtimes/stats'),
    );
    return Response(
      data: RuntimeStats.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取可用的运行环境版本
  ///
  /// 获取指定类型的可用运行环境版本列表
  /// @param type 运行环境类型
  /// @return 可用版本列表
  Future<Response<List<String>>> getAvailableRuntimeVersions(String type) async {
    final data = {'type': type};
    final response = await _client.post(
      ApiConstants.buildApiPath('/runtimes/versions'),
      data: data,
    );
    return Response(
      data: (response.data as List?)?.cast<String>() ?? [],
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }
}