/// 1Panel V2 API - Cronjob 相关接口
///
/// 此文件包含与定时任务管理相关的所有API接口，
/// 包括定时任务的创建、删除、更新、查询等操作。

import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/config/api_constants.dart';
import '../../data/models/cronjob_models.dart';
import '../../data/models/common_models.dart';

class CronjobV2Api {
  final ApiClient _client;

  CronjobV2Api(this._client);

  /// 创建定时任务
  ///
  /// 创建一个新的定时任务
  /// @param cronjob 定时任务配置信息
  /// @return 创建结果
  Future<Response> createCronjob(CronJobCreate cronjob) async {
    return await _client.post(
      ApiConstants.buildApiPath('/cronjobs'),
      data: cronjob.toJson(),
    );
  }

  /// 删除定时任务
  ///
  /// 删除指定的定时任务
  /// @param ids 定时任务ID列表
  /// @return 删除结果
  Future<Response> deleteCronjob(List<int> ids) async {
    final operation = OperateByID(ids: ids);
    return await _client.post(
      ApiConstants.buildApiPath('/cronjobs/del'),
      data: operation.toJson(),
    );
  }

  /// 更新定时任务
  ///
  /// 更新指定的定时任务
  /// @param cronjob 定时任务更新信息
  /// @return 更新结果
  Future<Response> updateCronjob(CronJobUpdate cronjob) async {
    return await _client.post(
      ApiConstants.buildApiPath('/cronjobs/${cronjob.id}/update'),
      data: cronjob.toJson(),
    );
  }

  /// 获取定时任务列表
  ///
  /// 获取所有定时任务列表
  /// @param search 搜索关键词（可选）
  /// @param type 任务类型（可选）
  /// @param status 任务状态（可选）
  /// @param page 页码（可选，默认为1）
  /// @param pageSize 每页数量（可选，默认为10）
  /// @return 定时任务列表
  Future<Response<PageResult<CronJobInfo>>> getCronjobs({
    String? search,
    String? type,
    CronJobStatus? status,
    int page = 1,
    int pageSize = 10,
  }) async {
    final request = CronJobSearch(
      page: page,
      pageSize: pageSize,
      search: search,
      type: type,
      status: status,
    );
    final response = await _client.post(
      ApiConstants.buildApiPath('/cronjobs/search'),
      data: request.toJson(),
    );
    return Response(
      data: PageResult.fromJson(
        response.data as Map<String, dynamic>,
        (json) => CronJobInfo.fromJson(json as Map<String, dynamic>),
      ),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取定时任务详情
  ///
  /// 获取指定定时任务的详细信息
  /// @param id 定时任务ID
  /// @return 定时任务详情
  Future<Response<CronJobInfo>> getCronjobDetail(int id) async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/cronjobs/$id'),
    );
    return Response(
      data: CronJobInfo.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 启动定时任务
  ///
  /// 启动指定的定时任务
  /// @param ids 定时任务ID列表
  /// @return 启动结果
  Future<Response> startCronjob(List<int> ids) async {
    final operation = CronJobOperate(ids: ids, operation: 'start');
    return await _client.post(
      ApiConstants.buildApiPath('/cronjobs/start'),
      data: operation.toJson(),
    );
  }

  /// 停止定时任务
  ///
  /// 停止指定的定时任务
  /// @param ids 定时任务ID列表
  /// @return 停止结果
  Future<Response> stopCronjob(List<int> ids) async {
    final operation = CronJobOperate(ids: ids, operation: 'stop');
    return await _client.post(
      ApiConstants.buildApiPath('/cronjobs/stop'),
      data: operation.toJson(),
    );
  }

  /// 立即执行定时任务
  ///
  /// 立即执行指定的定时任务
  /// @param ids 定时任务ID列表
  /// @return 执行结果
  Future<Response> runCronjob(List<int> ids) async {
    final operation = CronJobOperate(ids: ids, operation: 'run');
    return await _client.post(
      ApiConstants.buildApiPath('/cronjobs/run'),
      data: operation.toJson(),
    );
  }

  /// 启用定时任务
  ///
  /// 启用指定的定时任务
  /// @param ids 定时任务ID列表
  /// @return 启用结果
  Future<Response> enableCronjob(List<int> ids) async {
    final operation = CronJobOperate(ids: ids, operation: 'enable');
    return await _client.post(
      ApiConstants.buildApiPath('/cronjobs/enable'),
      data: operation.toJson(),
    );
  }

  /// 禁用定时任务
  ///
  /// 禁用指定的定时任务
  /// @param ids 定时任务ID列表
  /// @return 禁用结果
  Future<Response> disableCronjob(List<int> ids) async {
    final operation = CronJobOperate(ids: ids, operation: 'disable');
    return await _client.post(
      ApiConstants.buildApiPath('/cronjobs/disable'),
      data: operation.toJson(),
    );
  }

  /// 获取定时任务执行日志
  ///
  /// 获取指定定时任务的执行日志
  /// @param id 定时任务ID
  /// @param page 页码（可选，默认为1）
  /// @param pageSize 每页数量（可选，默认为10）
  /// @return 执行日志
  Future<Response<PageResult<CronJobLog>>> getCronjobLogs({
    required int id,
    int page = 1,
    int pageSize = 10,
  }) async {
    final data = {
      'cronjobId': id,
      'page': page,
      'pageSize': pageSize,
    };
    final response = await _client.post(
      ApiConstants.buildApiPath('/cronjobs/logs/search'),
      data: data,
    );
    return Response(
      data: PageResult.fromJson(
        response.data as Map<String, dynamic>,
        (json) => CronJobLog.fromJson(json as Map<String, dynamic>),
      ),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取定时任务统计信息
  ///
  /// 获取定时任务的统计信息
  /// @return 统计信息
  Future<Response<CronJobStats>> getCronjobStats() async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/cronjobs/stats'),
    );
    return Response(
      data: CronJobStats.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 清理定时任务日志
  ///
  /// 清理指定定时任务的日志
  /// @param id 定时任务ID
  /// @param days 保留天数
  /// @return 清理结果
  Future<Response> cleanCronjobLogs({
    required int id,
    required int days,
  }) async {
    final data = {
      'cronjobId': id,
      'days': days,
    };
    return await _client.post(
      ApiConstants.buildApiPath('/cronjobs/logs/clean'),
      data: data,
    );
  }

  /// 获取定时任务类型列表
  ///
  /// 获取所有可用的定时任务类型
  /// @return 任务类型列表
  Future<Response<List<String>>> getCronjobTypes() async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/cronjobs/types'),
    );
    return Response(
      data: (response.data as List?)?.map((item) => item as String).toList() ?? [],
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 验证Cron表达式
  ///
  /// 验证Cron表达式的有效性
  /// @param cronExpression Cron表达式
  /// @return 验证结果
  Future<Response<Map<String, dynamic>>> validateCronExpression(String cronExpression) async {
    final data = {
      'cronExpression': cronExpression,
    };
    return await _client.post(
      ApiConstants.buildApiPath('/cronjobs/validate'),
      data: data,
    );
  }

  /// 获取Cron表达式预览
  ///
  /// 获取Cron表达式的执行时间预览
  /// @param cronExpression Cron表达式
  /// @param count 预览次数（可选，默认为5）
  /// @return 预览结果
  Future<Response<List<String>>> previewCronExpression({
    required String cronExpression,
    int count = 5,
  }) async {
    final data = {
      'cronExpression': cronExpression,
      'count': count,
    };
    final response = await _client.post(
      ApiConstants.buildApiPath('/cronjobs/preview'),
      data: data,
    );
    return Response(
      data: (response.data as List?)?.map((item) => item as String).toList() ?? [],
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }
}