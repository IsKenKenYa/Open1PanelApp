import '../../api/v2/monitor_v2.dart';
import '../../core/services/base_component.dart';
import '../../data/models/monitoring_models.dart';

class MonitoringService extends BaseComponent {
  MonitoringService({
    MonitorV2Api? api,
    super.clientManager,
    super.permissionResolver,
  }) : _api = api;

  MonitorV2Api? _api;

  Future<MonitorV2Api> _ensureApi() async {
    if (_api != null) {
      return _api!;
    }
    _api = await clientManager.getMonitorApi();
    return _api!;
  }

  Future<SystemMetrics> getSystemMetrics({
    required MetricType metricType,
    String timeRange = '1h',
  }) {
    return runGuarded(() async {
      final api = await _ensureApi();
      final response = await api.getSystemMetrics(
        metricType: metricType,
        timeRange: timeRange,
      );
      return response.data ?? const SystemMetrics();
    });
  }

  Future<List<NetworkMetrics>> getNetworkMetrics({
    String? networkInterface,
    String timeRange = '1h',
  }) {
    return runGuarded(() async {
      final api = await _ensureApi();
      final response = await api.getNetworkMetrics(
        interface: networkInterface,
        timeRange: timeRange,
      );
      return response.data ?? [];
    });
  }
}
