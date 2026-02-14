import 'package:flutter/foundation.dart';
import '../../data/models/monitoring_models.dart';
import 'monitoring_service.dart';

class MonitoringData {
  final bool isLoading;
  final String? error;
  final SystemMetrics? cpuMetrics;
  final SystemMetrics? memoryMetrics;
  final SystemMetrics? diskMetrics;
  final List<NetworkMetrics> networkMetrics;
  final DateTime? lastUpdated;

  const MonitoringData({
    this.isLoading = false,
    this.error,
    this.cpuMetrics,
    this.memoryMetrics,
    this.diskMetrics,
    this.networkMetrics = const [],
    this.lastUpdated,
  });

  MonitoringData copyWith({
    bool? isLoading,
    String? error,
    SystemMetrics? cpuMetrics,
    SystemMetrics? memoryMetrics,
    SystemMetrics? diskMetrics,
    List<NetworkMetrics>? networkMetrics,
    DateTime? lastUpdated,
  }) {
    return MonitoringData(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      cpuMetrics: cpuMetrics ?? this.cpuMetrics,
      memoryMetrics: memoryMetrics ?? this.memoryMetrics,
      diskMetrics: diskMetrics ?? this.diskMetrics,
      networkMetrics: networkMetrics ?? this.networkMetrics,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

class MonitoringProvider extends ChangeNotifier {
  MonitoringProvider({MonitoringService? service}) : _service = service;

  MonitoringService? _service;

  MonitoringData _data = const MonitoringData();

  MonitoringData get data => _data;

  Future<void> _ensureService() async {
    _service ??= MonitoringService();
  }

  Future<void> load() async {
    _data = _data.copyWith(isLoading: true, error: null);
    notifyListeners();
    try {
      await _ensureService();
      final cpu = await _service!.getSystemMetrics(metricType: MetricType.cpu);
      final memory = await _service!.getSystemMetrics(metricType: MetricType.memory);
      final disk = await _service!.getSystemMetrics(metricType: MetricType.disk);
      final network = await _service!.getNetworkMetrics();
      _data = _data.copyWith(
        cpuMetrics: cpu,
        memoryMetrics: memory,
        diskMetrics: disk,
        networkMetrics: network,
        isLoading: false,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      _data = _data.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
    notifyListeners();
  }

  Future<void> refresh() async {
    await load();
  }

  void clearError() {
    _data = _data.copyWith(error: null);
    notifyListeners();
  }
}
