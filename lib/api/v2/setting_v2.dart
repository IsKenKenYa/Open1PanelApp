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
  Future<Response<SettingInfo>> getSystemSettings() async {
    final response = await _client.post(
      ApiConstants.buildApiPath('/core/settings/search'),
    );
    return Response(
      data: SettingInfo.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 通过key获取系统设置
  ///
  /// 通过key获取系统设置
  /// @param key 设置key
  /// @return 系统设置
  Future<Response<SettingInfo>> getSystemSettingByKey(String key) async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/core/settings/by'),
      queryParameters: {'key': key},
    );
    return Response(
      data: SettingInfo.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 更新系统设置
  ///
  /// 更新系统设置
  /// @param request 设置更新请求
  /// @return 更新结果
  Future<Response<void>> updateSystemSetting(SettingUpdate request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/core/settings/update'),
      data: request.toJson(),
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

  /// 获取终端设置
  ///
  /// 获取终端设置信息
  /// @return 终端设置
  Future<Response<TerminalInfo>> getTerminalSettings() async {
    final response = await _client.post(
      ApiConstants.buildApiPath('/core/settings/terminal/search'),
    );
    return Response(
      data: TerminalInfo.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 更新终端设置
  ///
  /// 更新终端设置
  /// @param request 终端设置更新请求
  /// @return 更新结果
  Future<Response<void>> updateTerminalSettings(TerminalUpdate request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/core/settings/terminal/update'),
      data: request.toJson(),
    );
  }

  /// 获取界面设置
  ///
  /// 获取界面设置信息
  /// @return 界面设置
  Future<Response<InterfaceInfo>> getInterfaceSettings() async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/core/settings/interface'),
    );
    return Response(
      data: InterfaceInfo.fromJson(response.data as Map<String, dynamic>),
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
  Future<Response<void>> updatePasswordSettings(PasswordUpdate request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/core/settings/password/update'),
      data: request.toJson(),
    );
  }

  /// 更新端口设置
  ///
  /// 更新系统端口设置
  /// @param request 端口更新请求
  /// @return 更新结果
  Future<Response<void>> updatePortSettings(PortUpdate request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/core/settings/port/update'),
      data: request.toJson(),
    );
  }

  /// 更新代理设置
  ///
  /// 更新系统代理设置
  /// @param request 代理更新请求
  /// @return 更新结果
  Future<Response<void>> updateProxySettings(ProxyUpdate request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/core/settings/proxy/update'),
      data: request.toJson(),
    );
  }

  /// 更新绑定设置
  ///
  /// 更新绑定相关设置
  /// @param request 绑定更新请求
  /// @return 更新结果
  Future<Response<void>> updateBindSettings(BindUpdate request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/core/settings/bind/update'),
      data: request.toJson(),
    );
  }

  /// 更新菜单设置
  ///
  /// 更新系统菜单设置
  /// @param request 菜单更新请求
  /// @return 更新结果
  Future<Response<void>> updateMenuSettings(MenuUpdate request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/core/settings/menu/update'),
      data: request.toJson(),
    );
  }

  /// 获取默认菜单
  ///
  /// 获取默认菜单配置
  /// @return 默认菜单
  Future<Response<Map<String, dynamic>>> getDefaultMenu() async {
    final response = await _client.post(
      ApiConstants.buildApiPath('/core/settings/menu/default'),
    );
    return Response(
      data: response.data as Map<String, dynamic>,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 处理过期
  ///
  /// 处理系统过期
  /// @param request 过期处理请求
  /// @return 处理结果
  Future<Response<void>> handleExpired(ExpiredHandle request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/core/settings/expired/handle'),
      data: request.toJson(),
    );
  }

  /// 生成API密钥
  ///
  /// 生成新的API密钥
  /// @return API密钥生成结果
  Future<Response<Map<String, dynamic>>> generateApiKey() async {
    final response = await _client.post(
      ApiConstants.buildApiPath('/core/settings/api/config/generate/key'),
    );
    return Response(
      data: response.data as Map<String, dynamic>,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 更新API配置
  ///
  /// 更新API配置
  /// @param request API配置更新请求
  /// @return 更新结果
  Future<Response<void>> updateApiConfig(ApiConfigUpdate request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/core/settings/api/config/update'),
      data: request.toJson(),
    );
  }

  /// 获取应用商店配置
  ///
  /// 获取应用商店配置信息
  /// @return 应用商店配置
  Future<Response<Map<String, dynamic>>> getAppStoreConfig() async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/core/settings/apps/store/config'),
    );
    return Response(
      data: response.data as Map<String, dynamic>,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 更新应用商店配置
  ///
  /// 更新应用商店配置
  /// @param request 应用商店配置更新请求
  /// @return 更新结果
  Future<Response<void>> updateAppStoreConfig(AppStoreConfigUpdate request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/core/settings/apps/store/update'),
      data: request.toJson(),
    );
  }

  // ==================== 快照相关API ====================

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

  /// 通过key获取设置（settings路径）
  ///
  /// 通过key获取设置
  /// @param key 设置key
  /// @return 设置值
  Future<Response<Map<String, dynamic>>> getSettingByKey(String key) async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/settings/get/$key'),
    );
    return Response(
      data: response.data as Map<String, dynamic>,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 搜索设置
  ///
  /// 搜索系统设置
  /// @return 设置信息
  Future<Response<Map<String, dynamic>>> searchSettings() async {
    final response = await _client.post(
      ApiConstants.buildApiPath('/settings/search'),
    );
    return Response(
      data: response.data as Map<String, dynamic>,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 检查设置可用性
  ///
  /// 检查设置是否可用
  /// @return 可用性结果
  Future<Response<Map<String, dynamic>>> checkSettingsAvailable() async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/settings/search/available'),
    );
    return Response(
      data: response.data as Map<String, dynamic>,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 保存描述
  ///
  /// 保存系统描述
  /// @param request 描述保存请求
  /// @return 保存结果
  Future<Response<void>> saveDescription(DescriptionSave request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/settings/description/save'),
      data: request.toJson(),
    );
  }

  // ==================== MFA相关API ====================

  /// 加载MFA信息
  ///
  /// 加载MFA密钥和二维码
  /// @param request MFA凭证请求
  /// @return MFA OTP信息
  Future<Response<MfaOtp>> loadMfaInfo(MfaCredential request) async {
    final response = await _client.post<dynamic>(
      ApiConstants.buildApiPath('/core/settings/mfa'),
      data: request.toJson(),
    );
    final data = response.data;
    Map<String, dynamic>? payload;
    if (data is Map<String, dynamic>) {
      final inner = data['data'];
      if (inner is Map<String, dynamic>) {
        payload = inner;
      } else {
        payload = data;
      }
    }
    return Response(
      data: payload == null ? const MfaOtp() : MfaOtp.fromJson(payload),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 绑定MFA
  ///
  /// 绑定MFA认证
  /// @param request MFA绑定请求
  /// @return 绑定结果
  Future<Response<void>> bindMfa(MfaBindRequest request) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiConstants.buildApiPath('/core/settings/mfa/bind'),
      data: request.toJson(),
    );
    return Response(
      data: null,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取MFA状态
  ///
  /// 获取当前用户的MFA启用状态
  /// @return MFA状态
  Future<Response<MfaStatus>> getMfaStatus() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiConstants.buildApiPath('/core/settings/mfa/status'),
    );
    final data = response.data!;
    return Response(
      data: MfaStatus.fromJson(data['data'] as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 解绑MFA
  ///
  /// 解绑MFA认证
  /// @param request 解绑请求（包含验证码）
  /// @return 解绑结果
  Future<Response<void>> unbindMfa(Map<String, dynamic> request) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiConstants.buildApiPath('/core/settings/mfa/unbind'),
      data: request,
    );
    return Response(
      data: null,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }
}

// ==================== 请求模型 ====================

class SettingUpdate {
  final String key;
  final String value;

  const SettingUpdate({required this.key, required this.value});

  Map<String, dynamic> toJson() => {'key': key, 'value': value};
}

class TerminalUpdate {
  final String? lineTheme;
  final int? fontSize;
  final String? fontFamily;

  const TerminalUpdate({this.lineTheme, this.fontSize, this.fontFamily});

  Map<String, dynamic> toJson() => {
        if (lineTheme != null) 'lineTheme': lineTheme,
        if (fontSize != null) 'fontSize': fontSize,
        if (fontFamily != null) 'fontFamily': fontFamily,
      };
}

class PasswordUpdate {
  final String oldPassword;
  final String newPassword;

  const PasswordUpdate({required this.oldPassword, required this.newPassword});

  Map<String, dynamic> toJson() => {'oldPassword': oldPassword, 'newPassword': newPassword};
}

class PortUpdate {
  final int port;

  const PortUpdate({required this.port});

  Map<String, dynamic> toJson() => {'port': port};
}

class ProxyUpdate {
  final String? proxyUrl;
  final int? proxyPort;

  const ProxyUpdate({this.proxyUrl, this.proxyPort});

  Map<String, dynamic> toJson() => {
        if (proxyUrl != null) 'proxyUrl': proxyUrl,
        if (proxyPort != null) 'proxyPort': proxyPort,
      };
}

class BindUpdate {
  final String? bindAddress;

  const BindUpdate({this.bindAddress});

  Map<String, dynamic> toJson() => {
        if (bindAddress != null) 'bindAddress': bindAddress,
      };
}

class MenuUpdate {
  final List<String> menus;

  const MenuUpdate({required this.menus});

  Map<String, dynamic> toJson() => {'menus': menus};
}

class ExpiredHandle {
  final String? method;

  const ExpiredHandle({this.method});

  Map<String, dynamic> toJson() => {if (method != null) 'method': method};
}

class ApiConfigUpdate {
  final String? apiKey;

  const ApiConfigUpdate({this.apiKey});

  Map<String, dynamic> toJson() => {if (apiKey != null) 'apiKey': apiKey};
}

class AppStoreConfigUpdate {
  final String? storeUrl;

  const AppStoreConfigUpdate({this.storeUrl});

  Map<String, dynamic> toJson() => {if (storeUrl != null) 'storeUrl': storeUrl};
}

class DescriptionSave {
  final String description;

  const DescriptionSave({required this.description});

  Map<String, dynamic> toJson() => {'description': description};
}
