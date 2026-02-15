import 'package:flutter/foundation.dart';
import '../../api/v2/monitor_v2.dart';

/// 监控指标快照
/// 
/// 从API响应中提取的最新监控数据
class MonitorMetricsSnapshot {
  final double? cpuPercent;
  final double? memoryPercent;
  final double? diskPercent;
  final double? load1;
  final double? load5;
  final double? load15;
  final DateTime? timestamp;

  const MonitorMetricsSnapshot({
    this.cpuPercent,
    this.memoryPercent,
    this.diskPercent,
    this.load1,
    this.load5,
    this.load15,
    this.timestamp,
  });

  bool get hasData =>
      cpuPercent != null ||
      memoryPercent != null ||
      diskPercent != null ||
      load1 != null;

  factory MonitorMetricsSnapshot.empty() => const MonitorMetricsSnapshot();
}

/// 监控数据点
class MonitorDataPoint {
  final DateTime time;
  final double value;

  const MonitorDataPoint({
    required this.time,
    required this.value,
  });
}

/// 监控时间序列
class MonitorTimeSeries {
  final String name;
  final List<MonitorDataPoint> data;
  final double? min;
  final double? max;
  final double? avg;

  const MonitorTimeSeries({
    required this.name,
    required this.data,
    this.min,
    this.max,
    this.avg,
  });

  factory MonitorTimeSeries.empty(String name) => MonitorTimeSeries(name: name, data: []);
}

/// 统一监控数据仓库
/// 
/// 提供监控数据获取的统一入口，避免代码重复
/// 
/// 使用方式:
/// ```dart
/// final repo = MonitorRepository();
/// final metrics = await repo.getCurrentMetrics(client);
/// final timeSeries = await repo.getTimeSeries(client, 'cpu');
/// ```
class MonitorRepository {
  const MonitorRepository();

  /// 获取当前监控指标
  /// 
  /// 返回最新的CPU、内存、磁盘、负载数据
  Future<MonitorMetricsSnapshot> getCurrentMetrics(dynamic client) async {
    try {
      final now = DateTime.now();
      final startTime = now.subtract(const Duration(hours: 1));

      debugPrint('[MonitorRepository] Calling API...');
      final response = await client.post(
        '/api/v2/hosts/monitor/search',
        data: {
          'param': 'all',
          'startTime': startTime.toUtc().toIso8601String(),
          'endTime': now.toUtc().toIso8601String(),
        },
      );

      debugPrint('[MonitorRepository] Response type: ${response.runtimeType}');
      debugPrint('[MonitorRepository] Response.data type: ${response.data.runtimeType}');
      debugPrint('[MonitorRepository] Response.data: ${response.data}');

      return _parseMetricsResponse(response.data, now);
    } catch (e, stack) {
      debugPrint('[MonitorRepository] getCurrentMetrics error: $e');
      debugPrint('[MonitorRepository] Stack: $stack');
      return const MonitorMetricsSnapshot();
    }
  }

  /// 获取时间序列数据
  /// 
  /// [client] API客户端
  /// [param] 参数类型: cpu, memory, load, io, network (注意: base单独使用会返回400)
  /// [valueKey] 值字段名
  /// [duration] 时间范围
  Future<MonitorTimeSeries> getTimeSeries(
    dynamic client,
    String param,
    String valueKey, {
    Duration duration = const Duration(hours: 1),
  }) async {
    try {
      final now = DateTime.now();
      final startTime = now.subtract(duration);

      // 使用 'all' 参数获取所有数据，然后从中提取需要的字段
      final response = await client.post(
        '/api/v2/hosts/monitor/search',
        data: {
          'param': 'all',
          'startTime': startTime.toUtc().toIso8601String(),
          'endTime': now.toUtc().toIso8601String(),
        },
      );

      return _parseTimeSeriesResponse(response.data, 'base', valueKey);
    } catch (e) {
      debugPrint('[MonitorRepository] getTimeSeries error: $e');
      return MonitorTimeSeries.empty(param);
    }
  }

  /// 获取GPU信息
  Future<List<GPUInfo>> getGPUInfo(dynamic client) async {
    try {
      final now = DateTime.now();
      final startTime = now.subtract(const Duration(hours: 1));

      final response = await client.post(
        '/api/v2/hosts/monitor/gpu/search',
        data: {
          'startTime': startTime.toUtc().toIso8601String(),
          'endTime': now.toUtc().toIso8601String(),
        },
      );

      if (response.data != null && response.data is Map) {
        final body = response.data as Map<String, dynamic>;
        final dataList = body['data'] as List?;
        if (dataList != null) {
          return dataList
              .map((e) => GPUInfo.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      }
      return [];
    } catch (e) {
      debugPrint('[MonitorRepository] getGPUInfo error: $e');
      return [];
    }
  }

  /// 获取监控设置
  Future<MonitorSetting?> getSetting(dynamic client) async {
    try {
      final response = await client.get('/api/v2/hosts/monitor/setting');
      if (response.data != null && response.data is Map) {
        return MonitorSetting.fromJson(response.data as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      debugPrint('[MonitorRepository] getSetting error: $e');
      return null;
    }
  }

  /// 更新监控设置
  Future<bool> updateSetting(
    dynamic client, {
    int? interval,
    int? retention,
    bool? enabled,
  }) async {
    try {
      await client.post(
        '/api/v2/hosts/monitor/setting/update',
        data: {
          if (interval != null) 'interval': interval,
          if (retention != null) 'retention': retention,
          if (enabled != null) 'enabled': enabled,
        },
      );
      return true;
    } catch (e) {
      debugPrint('[MonitorRepository] updateSetting error: $e');
      return false;
    }
  }

  /// 清理监控数据
  Future<bool> cleanData(dynamic client) async {
    try {
      await client.post('/api/v2/hosts/monitor/clean');
      return true;
    } catch (e) {
      debugPrint('[MonitorRepository] cleanData error: $e');
      return false;
    }
  }

  /// 解析监控指标响应
  MonitorMetricsSnapshot _parseMetricsResponse(dynamic data, DateTime timestamp) {
    if (data == null || data is! Map) {
      return const MonitorMetricsSnapshot();
    }

    final responseData = data as Map<String, dynamic>;
    final dataList = responseData['data'] as List?;

    if (dataList == null) {
      return const MonitorMetricsSnapshot();
    }

    double? cpuPercent;
    double? memoryPercent;
    double? diskPercent;
    double? load1;
    double? load5;
    double? load15;

    for (final item in dataList) {
      if (item is! Map<String, dynamic>) continue;

      final param = item['param'] as String?;
      final values = item['value'] as List?;

      if (values == null || values.isEmpty) continue;

      final lastValue = values.last;
      if (lastValue is! Map<String, dynamic>) continue;

      debugPrint('[MonitorRepository] Parsing param=$param, lastValue keys: ${lastValue.keys.toList()}');

      switch (param) {
        case 'base':
          // base 包含所有指标
          cpuPercent = (lastValue['cpu'] as num?)?.toDouble();
          memoryPercent = (lastValue['memory'] as num?)?.toDouble();
          load1 = (lastValue['cpuLoad1'] as num?)?.toDouble();
          load5 = (lastValue['cpuLoad5'] as num?)?.toDouble();
          load15 = (lastValue['cpuLoad15'] as num?)?.toDouble();
          debugPrint('[MonitorRepository] base: cpu=$cpuPercent, memory=$memoryPercent, load1=$load1');
          break;
        case 'cpu':
          cpuPercent ??= (lastValue['cpu'] as num?)?.toDouble();
          break;
        case 'memory':
          memoryPercent ??= (lastValue['memory'] as num?)?.toDouble();
          break;
        case 'load':
          load1 ??= (lastValue['cpuLoad1'] as num?)?.toDouble();
          load5 ??= (lastValue['cpuLoad5'] as num?)?.toDouble();
          load15 ??= (lastValue['cpuLoad15'] as num?)?.toDouble();
          break;
        case 'io':
          diskPercent ??= (lastValue['disk'] as num?)?.toDouble();
          break;
      }
    }

    debugPrint('[MonitorRepository] Final: cpu=$cpuPercent, memory=$memoryPercent, disk=$diskPercent, load1=$load1');

    return MonitorMetricsSnapshot(
      cpuPercent: cpuPercent,
      memoryPercent: memoryPercent,
      diskPercent: diskPercent,
      load1: load1,
      load5: load5,
      load15: load15,
      timestamp: timestamp,
    );
  }

  /// 解析时间序列响应
  MonitorTimeSeries _parseTimeSeriesResponse(
    dynamic data,
    String param,
    String valueKey,
  ) {
    if (data == null || data is! Map) {
      return MonitorTimeSeries.empty(param);
    }

    final responseData = data as Map<String, dynamic>;
    final dataList = responseData['data'] as List?;

    if (dataList == null || dataList.isEmpty) {
      debugPrint('[MonitorRepository] _parseTimeSeriesResponse: dataList is null or empty');
      return MonitorTimeSeries.empty(param);
    }

    // 查找匹配的数据项，如果没有匹配的，使用第一个
    var item = dataList.firstWhere(
      (e) => (e as Map)['param'] == param,
      orElse: () => null,
    );

    // 如果没有找到精确匹配，尝试使用 'base' 数据
    if (item == null && param != 'base') {
      item = dataList.firstWhere(
        (e) => (e as Map)['param'] == 'base',
        orElse: () => null,
      );
      debugPrint('[MonitorRepository] Using base data for param=$param');
    }

    if (item == null) {
      debugPrint('[MonitorRepository] No matching item found for param=$param');
      return MonitorTimeSeries.empty(param);
    }

    final itemMap = item as Map<String, dynamic>;
    final dates = (itemMap['date'] as List?)?.map((e) => e.toString()).toList();
    final values = itemMap['value'] as List?;

    debugPrint('[MonitorRepository] dates count: ${dates?.length ?? 0}, values count: ${values?.length ?? 0}');

    if (dates == null || values == null || dates.length != values.length) {
      debugPrint('[MonitorRepository] Date/value mismatch or null');
      return MonitorTimeSeries.empty(param);
    }

    final dataPoints = <MonitorDataPoint>[];
    double? min;
    double? max;
    double sum = 0;
    int count = 0;
    final now = DateTime.now();

    for (var i = 0; i < dates.length; i++) {
      final valueMap = values[i] as Map<String, dynamic>?;
      if (valueMap == null) continue;

      final value = (valueMap[valueKey] as num?)?.toDouble();
      if (value == null) {
        debugPrint('[MonitorRepository] valueKey=$valueKey not found in valueMap: ${valueMap.keys.toList()}');
        continue;
      }

      final time = DateTime.tryParse(dates[i]) ?? now;
      dataPoints.add(MonitorDataPoint(time: time, value: value));

      if (min == null || value < min) min = value;
      if (max == null || value > max) max = value;
      sum += value;
      count++;
    }

    debugPrint('[MonitorRepository] Parsed $count data points for $param, min=$min, max=$max, avg=${count > 0 ? sum / count : null}');

    return MonitorTimeSeries(
      name: param,
      data: dataPoints,
      min: min,
      max: max,
      avg: count > 0 ? sum / count : null,
    );
  }
}
