import 'package:flutter/services.dart';

class OhosPlatformChannel {
  const OhosPlatformChannel({
    MethodChannel channel = const MethodChannel(channelName),
  }) : _channel = channel;

  static const String channelName = 'onepanel/ohos_platform';

  final MethodChannel _channel;

  Future<Map<String, Object?>> getRuntimeInfo() async {
    final raw = await _channel.invokeMapMethod<String, Object?>(
      'getRuntimeInfo',
    );
    return raw ?? const <String, Object?>{};
  }

  Future<String?> saveBytes({
    required String fileName,
    required Uint8List bytes,
    String? mimeType,
  }) {
    return _channel.invokeMethod<String>(
      'saveBytes',
      <String, Object?>{
        'fileName': fileName,
        'bytes': bytes,
        'mimeType': mimeType,
      },
    );
  }

  Future<bool> openPath(String path) async {
    final opened = await _channel.invokeMethod<bool>(
      'openPath',
      <String, Object?>{'path': path},
    );
    return opened == true;
  }

  Future<bool> openDirectory(String path) async {
    final opened = await _channel.invokeMethod<bool>(
      'openDirectory',
      <String, Object?>{'path': path},
    );
    return opened == true;
  }

  Future<String?> pickSaveDirectory() {
    return _channel.invokeMethod<String>('pickSaveDirectory');
  }

  Future<String?> pickAndSaveBytes({
    required String fileName,
    required Uint8List bytes,
    String? mimeType,
  }) {
    return _channel.invokeMethod<String>(
      'pickAndSaveBytes',
      <String, Object?>{
        'fileName': fileName,
        'bytes': bytes,
        'mimeType': mimeType,
      },
    );
  }

  Future<String?> saveBytesToDownload({
    required String fileName,
    required Uint8List bytes,
  }) {
    return _channel.invokeMethod<String>(
      'saveBytesToDownload',
      <String, Object?>{
        'fileName': fileName,
        'bytes': bytes,
      },
    );
  }

  static const MethodChannel _downloadChannel =
      MethodChannel('onepanel/ohos_download');

  Future<String?> downloadFile({
    required String url,
    required String savedDir,
    String? fileName,
    Map<String, String>? headers,
  }) {
    return _downloadChannel.invokeMethod<String>(
      'enqueue',
      <String, Object?>{
        'url': url,
        'savedDir': savedDir,
        'fileName': fileName,
        'headers': headers ?? <String, String>{},
      },
    );
  }

  Future<void> pauseDownload(String taskId) async {
    await _downloadChannel.invokeMethod<void>('pause', <String, Object?>{
      'taskId': taskId,
    });
  }

  Future<void> resumeDownload(String taskId) async {
    await _downloadChannel.invokeMethod<void>('resume', <String, Object?>{
      'taskId': taskId,
    });
  }

  Future<void> cancelDownload(String taskId) async {
    await _downloadChannel.invokeMethod<void>('cancel', <String, Object?>{
      'taskId': taskId,
    });
  }
}
