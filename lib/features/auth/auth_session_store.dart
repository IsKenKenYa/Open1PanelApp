import 'dart:io' as io;

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:onepanel_client/core/storage/platform_secure_storage.dart';

class AuthSession {
  const AuthSession({
    required this.token,
    this.username,
  });

  final String token;
  final String? username;
}

abstract class AuthSessionStore {
  Future<AuthSession?> readSession();
  Future<void> saveSession(AuthSession session);
  Future<void> clearSession();
}

class SecureAuthSessionStore implements AuthSessionStore {
  SecureAuthSessionStore({PlatformSecureStorage? storage})
      : _storage = storage;

  static const String tokenKey = 'auth_token';
  static const String usernameKey = 'auth_username';

  PlatformSecureStorage? _storage;

  Future<PlatformSecureStorage> _ensureStorage() async {
    _storage ??= await PlatformSecureStorage.create();
    return _storage!;
  }

  @override
  Future<AuthSession?> readSession() async {
    final storage = await _ensureStorage();
    final token = await storage.read(key: tokenKey);
    if (token == null || token.isEmpty) return null;

    return AuthSession(
      token: token,
      username: await storage.read(key: usernameKey),
    );
  }

  @override
  Future<void> saveSession(AuthSession session) async {
    final storage = await _ensureStorage();
    await storage.write(key: tokenKey, value: session.token);
    if (session.username == null || session.username!.isEmpty) {
      await storage.delete(key: usernameKey);
      return;
    }
    await storage.write(key: usernameKey, value: session.username);
  }

  @override
  Future<void> clearSession() async {
    final storage = await _ensureStorage();
    await storage.delete(key: tokenKey);
    await storage.delete(key: usernameKey);
  }
}
