import 'package:flutter/foundation.dart';
import 'package:onepanelapp_app/core/config/api_config.dart';
import 'package:onepanelapp_app/core/network/api_client_manager.dart';
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

      double? cpuPercent;
      double? memoryPercent;
      double? diskPercent;
      double? load;

      try {
        final now = DateTime.now();
        final startTime = now.subtract(const Duration(hours: 1));
        
        final response = await client.post(
          '/api/v2/hosts/monitor/search',
          data: {
            'param': 'all',
            'startTime': startTime.toUtc().toIso8601String(),
            'endTime': now.toUtc().toIso8601String(),
          },
        );
        
        if (response.data != null && response.data is Map) {
          final responseData = response.data as Map<String, dynamic>;
          final dataList = responseData['data'] as List?;
          
          if (dataList != null) {
            for (final item in dataList) {
              if (item is Map<String, dynamic>) {
                final param = item['param'] as String?;
                final values = item['value'] as List?;
                
                if (values != null && values.isNotEmpty) {
                  final lastValue = values.last;
                  
                  if (lastValue is Map<String, dynamic>) {
                    switch (param) {
                      case 'base':
                        cpuPercent = (lastValue['cpu'] as num?)?.toDouble();
                        memoryPercent = (lastValue['memory'] as num?)?.toDouble();
                        load = (lastValue['cpuLoad1'] as num?)?.toDouble();
                        break;
                      case 'cpu':
                        if (cpuPercent == null) {
                          cpuPercent = (lastValue['cpu'] as num?)?.toDouble();
                        }
                        break;
                      case 'memory':
                        if (memoryPercent == null) {
                          memoryPercent = (lastValue['memory'] as num?)?.toDouble();
                        }
                        break;
                      case 'load':
                        if (load == null) {
                          load = (lastValue['cpuLoad1'] as num?)?.toDouble();
                        }
                        break;
                      case 'io':
                        if (diskPercent == null) {
                          diskPercent = (lastValue['disk'] as num?)?.toDouble();
                        }
                        break;
                    }
                  }
                }
              }
            }
          }
        }
      } catch (e) {
        debugPrint('[ServerRepository] Metrics fetch error: $e');
      }

      return ServerMetricsSnapshot(
        cpuPercent: cpuPercent,
        memoryPercent: memoryPercent,
        diskPercent: diskPercent,
        load: load,
      );
    } catch (e, stack) {
      debugPrint('[ServerRepository] Error loading metrics: $e');
      debugPrint('[ServerRepository] Stack: $stack');
      return const ServerMetricsSnapshot();
    }
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
