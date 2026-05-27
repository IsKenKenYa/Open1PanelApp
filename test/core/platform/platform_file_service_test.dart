import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onepanel_client/core/platform/platform_capabilities.dart';
import 'package:onepanel_client/core/platform/services/ohos_platform_channel.dart';
import 'package:onepanel_client/core/platform/services/platform_file_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PlatformFileService', () {
    const channel = MethodChannel(OhosPlatformChannel.channelName);

    tearDown(() async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    test('uses OHOS native save channel before falling back', () async {
      final calls = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
        calls.add(call);
        if (call.method == 'saveBytes') {
          return '/data/storage/el2/base/files/exports/logs.txt';
        }
        return null;
      });

      final service = PlatformFileService(
        capabilities: PlatformCapabilities.resolveForTest(
          isWeb: false,
          targetPlatform: TargetPlatform.android,
          operatingSystem: 'ohos',
        ),
        ohosChannel: const OhosPlatformChannel(channel: channel),
      );

      final path = await service.saveBytes(
        fileName: 'logs.txt',
        bytes: Uint8List.fromList(<int>[1, 2, 3]),
        mimeType: 'text/plain',
      );

      expect(path, '/data/storage/el2/base/files/exports/logs.txt');
      expect(calls.single.method, 'saveBytes');
      expect(calls.single.arguments['fileName'], 'logs.txt');
    });

    test('falls back to app export directory when OHOS save channel fails',
        () async {
      final tempDir = await Directory.systemTemp.createTemp(
        'onepanel_platform_file_service_test_',
      );
      addTearDown(() async {
        if (await tempDir.exists()) {
          await tempDir.delete(recursive: true);
        }
      });

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
        throw PlatformException(code: 'native_save_failed');
      });

      final service = PlatformFileService(
        capabilities: PlatformCapabilities.resolveForTest(
          isWeb: false,
          targetPlatform: TargetPlatform.android,
          operatingSystem: 'ohos',
        ),
        ohosChannel: const OhosPlatformChannel(channel: channel),
        fallbackDirectoryResolver: () async => tempDir,
      );

      final path = await service.saveBytes(
        fileName: 'a/b:logs.txt',
        bytes: Uint8List.fromList(<int>[4, 5, 6]),
      );

      expect(path, endsWith('a_b_logs.txt'));
      expect(await File(path).readAsBytes(), <int>[4, 5, 6]);
    });
  });
}
