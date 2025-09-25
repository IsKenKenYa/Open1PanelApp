/// 1Panel V2 API - Container Compose 相关接口
/// 
/// 此文件包含与容器编排相关的所有API接口，
/// 包括Compose项目的创建、删除、启动、停止、查询等操作。

import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../models/container_compose_models.dart';

class ContainerComposeV2Api {
  final ApiClient _client;

  ContainerComposeV2Api(this._client);

  /// 创建Compose项目
  /// 
  /// 创建一个新的Compose项目
  /// @param compose Compose项目配置信息
  /// @return 创建结果
  Future<Response> createCompose(Map<String, dynamic> compose) async {
    return await _client.post('/containers/compose/create', data: compose);
  }

  /// 删除Compose项目
  /// 
  /// 删除指定的Compose项目
  /// @param ids Compose项目ID列表
  /// @param force 是否强制删除
  /// @return 删除结果
  Future<Response> deleteCompose(List<int> ids, {bool force = false}) async {
    final data = {
      'ids': ids,
      'force': force,
    };
    return await _client.post('/containers/compose/del', data: data);
  }

  /// 启动Compose项目
  /// 
  /// 启动指定的Compose项目
  /// @param ids Compose项目ID列表
  /// @return 启动结果
  Future<Response> startCompose(List<int> ids) async {
    final data = {
      'ids': ids,
    };
    return await _client.post('/containers/compose/start', data: data);
  }

  /// 停止Compose项目
  /// 
  /// 停止指定的Compose项目
  /// @param ids Compose项目ID列表
  /// @return 停止结果
  Future<Response> stopCompose(List<int> ids) async {
    final data = {
      'ids': ids,
    };
    return await _client.post('/containers/compose/stop', data: data);
  }

  /// 重启Compose项目
  /// 
  /// 重启指定的Compose项目
  /// @param ids Compose项目ID列表
  /// @return 重启结果
  Future<Response> restartCompose(List<int> ids) async {
    final data = {
      'ids': ids,
    };
    return await _client.post('/containers/compose/restart', data: data);
  }

  /// 获取Compose项目列表
  /// 
  /// 获取所有Compose项目列表
  /// @param search 搜索关键词（可选）
  /// @param page 页码（可选，默认为1）
  /// @param pageSize 每页数量（可选，默认为10）
  /// @return Compose项目列表
  Future<Response> getComposes({
    String? search,
    int page = 1,
    int pageSize = 10,
  }) async {
    final data = {
      'page': page,
      'pageSize': pageSize,
      if (search != null) 'search': search,
    };
    return await _client.post('/containers/compose/search', data: data);
  }

  /// 获取Compose项目详情
  /// 
  /// 获取指定Compose项目的详细信息
  /// @param id Compose项目ID
  /// @return Compose项目详情
  Future<Response> getComposeDetail(int id) async {
    return await _client.get('/containers/compose/$id');
  }

  /// 更新Compose项目
  /// 
  /// 更新指定的Compose项目
  /// @param id Compose项目ID
  /// @param compose 更新的Compose项目配置
  /// @return 更新结果
  Future<Response> updateCompose(int id, Map<String, dynamic> compose) async {
    return await _client.post('/containers/compose/$id/update', data: compose);
  }

  /// 获取Compose项目日志
  /// 
  /// 获取指定Compose项目的日志
  /// @param id Compose项目ID
  /// @param lines 日志行数（可选，默认为100）
  /// @return Compose项目日志
  Future<Response> getComposeLogs(int id, {int lines = 100}) async {
    final data = {
      'lines': lines,
    };
    return await _client.post('/containers/compose/$id/logs', data: data);
  }

  /// 获取Compose项目配置
  /// 
  /// 获取指定Compose项目的配置文件内容
  /// @param id Compose项目ID
  /// @return Compose项目配置
  Future<Response> getComposeConfig(int id) async {
    return await _client.get('/containers/compose/$id/config');
  }

  /// 更新Compose项目配置
  /// 
  /// 更新指定Compose项目的配置文件内容
  /// @param id Compose项目ID
  /// @param content 配置文件内容
  /// @return 更新结果
  Future<Response> updateComposeConfig(int id, String content) async {
    final data = {
      'content': content,
    };
    return await _client.post('/containers/compose/$id/config', data: data);
  }
}