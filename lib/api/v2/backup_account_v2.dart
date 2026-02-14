import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import '../../core/config/api_constants.dart';
import '../../data/models/backup_account_models.dart';
import '../../data/models/common_models.dart' hide CommonBackup, CommonRecover, RecordSearch;

class BackupAccountV2Api {
  final DioClient _client;

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
    final response = await _client.post(
      '${ApiConstants.buildApiPath('/backups')}/test',
      data: request.toJson(),
    );
    return Response(
      data: response.statusCode == 200,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 刷新备份令牌
  ///
  /// 刷新备份账户的访问令牌
  /// @param request 备份账户配置
  /// @return 刷新结果
  Future<Response> refreshBackupToken(BackupOperate request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/backups/refresh/token'),
      data: request.toJson(),
    );
  }

  /// 分页搜索备份账户
  ///
  /// 分页搜索备份账户列表
  /// @param search 搜索请求
  /// @return 备份账户分页列表
  Future<Response<PageResult<BackupAccountInfo>>> searchBackupAccounts(BackupAccountSearch search) async {
    final response = await _client.post(
      ApiConstants.buildApiPath('/backups/search'),
      data: search.toJson(),
    );
    return Response(
      data: PageResult.fromJson(
        response.data as Map<String, dynamic>,
        (json) => BackupAccountInfo.fromJson(json as Map<String, dynamic>),
      ),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 从备份账户列出文件
  ///
  /// 列出备份账户中的文件
  /// @param request 文件搜索请求
  /// @return 文件列表
  Future<Response<List<BackupFile>>> listBackupFiles(BackupFileSearch request) async {
    final response = await _client.post(
      ApiConstants.buildApiPath('/backups/search/files'),
      data: request.toJson(),
    );
    return Response(
      data: (response.data as List?)
          ?.map((item) => BackupFile.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 更新备份账户
  ///
  /// 更新指定的备份账户配置
  /// @param request 更新请求
  /// @return 更新结果
  Future<Response> updateBackupAccount(BackupOperate request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/backups/update'),
      data: request.toJson(),
    );
  }

  // Core Backup APIs
  /// 创建核心备份账户
  ///
  /// 创建新的核心备份账户
  /// @param request 备份账户配置
  /// @return 创建结果
  Future<Response> createCoreBackupAccount(BackupOperate request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/core/backups'),
      data: request.toJson(),
    );
  }

  /// 获取存储桶列表
  ///
  /// 获取对象存储的存储桶列表
  /// @param request 备份账户配置
  /// @return 存储桶列表
  Future<Response<List<String>>> getBuckets(BackupOperate request) async {
    final response = await _client.post(
      ApiConstants.buildApiPath('/core/backups/buckets'),
      data: request.toJson(),
    );
    return Response(
      data: (response.data as List?)?.cast<String>() ?? [],
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取备份账户基础信息
  ///
  /// 根据客户端类型获取备份账户基础信息
  /// @param clientType 客户端类型
  /// @return 基础信息
  Future<Response<Map<String, dynamic>>> getBackupClientInfo(String clientType) async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/core/backups/client/$clientType'),
    );
    return Response(
      data: response.data as Map<String, dynamic>,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 删除核心备份账户
  ///
  /// 删除指定的核心备份账户
  /// @param request 删除请求
  /// @return 删除结果
  Future<Response> deleteCoreBackupAccount(OperateByID request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/core/backups/del'),
      data: request.toJson(),
    );
  }

  /// 刷新核心备份令牌
  ///
  /// 刷新核心备份账户的访问令牌
  /// @param request 备份账户配置
  /// @return 刷新结果
  Future<Response> refreshCoreBackupToken(BackupOperate request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/core/backups/refresh/token'),
      data: request.toJson(),
    );
  }

  /// 更新核心备份账户
  ///
  /// 更新指定的核心备份账户配置
  /// @param request 更新请求
  /// @return 更新结果
  Future<Response> updateCoreBackupAccount(BackupOperate request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/core/backups/update'),
      data: request.toJson(),
    );
  }

  /// 删除备份记录
  ///
  /// 删除指定的备份记录
  /// @param request 删除请求
  /// @return 删除结果
  Future<Response> deleteBackupRecord(OperateByID request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/backups/record/del'),
      data: request.toJson(),
    );
  }

  /// 获取备份记录详情
  ///
  /// 获取指定备份记录的详细信息
  /// @param id 备份记录ID
  /// @return 备份记录详情
  Future<Response<BackupRecord>> getBackupRecordDetail(int id) async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/backups/record/$id'),
    );
    return Response(
      data: BackupRecord.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 验证备份文件
  ///
  /// 验证备份文件的完整性
  /// @param request 验证请求
  /// @return 验证结果
  Future<Response<Map<String, dynamic>>> verifyBackupFile(BackupVerifyRequest request) async {
    final response = await _client.post(
      ApiConstants.buildApiPath('/backups/verify'),
      data: request.toJson(),
    );
    return Response(
      data: response.data as Map<String, dynamic>,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }
}
