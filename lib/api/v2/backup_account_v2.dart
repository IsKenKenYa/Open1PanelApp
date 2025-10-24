/// 1Panel V2 API - Backup Account 相关接口
///
/// 此文件包含与备份账户管理相关的所有API接口，
/// 包括备份账户的创建、删除、更新、查询等操作。

import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/config/api_constants.dart';
import '../../data/models/backup_account_models.dart';

class BackupAccountV2Api {
  final ApiClient _client;

  BackupAccountV2Api(this._client);

  /// 创建备份账户
  ///
  /// 创建一个新的备份账户
  /// @param request 备份账户配置信息
  /// @return 创建结果
  Future<Response> createBackupAccount(BackupOperate request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/backups'),
      data: request.toJson(),
    );
  }

  /// 删除备份账户
  ///
  /// 删除指定的备份账户
  /// @param request 删除请求
  /// @return 删除结果
  Future<Response> deleteBackupAccount(OperateByID request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/backups/del'),
      data: request.toJson(),
    );
  }

  /// 获取备份账户选项列表
  ///
  /// 获取所有可用的备份账户选项
  /// @return 备份账户选项列表
  Future<Response<List<BackupOption>>> getBackupAccountOptions() async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/backups/options'),
    );
    return Response(
      data: (response.data as List?)
          ?.map((item) => BackupOption.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取本地备份目录
  ///
  /// 获取本地备份目录路径
  /// @return 本地备份目录
  Future<Response<String>> getLocalBackupDir() async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/backups/local'),
    );
    return Response(
      data: response.data?.toString() ?? '',
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 备份系统数据
  ///
  /// 执行系统数据备份
  /// @param request 备份请求
  /// @return 备份结果
  Future<Response> backupSystemData(CommonBackup request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/backups/backup'),
      data: request.toJson(),
    );
  }

  /// 恢复系统数据
  ///
  /// 从备份恢复系统数据
  /// @param request 恢复请求
  /// @return 恢复结果
  Future<Response> recoverSystemData(CommonRecover request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/backups/recover'),
      data: request.toJson(),
    );
  }

  /// 从上传恢复系统数据
  ///
  /// 从上传的备份文件恢复系统数据
  /// @param request 恢复请求
  /// @return 恢复结果
  Future<Response> recoverSystemDataFromUpload(CommonRecover request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/backups/recover/byupload'),
      data: request.toJson(),
    );
  }

  /// 下载备份记录
  ///
  /// 下载指定的备份记录文件
  /// @param request 下载请求
  /// @return 下载结果
  Future<Response<String>> downloadBackupRecord(DownloadRecord request) async {
    final response = await _client.post(
      ApiConstants.buildApiPath('/backup/record/download'),
      data: request.toJson(),
    );
    return Response(
      data: response.data?.toString() ?? '',
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 分页查询备份记录
  ///
  /// 分页查询备份记录列表
  /// @param request 搜索请求
  /// @return 备份记录列表
  Future<Response<PageResult>> searchBackupRecords(RecordSearch request) async {
    final response = await _client.post(
      ApiConstants.buildApiPath('/backups/record/search'),
      data: request.toJson(),
    );
    return Response(
      data: PageResult.fromJson(response.data as Map<String, dynamic>, (json) => json),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 按定时任务分页查询备份记录
  ///
  /// 按定时任务分页查询备份记录列表
  /// @param request 搜索请求
  /// @return 备份记录列表
  Future<Response<PageResult>> searchBackupRecordsByCronjob(RecordSearchByCronjob request) async {
    final response = await _client.post(
      ApiConstants.buildApiPath('/backups/record/search/bycronjob'),
      data: request.toJson(),
    );
    return Response(
      data: PageResult.fromJson(response.data as Map<String, dynamic>, (json) => json),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 加载备份记录大小
  ///
  /// 加载备份记录的文件大小信息
  /// @param request 搜索请求
  /// @return 备份记录大小列表
  Future<Response<List<RecordFileSize>>> loadBackupRecordSizes(SearchForSize request) async {
    final response = await _client.post(
      ApiConstants.buildApiPath('/backups/record/size'),
      data: request.toJson(),
    );
    return Response(
      data: (response.data as List?)
          ?.map((item) => RecordFileSize.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取备份账户详情
  ///
  /// 获取指定备份账户的详细信息
  /// @param id 备份账户ID
  /// @return 备份账户详情
  Future<Response<BackupOperate>> getBackupAccountDetail(int id) async {
    final response = await _client.get(
      '${ApiConstants.buildApiPath('/backups')}/$id',
    );
    return Response(
      data: BackupOperate.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 测试备份账户连接
  ///
  /// 测试指定备份账户的连接
  /// @param request 备份账户配置
  /// @return 测试结果
  Future<Response<bool>> testBackupAccount(BackupOperate request) async {
    try {
      final response = await _client.post(
        '${ApiConstants.buildApiPath('/backups')}/test',
        data: request.toJson(),
      );
      return Response(
        data: true, // 如果没有异常，则连接测试成功
        statusCode: response.statusCode,
        statusMessage: response.statusMessage,
        requestOptions: response.requestOptions,
      );
    } catch (e) {
      return Response(
        data: false, // 连接测试失败
        statusCode: 500,
        statusMessage: 'Connection test failed',
        requestOptions: _client.dio.options,
      );
    }
  }
}

/// 分页结果基类
class PageResult extends Equatable {
  final List<dynamic> items;
  final int total;

  const PageResult({
    required this.items,
    required this.total,
  });

  factory PageResult.fromJson(Map<String, dynamic> json, Function(dynamic)? fromJsonT) {
    return PageResult(
      items: (json['items'] as List?) ?? [],
      total: json['total'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [items, total];
}