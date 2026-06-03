import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:onepanel_client/core/platform/services/ohos_platform_channel.dart';
import 'package:onepanel_client/core/platform/services/platform_file_service.dart';
import 'package:onepanel_client/core/services/logger/logger_service.dart';

class FileSaveResult {
  final String? filePath;
  final bool success;
  final String? errorMessage;
  // Mirrors SaveOutcome fields so callers can render the saved location
  // without poking into platform-specific URIs themselves.
  final String? displayName;
  final SaveLocationKind kind;
  final String? category;
  // True when the user dismissed the picker (different from a real error).
  final bool wasCancelled;
  // True when the native picker failed and the service silently fell
  // back to the app's private directory. UI is expected to warn.
  final bool privateFallbackUsed;

  const FileSaveResult({
    this.filePath,
    required this.success,
    this.errorMessage,
    this.displayName,
    this.kind = SaveLocationKind.other,
    this.category,
    this.wasCancelled = false,
    this.privateFallbackUsed = false,
  });

  factory FileSaveResult.fromOutcome(SaveOutcome outcome) {
    return FileSaveResult(
      filePath: outcome.uri,
      success: true,
      displayName: outcome.displayName,
      kind: outcome.kind,
      category: outcome.category,
      wasCancelled: outcome.isCancelled,
      privateFallbackUsed: outcome.privateFallbackUsed,
    );
  }
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
    String? category,
  }) async {
    appLogger.dWithPackage('file_save',
        'saveFile: fileName=$fileName, bytesLength=${bytes.length}');

    try {
      final outcome = await _platformFileService.saveBytesStructured(
        fileName: fileName,
        bytes: bytes,
        mimeType: mimeType,
        category: category,
      );

      if (outcome.isCancelled) {
        appLogger.iWithPackage('file_save', 'saveFile: user cancelled');
        return const FileSaveResult(
          success: false,
          wasCancelled: true,
        );
      }

      appLogger.iWithPackage(
        'file_save',
        'saveFile: 文件已保存到 ${outcome.uri} (kind=${outcome.kind})',
      );
      return FileSaveResult.fromOutcome(outcome);
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

  /// Open a [FileSaveResult] through the most appropriate native opener.
  /// Routes content:// URIs to the OHOS picker-aware openUri path and
  /// filesystem paths to the standard file open flow.
  Future<bool> openSaveResult(FileSaveResult result) async {
    if (!result.success || result.filePath == null || result.filePath!.isEmpty) {
      return false;
    }
    // We re-derive a SaveOutcome from FileSaveResult fields. The mapping
    // is loss-free: the display name and kind are preserved on the result.
    final outcome = SaveOutcome(
      uri: result.filePath!,
      displayName: result.displayName ?? '',
      kind: result.kind,
      category: result.category,
      privateFallbackUsed: result.privateFallbackUsed,
    );
    return _platformFileService.openSaveOutcome(outcome);
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
