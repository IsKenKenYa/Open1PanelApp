/// 1Panel V2 API - TaskLog 相关接口
/// 
/// 此文件包含与任务日志管理相关的所有API接口，
/// 包括任务日志的查询、统计、清理等操作。

import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../models/task_log_models.dart';

class TaskLogV2Api {
  final ApiClient _client;

  TaskLogV2Api(this._client);

  /// 获取任务日志列表
  /// 
  /// 获取所有任务日志列表
  /// @param search 搜索关键词（可选）
  /// @param status 任务状态（可选）
  /// @param type 任务类型（可选）
  /// @param page 页码（可选，默认为1）
  /// @param pageSize 每页数量（可选，默认为10）
  /// @return 任务日志列表
  Future<Response> getTaskLogs({
    String? search,
    String? status,
    String? type,
    int page = 1,
    int pageSize = 10,
  }) async {
    final data = {
      'page': page,
      'pageSize': pageSize,
      if (search != null) 'search': search,
      if (status != null) 'status': status,
      if (type != null) 'type': type,
    };
    return await _client.post('/logs/tasks/search', data: data);
  }

  /// 获取任务日志详情
  /// 
  /// 获取指定任务日志的详细信息
  /// @param id 任务日志ID
  /// @return 任务日志详情
  Future<Response> getTaskLogDetail(int id) async {
    return await _client.get('/logs/tasks/$id');
  }

  /// 获取正在执行的任务数量
  /// 
  /// 获取正在执行的任务数量
  /// @return 正在执行的任务数量
  Future<Response> getExecutingTaskCount() async {
    return await _client.get('/logs/tasks/executing/count');
  }

  /// 获取正在执行的任务列表
  /// 
  /// 获取正在执行的任务列表
  /// @return 正在执行的任务列表
  Future<Response> getExecutingTasks() async {
    return await _client.get('/logs/tasks/executing');
  }

  /// 停止正在执行的任务
  /// 
  /// 停止指定的正在执行的任务
  /// @param ids 任务ID列表
  /// @return 停止结果
  Future<Response> stopExecutingTask(List<int> ids) async {
    final data = {
      'ids': ids,
    };
    return await _client.post('/logs/tasks/executing/stop', data: data);
  }

  /// 获取任务日志统计信息
  /// 
  /// 获取任务日志统计信息
  /// @param timeRange 时间范围（可选，默认为1d）
  /// @return 统计信息
  Future<Response> getTaskLogStats({String timeRange = '1d'}) async {
    final data = {
      'timeRange': timeRange,
    };
    return await _client.post('/logs/tasks/stats', data: data);
  }

  /// 清理任务日志
  /// 
  /// 清理任务日志
  /// @param days 保留天数
  /// @return 清理结果
  Future<Response> cleanTaskLogs(int days) async {
    final data = {
      'days': days,
    };
    return await _client.post('/logs/tasks/clean', data: data);
  }

  /// 导出任务日志
  /// 
  /// 导出任务日志
  /// @param search 搜索关键词（可选）
  /// @param status 任务状态（可选）
  /// @param type 任务类型（可选）
  /// @param startTime 开始时间（可选）
  /// @param endTime 结束时间（可选）
  /// @return 导出结果
  Future<Response> exportTaskLogs({
    String? search,
    String? status,
    String? type,
    String? startTime,
    String? endTime,
  }) async {
    final data = {
      if (search != null) 'search': search,
      if (status != null) 'status': status,
      if (type != null) 'type': type,
      if (startTime != null) 'startTime': startTime,
      if (endTime != null) 'endTime': endTime,
    };
    return await _client.post('/logs/tasks/export', data: data);
  }

  /// 获取任务日志文件
  /// 
  /// 获取任务日志文件
  /// @param id 任务日志ID
  /// @return 任务日志文件
  Future<Response> getTaskLogFile(int id) async {
    return await _client.get('/logs/tasks/$id/file');
  }

  /// 获取任务日志文件内容
  /// 
  /// 获取任务日志文件内容
  /// @param id 任务日志ID
  /// @param lines 日志行数（可选，默认为100）
  /// @return 日志内容
  Future<Response> getTaskLogFileContent(int id, {int lines = 100}) async {
    final data = {
      'lines': lines,
    };
    return await _client.post('/logs/tasks/$id/file/content', data: data);
  }

  /// 删除任务日志
  /// 
  /// 删除指定的任务日志
  /// @param ids 任务日志ID列表
  /// @return 删除结果
  Future<Response> deleteTaskLogs(List<int> ids) async {
    final data = {
      'ids': ids,
    };
    return await _client.post('/logs/tasks/del', data: data);
  }
}