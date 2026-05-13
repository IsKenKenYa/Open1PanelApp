import 'dart:io' as io;

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/logger/logger_service.dart';

/// 平台感知的安全存储适配器
/// 
/// - OHOS: 使用 SharedPreferences（沙箱保证安全性）
/// - 其他平台: 使用 flutter_secure_storage
class PlatformSecureStorage {
  final FlutterSecureStorage? _secureStorage;
  final SharedPreferences? _prefsFallback;
  final bool _usePrefs;

  static Future<PlatformSecureStorage> create() async {
    final usePrefs = _shouldUsePrefsFallback();
    
    FlutterSecureStorage? secureStorage;
    SharedPreferences? prefs;
    
    if (!usePrefs) {
      try {
        secureStorage = const FlutterSecureStorage(
          aOptions: AndroidOptions(
            encryptedSharedPreferences: true,
          ),
          iOptions: IOSOptions(
            accessibility: KeychainAccessibility.first_unlock,
          ),
          lOptions: LinuxOptions(),
        );
        // 尝试调用一次，确认是否支持
        await secureStorage.read(key: '__test__');
      } on UnsupportedError catch (e, s) {
        appLogger.eWithPackage('core.storage.platform_secure', 'SecureStorage not supported, falling back to SharedPreferences', error: e, stackTrace: s);
      }
    }
    
    if (usePrefs || secureStorage == null) {
      prefs = await SharedPreferences.getInstance();
    }
    
    return PlatformSecureStorage._(
      secureStorage: usePrefs ? null : secureStorage,
      prefs: prefs,
      usePrefs: usePrefs || secureStorage == null,
    );
  }

  PlatformSecureStorage._({
    required FlutterSecureStorage? secureStorage,
    required SharedPreferences? prefs,
    required bool usePrefs,
  }) : _secureStorage = secureStorage,
       _prefsFallback = prefs,
       _usePrefs = usePrefs;

  /// 判断当前平台是否应该使用 SharedPreferences 替代 FlutterSecureStorage
  static bool _shouldUsePrefsFallback() {
    if (kIsWeb) return false;
    
    // OHOS 检测
    // OHOS Flutter 可能识别为 Android 或自定义平台
    if (io.Platform.isAndroid) {
      try {
        // 尝试检测 OHOS 操作系统
        final os = io.Platform.operatingSystem;
        if (os.toLowerCase().contains('ohos') || os.toLowerCase().contains('harmony')) {
          return true;
        }
      } catch (_) {
        // ignore
      }
    }
    
    // 桌面端：macOS/Windows/Linux
    if (io.Platform.isMacOS || io.Platform.isWindows || io.Platform.isLinux) {
      return true;
    }
    
    return false;
  }

  Future<String?> read({required String key}) async {
    if (_usePrefs) {
      return _prefsFallback!.getString(_prefixKey(key));
    }
    return _secureStorage!.read(key: key);
  }

  Future<void> write({required String key, required String? value}) async {
    if (_usePrefs) {
      if (value == null) {
        await _prefsFallback!.remove(_prefixKey(key));
      } else {
        await _prefsFallback!.setString(_prefixKey(key), value);
      }
      return;
    }
    if (value == null) {
      await _secureStorage!.delete(key: key);
    } else {
      await _secureStorage!.write(key: key, value: value);
    }
  }

  Future<void> delete({required String key}) async {
    if (_usePrefs) {
      await _prefsFallback!.remove(_prefixKey(key));
      return;
    }
    await _secureStorage!.delete(key: key);
  }

  Future<void> deleteAll() async {
    if (_usePrefs) {
      final keys = _prefsFallback!.getKeys().where((k) => k.startsWith(_keyPrefix));
      for (final key in keys) {
        await _prefsFallback!.remove(key);
      }
      return;
    }
    await _secureStorage!.deleteAll();
  }

  static const String _keyPrefix = 'open1panel_secure_';

  String _prefixKey(String key) => '$_keyPrefix$key';
}