import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onepanel_client/core/platform/platform_capabilities.dart';
import 'package:onepanel_client/core/storage/platform_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PlatformSecureStorage', () {
    const channel = MethodChannel(PlatformSecureStorage.ohosChannelName);

    tearDown(() async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
      SharedPreferences.setMockInitialValues(<String, Object>{});
    });

    test('uses OHOS method channel backend when native channel is healthy',
        () async {
      final values = <String, String>{};
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
        switch (call.method) {
          case 'ping':
            return true;
          case 'write':
            values[call.arguments['key'] as String] =
                call.arguments['value'] as String;
            return true;
          case 'read':
            return values[call.arguments['key'] as String];
          case 'delete':
            values.remove(call.arguments['key'] as String);
            return true;
          case 'deleteAll':
            values.clear();
            return true;
          default:
            return null;
        }
      });

      final storage = await PlatformSecureStorage.create(
        capabilities: PlatformCapabilities.resolveForTest(
          isWeb: false,
          targetPlatform: TargetPlatform.android,
          operatingSystem: 'ohos',
        ),
        ohosMethodChannel: channel,
      );

      expect(storage.backend, PlatformSecureStorageBackend.ohosMethodChannel);

      await storage.write(key: 'token', value: 'secret');
      expect(await storage.read(key: 'token'), 'secret');

      await storage.delete(key: 'token');
      expect(await storage.read(key: 'token'), isNull);
    });

    test('falls back to SharedPreferences when OHOS secure channel fails',
        () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final prefs = await SharedPreferences.getInstance();

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
        throw PlatformException(code: 'unavailable');
      });

      final storage = await PlatformSecureStorage.create(
        capabilities: PlatformCapabilities.resolveForTest(
          isWeb: false,
          targetPlatform: TargetPlatform.android,
          operatingSystem: 'HarmonyOS',
        ),
        sharedPreferences: prefs,
        ohosMethodChannel: channel,
      );

      expect(
        storage.backend,
        PlatformSecureStorageBackend.sharedPreferencesFallback,
      );

      await storage.write(key: 'token', value: 'fallback-secret');
      expect(await storage.read(key: 'token'), 'fallback-secret');
    });
  });
}
