import 'dart:io';
import 'dart:typed_data';

import 'package:android_intent_plus/android_intent.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'package:onepanel_client/core/platform/platform_capabilities.dart';
import 'package:onepanel_client/core/platform/services/ohos_platform_channel.dart';
import 'package:onepanel_client/core/services/logger/logger_service.dart';

typedef DirectoryResolver = Future<Directory> Function();

class PlatformFileService {
  PlatformFileService({
    PlatformCapabilitiesSnapshot? capabilities,
    OhosPlatformChannel? ohosChannel,
    DirectoryResolver? fallbackDirectoryResolver,
  })  : _capabilities = capabilities ?? PlatformCapabilities.current(),
        _ohosChannel = ohosChannel ?? const OhosPlatformChannel(),
        _fallbackDirectoryResolver = fallbackDirectoryResolver;

  final PlatformCapabilitiesSnapshot _capabilities;
  final OhosPlatformChannel _ohosChannel;
  final DirectoryResolver? _fallbackDirectoryResolver;

  Future<String?> pickFile({bool withData = false}) async {
    final result = await FilePicker.platform.pickFiles(withData: withData);
    return result?.files.single.path;
  }

  Future<String> saveBytes({
    required String fileName,
    required Uint8List bytes,
    String? mimeType,
  }) async {
    final safeFileName = _sanitizeFileName(fileName);

    if (_capabilities.supportsNativeFileSave) {
      try {
        final nativePath = await _ohosChannel.saveBytes(
          fileName: safeFileName,
          bytes: bytes,
          mimeType: mimeType,
        );
        if (nativePath != null && nativePath.isNotEmpty) {
          return nativePath;
        }
      } catch (error, stackTrace) {
        appLogger.wWithPackage(
          'core.platform.file_service',
          'OHOS native save failed, falling back to app documents directory',
          error: error,
          stackTrace: stackTrace,
        );
      }

      return _saveToFallbackDirectory(
        fileName: safeFileName,
        bytes: bytes,
      );
    }

    try {
      final result = await FilePicker.platform.saveFile(
        dialogTitle: '保存文件',
        fileName: safeFileName,
        bytes: bytes,
      );
      if (result != null && result.isNotEmpty) {
        return result;
      }
      throw const FileSystemException('用户取消保存');
    } catch (error, stackTrace) {
      appLogger.wWithPackage(
        'core.platform.file_service',
        'FilePicker save failed, falling back to default directory',
        error: error,
        stackTrace: stackTrace,
      );
      return _saveToFallbackDirectory(
        fileName: safeFileName,
        bytes: bytes,
      );
    }
  }

  Future<void> openFile(String filePath) async {
    if (!await File(filePath).exists()) {
      throw FileSystemException('文件不存在', filePath);
    }

    if (_capabilities.isOhos) {
      final opened = await _tryOpenOhosPath(filePath);
      if (opened) {
        return;
      }
    }

    if (Platform.isMacOS) {
      await Process.run('open', <String>[filePath]);
      return;
    }
    if (Platform.isWindows) {
      await Process.run('cmd', <String>['/c', 'start', '', filePath],
          runInShell: true);
      return;
    }
    if (Platform.isLinux) {
      await Process.run('xdg-open', <String>[filePath]);
      return;
    }
    if (Platform.isAndroid || Platform.isIOS) {
      appLogger.wWithPackage(
        'core.platform.file_service',
        '当前平台不支持直接打开文件，将打开文件所在目录',
      );
      await _openDirectoryWithHost(filePath);
      return;
    }

    throw UnsupportedError('当前平台不支持打开文件');
  }

  Future<void> openDirectory(String path) async {
    final directory = Directory(path);
    if (!await directory.exists()) {
      throw FileSystemException('目录不存在', path);
    }

    if (_capabilities.isOhos) {
      final opened = await _tryOpenOhosDirectory(path);
      if (opened) {
        return;
      }
    }

    await _openDirectoryPathWithHost(path);
  }

  Future<String?> getDownloadDirectoryPath() async {
    try {
      if (_capabilities.supportsAndroidIntent) {
        final dir = Directory('/storage/emulated/0/Download');
        if (await dir.exists()) {
          return dir.path;
        }
        final extDir = await getExternalStorageDirectory();
        return extDir?.path ?? (await _getFallbackDownloadDir()).path;
      }

      return (await _getFallbackDownloadDir()).path;
    } catch (error, stackTrace) {
      appLogger.eWithPackage(
        'core.platform.file_service',
        'getDownloadDirectoryPath failed',
        error: error,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  Future<bool> openDownloadsDirectory() async {
    if (_capabilities.supportsAndroidIntent) {
      const data =
          'content://com.android.externalstorage.documents/document/primary%3ADownload';
      try {
        final intent = const AndroidIntent(
          action: 'android.intent.action.VIEW',
          data: data,
          type: 'vnd.android.document/directory',
          flags: <int>[268435456],
        );
        await intent.launch();
        return true;
      } catch (error, stackTrace) {
        appLogger.wWithPackage(
          'core.platform.file_service',
          'Android open downloads directory failed',
          error: error,
          stackTrace: stackTrace,
        );
        return false;
      }
    }

    final path = await getDownloadDirectoryPath();
    if (path == null) {
      return false;
    }
    try {
      await openDirectory(path);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<String> _saveToFallbackDirectory({
    required String fileName,
    required Uint8List bytes,
  }) async {
    final directory = await _getFallbackDownloadDir();
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    final filePath = await _getUniqueFilePath(directory.path, fileName);
    final file = await File(filePath).create(recursive: true);
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }

  Future<Directory> _getFallbackDownloadDir() async {
    if (_fallbackDirectoryResolver != null) {
      return _fallbackDirectoryResolver();
    }
    if (_capabilities.isOhos || Platform.isAndroid || Platform.isIOS) {
      final documents = await getApplicationDocumentsDirectory();
      return Directory('${documents.path}/exports');
    }
    return await getDownloadsDirectory() ??
        await getApplicationDocumentsDirectory();
  }

  Future<String> _getUniqueFilePath(String directory, String fileName) async {
    final filePath = '$directory/$fileName';

    if (!await File(filePath).exists()) {
      return filePath;
    }

    final lastDot = fileName.lastIndexOf('.');
    final baseName = lastDot > 0 ? fileName.substring(0, lastDot) : fileName;
    final extension = lastDot > 0 ? fileName.substring(lastDot) : '';

    const maxAttempts = 9999;
    var counter = 1;
    while (counter <= maxAttempts) {
      final newPath = '$directory/${baseName}_$counter$extension';
      if (!await File(newPath).exists()) {
        return newPath;
      }
      counter++;
    }
    throw FileSystemException(
      '无法生成唯一文件名，已尝试 $maxAttempts 次',
      '$directory/$fileName',
    );
  }

  String _sanitizeFileName(String fileName) {
    return fileName.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_');
  }

  Future<bool> _tryOpenOhosPath(String path) async {
    try {
      return _ohosChannel.openPath(path);
    } catch (error, stackTrace) {
      appLogger.wWithPackage(
        'core.platform.file_service',
        'OHOS openPath failed',
        error: error,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  Future<bool> _tryOpenOhosDirectory(String path) async {
    try {
      return _ohosChannel.openDirectory(path);
    } catch (error, stackTrace) {
      appLogger.wWithPackage(
        'core.platform.file_service',
        'OHOS openDirectory failed',
        error: error,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  Future<void> _openDirectoryWithHost(String filePath) async {
    await _openDirectoryPathWithHost(File(filePath).parent.path);
  }

  Future<void> _openDirectoryPathWithHost(String directoryPath) async {
    if (Platform.isMacOS) {
      await Process.run('open', <String>[directoryPath]);
      return;
    }
    if (Platform.isWindows) {
      await Process.run('explorer', <String>[directoryPath]);
      return;
    }
    if (Platform.isLinux) {
      await Process.run('xdg-open', <String>[directoryPath]);
      return;
    }
    throw UnsupportedError('当前平台不支持打开文件所在目录');
  }
}
