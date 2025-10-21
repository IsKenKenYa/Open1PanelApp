/// 1Panel V2 API - Setting 相关接口
/// 
/// 此文件包含与系统设置相关的所有API接口，
/// 包括系统配置、用户设置、安全设置等操作。

import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../models/setting_models.dart';

class SettingV2Api {
  final ApiClient _client;

  SettingV2Api(this._client);

  /// 获取系统设置
  /// 
  /// 获取系统设置信息
  /// @return 系统设置
  Future<Response> getSystemSettings() async {
    return await _client.get('/settings');
  }

  /// 更新系统设置
  /// 
  /// 更新系统设置
  /// @param settings 设置信息
  /// @return 更新结果
  Future<Response> updateSystemSettings(Map<String, dynamic> settings) async {
    return await _client.post('/settings', data: settings);
  }

  /// 获取系统信息
  /// 
  /// 获取系统基本信息
  /// @return 系统信息
  Future<Response> getSystemInfo() async {
    return await _client.get('/dashboard/base/os');
  }

  /// 获取系统时间
  /// 
  /// 获取系统时间
  /// @return 系统时间
  Future<Response> getSystemTime() async {
    return await _client.get('/settings/time');
  }

  /// 更新系统时间
  /// 
  /// 更新系统时间
  /// @param time 时间
  /// @param timezone 时区（可选）
  /// @return 更新结果
  Future<Response> updateSystemTime(String time, {String? timezone}) async {
    final data = {
      'time': time,
      if (timezone != null) 'timezone': timezone,
    };
    return await _client.post('/settings/time', data: data);
  }

  /// 同步系统时间
  /// 
  /// 同步系统时间
  /// @param ntpServer NTP服务器（可选）
  /// @return 同步结果
  Future<Response> syncSystemTime({String? ntpServer}) async {
    final data = {
      if (ntpServer != null) 'ntpServer': ntpServer,
    };
    return await _client.post('/settings/time/sync', data: data);
  }

  /// 获取安全设置
  /// 
  /// 获取安全设置信息
  /// @return 安全设置
  Future<Response> getSecuritySettings() async {
    return await _client.get('/settings/security');
  }

  /// 更新安全设置
  /// 
  /// 更新安全设置
  /// @param settings 安全设置
  /// @return 更新结果
  Future<Response> updateSecuritySettings(Map<String, dynamic> settings) async {
    return await _client.post('/settings/security', data: settings);
  }

  /// 获取面板设置
  /// 
  /// 获取面板设置信息
  /// @return 面板设置
  Future<Response> getPanelSettings() async {
    return await _client.get('/settings/panel');
  }

  /// 更新面板设置
  /// 
  /// 更新面板设置
  /// @param settings 面板设置
  /// @return 更新结果
  Future<Response> updatePanelSettings(Map<String, dynamic> settings) async {
    return await _client.post('/settings/panel', data: settings);
  }

  /// 获取用户设置
  /// 
  /// 获取用户设置信息
  /// @return 用户设置
  Future<Response> getUserSettings() async {
    return await _client.get('/settings/user');
  }

  /// 更新用户设置
  /// 
  /// 更新用户设置
  /// @param settings 用户设置
  /// @return 更新结果
  Future<Response> updateUserSettings(Map<String, dynamic> settings) async {
    return await _client.post('/settings/user', data: settings);
  }

  /// 获取通知设置
  /// 
  /// 获取通知设置信息
  /// @return 通知设置
  Future<Response> getNotificationSettings() async {
    return await _client.get('/settings/notification');
  }

  /// 更新通知设置
  /// 
  /// 更新通知设置
  /// @param settings 通知设置
  /// @return 更新结果
  Future<Response> updateNotificationSettings(Map<String, dynamic> settings) async {
    return await _client.post('/settings/notification', data: settings);
  }

  /// 获取备份设置
  /// 
  /// 获取备份设置信息
  /// @return 备份设置
  Future<Response> getBackupSettings() async {
    return await _client.get('/settings/backup');
  }

  /// 更新备份设置
  /// 
  /// 更新备份设置
  /// @param settings 备份设置
  /// @return 更新结果
  Future<Response> updateBackupSettings(Map<String, dynamic> settings) async {
    return await _client.post('/settings/backup', data: settings);
  }

  /// 获取主题设置
  /// 
  /// 获取主题设置信息
  /// @return 主题设置
  Future<Response> getThemeSettings() async {
    return await _client.get('/settings/theme');
  }

  /// 更新主题设置
  /// 
  /// 更新主题设置
  /// @param settings 主题设置
  /// @return 更新结果
  Future<Response> updateThemeSettings(Map<String, dynamic> settings) async {
    return await _client.post('/settings/theme', data: settings);
  }

  /// 获取语言设置
  /// 
  /// 获取语言设置信息
  /// @return 语言设置
  Future<Response> getLanguageSettings() async {
    return await _client.get('/settings/language');
  }

  /// 更新语言设置
  /// 
  /// 更新语言设置
  /// @param language 语言
  /// @return 更新结果
  Future<Response> updateLanguageSettings(String language) async {
    final data = {
      'language': language,
    };
    return await _client.post('/settings/language', data: data);
  }

  /// 获取时区列表
  /// 
  /// 获取可用的时区列表
  /// @return 时区列表
  Future<Response> getTimezones() async {
    return await _client.get('/settings/timezones');
  }

  /// 获取语言列表
  /// 
  /// 获取可用的语言列表
  /// @return 语言列表
  Future<Response> getLanguages() async {
    return await _client.get('/settings/languages');
  }

  /// 获取主题列表
  /// 
  /// 获取可用的主题列表
  /// @return 主题列表
  Future<Response> getThemes() async {
    return await _client.get('/settings/themes');
  }

  /// 重置系统设置
  /// 
  /// 重置系统设置为默认值
  /// @return 重置结果
  Future<Response> resetSystemSettings() async {
    return await _client.post('/settings/reset');
  }

  /// 导出系统设置
  /// 
  /// 导出系统设置
  /// @return 导出结果
  Future<Response> exportSystemSettings() async {
    return await _client.get('/settings/export');
  }

  /// 导入系统设置
  /// 
  /// 导入系统设置
  /// @param settings 设置内容
  /// @return 导入结果
  Future<Response> importSystemSettings(Map<String, dynamic> settings) async {
    return await _client.post('/settings/import', data: settings);
  }
}