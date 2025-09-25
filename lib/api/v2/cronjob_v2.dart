/// 1Panel V2 API - Cronjob 相关接口
/// 
/// 此文件包含与定时任务管理相关的所有API接口，
/// 包括定时任务的创建、删除、更新、查询等操作。

import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../models/cronjob_models.dart';

class CronjobV2Api {
  final ApiClient _client;

  CronjobV2Api(this._client);

  /// 创建定时任务
  /// 
  /// 创建一个新的定时任务
  /// @param cronjob 定时任务配置信息
  /// @return 创建结果
  Future<Response> createCronjob(Map<String, dynamic> cronjob) async {
    return await _client.post('/cronjobs', data: cronjob);
  }

  /// 删除定时任务
  /// 
  /// 删除指定的定时任务
  /// @param ids 定时任务ID列表
  /// @return 删除结果
  Future<Response> deleteCronjob(List<int> ids) async {
    final data = {
      'ids': ids,
    };
    return await _client.post('/cronjobs/del', data: data);
  }

  /// 更新定时任务
  /// 
  /// 更新指定的定时任务
  /// @param id 定时任务ID
  /// @param cronjob 更新的定时任务信息
  /// @return 更新结果
  Future<Response> updateCronjob(int id, Map<String, dynamic> cronjob) async {
    return await _client.post('/cronjobs/$id/update', data: cronjob);
  }

  /// 获取定时任务列表
  /// 
  /// 获取所有定时任务列表
  /// @param search 搜索关键词（可选）
  /// @param type 任务类型（可选）
  /// @param page 页码（可选，默认为1）
  /// @param pageSize 每页数量（可选，默认为10）
  /// @return 定时任务列表
  Future<Response> getCronjobs({
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
    return await _client.post('/cronjobs/search', data: data);
  }

  /// 获取定时任务详情
  /// 
  /// 获取指定定时任务的详细信息
  /// @param id 定时任务ID
  /// @return 定时任务详情
  Future<Response> getCronjobDetail(int id) async {
    return await _client.get('/cronjobs/$id');
  }

  /// 启动定时任务
  /// 
  /// 启动指定的定时任务
  /// @param id 定时任务ID
  /// @return 启动结果
  Future<Response> startCronjob(int id) async {
    return await _client.post('/cronjobs/$id/start');
  }

  /// 停止定时任务
  /// 
  /// 停止指定的定时任务
  /// @param id 定时任务ID
  /// @return 停止结果
  Future<Response> stopCronjob(int id) async {
    return await _client.post('/cronjobs/$id/stop');
  }

  /// 执行定时任务
  /// 
  /// 立即执行指定的定时任务
  /// @param id 定时任务ID
  /// @return 执行结果
  Future<Response> executeCronjob(int id) async {
    return await _client.post('/cronjobs/$id/execute');
  }

  /// 获取定时任务日志
  /// 
  /// 获取指定定时任务的执行日志
  /// @param id 定时任务ID
  /// @param lines 日志行数（可选，默认为100）
  /// @return 任务日志
  Future<Response> getCronjobLogs(int id, {int lines = 100}) async {
    final data = {
      'lines': lines,
    };
    return await _client.post('/cronjobs/$id/logs', data: data);
  }

  /// 获取定时任务执行记录
  /// 
  /// 获取指定定时任务的执行记录
  /// @param id 定时任务ID
  /// @param page 页码（可选，默认为1）
  /// @param pageSize 每页数量（可选，默认为10）
  /// @return 执行记录
  Future<Response> getCronjobRecords(int id, {
    int page = 1,
    int pageSize = 10,
  }) async {
    final data = {
      'page': page,
      'pageSize': pageSize,
    };
    return await _client.post('/cronjobs/$id/records', data: data);
  }
}