import 'package:flutter/material.dart';
import '../../api/v2/dashboard_v2.dart';
import '../../data/models/common_models.dart';
import '../../data/models/dashboard_models.dart';
import '../../core/network/api_client_manager.dart';

enum DashboardStatus { initial, loading, loaded, error }

class DashboardData {
  final SystemInfo? systemInfo;
  final DashboardMetrics? metrics;
  final double? cpuPercent;
  final double? memoryPercent;
  final double? diskPercent;
  final String memoryUsage;
  final String diskUsage;
  final String uptime;
  final DateTime? lastUpdated;
  final List<ProcessInfo> topCpuProcesses;
  final List<ProcessInfo> topMemoryProcesses;

  const DashboardData({
    this.systemInfo,
    this.metrics,
    this.cpuPercent,
    this.memoryPercent,
    this.diskPercent,
    this.memoryUsage = '--',
    this.diskUsage = '--',
    this.uptime = '--',
    this.lastUpdated,
    this.topCpuProcesses = const [],
    this.topMemoryProcesses = const [],
  });

  DashboardData copyWith({
    SystemInfo? systemInfo,
    DashboardMetrics? metrics,
    double? cpuPercent,
    double? memoryPercent,
    double? diskPercent,
    String? memoryUsage,
    String? diskUsage,
    String? uptime,
    DateTime? lastUpdated,
    List<ProcessInfo>? topCpuProcesses,
    List<ProcessInfo>? topMemoryProcesses,
  }) {
    return DashboardData(
      systemInfo: systemInfo ?? this.systemInfo,
      metrics: metrics ?? this.metrics,
      cpuPercent: cpuPercent ?? this.cpuPercent,
      memoryPercent: memoryPercent ?? this.memoryPercent,
      diskPercent: diskPercent ?? this.diskPercent,
      memoryUsage: memoryUsage ?? this.memoryUsage,
      diskUsage: diskUsage ?? this.diskUsage,
      uptime: uptime ?? this.uptime,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      topCpuProcesses: topCpuProcesses ?? this.topCpuProcesses,
      topMemoryProcesses: topMemoryProcesses ?? this.topMemoryProcesses,
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

  DashboardStatus _status = DashboardStatus.initial;
  DashboardData _data = const DashboardData();
  String _errorMessage = '';
  List<DashboardActivity> _activities = [];
  bool _isLoadingTopProcesses = false;

  DashboardStatus get status => _status;
  DashboardData get data => _data;
  String get errorMessage => _errorMessage;
  List<DashboardActivity> get activities => _activities;
  bool get isLoadingTopProcesses => _isLoadingTopProcesses;

  Future<DashboardV2Api> _getApi() async {
    _api ??= await ApiClientManager.instance.getDashboardApi();
    return _api!;
  }

  Future<void> loadData() async {
    _status = DashboardStatus.loading;
    notifyListeners();

    try {
      final api = await _getApi();

      final osResponse = await api.getOperatingSystemInfo();
      final baseResponse = await api.getDashboardBase();
      final currentResponse = await api.getCurrentMetrics();

      final systemInfo = osResponse.data;
      final baseData = baseResponse.data;
      final currentMetrics = currentResponse.data;

      final cpuPercent = currentMetrics?.current ?? baseData?['cpuPercent'] as double?;
      final memoryPercent = baseData?['memoryPercent'] as double?;
      final diskPercent = baseData?['diskPercent'] as double?;

      _data = DashboardData(
        systemInfo: systemInfo,
        metrics: baseData != null ? DashboardMetrics.fromJson(baseData) : null,
        cpuPercent: cpuPercent,
        memoryPercent: memoryPercent,
        diskPercent: diskPercent,
        memoryUsage: _formatMemoryUsage(baseData),
        diskUsage: _formatDiskUsage(baseData),
        uptime: baseData?['uptime']?.toString() ?? '--',
        lastUpdated: DateTime.now(),
      );

      _status = DashboardStatus.loaded;
      _errorMessage = '';
    } catch (e) {
      _status = DashboardStatus.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
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

  List<ProcessInfo> _parseProcessList(Map<String, dynamic>? data) {
    if (data == null) return [];
    
    final list = data['list'] as List<dynamic>? ?? 
                 data['processes'] as List<dynamic>? ??
                 data['items'] as List<dynamic>?;
    
    if (list == null) return [];

    return list
        .map((item) => ProcessInfo.fromJson(item as Map<String, dynamic>))
        .toList();
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

  Future<void> upgradeSystem() async {
    final api = await _getApi();
    await api.systemRestart('shutdown');
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
    Future.delayed(interval, () async {
      if (_status == DashboardStatus.loaded) {
        await refresh();
        startAutoRefresh(interval: interval);
      }
    });
  }
}
