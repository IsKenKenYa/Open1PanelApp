import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../api/v2/dashboard_v2.dart';
import '../../api/v2/logs_v2.dart';
import '../../api/v2/update_v2.dart';
import '../../core/network/api_client_manager.dart';
import '../../data/models/common_models.dart';
import '../../data/models/logs_models.dart';

/// 仪表盘数据模型
class DashboardData {
  final SystemInfo? systemInfo;
  final List<DashboardActivity> activities;
  final DateTime? lastUpdated;
  final bool isLoading;
  final String? error;

  const DashboardData({
    this.systemInfo,
    this.activities = const [],
    this.lastUpdated,
    this.isLoading = false,
    this.error,
  });

  DashboardData copyWith({
    SystemInfo? systemInfo,
    List<DashboardActivity>? activities,
    DateTime? lastUpdated,
    bool? isLoading,
    String? error,
  }) {
    return DashboardData(
      systemInfo: systemInfo ?? this.systemInfo,
      activities: activities ?? this.activities,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  /// 获取CPU使用率
  double? get cpuPercent => systemInfo?.cpuUsage;

  /// 获取内存使用率
  double? get memoryPercent {
    return systemInfo?.memoryUsage;
  }

  /// 获取内存使用信息
  String get memoryUsage {
    if (systemInfo == null) return '--';
    final used = _formatBytes(systemInfo!.usedMemory ?? 0);
    final total = _formatBytes(systemInfo!.totalMemory ?? 0);
    return '$used / $total';
  }

  /// 获取磁盘使用率
  double? get diskPercent {
    return systemInfo?.diskUsage;
  }

  /// 获取磁盘使用信息
  String get diskUsage {
    if (systemInfo == null) return '--';
    final used = _formatBytes(systemInfo!.usedDisk ?? 0);
    final total = _formatBytes(systemInfo!.totalDisk ?? 0);
    return '$used / $total';
  }

  /// 获取运行时间
  String get uptime {
    final uptimeValue = systemInfo?.uptime;
    if (uptimeValue == null || uptimeValue.isEmpty) return '--';
    return uptimeValue;
  }

  /// 格式化字节数
  static String _formatBytes(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
  }
}

/// 仪表盘活动项
class DashboardActivity {
  final String title;
  final String description;
  final DateTime time;
  final ActivityType type;

  const DashboardActivity({
    required this.title,
    required this.description,
    required this.time,
    this.type = ActivityType.info,
  });
}

enum ActivityType { info, success, warning, error }

/// Dashboard状态管理器
class DashboardProvider extends ChangeNotifier {
  DashboardProvider({
    DashboardV2Api? dashboardApi,
    LogsV2Api? logsApi,
    UpdateV2Api? updateApi,
  })  : _dashboardApi = dashboardApi,
        _logsApi = logsApi,
        _updateApi = updateApi;

  DashboardV2Api? _dashboardApi;
  LogsV2Api? _logsApi;
  UpdateV2Api? _updateApi;
  Timer? _refreshTimer;

  DashboardData _data = const DashboardData();

  DashboardData get data => _data;

  /// 获取API客户端
  Future<void> _ensureApiClients() async {
    if (_dashboardApi == null || _logsApi == null || _updateApi == null) {
      final manager = ApiClientManager.instance;
      _dashboardApi = await manager.getDashboardApi();
      _logsApi = await manager.getLogsApi();
      _updateApi = await manager.getUpdateApi();
    }
  }

  /// 加载仪表盘数据
  Future<void> loadData() async {
    _data = _data.copyWith(isLoading: true, error: null);
    notifyListeners();

    try {
      await _ensureApiClients();

      final systemInfoResponse = await _dashboardApi!.getOperatingSystemInfo();
      final activities = await _loadActivities();

      _data = _data.copyWith(
        systemInfo: systemInfoResponse.data,
        activities: activities,
        lastUpdated: DateTime.now(),
        isLoading: false,
      );
    } catch (e) {
      _data = _data.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
    notifyListeners();
  }

  /// 刷新数据
  Future<void> refresh() async {
    await loadData();
  }

  /// 开始自动刷新
  void startAutoRefresh({Duration interval = const Duration(seconds: 30)}) {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(interval, (_) {
      loadData();
    });
  }

  /// 停止自动刷新
  void stopAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  Future<List<DashboardActivity>> _loadActivities() async {
    final response = await _logsApi!.getSystemLogs(const LogSearch(page: 1, pageSize: 5));
    final result = response.data as PageResult<LogInfo>;
    return result.items.map((log) {
      return DashboardActivity(
        title: log.message,
        description: log.type,
        time: log.timestamp ?? DateTime.now(),
        type: _mapLogLevel(log.level),
      );
    }).toList();
  }

  ActivityType _mapLogLevel(String level) {
    switch (level.toLowerCase()) {
      case 'error':
        return ActivityType.error;
      case 'warn':
      case 'warning':
        return ActivityType.warning;
      case 'info':
        return ActivityType.info;
      case 'success':
        return ActivityType.success;
      default:
        return ActivityType.info;
    }
  }

  Future<void> restartSystem() async {
    await _ensureApiClients();
    await _dashboardApi!.systemRestart('restart');
  }

  Future<void> upgradeSystem() async {
    await _ensureApiClients();
    await _updateApi!.systemUpgrade();
  }

  /// 清除错误
  void clearError() {
    _data = _data.copyWith(error: null);
    notifyListeners();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }
}
