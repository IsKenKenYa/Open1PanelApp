import 'package:flutter_test/flutter_test.dart';
import 'package:onepanelapp_app/data/models/monitoring_models.dart';
import 'package:onepanelapp_app/features/monitoring/monitoring_provider.dart';
import 'package:onepanelapp_app/features/monitoring/monitoring_service.dart';

class FakeMonitoringService extends MonitoringService {
  @override
  Future<SystemMetrics> getSystemMetrics({
    required MetricType metricType,
    String timeRange = '1h',
  }) async {
    return SystemMetrics(
      type: metricType,
      unit: '%',
      current: 0.6,
      min: 0.2,
      max: 0.9,
      avg: 0.5,
      dataPoints: const [
        MetricDataPoint(value: 0.2),
        MetricDataPoint(value: 0.6),
        MetricDataPoint(value: 0.9),
      ],
    );
  }

  @override
  Future<List<NetworkMetrics>> getNetworkMetrics({
    String? networkInterface,
    String timeRange = '1h',
  }) async {
    return const [
      NetworkMetrics(
        interface: 'eth0',
        bytesReceived: 1024,
        bytesSent: 2048,
        receiveSpeed: 12.5,
        transmitSpeed: 8.3,
      ),
    ];
  }
}

class ErrorMonitoringService extends MonitoringService {
  @override
  Future<SystemMetrics> getSystemMetrics({
    required MetricType metricType,
    String timeRange = '1h',
  }) async {
    throw Exception('加载失败');
  }
}

void main() {
  test('MonitoringProvider成功加载数据', () async {
    final provider = MonitoringProvider(service: FakeMonitoringService());
    var notified = 0;
    provider.addListener(() => notified++);

    await provider.load();

    expect(notified, greaterThan(0));
    expect(provider.data.error, isNull);
    expect(provider.data.cpuMetrics?.current, 0.6);
    expect(provider.data.networkMetrics.length, 1);
  });

  test('MonitoringProvider处理错误状态', () async {
    final provider = MonitoringProvider(service: ErrorMonitoringService());
    await provider.load();
    expect(provider.data.error, isNotNull);
  });
}
