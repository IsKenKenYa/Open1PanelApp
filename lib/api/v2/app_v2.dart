/// 1Panel V2 API - 应用管理服务

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../core/network/api_client.dart';
import '../../data/models/app_models.dart';

part 'app_v2.g.dart';

/// 应用管理服务
@RestApi()
abstract class AppV2Service {
  factory AppV2Service(Dio dio, {String baseUrl}) = _AppV2Service;

  /// 创建应用服务实例
  static AppV2Service create() {
    return AppV2Service(ApiClient.instance.dio);
  }

  /// 搜索应用
  @POST('/apps/search')
  Future<AppSearchResponse> searchApps(@Body() AppSearchRequest request);

  /// 获取应用服务信息
  @GET('/apps/services/{key}')
  Future<List<AppServiceResponse>> getAppServices(@Path('key') String key);

  /// 获取应用商店配置
  @GET('/apps/store/config')
  Future<AppstoreConfigResponse> getAppstoreConfig();

  /// 更新应用商店配置
  @POST('/apps/store/update')
  Future<void> updateAppstoreConfig(@Body() AppstoreUpdateRequest request);

  /// 同步本地应用
  @POST('/apps/sync/local')
  Future<void> syncLocalApps();

  /// 同步远程应用
  @POST('/apps/sync/remote')
  Future<void> syncRemoteApps();

  /// 安装应用
  @POST('/apps/install')
  Future<AppInstall> installApp(@Body() AppInstallCreateRequest request);

  /// 检查应用是否已安装
  @GET('/apps/installed/check')
  Future<AppInstalledCheckResponse> checkAppInstalled(@Query('key') String key, @Query('name') String? name);

  /// 获取应用安装配置
  @GET('/apps/installed/conf')
  Future<Map<String, dynamic>> getAppInstalledConf(@Query('key') String key, @Query('name') String? name);

  /// 更新应用安装配置
  @POST('/apps/installed/config/update')
  Future<void> updateAppInstalledConfig(@Body() Map<String, dynamic> request);

  /// 获取应用连接信息
  @GET('/apps/installed/conninfo/{key}')
  Future<Map<String, dynamic>> getAppConnInfo(@Path('key') String key);

  /// 获取已安装应用列表
  @GET('/apps/installed/list')
  Future<PageResult<AppInstall>> getInstalledApps(@Query('page') int page, @Query('pageSize') int pageSize, 
    @Query('all') bool? all, @Query('name') String? name, @Query('sync') bool? sync, 
    @Query('tags') List<String>? tags, @Query('type') String? type, @Query('unused') bool? unused, 
    @Query('update') bool? update);

  /// 获取已安装应用详情
  @GET('/apps/installed/{id}')
  Future<AppInstall> getInstalledAppDetail(@Path('id') int id);

  /// 删除已安装应用
  @DELETE('/apps/installed/{id}')
  Future<void> deleteInstalledApp(@Path('id') int id, @Query('deleteDB') bool? deleteDB, 
    @Query('deleteImage') bool? deleteImage, @Query('deleteBackup') bool? deleteBackup);

  /// 更新已安装应用
  @PUT('/apps/installed/{id}')
  Future<void> updateInstalledApp(@Path('id') int id, @Body() Map<String, dynamic> request);

  /// 操作已安装应用
  @POST('/apps/installed/operate')
  Future<void> operateInstalledApp(@Body() AppInstalledOperateRequest request);

  /// 获取应用详情
  @GET('/apps/{key}')
  Future<AppItem> getAppDetail(@Path('key') String key);

  /// 获取应用版本
  @GET('/apps/{key}/versions')
  Future<List<String>> getAppVersions(@Path('key') String key);

  /// 获取应用参数
  @GET('/apps/{key}/params')
  Future<Map<String, dynamic>> getAppParams(@Path('key') String key, @Query('version') String version);

  /// 忽略应用升级
  @POST('/apps/installed/ignore/upgrade')
  Future<void> ignoreAppUpgrade(@Body() Map<String, dynamic> request);

  /// 获取应用升级信息
  @GET('/apps/installed/upgrade')
  Future<List<AppInstall>> getAppUpgradeInfo();

  /// 获取应用列表更新信息
  @GET('/apps/checkupdate')
  Future<Map<String, dynamic>> getAppUpdateInfo();

  /// 根据应用ID、版本和类型获取应用详情
  @GET('/apps/detail/{appId}/{version}/{type}')
  Future<Map<String, dynamic>> getAppDetailById(@Path('appId') int appId, @Path('version') String version, @Path('type') String type);

  /// 根据ID获取应用详情
  @GET('/apps/details/{id}')
  Future<Map<String, dynamic>> getAppDetailsById(@Path('id') int id);

  /// 获取忽略升级的应用列表
  @GET('/apps/ignored')
  Future<List<Map<String, dynamic>>> getIgnoredApps();

  /// 删除应用前的检查
  @GET('/apps/installed/delete/check/{appInstallId}')
  Future<List<Map<String, dynamic>>> checkBeforeDeleteApp(@Path('appInstallId') int appInstallId);

  /// 根据应用key获取端口
  @POST('/apps/installed/loadport')
  Future<int> getAppPort(@Body() Map<String, dynamic> request);

  /// 操作已安装应用
  @POST('/apps/installed/op')
  Future<void> operateApp(@Body() AppInstalledOperateRequest request);

  /// 根据应用安装ID获取参数
  @GET('/apps/installed/params/{appInstallId}')
  Future<Map<String, dynamic>> getAppParamsByInstallId(@Path('appInstallId') String appInstallId);

  /// 更新应用参数
  @POST('/apps/installed/params/update')
  Future<void> updateAppParams(@Body() Map<String, dynamic> request);

  /// 修改应用端口
  @POST('/apps/installed/port/change')
  Future<void> changeAppPort(@Body() Map<String, dynamic> request);

  /// 分页查询已安装应用
  @POST('/apps/installed/search')
  Future<PageResult<AppInstall>> searchInstalledApps(@Body() AppInstalledSearchRequest request);

  /// 同步已安装应用
  @POST('/apps/installed/sync')
  Future<void> syncInstalledApps();

  /// 获取应用可更新版本
  @GET('/apps/installed/update/versions/{appInstallId}')
  Future<List<Map<String, dynamic>>> getAppUpdateVersions(@Path('appInstallId') int appInstallId);
}