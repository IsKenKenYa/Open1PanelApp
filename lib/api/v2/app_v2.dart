import 'package:dio/dio.dart';
import '../../data/models/app_models.dart';
import '../../core/config/api_constants.dart';

/// 1Panel V2 API - 应用管理接口
class AppV2Api {
  final Dio _dio;

  AppV2Api(this._dio);

  List<T> _parseListData<T>(dynamic dataField, T Function(Map<String, dynamic>) fromJson) {
    if (dataField is List) {
      return dataField.map((e) => fromJson(e as Map<String, dynamic>)).toList();
    }
    if (dataField is Map<String, dynamic>) {
      final items = dataField['items'];
      if (items is List) {
        return items.map((e) => fromJson(e as Map<String, dynamic>)).toList();
      }
    }
    return [];
  }

  AppSearchResponse _parseAppSearchResponse(dynamic dataField) {
    if (dataField is Map<String, dynamic>) {
      return AppSearchResponse.fromJson(dataField);
    }
    if (dataField is List) {
      final items = dataField.map((e) => AppItem.fromJson(e as Map<String, dynamic>)).toList();
      return AppSearchResponse(items: items, total: items.length);
    }
    return AppSearchResponse(items: [], total: 0);
  }

  AppListResponse _parseAppListResponse(dynamic dataField) {
    if (dataField is Map<String, dynamic>) {
      if (dataField.containsKey('apps')) {
        return AppListResponse.fromJson(dataField);
      }
      final items = _parseListData(dataField, AppInstallInfo.fromJson);
      final total = dataField['total'];
      return AppListResponse(apps: items, total: total is num ? total.toInt() : items.length);
    }
    if (dataField is List) {
      final items = dataField.map((e) => AppInstallInfo.fromJson(e as Map<String, dynamic>)).toList();
      return AppListResponse(apps: items, total: items.length);
    }
    return AppListResponse(apps: [], total: 0);
  }

  AppUpdateResponse _parseAppUpdateResponse(dynamic dataField) {
    if (dataField is Map<String, dynamic>) {
      if (dataField.containsKey('updates')) {
        return AppUpdateResponse.fromJson(dataField);
      }
      final items = _parseListData(dataField, AppInstallInfo.fromJson);
      final total = dataField['total'];
      return AppUpdateResponse(updates: items, total: total is num ? total.toInt() : items.length);
    }
    if (dataField is List) {
      final items = dataField.map((e) => AppInstallInfo.fromJson(e as Map<String, dynamic>)).toList();
      return AppUpdateResponse(updates: items, total: items.length);
    }
    return AppUpdateResponse(updates: [], total: 0);
  }

  /// 安装应用
  Future<AppInstallInfo> installApp(AppInstallCreateRequest request) async {
    final response = await _dio.post<dynamic>(
      ApiConstants.buildApiPath('/apps/install'),
      data: request.toJson(),
    );
    final data = response.data as Map<String, dynamic>;
    return AppInstallInfo.fromJson(data['data'] as Map<String, dynamic>);
  }

  /// 卸载应用
  Future<void> uninstallApp(String appInstallId) async {
    await _dio.delete(
      ApiConstants.buildApiPath('/apps/uninstall/$appInstallId'),
    );
  }

  /// 更新应用
  Future<void> updateApp(String appInstallId) async {
    await _dio.put(
      ApiConstants.buildApiPath('/apps/update/$appInstallId'),
    );
  }

  /// 搜索应用
  Future<AppSearchResponse> searchApps(AppSearchRequest request) async {
    final response = await _dio.post<dynamic>(
      ApiConstants.buildApiPath('/apps/search'),
      data: request.toJson(),
    );
    final data = response.data as Map<String, dynamic>;
    return _parseAppSearchResponse(data['data']);
  }

  /// 获取应用列表
  Future<AppListResponse> getAppList() async {
    final response = await _dio.get<dynamic>(
      ApiConstants.buildApiPath('/apps/list'),
    );
    final data = response.data as Map<String, dynamic>;
    return _parseAppListResponse(data['data']);
  }

  /// 获取应用详情
  Future<AppItem> getAppDetail(String appId, String version, String type) async {
    final response = await _dio.get<dynamic>(
      ApiConstants.buildApiPath('/apps/detail/$appId/$version/$type'),
    );
    final data = response.data as Map<String, dynamic>;
    return AppItem.fromJson(data['data'] as Map<String, dynamic>);
  }

  /// 获取应用详情（通过ID）
  Future<AppItem> getAppDetails(String id) async {
    final response = await _dio.get<dynamic>(
      ApiConstants.buildApiPath('/apps/details/$id'),
    );
    final data = response.data as Map<String, dynamic>;
    return AppItem.fromJson(data['data'] as Map<String, dynamic>);
  }

  /// 检查应用更新
  Future<AppUpdateResponse> checkAppUpdate() async {
    final response = await _dio.get<dynamic>(
      ApiConstants.buildApiPath('/apps/checkupdate'),
    );
    final data = response.data as Map<String, dynamic>;
    return _parseAppUpdateResponse(data['data']);
  }

  /// 获取忽略更新的应用列表
  Future<List<AppInstallInfo>> getIgnoredApps() async {
    final response = await _dio.get<dynamic>(
      ApiConstants.buildApiPath('/apps/ignored'),
    );
    final data = response.data as Map<String, dynamic>;
    return _parseListData(data['data'], AppInstallInfo.fromJson);
  }

  /// 检查应用安装
  Future<AppInstalledCheckResponse> checkAppInstall(AppInstalledCheckRequest request) async {
    final response = await _dio.post<dynamic>(
      ApiConstants.buildApiPath('/apps/installed/check'),
      data: request.toJson(),
    );
    final data = response.data as Map<String, dynamic>;
    return AppInstalledCheckResponse.fromJson(data['data'] as Map<String, dynamic>);
  }

  /// 获取应用安装配置
  Future<Map<String, dynamic>> getAppInstallConfig(String appInstallId) async {
    final response = await _dio.get<dynamic>(
      ApiConstants.buildApiPath('/apps/installed/conf/$appInstallId'),
    );
    final data = response.data as Map<String, dynamic>;
    return data['data'] as Map<String, dynamic>;
  }

  /// 更新应用安装配置
  Future<void> updateAppInstallConfig(Map<String, dynamic> request) async {
    await _dio.put(
      ApiConstants.buildApiPath('/apps/installed/config/update'),
      data: request,
    );
  }

  /// 获取应用连接信息
  Future<Map<String, dynamic>> getAppConnInfo(String key) async {
    final response = await _dio.get<dynamic>(
      ApiConstants.buildApiPath('/apps/installed/conninfo/$key'),
    );
    final data = response.data as Map<String, dynamic>;
    return data['data'] as Map<String, dynamic>;
  }

  /// 检查应用卸载
  Future<Map<String, dynamic>> checkAppUninstall(String appInstallId) async {
    final response = await _dio.get<dynamic>(
      ApiConstants.buildApiPath('/apps/installed/delete/check/$appInstallId'),
    );
    final data = response.data as Map<String, dynamic>;
    return data['data'] as Map<String, dynamic>;
  }

  /// 忽略应用更新
  Future<void> ignoreAppUpdate(AppInstalledIgnoreUpgradeRequest request) async {
    await _dio.post(
      ApiConstants.buildApiPath('/apps/installed/ignore'),
      data: request.toJson(),
    );
  }

  /// 获取已安装应用列表
  Future<List<AppInstallInfo>> getInstalledApps() async {
    final response = await _dio.get<dynamic>(
      ApiConstants.buildApiPath('/apps/installed/list'),
    );
    final data = response.data as Map<String, dynamic>;
    return _parseListData(data['data'], AppInstallInfo.fromJson);
  }

  /// 加载应用端口
  Future<int> loadAppPort(Map<String, dynamic> request) async {
    final response = await _dio.post<dynamic>(
      ApiConstants.buildApiPath('/apps/installed/loadport'),
      data: request,
    );
    final data = response.data as Map<String, dynamic>;
    return data['data'] as int;
  }

  /// 应用操作（启动、停止、重启）
  Future<void> operateApp(AppInstalledOperateRequest request) async {
    await _dio.post(
      ApiConstants.buildApiPath('/apps/installed/op'),
      data: request.toJson(),
    );
  }

  /// 获取应用安装参数
  Future<Map<String, dynamic>> getAppInstallParams(String appInstallId) async {
    final response = await _dio.get<dynamic>(
      ApiConstants.buildApiPath('/apps/installed/params/$appInstallId'),
    );
    final data = response.data as Map<String, dynamic>;
    return data['data'] as Map<String, dynamic>;
  }

  /// 搜索已安装应用
  Future<PageResult<AppInstallInfo>> searchInstalledApps(AppInstalledSearchRequest request) async {
    final response = await _dio.post<dynamic>(
      ApiConstants.buildApiPath('/apps/installed/search'),
      data: request.toJson(),
    );
    final data = response.data as Map<String, dynamic>;
    return PageResult.fromJson(
      data['data'] as Map<String, dynamic>,
      (dynamic item) => AppInstallInfo.fromJson(item as Map<String, dynamic>),
    );
  }

  /// 同步应用状态
  Future<void> syncAppStatus() async {
    await _dio.post(
      ApiConstants.buildApiPath('/apps/installed/sync'),
    );
  }

  /// 获取应用更新版本列表
  Future<List<AppVersion>> getAppUpdateVersions(String appInstallId) async {
    final response = await _dio.get<dynamic>(
      ApiConstants.buildApiPath('/apps/installed/update/versions/$appInstallId'),
    );
    final data = response.data as Map<String, dynamic>;
    // 处理API返回的data字段可能是Map或List的情况
    final dataField = data['data'];
    if (dataField is List) {
      return dataField.map((e) => AppVersion.fromJson(e as Map<String, dynamic>)).toList();
    } else if (dataField is Map<String, dynamic>) {
      final items = dataField['items'] as List?;
      return items?.map((e) => AppVersion.fromJson(e as Map<String, dynamic>)).toList() ?? [];
    }
    return [];
  }

  /// 获取应用服务列表
  Future<List<AppServiceResponse>> getAppServices(String key) async {
    final response = await _dio.get<dynamic>(
      ApiConstants.buildApiPath('/apps/services/$key'),
    );
    final data = response.data as Map<String, dynamic>;
    // 处理API返回的data字段可能是Map或List的情况
    final dataField = data['data'];
    if (dataField is List) {
      return dataField.map((e) => AppServiceResponse.fromJson(e as Map<String, dynamic>)).toList();
    } else if (dataField is Map<String, dynamic>) {
      final items = dataField['items'] as List?;
      return items?.map((e) => AppServiceResponse.fromJson(e as Map<String, dynamic>)).toList() ?? [];
    }
    return [];
  }

  /// 获取应用商店配置
  Future<AppstoreConfigResponse> getAppstoreConfig() async {
    final response = await _dio.get<dynamic>(
      ApiConstants.buildApiPath('/core/settings/apps/store/config'),
    );
    final data = response.data as Map<String, dynamic>;
    return AppstoreConfigResponse.fromJson(data['data'] as Map<String, dynamic>);
  }

  /// 更新应用商店配置
  Future<void> updateAppstoreConfig(AppstoreUpdateRequest request) async {
    await _dio.post(
      ApiConstants.buildApiPath('/apps/store/update'),
      data: request.toJson(),
    );
  }

  /// 同步本地应用列表
  Future<void> syncLocalApps() async {
    await _dio.post(
      ApiConstants.buildApiPath('/apps/sync/local'),
    );
  }

  /// 同步远程应用列表
  Future<void> syncRemoteApps() async {
    await _dio.post(
      ApiConstants.buildApiPath('/apps/sync/remote'),
    );
  }
}
