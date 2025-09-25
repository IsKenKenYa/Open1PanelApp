/// 1Panel V2 API - Snapshot 相关接口
/// 
/// 此文件包含与系统快照相关的所有API接口，
/// 包括快照的创建、恢复、管理等操作。

import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../models/snapshot_models.dart';

class SnapshotV2Api {
  final ApiClient _client;

  SnapshotV2Api(this._client);

  /// 获取快照列表
  /// 
  /// 获取所有快照列表
  /// @param page 页码（可选，默认为1）
  /// @param pageSize 每页数量（可选，默认为10）
  /// @return 快照列表
  Future<Response> getSnapshots({
    int page = 1,
    int pageSize = 10,
  }) async {
    final data = {
      'page': page,
      'pageSize': pageSize,
    };
    return await _client.post('/snapshots/search', data: data);
  }

  /// 创建快照
  /// 
  /// 创建系统快照
  /// @param name 快照名称
  /// @param description 快照描述（可选）
  /// @param includeData 是否包含数据（可选，默认为false）
  /// @return 创建结果
  Future<Response> createSnapshot({
    required String name,
    String? description,
    bool includeData = false,
  }) async {
    final data = {
      'name': name,
      if (description != null) 'description': description,
      'includeData': includeData,
    };
    return await _client.post('/snapshots', data: data);
  }

  /// 恢复快照
  /// 
  /// 从指定快照恢复系统
  /// @param id 快照ID
  /// @return 恢复结果
  Future<Response> restoreSnapshot(int id) async {
    return await _client.post('/snapshots/$id/restore');
  }

  /// 删除快照
  /// 
  /// 删除指定的快照
  /// @param id 快照ID
  /// @return 删除结果
  Future<Response> deleteSnapshot(int id) async {
    return await _client.delete('/snapshots/$id');
  }

  /// 批量删除快照
  /// 
  /// 批量删除指定的快照
  /// @param ids 快照ID列表
  /// @return 删除结果
  Future<Response> deleteSnapshots(List<int> ids) async {
    final data = {
      'ids': ids,
    };
    return await _client.post('/snapshots/batch/delete', data: data);
  }

  /// 获取快照详情
  /// 
  /// 获取指定快照的详细信息
  /// @param id 快照ID
  /// @return 快照详情
  Future<Response> getSnapshotDetail(int id) async {
    return await _client.get('/snapshots/$id');
  }

  /// 获取快照状态
  /// 
  /// 获取指定快照的状态
  /// @param id 快照ID
  /// @return 快照状态
  Future<Response> getSnapshotStatus(int id) async {
    return await _client.get('/snapshots/$id/status');
  }

  /// 获取快照日志
  /// 
  /// 获取指定快照的日志
  /// @param id 快照ID
  /// @param lines 日志行数（可选，默认为100）
  /// @return 快照日志
  Future<Response> getSnapshotLogs(int id, {int lines = 100}) async {
    final data = {
      'lines': lines,
    };
    return await _client.post('/snapshots/$id/logs', data: data);
  }

  /// 下载快照
  /// 
  /// 下载指定的快照
  /// @param id 快照ID
  /// @return 下载结果
  Future<Response> downloadSnapshot(int id) async {
    return await _client.get('/snapshots/$id/download');
  }

  /// 导入快照
  /// 
  /// 导入快照
  /// @param filePath 快照文件路径
  /// @return 导入结果
  Future<Response> importSnapshot(String filePath) async {
    final data = {
      'filePath': filePath,
    };
    return await _client.post('/snapshots/import', data: data);
  }

  /// 获取快照配置
  /// 
  /// 获取快照配置信息
  /// @return 快照配置
  Future<Response> getSnapshotConfig() async {
    return await _client.get('/snapshots/config');
  }

  /// 更新快照配置
  /// 
  /// 更新快照配置
  /// @param config 快照配置
  /// @return 更新结果
  Future<Response> updateSnapshotConfig(Map<String, dynamic> config) async {
    return await _client.post('/snapshots/config', data: config);
  }

  /// 获取快照统计信息
  /// 
  /// 获取快照统计信息
  /// @return 统计信息
  Future<Response> getSnapshotStats() async {
    return await _client.get('/snapshots/stats');
  }

  /// 获取快照存储信息
  /// 
  /// 获取快照存储信息
  /// @return 存储信息
  Future<Response> getSnapshotStorage() async {
    return await _client.get('/snapshots/storage');
  }

  /// 清理快照
  /// 
  /// 清理快照
  /// @param days 保留天数
  /// @return 清理结果
  Future<Response> cleanSnapshots(int days) async {
    final data = {
      'days': days,
    };
    return await _client.post('/snapshots/clean', data: data);
  }

  /// 创建定时快照
  /// 
  /// 创建定时快照任务
  /// @param name 任务名称
  /// @param cronExpression cron表达式
  /// @param description 任务描述（可选）
  /// @param includeData 是否包含数据（可选，默认为false）
  /// @param maxCount 最大保留数量（可选）
  /// @return 创建结果
  Future<Response> createScheduledSnapshot({
    required String name,
    required String cronExpression,
    String? description,
    bool includeData = false,
    int? maxCount,
  }) async {
    final data = {
      'name': name,
      'cronExpression': cronExpression,
      if (description != null) 'description': description,
      'includeData': includeData,
      if (maxCount != null) 'maxCount': maxCount,
    };
    return await _client.post('/snapshots/scheduled', data: data);
  }

  /// 获取定时快照列表
  /// 
  /// 获取定时快照任务列表
  /// @return 定时快照列表
  Future<Response> getScheduledSnapshots() async {
    return await _client.get('/snapshots/scheduled');
  }

  /// 更新定时快照
  /// 
  /// 更新定时快照任务
  /// @param id 任务ID
  /// @param config 任务配置
  /// @return 更新结果
  Future<Response> updateScheduledSnapshot(int id, Map<String, dynamic> config) async {
    return await _client.post('/snapshots/scheduled/$id', data: config);
  }

  /// 删除定时快照
  /// 
  /// 删除定时快照任务
  /// @param id 任务ID
  /// @return 删除结果
  Future<Response> deleteScheduledSnapshot(int id) async {
    return await _client.delete('/snapshots/scheduled/$id');
  }

  /// 启动定时快照
  /// 
  /// 启动定时快照任务
  /// @param id 任务ID
  /// @return 启动结果
  Future<Response> startScheduledSnapshot(int id) async {
    return await _client.post('/snapshots/scheduled/$id/start');
  }

  /// 停止定时快照
  /// 
  /// 停止定时快照任务
  /// @param id 任务ID
  /// @return 停止结果
  Future<Response> stopScheduledSnapshot(int id) async {
    return await _client.post('/snapshots/scheduled/$id/stop');
  }
}