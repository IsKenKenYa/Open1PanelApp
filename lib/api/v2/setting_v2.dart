/// 1Panel V2 API - Setting 相关接口
///
/// 此文件包含与系统设置相关的所有API接口，
/// 包括系统配置、用户设置、安全设置等操作。

import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import '../../core/config/api_constants.dart';
import '../../data/models/setting_models.dart';

class SettingV2Api {
  final DioClient _client;

  SettingV2Api(this._client);

  /// 获取系统设置
  ///
  /// 获取系统设置信息
  /// @return 系统设置
  Future<Response<SystemSettings>> getSystemSettings() async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/settings'),
    );
    return Response(
      data: SystemSettings.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 更新系统设置
  ///
  /// 更新系统设置
  /// @param settings 设置信息
  /// @return 更新结果
  Future<Response<SystemSettings>> updateSystemSettings(SystemSettings settings) async {
    final response = await _client.post(
      ApiConstants.buildApiPath('/settings'),
      data: settings.toJson(),
    );
    return Response(
      data: SystemSettings.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取系统信息
  ///
  /// 获取系统基本信息
  /// @return 系统信息
  Future<Response<SystemInfo>> getSystemInfo() async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/dashboard/base/os'),
    );
    return Response(
      data: SystemInfo.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取系统时间
  ///
  /// 获取系统时间
  /// @return 系统时间
  Future<Response<SystemTime>> getSystemTime() async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/settings/time'),
    );
    return Response(
      data: SystemTime.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 更新系统时间
  ///
  /// 更新系统时间
  /// @param timeSet 时间设置
  /// @return 更新结果
  Future<Response<SystemTime>> updateSystemTime(SystemTimeSet timeSet) async {
    final response = await _client.post(
      ApiConstants.buildApiPath('/settings/time'),
      data: timeSet.toJson(),
    );
    return Response(
      data: SystemTime.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 同步系统时间
  ///
  /// 同步系统时间
  /// @param ntpSync NTP同步设置
  /// @return 同步结果
  Future<Response> syncSystemTime(NTPSync ntpSync) async {
    return await _client.post(
      ApiConstants.buildApiPath('/settings/time/sync'),
      data: ntpSync.toJson(),
    );
  }

  /// 获取安全设置
  ///
  /// 获取安全设置信息
  /// @return 安全设置
  Future<Response<SecuritySettings>> getSecuritySettings() async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/settings/security'),
    );
    return Response(
      data: SecuritySettings.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 更新安全设置
  ///
  /// 更新安全设置
  /// @param settings 安全设置
  /// @return 更新结果
  Future<Response<SecuritySettings>> updateSecuritySettings(SecuritySettings settings) async {
    final response = await _client.post(
      ApiConstants.buildApiPath('/settings/security'),
      data: settings.toJson(),
    );
    return Response(
      data: SecuritySettings.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取面板设置
  ///
  /// 获取面板设置信息
  /// @return 面板设置
  Future<Response<PanelSettings>> getPanelSettings() async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/settings/panel'),
    );
    return Response(
      data: PanelSettings.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 更新面板设置
  ///
  /// 更新面板设置
  /// @param settings 面板设置
  /// @return 更新结果
  Future<Response<PanelSettings>> updatePanelSettings(PanelSettings settings) async {
    final response = await _client.post(
      ApiConstants.buildApiPath('/settings/panel'),
      data: settings.toJson(),
    );
    return Response(
      data: PanelSettings.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取用户设置
  ///
  /// 获取用户设置信息
  /// @return 用户设置
  Future<Response<UserSettings>> getUserSettings() async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/settings/user'),
    );
    return Response(
      data: UserSettings.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 更新用户设置
  ///
  /// 更新用户设置
  /// @param settings 用户设置
  /// @return 更新结果
  Future<Response<UserSettings>> updateUserSettings(UserSettings settings) async {
    final response = await _client.post(
      ApiConstants.buildApiPath('/settings/user'),
      data: settings.toJson(),
    );
    return Response(
      data: UserSettings.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取通知设置
  ///
  /// 获取通知设置信息
  /// @return 通知设置
  Future<Response<NotificationSettings>> getNotificationSettings() async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/settings/notification'),
    );
    return Response(
      data: NotificationSettings.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 更新通知设置
  ///
  /// 更新通知设置
  /// @param settings 通知设置
  /// @return 更新结果
  Future<Response<NotificationSettings>> updateNotificationSettings(NotificationSettings settings) async {
    final response = await _client.post(
      ApiConstants.buildApiPath('/settings/notification'),
      data: settings.toJson(),
    );
    return Response(
      data: NotificationSettings.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取备份设置
  ///
  /// 获取备份设置信息
  /// @return 备份设置
  Future<Response<BackupSettings>> getBackupSettings() async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/settings/backup'),
    );
    return Response(
      data: BackupSettings.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 更新备份设置
  ///
  /// 更新备份设置
  /// @param settings 备份设置
  /// @return 更新结果
  Future<Response<BackupSettings>> updateBackupSettings(BackupSettings settings) async {
    final response = await _client.post(
      ApiConstants.buildApiPath('/settings/backup'),
      data: settings.toJson(),
    );
    return Response(
      data: BackupSettings.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取主题设置
  ///
  /// 获取主题设置信息
  /// @return 主题设置
  Future<Response<ThemeSettings>> getThemeSettings() async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/settings/theme'),
    );
    return Response(
      data: ThemeSettings.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 更新主题设置
  ///
  /// 更新主题设置
  /// @param settings 主题设置
  /// @return 更新结果
  Future<Response<ThemeSettings>> updateThemeSettings(ThemeSettings settings) async {
    final response = await _client.post(
      ApiConstants.buildApiPath('/settings/theme'),
      data: settings.toJson(),
    );
    return Response(
      data: ThemeSettings.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取语言设置
  ///
  /// 获取语言设置信息
  /// @return 语言设置
  Future<Response<LanguageSettings>> getLanguageSettings() async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/settings/language'),
    );
    return Response(
      data: LanguageSettings.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 更新语言设置
  ///
  /// 更新语言设置
  /// @param languageSet 语言设置
  /// @return 更新结果
  Future<Response<LanguageSettings>> updateLanguageSettings(LanguageSet languageSet) async {
    final response = await _client.post(
      ApiConstants.buildApiPath('/settings/language'),
      data: languageSet.toJson(),
    );
    return Response(
      data: LanguageSettings.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取时区列表
  ///
  /// 获取可用的时区列表
  /// @return 时区列表
  Future<Response<List<TimezoneInfo>>> getTimezones() async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/settings/timezones'),
    );
    return Response(
      data: (response.data as List?)
          ?.map((item) => TimezoneInfo.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取语言列表
  ///
  /// 获取可用的语言列表
  /// @return 语言列表
  Future<Response<List<LanguageInfo>>> getLanguages() async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/settings/languages'),
    );
    return Response(
      data: (response.data as List?)
          ?.map((item) => LanguageInfo.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取主题列表
  ///
  /// 获取可用的主题列表
  /// @return 主题列表
  Future<Response<List<ThemeInfo>>> getThemes() async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/settings/themes'),
    );
    return Response(
      data: (response.data as List?)
          ?.map((item) => ThemeInfo.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 重置系统设置
  ///
  /// 重置系统设置为默认值
  /// @return 重置结果
  Future<Response> resetSystemSettings() async {
    return await _client.post(
      ApiConstants.buildApiPath('/settings/reset'),
    );
  }

  /// 导出系统设置
  ///
  /// 导出系统设置
  /// @return 导出结果
  Future<Response<SettingsExport>> exportSystemSettings() async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/settings/export'),
    );
    return Response(
      data: SettingsExport.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 导入系统设置
  ///
  /// 导入系统设置
  /// @param settingsImport 设置导入内容
  /// @return 导入结果
  Future<Response<SystemSettings>> importSystemSettings(SettingsImport settingsImport) async {
    final response = await _client.post(
      ApiConstants.buildApiPath('/settings/import'),
      data: settingsImport.toJson(),
    );
    return Response(
      data: SystemSettings.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 生成API密钥
  ///
  /// 生成新的API密钥
  /// @return API密钥生成结果
  Future<Response<Map<String, dynamic>>> generateApiKey() async {
    final response = await _client.post(
      ApiConstants.buildApiPath('/settings/api/config/generate/key'),
    );
    return Response(
      data: response.data as Map<String, dynamic>,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取基础目录设置
  ///
  /// 获取基础目录配置信息
  /// @return 基础目录设置
  Future<Response<Map<String, dynamic>>> getBaseDir() async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/settings/basedir'),
    );
    return Response(
      data: response.data as Map<String, dynamic>,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 更新基础目录设置
  ///
  /// 更新基础目录配置
  /// @param dirPath 基础目录路径
  /// @return 更新结果
  Future<Response<void>> updateBaseDir(@Body() Map<String, dynamic> request) async {
    final response = await _client.put(
      ApiConstants.buildApiPath('/settings/basedir'),
      data: request,
    );
    return Response(
      data: null,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 绑定更新设置
  ///
  /// 更新绑定相关设置
  /// @param request 绑定更新请求
  /// @return 更新结果
  Future<Response<void>> updateBindSettings(@Body() Map<String, dynamic> request) async {
    final response = await _client.put(
      ApiConstants.buildApiPath('/settings/bind/update'),
      data: request,
    );
    return Response(
      data: null,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 更新密码设置
  ///
  /// 更新系统密码设置
  /// @param request 密码更新请求
  /// @return 更新结果
  Future<Response<void>> updatePasswordSettings(@Body() Map<String, dynamic> request) async {
    final response = await _client.put(
      ApiConstants.buildApiPath('/settings/password/update'),
      data: request,
    );
    return Response(
      data: null,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 更新端口设置
  ///
  /// 更新系统端口设置
  /// @param request 端口更新请求
  /// @return 更新结果
  Future<Response<void>> updatePortSettings(@Body() Map<String, dynamic> request) async {
    final response = await _client.put(
      ApiConstants.buildApiPath('/settings/port/update'),
      data: request,
    );
    return Response(
      data: null,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 更新代理设置
  ///
  /// 更新系统代理设置
  /// @param request 代理更新请求
  /// @return 更新结果
  Future<Response<void>> updateProxySettings(@Body() Map<String, dynamic> request) async {
    final response = await _client.put(
      ApiConstants.buildApiPath('/settings/proxy/update'),
      data: request,
    );
    return Response(
      data: null,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 系统回滚
  ///
  /// 执行系统回滚操作
  /// @return 回滚结果
  Future<Response<void>> systemRollback() async {
    final response = await _client.post(
      ApiConstants.buildApiPath('/settings/rollback'),
    );
    return Response(
      data: null,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 更新界面设置
  ///
  /// 更新用户界面设置
  /// @param request 界面更新请求
  /// @return 更新结果
  Future<Response<void>> updateInterfaceSettings(@Body() Map<String, dynamic> request) async {
    final response = await _client.put(
      ApiConstants.buildApiPath('/settings/interface'),
      data: request,
    );
    return Response(
      data: null,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 更新菜单设置
  ///
  /// 更新系统菜单设置
  /// @param request 菜单更新请求
  /// @return 更新结果
  Future<Response<void>> updateMenuSettings(@Body() Map<String, dynamic> request) async {
    final response = await _client.put(
      ApiConstants.buildApiPath('/settings/menu/update'),
      data: request,
    );
    return Response(
      data: null,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 终端设置搜索
  ///
  /// 搜索终端设置
  /// @param request 搜索请求
  /// @return 搜索结果
  Future<Response<List<SettingInfo>>> searchTerminalSettings(@Body() Map<String, dynamic> request) async {
    final response = await _client.post(
      ApiConstants.buildApiPath('/settings/terminal/search'),
      data: request,
    );
    return Response(
      data: (response.data as List?)
          ?.map((item) => SettingInfo.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 更新终端设置
  ///
  /// 更新终端设置
  /// @param request 终端更新请求
  /// @return 更新结果
  Future<Response<void>> updateTerminalSettings(@Body() Map<String, dynamic> request) async {
    final response = await _client.put(
      ApiConstants.buildApiPath('/settings/terminal/update'),
      data: request,
    );
    return Response(
      data: null,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 更新SSL设置
  ///
  /// 更新SSL证书设置
  /// @param request SSL更新请求
  /// @return 更新结果
  Future<Response<void>> updateSSLSettings(@Body() Map<String, dynamic> request) async {
    final response = await _client.put(
      ApiConstants.buildApiPath('/settings/ssl/update'),
      data: request,
    );
    return Response(
      data: null,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取SSL证书信息
  ///
  /// 获取SSL证书信息
  /// @return SSL证书信息
  Future<Response<Map<String, dynamic>>> getSSLInfo() async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/settings/ssl/info'),
    );
    return Response(
      data: response.data as Map<String, dynamic>,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 下载SSL证书
  ///
  /// 下载SSL证书文件
  /// @param request SSL下载请求
  /// @return 下载结果
  Future<Response<String>> downloadSSLCertificate(@Body() Map<String, dynamic> request) async {
    final response = await _client.post(
      ApiConstants.buildApiPath('/settings/ssl/download'),
      data: request,
    );
    return Response(
      data: response.data?.toString() ?? '',
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 处理许可证过期
  ///
  /// 处理许可证过期
  /// @param request 过期处理请求
  /// @return 处理结果
  Future<Response<void>> handleLicenseExpire(@Body() Map<String, dynamic> request) async {
    final response = await _client.put(
      ApiConstants.buildApiPath('/settings/expire/handle'),
      data: request,
    );
    return Response(
      data: null,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 系统升级
  ///
  /// 执行系统升级操作
  /// @return 升级结果
  Future<Response<void>> systemUpgrade() async {
    final response = await _client.post(
      ApiConstants.buildApiPath('/settings/upgrade'),
    );
    return Response(
      data: null,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 系统验证
  ///
  /// 执行系统验证操作
  /// @param request 验证请求
  /// @return 验证结果
  Future<Response<Map<String, dynamic>>> systemVerify(@Body() Map<String, dynamic> request) async {
    final response = await _client.post(
      ApiConstants.buildApiPath('/settings/verify'),
      data: request,
    );
    return Response(
      data: response.data as Map<String, dynamic>,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 验证过期码
  ///
  /// 验证许可证过期码
  /// @param request 过期码验证请求
  /// @return 验证结果
  Future<Response<Map<String, dynamic>>> verifyExpireCode(@Body() Map<String, dynamic> request) async {
    final response = await _client.post(
      ApiConstants.buildApiPath('/settings/expire/code'),
      data: request,
    );
    return Response(
      data: response.data as Map<String, dynamic>,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 升级过期版本
  ///
  /// 升级过期版本
  /// @param request 过期升级请求
  /// @return 升级结果
  Future<Response<void>> upgradeExpireVersion(@Body() Map<String, dynamic> request) async {
    final response = await _client.post(
      ApiConstants.buildApiPath('/settings/expire/upgrade'),
      data: request,
    );
    return Response(
      data: null,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 设置向导
  ///
  /// 执行设置向导操作
  /// @param request 向导请求
  /// @return 向导结果
  Future<Response<Map<String, dynamic>>> wizardSettings(@Body() Map<String, dynamic> request) async {
    final response = await _client.post(
      ApiConstants.buildApiPath('/settings/wizard'),
      data: request,
    );
    return Response(
      data: response.data as Map<String, dynamic>,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }
}