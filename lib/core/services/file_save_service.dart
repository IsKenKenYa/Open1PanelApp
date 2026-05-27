import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:onepanel_client/core/platform/services/platform_file_service.dart';
import 'package:onepanel_client/core/services/logger/logger_service.dart';

class FileSaveResult {
  final String? filePath;
  final bool success;
  final String? errorMessage;

  const FileSaveResult({
    this.filePath,
    required this.success,
    this.errorMessage,
  });
}

class FileSaveService {
  static final FileSaveService _instance = FileSaveService._internal();
  factory FileSaveService() => _instance;
  FileSaveService._internal();

  PlatformFileService _platformFileService = PlatformFileService();

  @visibleForTesting
  void setPlatformFileServiceForTest(PlatformFileService service) {
    _platformFileService = service;
  }

  Future<FileSaveResult> saveFile({
    required String fileName,
    required Uint8List bytes,
    String? mimeType,
  }) async {
    appLogger.dWithPackage('file_save',
        'saveFile: fileName=$fileName, bytesLength=${bytes.length}');

    try {
      final result = await _platformFileService.saveBytes(
        fileName: fileName,
        bytes: bytes,
        mimeType: mimeType,
      );

      appLogger.iWithPackage('file_save', 'saveFile: 文件已保存到 $result');
      return FileSaveResult(
        success: true,
        filePath: result,
      );
    } catch (e, stackTrace) {
      appLogger.eWithPackage(
        'file_save',
        'saveFile: 保存失败',
        error: e,
        stackTrace: stackTrace,
      );
      return FileSaveResult(
        success: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> openFile(String filePath) async {
    appLogger.dWithPackage('file_save', 'openFile: filePath=$filePath');

    if (!await File(filePath).exists()) {
      throw Exception('文件不存在: $filePath');
    }

    await _platformFileService.openFile(filePath);
  }

  Future<void> openFileLocation(String filePath) async {
    appLogger.dWithPackage('file_save', 'openFileLocation: filePath=$filePath');

    final file = File(filePath);
    if (!await file.exists()) {
      throw Exception('文件不存在: $filePath');
    }

    await _platformFileService.openDirectory(file.parent.path);

    appLogger.iWithPackage(
        'file_save', 'openFileLocation: 已打开目录 ${file.parent.path}');
  }

  Future<bool> openDownloadsDirectory() async {
    return _platformFileService.openDownloadsDirectory();
  }

  Future<String?> getDownloadDirectoryPath() async {
    return _platformFileService.getDownloadDirectoryPath();
  }
}
