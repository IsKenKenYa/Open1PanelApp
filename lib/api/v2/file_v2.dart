/// 1Panel V2 API - File 相关接口
/// 
/// 此文件包含与文件管理相关的所有API接口，
/// 包括文件的上传、下载、删除、编辑、查询等操作。

import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../models/file_models.dart';

class FileV2Api {
  final ApiClient _client;

  FileV2Api(this._client);

  /// 获取文件列表
  /// 
  /// 获取指定目录下的文件列表
  /// @param path 目录路径
  /// @param search 搜索关键词（可选）
  /// @param page 页码（可选，默认为1）
  /// @param pageSize 每页数量（可选，默认为10）
  /// @return 文件列表
  Future<Response> getFiles(String path, {
    String? search,
    int page = 1,
    int pageSize = 10,
  }) async {
    final data = {
      'path': path,
      'page': page,
      'pageSize': pageSize,
      if (search != null) 'search': search,
    };
    return await _client.post('/files', data: data);
  }

  /// 创建目录
  /// 
  /// 创建一个新的目录
  /// @param path 目录路径
  /// @return 创建结果
  Future<Response> createDirectory(String path) async {
    final data = {
      'path': path,
    };
    return await _client.post('/files/directory', data: data);
  }

  /// 删除文件或目录
  /// 
  /// 删除指定的文件或目录
  /// @param paths 文件或目录路径列表
  /// @param force 是否强制删除
  /// @return 删除结果
  Future<Response> deleteFiles(List<String> paths, {bool force = false}) async {
    final data = {
      'paths': paths,
      'force': force,
    };
    return await _client.post('/files/del', data: data);
  }

  /// 重命名文件或目录
  /// 
  /// 重命名指定的文件或目录
  /// @param oldPath 原路径
  /// @param newPath 新路径
  /// @return 重命名结果
  Future<Response> renameFile(String oldPath, String newPath) async {
    final data = {
      'oldPath': oldPath,
      'newPath': newPath,
    };
    return await _client.post('/files/rename', data: data);
  }

  /// 移动文件或目录
  /// 
  /// 移动指定的文件或目录
  /// @param paths 要移动的文件或目录路径列表
  /// @param targetPath 目标路径
  /// @return 移动结果
  Future<Response> moveFiles(List<String> paths, String targetPath) async {
    final data = {
      'paths': paths,
      'targetPath': targetPath,
    };
    return await _client.post('/files/move', data: data);
  }

  /// 复制文件或目录
  /// 
  /// 复制指定的文件或目录
  /// @param paths 要复制的文件或目录路径列表
  /// @param targetPath 目标路径
  /// @return 复制结果
  Future<Response> copyFiles(List<String> paths, String targetPath) async {
    final data = {
      'paths': paths,
      'targetPath': targetPath,
    };
    return await _client.post('/files/copy', data: data);
  }

  /// 上传文件
  /// 
  /// 上传文件到指定目录
  /// @param path 目标目录路径
  /// @param file 文件对象
  /// @return 上传结果
  Future<Response> uploadFile(String path, dynamic file) async {
    final formData = FormData.fromMap({
      'path': path,
      'file': file,
    });
    return await _client.post('/files/upload', data: formData);
  }

  /// 下载文件
  /// 
  /// 下载指定的文件
  /// @param path 文件路径
  /// @return 文件内容
  Future<Response> downloadFile(String path) async {
    final data = {
      'path': path,
    };
    return await _client.post('/files/download', data: data);
  }

  /// 获取文件内容
  /// 
  /// 获取指定文件的内容
  /// @param path 文件路径
  /// @return 文件内容
  Future<Response> getFileContent(String path) async {
    final data = {
      'path': path,
    };
    return await _client.post('/files/content', data: data);
  }

  /// 更新文件内容
  /// 
  /// 更新指定文件的内容
  /// @param path 文件路径
  /// @param content 文件内容
  /// @return 更新结果
  Future<Response> updateFileContent(String path, String content) async {
    final data = {
      'path': path,
      'content': content,
    };
    return await _client.post('/files/content/update', data: data);
  }

  /// 压缩文件或目录
  /// 
  /// 压缩指定的文件或目录
  /// @param paths 要压缩的文件或目录路径列表
  /// @param targetPath 目标压缩文件路径
  /// @param type 压缩类型（zip, tar, tar.gz）
  /// @return 压缩结果
  Future<Response> compressFiles(List<String> paths, String targetPath, String type) async {
    final data = {
      'paths': paths,
      'targetPath': targetPath,
      'type': type,
    };
    return await _client.post('/files/compress', data: data);
  }

  /// 解压文件
  /// 
  /// 解压指定的压缩文件
  /// @param path 压缩文件路径
  /// @param targetPath 目标目录路径
  /// @return 解压结果
  Future<Response> extractFile(String path, String targetPath) async {
    final data = {
      'path': path,
      'targetPath': targetPath,
    };
    return await _client.post('/files/extract', data: data);
  }

  /// 获取文件权限
  /// 
  /// 获取指定文件的权限信息
  /// @param path 文件路径
  /// @return 文件权限
  Future<Response> getFilePermission(String path) async {
    final data = {
      'path': path,
    };
    return await _client.post('/files/permission', data: data);
  }

  /// 更新文件权限
  /// 
  /// 更新指定文件的权限
  /// @param path 文件路径
  /// @param permission 权限信息
  /// @return 更新结果
  Future<Response> updateFilePermission(String path, Map<String, dynamic> permission) async {
    final data = {
      'path': path,
      'permission': permission,
    };
    return await _client.post('/files/permission/update', data: data);
  }
}