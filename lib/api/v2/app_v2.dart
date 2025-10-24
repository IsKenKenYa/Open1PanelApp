import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../data/models/app_models.dart';
import '../../core/network/api_client.dart';
import '../../core/config/api_constants.dart';

part 'app_v2.g.dart';

/// 1Panel V2 API - 应用管理接口
@RestApi()
abstract class AppV2Api {
  factory AppV2Api(Dio dio, {String baseUrl}) = _AppV2Api;

  /// 安装应用
  @POST('/api/v2/apps/install')
  Future<AppInstallInfo> installApp(@Body() AppInstallCreateRequest request);

  /// 卸载应用
  @DELETE('/api/v2/apps/uninstall/{appInstallId}')
  Future<void> uninstallApp(@Path('appInstallId') String appInstallId);

  /// 更新应用
  @PUT('/api/v2/apps/update/{appInstallId}')
  Future<void> updateApp(@Path('appInstallId') String appInstallId);

  /// 搜索应用
  @POST('/api/v2/apps/search')
  Future<AppSearchResponse> searchApps(@Body() AppSearchRequest request);

  /// 获取应用列表
  @GET('/api/v2/apps/list')
  Future<AppListResponse> getAppList();

  /// 获取应用详情
  @GET('/api/v2/apps/detail/{appId}/{version}/{type}')
  Future<AppItem> getAppDetail(
    @Path('appId') String appId,
    @Path('version') String version,
    @Path('type') String type,
  );

  /// 获取应用详情（通过ID）
  @GET('/api/v2/apps/details/{id}')
  Future<AppItem> getAppDetails(@Path('id') String id);

  /// 检查应用更新
  @GET('/api/v2/apps/checkupdate')
  Future<AppUpdateResponse> checkAppUpdate();

  /// 获取忽略更新的应用列表
  @GET('/api/v2/apps/ignored')
  Future<List<AppInstallInfo>> getIgnoredApps();

  /// 检查应用安装
  @POST('/api/v2/apps/installed/check')
  Future<AppInstalledCheckResponse> checkAppInstall(@Body() AppInstalledCheckRequest request);

  /// 获取应用安装配置
  @GET('/api/v2/apps/installed/conf/{appInstallId}')
  Future<Map<String, dynamic>> getAppInstallConfig(@Path('appInstallId') String appInstallId);

  /// 更新应用安装配置
  @PUT('/api/v2/apps/installed/config/update')
  Future<void> updateAppInstallConfig(@Body() Map<String, dynamic> request);

  /// 获取应用连接信息
  @GET('/api/v2/apps/installed/conninfo/{key}')
  Future<Map<String, dynamic>> getAppConnInfo(@Path('key') String key);

  /// 检查应用卸载
  @GET('/api/v2/apps/installed/delete/check/{appInstallId}')
  Future<Map<String, dynamic>> checkAppUninstall(@Path('appInstallId') String appInstallId);

  /// 忽略应用更新
  @POST('/api/v2/apps/installed/ignore')
  Future<void> ignoreAppUpdate(@Body() AppInstalledIgnoreUpgradeRequest request);

  /// 获取已安装应用列表
  @GET('/api/v2/apps/installed/list')
  Future<List<AppInstallInfo>> getInstalledApps();

  /// 加载应用端口
  @POST('/api/v2/apps/installed/loadport')
  Future<int> loadAppPort(@Body() Map<String, dynamic> request);

  /// 应用操作（启动、停止、重启）
  @POST('/api/v2/apps/installed/op')
  Future<void> operateApp(@Body() AppInstalledOperateRequest request);

  /// 获取应用安装参数
  @GET('/api/v2/apps/installed/params/{appInstallId}')
  Future<Map<String, dynamic>> getAppInstallParams(@Path('appInstallId') String appInstallId);

  /// 搜索已安装应用
  @POST('/api/v2/apps/installed/search')
  Future<PageResult<AppInstallInfo>> searchInstalledApps(@Body() AppInstalledSearchRequest request);

  /// 同步应用状态
  @POST('/api/v2/apps/installed/sync')
  Future<void> syncAppStatus();

  /// 获取应用更新版本列表
  @GET('/api/v2/apps/installed/update/versions/{appInstallId}')
  Future<List<AppVersion>> getAppUpdateVersions(@Path('appInstallId') String appInstallId);

  /// 获取应用服务列表
  @GET('/api/v2/apps/services/{key}')
  Future<List<AppServiceResponse>> getAppServices(@Path('key') String key);

  /// 获取应用商店配置
  @GET('/api/v2/apps/store/config')
  Future<AppstoreConfigResponse> getAppstoreConfig();

  /// 更新应用商店配置
  @POST('/api/v2/apps/store/update')
  Future<void> updateAppstoreConfig(@Body() AppstoreUpdateRequest request);

  /// 同步本地应用列表
  @POST('/api/v2/apps/sync/local')
  Future<void> syncLocalApps();

  /// 同步远程应用列表
  @POST('/api/v2/apps/sync/remote')
  Future<void> syncRemoteApps();
}