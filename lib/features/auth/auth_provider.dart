import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/v2/auth_v2.dart';
import '../../data/models/auth_models.dart';
import '../../core/network/api_client_manager.dart';

enum AuthStatus { initial, checking, authenticated, unauthenticated, mfaRequired }

class AuthProvider extends ChangeNotifier {
  AuthV2Api? _api;
  static const String _tokenKey = 'auth_token';
  static const String _usernameKey = 'auth_username';

  AuthStatus _status = AuthStatus.initial;
  String? _token;
  String? _username;
  String? _errorMessage;
  CaptchaData? _captcha;
  LoginSettings? _loginSettings;
  bool _isLoading = false;
  bool _isDemoMode = false;

  AuthStatus get status => _status;
  String? get token => _token;
  String? get username => _username;
  String? get errorMessage => _errorMessage;
  CaptchaData? get captcha => _captcha;
  LoginSettings? get loginSettings => _loginSettings;
  bool get isLoading => _isLoading;
  bool get isDemoMode => _isDemoMode;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isMfaRequired => _status == AuthStatus.mfaRequired;

  Future<AuthV2Api> _getApi() async {
    _api ??= await ApiClientManager.instance.getAuthApi();
    return _api!;
  }

  Future<void> checkAuthStatus() async {
    _status = AuthStatus.checking;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedToken = prefs.getString(_tokenKey);
      
      if (savedToken != null && savedToken.isNotEmpty) {
        _token = savedToken;
        _username = prefs.getString(_usernameKey);
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (e) {
      _status = AuthStatus.unauthenticated;
    }

    notifyListeners();
  }

  Future<void> loadLoginSettings() async {
    try {
      final api = await _getApi();
      final response = await api.getLoginSettings();
      final data = response.data;

      if (data != null) {
        _loginSettings = LoginSettings.fromJson(data);
      }
    } catch (e) {
      debugPrint('Failed to load login settings: $e');
    }

    notifyListeners();
  }

  Future<void> loadCaptcha() async {
    try {
      final api = await _getApi();
      final response = await api.getCaptcha();
      final data = response.data;

      if (data != null) {
        _captcha = CaptchaData(base64: data);
      }
    } catch (e) {
      debugPrint('Failed to load captcha: $e');
    }

    notifyListeners();
  }

  Future<void> checkDemoMode() async {
    try {
      final api = await _getApi();
      final response = await api.checkDemoMode();
      final data = response.data;

      if (data != null) {
        final demoStatus = DemoModeStatus.fromJson(data);
        _isDemoMode = demoStatus.isDemo ?? false;
      }
    } catch (e) {
      debugPrint('Failed to check demo mode: $e');
    }

    notifyListeners();
  }

  Future<bool> login({
    required String username,
    required String password,
    String? captcha,
    String? captchaId,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final api = await _getApi();
      final request = LoginRequest(
        username: username,
        password: password,
        captcha: captcha,
        captchaId: captchaId,
      ).toJson();

      final response = await api.login(request);
      final data = response.data;

      if (data != null) {
        final loginResponse = LoginResponse.fromJson(data);

        if (loginResponse.mfaStatus == true) {
          _username = username;
          _status = AuthStatus.mfaRequired;
          _isLoading = false;
          notifyListeners();
          return false;
        }

        if (loginResponse.token != null) {
          _token = loginResponse.token;
          _username = username;
          
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_tokenKey, _token!);
          await prefs.setString(_usernameKey, username);
          
          _status = AuthStatus.authenticated;
          _isLoading = false;
          notifyListeners();
          return true;
        }
      }

      _errorMessage = 'Login failed: Invalid response';
      _status = AuthStatus.unauthenticated;
    } catch (e) {
      _errorMessage = e.toString();
      _status = AuthStatus.unauthenticated;
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> mfaLogin(String code) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final api = await _getApi();
      final request = MfaLoginRequest(
        code: code,
        name: _username,
      ).toJson();

      final response = await api.mfaLogin(request);
      final data = response.data;

      if (data != null) {
        final loginResponse = LoginResponse.fromJson(data);

        if (loginResponse.token != null) {
          _token = loginResponse.token;
          
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_tokenKey, _token!);
          
          _status = AuthStatus.authenticated;
          _isLoading = false;
          notifyListeners();
          return true;
        }
      }

      _errorMessage = 'MFA verification failed';
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      final api = await _getApi();
      await api.logout();
    } catch (e) {
      debugPrint('Logout API call failed: $e');
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_usernameKey);
    
    _token = null;
    _username = null;
    _status = AuthStatus.unauthenticated;
    _isLoading = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void resetMfaState() {
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}
