import 'package:onepanelapp_app/core/config/api_config.dart';
import 'package:onepanelapp_app/core/network/api_client_manager.dart';
import 'package:onepanelapp_app/api/v2/dashboard_v2.dart';
import 'server_models.dart';

class ServerRepository {
  const ServerRepository();

  Future<List<ServerCardViewModel>> loadServerCards() async {
    final configs = await ApiConfigManager.getConfigs();
    final current = await ApiConfigManager.getCurrentConfig();

    return configs
        .map(
          (config) => ServerCardViewModel(
            config: config,
            isCurrent: current?.id == config.id,
            metrics: const ServerMetricsSnapshot(),
          ),
        )
        .toList();
  }

  Future<ServerMetricsSnapshot> loadServerMetrics(String serverId) async {
    try {
      final configs = await ApiConfigManager.getConfigs();
      final config = configs.firstWhere(
        (c) => c.id == serverId,
        orElse: () => throw Exception('Server not found'),
      );

      final manager = ApiClientManager.instance;
      final client = manager.getClient(serverId, config.url, config.apiKey);
      final api = DashboardV2Api(client);

      final response = await api.getDashboardBase();
      final data = response.data;

      if (data != null) {
        return ServerMetricsSnapshot(
          cpuPercent: _parseDouble(data['cpuPercent']),
          memoryPercent: _parseDouble(data['memoryPercent']),
          diskPercent: _parseDouble(data['diskPercent']),
          load: _parseDouble(data['load']),
        );
      }

      return const ServerMetricsSnapshot();
    } catch (e) {
      return const ServerMetricsSnapshot();
    }
  }

  double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  Future<void> setCurrent(String id) async {
    await ApiConfigManager.setCurrentConfig(id);
  }

  Future<void> removeConfig(String id) async {
    await ApiConfigManager.deleteConfig(id);
  }

  Future<void> saveConfig(ApiConfig config) async {
    await ApiConfigManager.saveConfig(config);
    await ApiConfigManager.setCurrentConfig(config.id);
  }
}
