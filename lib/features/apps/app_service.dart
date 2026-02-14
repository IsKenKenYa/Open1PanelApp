import '../../api/v2/app_v2.dart';
import '../../core/services/base_component.dart';
import '../../data/models/app_models.dart';

class AppService extends BaseComponent {
  AppService({
    AppV2Api? api,
    super.clientManager,
    super.permissionResolver,
  }) : _api = api;

  AppV2Api? _api;

  Future<AppV2Api> _ensureApi() async {
    if (_api != null) {
      return _api!;
    }
    _api = await clientManager.getAppApi();
    return _api!;
  }

  Future<List<AppItem>> searchApps(AppSearchRequest request) {
    return runGuarded(() async {
      final api = await _ensureApi();
      final response = await api.searchApps(request);
      return response.items;
    });
  }

  Future<List<AppInstallInfo>> getInstalledApps() {
    return runGuarded(() async {
      final api = await _ensureApi();
      return api.getInstalledApps();
    });
  }

  Future<void> installApp(AppInstallCreateRequest request) {
    return runGuarded(() async {
      final api = await _ensureApi();
      await api.installApp(request);
    });
  }

  Future<void> uninstallApp(String installId) {
    return runGuarded(() async {
      final api = await _ensureApi();
      await api.uninstallApp(installId);
    });
  }

  Future<void> operateApp(int installId, String operate) {
    return runGuarded(() async {
      final api = await _ensureApi();
      await api.operateApp(
        AppInstalledOperateRequest(
          installId: installId,
          operate: operate,
        ),
      );
    });
  }

  Future<void> syncInstalledApps() {
    return runGuarded(() async {
      final api = await _ensureApi();
      await api.syncAppStatus();
    });
  }
}
