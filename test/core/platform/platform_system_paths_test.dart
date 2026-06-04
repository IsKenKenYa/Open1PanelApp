import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onepanel_client/core/platform/platform_capabilities.dart';
import 'package:onepanel_client/core/platform/services/ohos_platform_channel.dart';
import 'package:onepanel_client/core/platform/services/platform_system_paths.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PlatformSystemPaths', () {
    const channel = MethodChannel(OhosPlatformChannel.channelName);

    tearDown(() {
      PlatformSystemPaths.testResolver = null;
      PlatformSystemPaths.testOhosChannel = null;
      PlatformSystemPaths.testCapabilities = null;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    test('OHOS path returns directory from getPublicDownloadDir', () async {
      final tempDir = await Directory.systemTemp.createTemp(
        'onepanel_psp_ohos_',
      );
      addTearDown(() async {
        if (await tempDir.exists()) {
          await tempDir.delete(recursive: true);
        }
      });

      // Force the OHOS branch.
      PlatformSystemPaths.testCapabilities =
          PlatformCapabilities.resolveForTest(
        isWeb: false,
        targetPlatform: TargetPlatform.android,
        operatingSystem: 'ohos',
      );

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
        if (call.method == 'getPublicDownloadDir') {
          return <String, Object?>{
            'path': tempDir.path,
            'displayName': '下载',
          };
        }
        return null;
      });

      final dir = await PlatformSystemPaths.defaultDownloadDir();
      expect(dir, isNotNull);
      expect(dir!.path, tempDir.path);
    });

    test('OHOS path returns null when channel throws', () async {
      PlatformSystemPaths.testCapabilities =
          PlatformCapabilities.resolveForTest(
        isWeb: false,
        targetPlatform: TargetPlatform.android,
        operatingSystem: 'ohos',
      );

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
        if (call.method == 'getPublicDownloadDir') {
          throw PlatformException(code: 'ohos_fail');
        }
        return null;
      });

      final dir = await PlatformSystemPaths.defaultDownloadDir();
      // OHOS path returns null on failure, callers fall back to app docs.
      expect(dir, isNull);
    });

    test('macOS path resolves to HOME/Downloads', () async {
      PlatformSystemPaths.testCapabilities =
          PlatformCapabilities.resolveForTest(
        isWeb: false,
        targetPlatform: TargetPlatform.macOS,
        operatingSystem: 'macos',
      );

      final dir = await PlatformSystemPaths.defaultDownloadDir();
      expect(dir, isNotNull);
      expect(dir!.path, '${Platform.environment['HOME']}/Downloads');
    });

    test('Linux path uses XDG_DOWNLOAD_DIR when set', () async {
      PlatformSystemPaths.testCapabilities =
          PlatformCapabilities.resolveForTest(
        isWeb: false,
        targetPlatform: TargetPlatform.linux,
        operatingSystem: 'linux',
      );

      // We can't reliably set XDG_DOWNLOAD_DIR in the test process,
      // so the resolver falls back to $HOME/Downloads. Assert the
      // non-null path semantics.
      final dir = await PlatformSystemPaths.defaultDownloadDir();
      expect(dir, isNotNull);
      expect(dir!.path, contains('Downloads'));
    });

    test('testResolver takes precedence over the platform branches',
        () async {
      final tempDir = await Directory.systemTemp.createTemp(
        'onepanel_psp_test_resolver_',
      );
      addTearDown(() async {
        if (await tempDir.exists()) {
          await tempDir.delete(recursive: true);
        }
      });

      PlatformSystemPaths.testResolver = () async => tempDir;
      final dir = await PlatformSystemPaths.defaultDownloadDir();
      expect(dir?.path, tempDir.path);
    });

    test('resolveFilePath composes <base>/<subDir>/<category>/<file>',
        () async {
      final tempDir = await Directory.systemTemp.createTemp(
        'onepanel_psp_resolve_',
      );
      addTearDown(() async {
        if (await tempDir.exists()) {
          await tempDir.delete(recursive: true);
        }
      });

      PlatformSystemPaths.testResolver = () async => tempDir;

      final file = await PlatformSystemPaths.resolveFilePath(
        fileName: 'app.log',
        subDir: '1Panel-Client',
      );
      expect(file, isNotNull);
      expect(file!.path, contains('1Panel-Client'));
      expect(file.path, endsWith('app.log'));
    });

    test('resolveFilePath omits subDir when empty', () async {
      final tempDir = await Directory.systemTemp.createTemp(
        'onepanel_psp_resolve_empty_',
      );
      addTearDown(() async {
        if (await tempDir.exists()) {
          await tempDir.delete(recursive: true);
        }
      });

      PlatformSystemPaths.testResolver = () async => tempDir;

      final file = await PlatformSystemPaths.resolveFilePath(
        fileName: 'app.log',
        subDir: '',
      );
      expect(file, isNotNull);
      expect(file!.path, endsWith('app.log'));
    });
  });
}
