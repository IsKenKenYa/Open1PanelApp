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
}
