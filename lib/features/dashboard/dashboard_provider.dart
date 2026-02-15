import 'dart:async';
import 'package:flutter/material.dart';
import '../../api/v2/dashboard_v2.dart';
import '../../data/models/common_models.dart';
import '../../data/models/dashboard_models.dart';
import '../../core/network/api_client_manager.dart';

enum DashboardStatus { initial, loading, loaded, error }

class NodeInfo {
  final String? name;
  final String? status;
  final String? version;
  final String? ip;

  const NodeInfo({
    this.name,
    this.status,
    this.version,
    this.ip,
  });

  factory NodeInfo.fromJson(Map<String, dynamic> json) {
    return NodeInfo(
      name: json['name'] as String?,
      status: json['status'] as String?,
      version: json['version'] as String?,
      ip: json['ip'] as String?,
    );
  }
}

class AppLauncherOption {
  final String key;
  final String name;
  final String? icon;

  const AppLauncherOption({
    required this.key,
    required this.name,
    this.icon,
  });

  factory AppLauncherOption.fromJson(Map<String, dynamic> json) {
    return AppLauncherOption(
      key: json['key'] as String? ?? '',
      name: json['name'] as String? ?? '',
      icon: json['icon'] as String?,
    );
  }
}

class AppLauncherItem {
  final String key;
  final String name;
  final String? icon;
  final String? url;

  const AppLauncherItem({
    required this.key,
    required this.name,
    this.icon,
    this.url,
  });

  factory AppLauncherItem.fromJson(Map<String, dynamic> json) {
    return AppLauncherItem(
      key: json['key'] as String? ?? '',
      name: json['name'] as String? ?? '',
      icon: json['icon'] as String?,
      url: json['url'] as String?,
    );
  }
}

class QuickJumpOption {
  final String key;
  final String name;
  final String? icon;
  final bool enabled;

  const QuickJumpOption({
    required this.key,
    required this.name,
    this.icon,
    this.enabled = true,
  });

  factory QuickJumpOption.fromJson(Map<String, dynamic> json) {
    return QuickJumpOption(
      key: json['key'] as String? ?? '',
      name: json['name'] as String? ?? '',
      icon: json['icon'] as String?,
      enabled: json['enabled'] as bool? ?? true,
    );
  }
}

class DashboardData {
  final SystemInfo? systemInfo;
  final DashboardMetrics? metrics;
  final NodeInfo? nodeInfo;
  final double? cpuPercent;
  final double? memoryPercent;
  final double? diskPercent;
  final String memoryUsage;
  final String diskUsage;
  final String uptime;
  final DateTime? lastUpdated;
  final List<ProcessInfo> topCpuProcesses;
  final List<ProcessInfo> topMemoryProcesses;
  final List<AppLauncherItem> appLaunchers;
  final List<AppLauncherOption> appLauncherOptions;
  final List<QuickJumpOption> quickOptions;

  const DashboardData({
    this.systemInfo,
    this.metrics,
    this.nodeInfo,
    this.cpuPercent,
    this.memoryPercent,
    this.diskPercent,
    this.memoryUsage = '--',
    this.diskUsage = '--',
    this.uptime = '--',
    this.lastUpdated,
    this.topCpuProcesses = const [],
    this.topMemoryProcesses = const [],
    this.appLaunchers = const [],
    this.appLauncherOptions = const [],
    this.quickOptions = const [],
  });

  DashboardData copyWith({
    SystemInfo? systemInfo,
    DashboardMetrics? metrics,
    NodeInfo? nodeInfo,
    double? cpuPercent,
    double? memoryPercent,
    double? diskPercent,
    String? memoryUsage,
    String? diskUsage,
    String? uptime,
    DateTime? lastUpdated,
    List<ProcessInfo>? topCpuProcesses,
    List<ProcessInfo>? topMemoryProcesses,
    List<AppLauncherItem>? appLaunchers,
    List<AppLauncherOption>? appLauncherOptions,
    List<QuickJumpOption>? quickOptions,
  }) {
    return DashboardData(
      systemInfo: systemInfo ?? this.systemInfo,
      metrics: metrics ?? this.metrics,
      nodeInfo: nodeInfo ?? this.nodeInfo,
      cpuPercent: cpuPercent ?? this.cpuPercent,
      memoryPercent: memoryPercent ?? this.memoryPercent,
      diskPercent: diskPercent ?? this.diskPercent,
      memoryUsage: memoryUsage ?? this.memoryUsage,
      diskUsage: diskUsage ?? this.diskUsage,
      uptime: uptime ?? this.uptime,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      topCpuProcesses: topCpuProcesses ?? this.topCpuProcesses,
      topMemoryProcesses: topMemoryProcesses ?? this.topMemoryProcesses,
      appLaunchers: appLaunchers ?? this.appLaunchers,
      appLauncherOptions: appLauncherOptions ?? this.appLauncherOptions,
      quickOptions: quickOptions ?? this.quickOptions,
    );
  }
}

enum ActivityType { success, warning, error, info }

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

class DashboardProvider extends ChangeNotifier {
  DashboardV2Api? _api;
  Timer? _refreshTimer;

  DashboardStatus _status = DashboardStatus.initial;
  DashboardData _data = const DashboardData();
  String _errorMessage = '';
  List<DashboardActivity> _activities = [];
  bool _isLoadingTopProcesses = false;
  bool _isLoadingAppLaunchers = false;
  bool _isLoadingQuickOptions = false;
  
  // 自动刷新设置
  Duration _refreshInterval = const Duration(seconds: 5);
  bool _autoRefreshEnabled = false;

  DashboardStatus get status => _status;
  DashboardData get data => _data;
  String get errorMessage => _errorMessage;
  List<DashboardActivity> get activities => _activities;
  bool get isLoadingTopProcesses => _isLoadingTopProcesses;
  bool get isLoadingAppLaunchers => _isLoadingAppLaunchers;
  bool get isLoadingQuickOptions => _isLoadingQuickOptions;
  Duration get refreshInterval => _refreshInterval;
  bool get autoRefreshEnabled => _autoRefreshEnabled;

  /// 设置刷新间隔
  void setRefreshInterval(Duration interval) {
    _refreshInterval = interval;
    if (_autoRefreshEnabled) {
      _stopAutoRefresh();
      _startAutoRefresh();
    }
    notifyListeners();
  }

  /// 启用/禁用自动刷新
  void toggleAutoRefresh(bool enabled) {
    _autoRefreshEnabled = enabled;
    if (enabled) {
      _startAutoRefresh();
    } else {
      _stopAutoRefresh();
    }
    notifyListeners();
  }

  void _startAutoRefresh() {
    _stopAutoRefresh();
    _refreshTimer = Timer.periodic(_refreshInterval, (_) {
      loadData();
    });
  }

  void _stopAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  Future<DashboardV2Api> _getApi() async {
    _api ??= await ApiClientManager.instance.getDashboardApi();
    return _api!;
  }

  Future<void> loadData() async {
    _status = DashboardStatus.loading;
    notifyListeners();

    try {
      final api = await _getApi();

      debugPrint('[DashboardProvider] Loading base info...');
      final baseResponse = await api.getDashboardBase();
      debugPrint('[DashboardProvider] Base response received');

      final baseData = baseResponse.data;

      // 从真实API响应中提取数据
      // baseData 包含: hostname, ipV4Addr, cpuCores, currentInfo 等
      // currentInfo 包含实时指标: cpuUsedPercent, memoryUsedPercent, diskData 等
      final currentInfo = baseData?['currentInfo'] as Map<String, dynamic>?;
      
      // 主机名 - 从 baseData 获取
      final hostname = baseData?['hostname'] as String?;
      
      // CPU百分比 - 从 currentInfo.cpuUsedPercent 获取
      final cpuPercent = (currentInfo?['cpuUsedPercent'] as num?)?.toDouble();
      
      // 内存百分比
      final memoryPercent = (currentInfo?['memoryUsedPercent'] as num?)?.toDouble();
      
      // 磁盘数据 - 从 currentInfo.diskData 数组获取
      final diskDataList = currentInfo?['diskData'] as List?;
      double? diskPercent;
      String? diskUsage;
      if (diskDataList != null && diskDataList.isNotEmpty) {
        final mainDisk = diskDataList.first as Map<String, dynamic>;
        diskPercent = (mainDisk['usedPercent'] as num?)?.toDouble();
        final used = mainDisk['used'] as int?;
        final total = mainDisk['total'] as int?;
        if (used != null && total != null) {
          diskUsage = '${_formatBytes(used)} / ${_formatBytes(total)}';
        }
      }

      // 负载
      final load1 = (currentInfo?['load1'] as num?)?.toDouble();
      final load5 = (currentInfo?['load5'] as num?)?.toDouble();
      final load15 = (currentInfo?['load15'] as num?)?.toDouble();

      // 运行时间
      final uptime = currentInfo?['uptime'] as int?;
      final uptimeStr = uptime != null ? _formatUptime(uptime) : '--';

      // 内存使用情况
      final memoryUsed = currentInfo?['memoryUsed'] as int?;
      final memoryTotal = currentInfo?['memoryTotal'] as int?;

      debugPrint('[DashboardProvider] hostname: $hostname');
      debugPrint('[DashboardProvider] cpuPercent: $cpuPercent, memoryPercent: $memoryPercent, diskPercent: $diskPercent');
      debugPrint('[DashboardProvider] load1: $load1, load5: $load5, load15: $load15');

      _data = DashboardData(
        systemInfo: null,
        metrics: baseData != null ? DashboardMetrics.fromJson(baseData) : null,
        cpuPercent: cpuPercent,
        memoryPercent: memoryPercent,
        diskPercent: diskPercent,
        memoryUsage: memoryPercent != null 
            ? '${memoryPercent.toStringAsFixed(1)}%' 
            : (memoryUsed != null && memoryTotal != null 
                ? '${_formatBytes(memoryUsed)} / ${_formatBytes(memoryTotal)}' 
                : '--'),
        diskUsage: diskUsage ?? (diskPercent != null ? '${diskPercent.toStringAsFixed(1)}%' : '--'),
        uptime: uptimeStr,
        lastUpdated: DateTime.now(),
      );

      _status = DashboardStatus.loaded;
      _errorMessage = '';
    } catch (e, stack) {
      debugPrint('[DashboardProvider] Error: $e');
      debugPrint('[DashboardProvider] Stack: $stack');
      _status = DashboardStatus.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  String _formatMemoryUsageFromNode(Map<String, dynamic>? nodeData) {
    if (nodeData == null) return '--';
    
    final used = nodeData['memoryUsed'] as int?;
    final total = nodeData['memoryTotal'] as int?;
    final percent = nodeData['memoryUsedPercent'] as num?;
    
    if (percent != null) {
      return '${percent.toStringAsFixed(1)}%';
    }
    
    if (used != null && total != null) {
      return '${_formatBytes(used)} / ${_formatBytes(total)}';
    }
    return '--';
  }

  String _formatUptime(int seconds) {
    final days = seconds ~/ 86400;
    final hours = (seconds % 86400) ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    
    if (days > 0) {
      return '${days}天 ${hours}小时';
    } else if (hours > 0) {
      return '${hours}小时 ${minutes}分钟';
    } else {
      return '${minutes}分钟';
    }
  }

  Future<void> loadTopProcesses() async {
    _isLoadingTopProcesses = true;
    notifyListeners();

    try {
      final api = await _getApi();

      final cpuResponse = await api.getTopCPUProcesses();
      final memResponse = await api.getTopMemoryProcesses();

      final cpuProcesses = _parseProcessList(cpuResponse.data);
      final memoryProcesses = _parseProcessList(memResponse.data);

      _data = _data.copyWith(
        topCpuProcesses: cpuProcesses,
        topMemoryProcesses: memoryProcesses,
      );
    } catch (e) {
      debugPrint('Failed to load top processes: $e');
    }

    _isLoadingTopProcesses = false;
    notifyListeners();
  }

  Future<void> loadAppLaunchers() async {
    _isLoadingAppLaunchers = true;
    notifyListeners();

    try {
      final api = await _getApi();
      final response = await api.getAppLauncher();
      final data = response.data;

      if (data != null) {
        final list = data['list'] as List<dynamic>? ?? 
                     data['launchers'] as List<dynamic>? ?? 
                     data['items'] as List<dynamic>? ?? [];

        final launchers = list
            .map((item) => AppLauncherItem.fromJson(item as Map<String, dynamic>))
            .toList();

        _data = _data.copyWith(appLaunchers: launchers);
      }
    } catch (e) {
      debugPrint('Failed to load app launchers: $e');
    }

    _isLoadingAppLaunchers = false;
    notifyListeners();
  }

  Future<void> loadAppLauncherOptions() async {
    try {
      final api = await _getApi();
      final response = await api.getAppLauncherOption();
      final data = response.data;

      if (data != null) {
        final list = data['list'] as List<dynamic>? ?? 
                     data['options'] as List<dynamic>? ?? 
                     data['items'] as List<dynamic>? ?? [];

        final options = list
            .map((item) => AppLauncherOption.fromJson(item as Map<String, dynamic>))
            .toList();

        _data = _data.copyWith(appLauncherOptions: options);
      }
    } catch (e) {
      debugPrint('Failed to load app launcher options: $e');
    }

    notifyListeners();
  }

  Future<void> loadCurrentNode() async {
    try {
      final api = await _getApi();
      final response = await api.getCurrentNode();
      final data = response.data;

      if (data != null) {
        final nodeInfo = NodeInfo.fromJson(data);
        _data = _data.copyWith(nodeInfo: nodeInfo);
      }
    } catch (e) {
      debugPrint('Failed to load current node: $e');
    }

    notifyListeners();
  }

  Future<void> updateAppLauncherShow(String key, bool show) async {
    try {
      final api = await _getApi();
      await api.updateAppLauncherShow(request: {'key': key, 'show': show});
      await loadAppLaunchers();
      _addActivity(
        title: 'App Launcher Updated',
        description: 'App launcher visibility changed for $key',
        type: ActivityType.success,
      );
    } catch (e) {
      debugPrint('Failed to update app launcher: $e');
      rethrow;
    }
  }

  Future<void> loadQuickOptions() async {
    _isLoadingQuickOptions = true;
    notifyListeners();

    try {
      final api = await _getApi();
      final response = await api.getQuickOption();
      final data = response.data;

      if (data != null) {
        final list = data['list'] as List<dynamic>? ?? 
                     data['options'] as List<dynamic>? ?? 
                     data['items'] as List<dynamic>? ?? [];

        final options = list
            .map((item) => QuickJumpOption.fromJson(item as Map<String, dynamic>))
            .toList();

        _data = _data.copyWith(quickOptions: options);
      }
    } catch (e) {
      debugPrint('Failed to load quick options: $e');
    }

    _isLoadingQuickOptions = false;
    notifyListeners();
  }

  Future<void> updateQuickChange(List<String> enabledKeys) async {
    try {
      final api = await _getApi();
      await api.updateQuickChange(request: {'keys': enabledKeys});
      await loadQuickOptions();
      _addActivity(
        title: 'Quick Options Updated',
        description: 'Quick jump options have been updated',
        type: ActivityType.success,
      );
    } catch (e) {
      debugPrint('Failed to update quick options: $e');
      rethrow;
    }
  }

  List<ProcessInfo> _parseProcessList(dynamic data) {
    if (data == null) return [];
    
    if (data is List) {
      return data
          .map((item) => ProcessInfo.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    
    if (data is Map<String, dynamic>) {
      final list = data['list'] as List<dynamic>? ?? 
                   data['processes'] as List<dynamic>? ??
                   data['items'] as List<dynamic>?;
      
      if (list == null) return [];

      return list
          .map((item) => ProcessInfo.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    
    return [];
  }

  String _formatMemoryUsage(Map<String, dynamic>? baseData) {
    final used = baseData?['memoryUsed'] as int?;
    final total = baseData?['memoryTotal'] as int?;
    
    if (used != null && total != null) {
      return '${_formatBytes(used)} / ${_formatBytes(total)}';
    }
    return '--';
  }

  String _formatDiskUsage(Map<String, dynamic>? baseData) {
    final used = baseData?['diskUsed'] as int?;
    final total = baseData?['diskTotal'] as int?;
    if (used != null && total != null) {
      return '${_formatBytes(used)} / ${_formatBytes(total)}';
    }
    return '--';
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  Future<void> refresh() async {
    await loadData();
    await loadTopProcesses();
  }

  Future<void> restartSystem() async {
    final api = await _getApi();
    await api.systemRestart('restart');
    _addActivity(
      title: 'System Restart',
      description: 'System restart command sent successfully',
      type: ActivityType.success,
    );
  }

  Future<void> shutdownSystem() async {
    final api = await _getApi();
    await api.systemRestart('shutdown');
    _addActivity(
      title: 'System Shutdown',
      description: 'System shutdown command sent',
      type: ActivityType.warning,
    );
  }

  Future<void> upgradeSystem() async {
    final api = await _getApi();
    await api.systemRestart('restart');
    _addActivity(
      title: 'System Upgrade',
      description: 'System upgrade initiated',
      type: ActivityType.info,
    );
  }

  void _addActivity({
    required String title,
    required String description,
    ActivityType type = ActivityType.info,
  }) {
    _activities.insert(
      0,
      DashboardActivity(
        title: title,
        description: description,
        time: DateTime.now(),
        type: type,
      ),
    );
    if (_activities.length > 10) {
      _activities = _activities.sublist(0, 10);
    }
    notifyListeners();
  }

  void startAutoRefresh({Duration interval = const Duration(seconds: 30)}) {
    stopAutoRefresh();
    _refreshTimer = Timer.periodic(interval, (timer) async {
      if (_status == DashboardStatus.loaded) {
        await refresh();
      }
    });
  }

  void stopAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  @override
  void dispose() {
    stopAutoRefresh();
    super.dispose();
  }
}
