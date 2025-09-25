/// 1Panel V2 API - Logs 相关接口
/// 
/// 此文件包含与日志管理相关的所有API接口，
/// 包括系统日志、应用日志、安全日志等操作。

import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../models/logs_models.dart';

class LogsV2Api {
  final ApiClient _client;

  LogsV2Api(this._client);

  /// 获取系统日志
  /// 
  /// 获取系统日志
  /// @param search 搜索关键词（可选）
  /// @param level 日志级别（可选）
  /// @param page 页码（可选，默认为1）
  /// @param pageSize 每页数量（可选，默认为10）
  /// @return 系统日志
  Future<Response> getSystemLogs({
    String? search,
    String? level,
    int page = 1,
    int pageSize = 10,
  }) async {
    final data = {
      'page': page,
      'pageSize': pageSize,
      if (search != null) 'search': search,
      if (level != null) 'level': level,
    };
    return await _client.post('/logs/system', data: data);
  }

  /// 获取系统日志文件列表
  /// 
  /// 获取系统日志文件列表
  /// @return 系统日志文件列表
  Future<Response> getSystemLogFiles() async {
    return await _client.get('/logs/system/files');
  }

  /// 获取指定系统日志文件内容
  /// 
  /// 获取指定系统日志文件的内容
  /// @param filename 日志文件名
  /// @param lines 日志行数（可选，默认为100）
  /// @return 日志内容
  Future<Response> getSystemLogFileContent(String filename, {int lines = 100}) async {
    final data = {
      'filename': filename,
      'lines': lines,
    };
    return await _client.post('/logs/system/file', data: data);
  }

  /// 获取应用日志
  /// 
  /// 获取应用日志
  /// @param search 搜索关键词（可选）
  /// @param appName 应用名称（可选）
  /// @param page 页码（可选，默认为1）
  /// @param pageSize 每页数量（可选，默认为10）
  /// @return 应用日志
  Future<Response> getAppLogs({
    String? search,
    String? appName,
    int page = 1,
    int pageSize = 10,
  }) async {
    final data = {
      'page': page,
      'pageSize': pageSize,
      if (search != null) 'search': search,
      if (appName != null) 'appName': appName,
    };
    return await _client.post('/logs/app', data: data);
  }

  /// 获取安全日志
  /// 
  /// 获取安全日志
  /// @param search 搜索关键词（可选）
  /// @param type 日志类型（可选）
  /// @param page 页码（可选，默认为1）
  /// @param pageSize 每页数量（可选，默认为10）
  /// @return 安全日志
  Future<Response> getSecurityLogs({
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
    return await _client.post('/logs/security', data: data);
  }

  /// 获取操作日志
  /// 
  /// 获取操作日志
  /// @param search 搜索关键词（可选）
  /// @param user 用户名（可选）
  /// @param startTime 开始时间（可选）
  /// @param endTime 结束时间（可选）
  /// @param page 页码（可选，默认为1）
  /// @param pageSize 每页数量（可选，默认为10）
  /// @return 操作日志
  Future<Response> getOperationLogs({
    String? search,
    String? user,
    String? startTime,
    String? endTime,
    int page = 1,
    int pageSize = 10,
  }) async {
    final data = {
      'page': page,
      'pageSize': pageSize,
      if (search != null) 'search': search,
      if (user != null) 'user': user,
      if (startTime != null) 'startTime': startTime,
      if (endTime != null) 'endTime': endTime,
    };
    return await _client.post('/logs/operation', data: data);
  }

  /// 获取访问日志
  /// 
  /// 获取访问日志
  /// @param search 搜索关键词（可选）
  /// @param ip IP地址（可选）
  /// @param startTime 开始时间（可选）
  /// @param endTime 结束时间（可选）
  /// @param page 页码（可选，默认为1）
  /// @param pageSize 每页数量（可选，默认为10）
  /// @return 访问日志
  Future<Response> getAccessLogs({
    String? search,
    String? ip,
    String? startTime,
    String? endTime,
    int page = 1,
    int pageSize = 10,
  }) async {
    final data = {
      'page': page,
      'pageSize': pageSize,
      if (search != null) 'search': search,
      if (ip != null) 'ip': ip,
      if (startTime != null) 'startTime': startTime,
      if (endTime != null) 'endTime': endTime,
    };
    return await _client.post('/logs/access', data: data);
  }

  /// 获取错误日志
  /// 
  /// 获取错误日志
  /// @param search 搜索关键词（可选）
  /// @param level 错误级别（可选）
  /// @param startTime 开始时间（可选）
  /// @param endTime 结束时间（可选）
  /// @param page 页码（可选，默认为1）
  /// @param pageSize 每页数量（可选，默认为10）
  /// @return 错误日志
  Future<Response> getErrorLogs({
    String? search,
    String? level,
    String? startTime,
    String? endTime,
    int page = 1,
    int pageSize = 10,
  }) async {
    final data = {
      'page': page,
      'pageSize': pageSize,
      if (search != null) 'search': search,
      if (level != null) 'level': level,
      if (startTime != null) 'startTime': startTime,
      if (endTime != null) 'endTime': endTime,
    };
    return await _client.post('/logs/error', data: data);
  }

  /// 获取日志统计信息
  /// 
  /// 获取日志统计信息
  /// @param type 日志类型
  /// @param timeRange 时间范围（可选，默认为1d）
  /// @return 统计信息
  Future<Response> getLogStats(String type, {String timeRange = '1d'}) async {
    final data = {
      'type': type,
      'timeRange': timeRange,
    };
    return await _client.post('/logs/stats', data: data);
  }

  /// 清理日志
  /// 
  /// 清理指定类型的日志
  /// @param type 日志类型
  /// @param days 保留天数
  /// @return 清理结果
  Future<Response> cleanLogs(String type, int days) async {
    final data = {
      'type': type,
      'days': days,
    };
    return await _client.post('/logs/clean', data: data);
  }

  /// 导出日志
  /// 
  /// 导出指定类型的日志
  /// @param type 日志类型
  /// @param search 搜索关键词（可选）
  /// @param startTime 开始时间（可选）
  /// @param endTime 结束时间（可选）
  /// @return 导出结果
  Future<Response> exportLogs(String type, {
    String? search,
    String? startTime,
    String? endTime,
  }) async {
    final data = {
      'type': type,
      if (search != null) 'search': search,
      if (startTime != null) 'startTime': startTime,
      if (endTime != null) 'endTime': endTime,
    };
    return await _client.post('/logs/export', data: data);
  }
}