/// 1Panel V2 API - Terminal 相关接口
/// 
/// 此文件包含与终端管理相关的所有API接口，
/// 包括终端连接、命令执行、会话管理等操作。

import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../models/terminal_models.dart';

class TerminalV2Api {
  final ApiClient _client;

  TerminalV2Api(this._client);

  /// 创建终端会话
  /// 
  /// 创建一个新的终端会话
  /// @param name 会话名称（可选）
  /// @param type 终端类型（可选，默认为bash）
  /// @param workingDirectory 工作目录（可选）
  /// @return 创建结果
  Future<Response> createTerminalSession({
    String? name,
    String type = 'bash',
    String? workingDirectory,
  }) async {
    final data = {
      if (name != null) 'name': name,
      'type': type,
      if (workingDirectory != null) 'workingDirectory': workingDirectory,
    };
    return await _client.post('/terminal/sessions', data: data);
  }

  /// 获取终端会话列表
  /// 
  /// 获取所有终端会话列表
  /// @return 会话列表
  Future<Response> getTerminalSessions() async {
    return await _client.get('/terminal/sessions');
  }

  /// 获取终端会话详情
  /// 
  /// 获取指定终端会话的详细信息
  /// @param sessionId 会话ID
  /// @return 会话详情
  Future<Response> getTerminalSessionDetail(String sessionId) async {
    return await _client.get('/terminal/sessions/$sessionId');
  }

  /// 删除终端会话
  /// 
  /// 删除指定的终端会话
  /// @param sessionId 会话ID
  /// @return 删除结果
  Future<Response> deleteTerminalSession(String sessionId) async {
    return await _client.delete('/terminal/sessions/$sessionId');
  }

  /// 执行终端命令
  /// 
  /// 在指定的终端会话中执行命令
  /// @param sessionId 会话ID
  /// @param command 要执行的命令
  /// @param timeout 超时时间（可选，单位：秒）
  /// @return 执行结果
  Future<Response> executeTerminalCommand({
    required String sessionId,
    required String command,
    int? timeout,
  }) async {
    final data = {
      'command': command,
      if (timeout != null) 'timeout': timeout,
    };
    return await _client.post('/terminal/sessions/$sessionId/execute', data: data);
  }

  /// 获取终端输出
  /// 
  /// 获取指定终端会话的输出
  /// @param sessionId 会话ID
  /// @param lines 输出行数（可选，默认为100）
  /// @return 终端输出
  Future<Response> getTerminalOutput(String sessionId, {int lines = 100}) async {
    final data = {
      'lines': lines,
    };
    return await _client.post('/terminal/sessions/$sessionId/output', data: data);
  }

  /// 发送输入到终端
  /// 
  /// 发送输入到指定的终端会话
  /// @param sessionId 会话ID
  /// @param input 输入内容
  /// @return 发送结果
  Future<Response> sendTerminalInput({
    required String sessionId,
    required String input,
  }) async {
    final data = {
      'input': input,
    };
    return await _client.post('/terminal/sessions/$sessionId/input', data: data);
  }

  /// 调整终端大小
  /// 
  /// 调整指定终端会话的大小
  /// @param sessionId 会话ID
  /// @param rows 行数
  /// @param columns 列数
  /// @return 调整结果
  Future<Response> resizeTerminal({
    required String sessionId,
    required int rows,
    required int columns,
  }) async {
    final data = {
      'rows': rows,
      'columns': columns,
    };
    return await _client.post('/terminal/sessions/$sessionId/resize', data: data);
  }

  /// 获取终端历史记录
  /// 
  /// 获取指定终端会话的历史记录
  /// @param sessionId 会话ID
  /// @param limit 记录数量限制（可选，默认为100）
  /// @return 历史记录
  Future<Response> getTerminalHistory(String sessionId, {int limit = 100}) async {
    final data = {
      'limit': limit,
    };
    return await _client.post('/terminal/sessions/$sessionId/history', data: data);
  }

  /// 清除终端历史记录
  /// 
  /// 清除指定终端会话的历史记录
  /// @param sessionId 会话ID
  /// @return 清除结果
  Future<Response> clearTerminalHistory(String sessionId) async {
    return await _client.post('/terminal/sessions/$sessionId/history/clear');
  }

  /// 获取终端状态
  /// 
  /// 获取指定终端会话的状态
  /// @param sessionId 会话ID
  /// @return 终端状态
  Future<Response> getTerminalStatus(String sessionId) async {
    return await _client.get('/terminal/sessions/$sessionId/status');
  }

  /// 重命名终端会话
  /// 
  /// 重命名指定的终端会话
  /// @param sessionId 会话ID
  /// @param name 新名称
  /// @return 重命名结果
  Future<Response> renameTerminalSession({
    required String sessionId,
    required String name,
  }) async {
    final data = {
      'name': name,
    };
    return await _client.post('/terminal/sessions/$sessionId/rename', data: data);
  }

  /// 获取终端文件列表
  /// 
  /// 获取指定终端会话的文件列表
  /// @param sessionId 会话ID
  /// @param path 路径（可选，默认为当前目录）
  /// @return 文件列表
  Future<Response> getTerminalFiles(String sessionId, {String? path}) async {
    final data = {
      if (path != null) 'path': path,
    };
    return await _client.post('/terminal/sessions/$sessionId/files', data: data);
  }

  /// 上传文件到终端
  /// 
  /// 上传文件到指定的终端会话
  /// @param sessionId 会话ID
  /// @param filePath 文件路径
  /// @param targetPath 目标路径（可选）
  /// @return 上传结果
  Future<Response> uploadFileToTerminal({
    required String sessionId,
    required String filePath,
    String? targetPath,
  }) async {
    final data = {
      'filePath': filePath,
      if (targetPath != null) 'targetPath': targetPath,
    };
    return await _client.post('/terminal/sessions/$sessionId/files/upload', data: data);
  }

  /// 从终端下载文件
  /// 
  /// 从指定的终端会话下载文件
  /// @param sessionId 会话ID
  /// @param filePath 文件路径
  /// @return 下载结果
  Future<Response> downloadFileFromTerminal({
    required String sessionId,
    required String filePath,
  }) async {
    final data = {
      'filePath': filePath,
    };
    return await _client.post('/terminal/sessions/$sessionId/files/download', data: data);
  }

  /// 获取终端进程列表
  /// 
  /// 获取指定终端会话的进程列表
  /// @param sessionId 会话ID
  /// @return 进程列表
  Future<Response> getTerminalProcesses(String sessionId) async {
    return await _client.get('/terminal/sessions/$sessionId/processes');
  }

  /// 终止终端进程
  /// 
  /// 终止指定终端会话的进程
  /// @param sessionId 会话ID
  /// @param processId 进程ID
  /// @return 终止结果
  Future<Response> terminateTerminalProcess({
    required String sessionId,
    required int processId,
  }) async {
    final data = {
      'processId': processId,
    };
    return await _client.post('/terminal/sessions/$sessionId/processes/terminate', data: data);
  }

  /// 获取终端配置
  /// 
  /// 获取终端配置信息
  /// @return 终端配置
  Future<Response> getTerminalConfig() async {
    return await _client.get('/terminal/config');
  }

  /// 更新终端配置
  /// 
  /// 更新终端配置
  /// @param config 终端配置
  /// @return 更新结果
  Future<Response> updateTerminalConfig(Map<String, dynamic> config) async {
    return await _client.post('/terminal/config', data: config);
  }

  /// 获取终端主题
  /// 
  /// 获取可用的终端主题列表
  /// @return 主题列表
  Future<Response> getTerminalThemes() async {
    return await _client.get('/terminal/themes');
  }

  /// 设置终端主题
  /// 
  /// 设置终端主题
  /// @param theme 主题名称
  /// @return 设置结果
  Future<Response> setTerminalTheme(String theme) async {
    final data = {
      'theme': theme,
    };
    return await _client.post('/terminal/theme', data: data);
  }

  /// 获取终端字体
  /// 
  /// 获取可用的终端字体列表
  /// @return 字体列表
  Future<Response> getTerminalFonts() async {
    return await _client.get('/terminal/fonts');
  }

  /// 设置终端字体
  /// 
  /// 设置终端字体
  /// @param font 字体名称
  /// @param fontSize 字体大小（可选）
  /// @return 设置结果
  Future<Response> setTerminalFont({
    required String font,
    double? fontSize,
  }) async {
    final data = {
      'font': font,
      if (fontSize != null) 'fontSize': fontSize,
    };
    return await _client.post('/terminal/font', data: data);
  }
}