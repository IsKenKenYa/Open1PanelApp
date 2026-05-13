import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:onepanel_client/core/platform/platform_capabilities.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/logger/logger_service.dart';

enum PlatformSecureStorageBackend {
  flutterSecureStorage,
  ohosMethodChannel,
  sharedPreferencesFallback,
}

class PlatformSecureStorage {
  PlatformSecureStorage._({
    required this.backend,
    FlutterSecureStorage? secureStorage,
    SharedPreferences? prefs,
    MethodChannel? ohosChannel,
  })  : _secureStorage = secureStorage,
        _prefsFallback = prefs,
        _ohosChannel = ohosChannel;

  static const String ohosChannelName = 'onepanel/secure_storage';
  static const String _prefsKeyPrefix = 'open1panel_secure_';

  final PlatformSecureStorageBackend backend;
  final FlutterSecureStorage? _secureStorage;
  final SharedPreferences? _prefsFallback;
  final MethodChannel? _ohosChannel;

  static Future<PlatformSecureStorage> create({
    PlatformCapabilitiesSnapshot? capabilities,
    FlutterSecureStorage? secureStorage,
    SharedPreferences? sharedPreferences,
    MethodChannel? ohosMethodChannel,
    bool probeSecureStorage = true,
  }) async {
    final resolvedCapabilities = capabilities ?? PlatformCapabilities.current();

    if (resolvedCapabilities.isOhos) {
      final ohosChannel =
          ohosMethodChannel ?? const MethodChannel(ohosChannelName);
      try {
        final healthy = await ohosChannel.invokeMethod<bool>('ping');
        if (healthy == true) {
          return PlatformSecureStorage._(
            backend: PlatformSecureStorageBackend.ohosMethodChannel,
            ohosChannel: ohosChannel,
          );
        }
      } catch (error, stackTrace) {
        appLogger.wWithPackage(
          'core.storage.platform_secure',
          'OHOS secure storage channel unavailable, falling back to SharedPreferences',
          error: error,
          stackTrace: stackTrace,
        );
      }

      return PlatformSecureStorage._(
        backend: PlatformSecureStorageBackend.sharedPreferencesFallback,
        prefs: sharedPreferences ?? await SharedPreferences.getInstance(),
      );
    }

    final candidate = secureStorage ??
        const FlutterSecureStorage(
          iOptions: IOSOptions(
            accessibility: KeychainAccessibility.first_unlock,
          ),
          lOptions: LinuxOptions(),
        );

    if (!probeSecureStorage) {
      return PlatformSecureStorage._(
        backend: PlatformSecureStorageBackend.flutterSecureStorage,
        secureStorage: candidate,
      );
    }

    try {
      await candidate.read(key: '__platform_probe__');
      return PlatformSecureStorage._(
        backend: PlatformSecureStorageBackend.flutterSecureStorage,
        secureStorage: candidate,
      );
    } on UnsupportedError catch (error, stackTrace) {
      appLogger.wWithPackage(
        'core.storage.platform_secure',
        'SecureStorage unsupported, falling back to SharedPreferences',
        error: error,
        stackTrace: stackTrace,
      );
    } on MissingPluginException catch (error, stackTrace) {
      appLogger.wWithPackage(
        'core.storage.platform_secure',
        'SecureStorage plugin missing, falling back to SharedPreferences',
        error: error,
        stackTrace: stackTrace,
      );
    } catch (error, stackTrace) {
      appLogger.wWithPackage(
        'core.storage.platform_secure',
        'SecureStorage probe failed, falling back to SharedPreferences',
        error: error,
        stackTrace: stackTrace,
      );
    }

    return PlatformSecureStorage._(
      backend: PlatformSecureStorageBackend.sharedPreferencesFallback,
      prefs: sharedPreferences ?? await SharedPreferences.getInstance(),
    );
  }

  Future<String?> read({required String key}) async {
    switch (backend) {
      case PlatformSecureStorageBackend.flutterSecureStorage:
        return _secureStorage!.read(key: key);
      case PlatformSecureStorageBackend.ohosMethodChannel:
        return _ohosChannel!.invokeMethod<String?>(
          'read',
          <String, Object?>{'key': key},
        );
      case PlatformSecureStorageBackend.sharedPreferencesFallback:
        return _prefsFallback!.getString(_prefixedKey(key));
    }
  }

  Future<void> write({required String key, required String? value}) async {
    switch (backend) {
      case PlatformSecureStorageBackend.flutterSecureStorage:
        if (value == null) {
          await _secureStorage!.delete(key: key);
        } else {
          await _secureStorage!.write(key: key, value: value);
        }
        return;
      case PlatformSecureStorageBackend.ohosMethodChannel:
        await _ohosChannel!.invokeMethod<void>(
          'write',
          <String, Object?>{'key': key, 'value': value},
        );
        return;
      case PlatformSecureStorageBackend.sharedPreferencesFallback:
        if (value == null) {
          await _prefsFallback!.remove(_prefixedKey(key));
        } else {
          await _prefsFallback!.setString(_prefixedKey(key), value);
        }
        return;
    }
  }

  Future<void> delete({required String key}) async {
    switch (backend) {
      case PlatformSecureStorageBackend.flutterSecureStorage:
        await _secureStorage!.delete(key: key);
        return;
      case PlatformSecureStorageBackend.ohosMethodChannel:
        await _ohosChannel!.invokeMethod<void>(
          'delete',
          <String, Object?>{'key': key},
        );
        return;
      case PlatformSecureStorageBackend.sharedPreferencesFallback:
        await _prefsFallback!.remove(_prefixedKey(key));
        return;
    }
  }

  Future<void> deleteAll() async {
    switch (backend) {
      case PlatformSecureStorageBackend.flutterSecureStorage:
        await _secureStorage!.deleteAll();
        return;
      case PlatformSecureStorageBackend.ohosMethodChannel:
        await _ohosChannel!.invokeMethod<void>('deleteAll');
        return;
      case PlatformSecureStorageBackend.sharedPreferencesFallback:
        final prefs = _prefsFallback!;
        final keys =
            prefs.getKeys().where((key) => key.startsWith(_prefsKeyPrefix));
        for (final key in keys) {
          await prefs.remove(key);
        }
        return;
    }
  }

  String _prefixedKey(String key) => '$_prefsKeyPrefix$key';
}
