/// 应用管理状态管理
///
/// 管理应用商店和已安装应用数据

import 'package:flutter/foundation.dart';
import '../../data/models/app_models.dart';
import 'app_service.dart';

/// 应用统计数据
class AppStats {
  final int total;
  final int installed;
  final int running;
  final int stopped;

  const AppStats({
    this.total = 0,
    this.installed = 0,
    this.running = 0,
    this.stopped = 0,
  });
}

/// 应用数据状态
class AppsData {
  final List<AppItem> availableApps;
  final List<AppInstallInfo> installedApps;
  final AppStats stats;
  final bool isLoading;
  final String? error;
  final DateTime? lastUpdated;

  const AppsData({
    this.availableApps = const [],
    this.installedApps = const [],
    this.stats = const AppStats(),
    this.isLoading = false,
    this.error,
    this.lastUpdated,
  });

  AppsData copyWith({
    List<AppItem>? availableApps,
    List<AppInstallInfo>? installedApps,
    AppStats? stats,
    bool? isLoading,
    String? error,
    DateTime? lastUpdated,
  }) {
    return AppsData(
      availableApps: availableApps ?? this.availableApps,
      installedApps: installedApps ?? this.installedApps,
      stats: stats ?? this.stats,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

/// 应用管理状态管理器
class AppsProvider extends ChangeNotifier {
  AppsProvider({AppService? service}) : _service = service;

  AppService? _service;

  AppsData _data = const AppsData();

  AppsData get data => _data;

  Future<void> _ensureService() async {
    _service ??= AppService();
  }

  /// 加载应用商店数据
  Future<void> loadAvailableApps() async {
    _data = _data.copyWith(isLoading: true, error: null);
    notifyListeners();

    try {
      await _ensureService();

      final apps = await _service!.searchApps(
        AppSearchRequest(
          page: 1,
          pageSize: 100,
        ),
      );

      _data = _data.copyWith(
        availableApps: apps,
        isLoading: false,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      _data = _data.copyWith(
        isLoading: false,
        error: '加载应用列表失败: $e',
      );
    }
    notifyListeners();
  }

  /// 加载已安装应用
  Future<void> loadInstalledApps() async {
    _data = _data.copyWith(isLoading: true, error: null);
    notifyListeners();

    try {
      await _ensureService();

      final apps = await _service!.getInstalledApps();

      // 计算统计
      int running = 0, stopped = 0;
      for (final app in apps) {
        if (app.status?.toLowerCase() == 'running') {
          running++;
        } else {
          stopped++;
        }
      }

      _data = _data.copyWith(
        installedApps: apps,
        stats: AppStats(
          total: apps.length,
          installed: apps.length,
          running: running,
          stopped: stopped,
        ),
        isLoading: false,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      _data = _data.copyWith(
        isLoading: false,
        error: '加载已安装应用失败: $e',
      );
    }
    notifyListeners();
  }

  /// 加载所有数据
  Future<void> loadAll() async {
    _data = _data.copyWith(isLoading: true, error: null);
    notifyListeners();

    try {
      await _ensureService();

      // 并行加载应用商店和已安装应用
      await Future.wait([
        loadAvailableApps(),
        loadInstalledApps(),
      ]);
    } catch (e) {
      _data = _data.copyWith(
        isLoading: false,
        error: '加载数据失败: $e',
      );
      notifyListeners();
    }
  }

  /// 安装应用
  Future<bool> installApp(AppInstallCreateRequest request) async {
    try {
      await _ensureService();
      await _service!.installApp(request);
      await loadInstalledApps(); // 刷新已安装列表
      return true;
    } catch (e) {
      _data = _data.copyWith(error: '安装应用失败: $e');
      notifyListeners();
      return false;
    }
  }

  /// 卸载应用
  Future<bool> uninstallApp(String installId) async {
    try {
      await _ensureService();
      await _service!.uninstallApp(installId);
      await loadInstalledApps(); // 刷新已安装列表
      return true;
    } catch (e) {
      _data = _data.copyWith(error: '卸载应用失败: $e');
      notifyListeners();
      return false;
    }
  }

  /// 启动应用
  Future<bool> startApp(String installId) async {
    try {
      await _ensureService();
      final id = int.tryParse(installId);
      if (id == null) {
        _data = _data.copyWith(error: '启动应用失败: 无效应用ID');
        notifyListeners();
        return false;
      }
      await _service!.operateApp(id, 'start');
      await loadInstalledApps(); // 刷新列表
      return true;
    } catch (e) {
      _data = _data.copyWith(error: '启动应用失败: $e');
      notifyListeners();
      return false;
    }
  }

  /// 停止应用
  Future<bool> stopApp(String installId) async {
    try {
      await _ensureService();
      final id = int.tryParse(installId);
      if (id == null) {
        _data = _data.copyWith(error: '停止应用失败: 无效应用ID');
        notifyListeners();
        return false;
      }
      await _service!.operateApp(id, 'stop');
      await loadInstalledApps(); // 刷新列表
      return true;
    } catch (e) {
      _data = _data.copyWith(error: '停止应用失败: $e');
      notifyListeners();
      return false;
    }
  }

  /// 重启应用
  Future<bool> restartApp(String installId) async {
    try {
      await _ensureService();
      final id = int.tryParse(installId);
      if (id == null) {
        _data = _data.copyWith(error: '重启应用失败: 无效应用ID');
        notifyListeners();
        return false;
      }
      await _service!.operateApp(id, 'restart');
      await loadInstalledApps(); // 刷新列表
      return true;
    } catch (e) {
      _data = _data.copyWith(error: '重启应用失败: $e');
      notifyListeners();
      return false;
    }
  }

  /// 刷新数据
  Future<void> refresh() async {
    await loadAll();
  }

  /// 清除错误
  void clearError() {
    _data = _data.copyWith(error: null);
    notifyListeners();
  }
}
