import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import '../../core/config/api_constants.dart';
import '../../data/models/monitoring_models.dart';

class MonitorV2Api {
  final DioClient _client;

  MonitorV2Api(this._client);

  /// 获取监控数据
  ///
  /// 获取系统监控指标数据
  /// @param request 监控搜索请求
  /// @return 监控数据列表
  Future<Response<List<MonitorData>>> getMonitorData(MonitorSearch request) async {
    final response = await _client.post(
      ApiConstants.buildApiPath('/hosts/monitor/search'),
      data: request.toJson(),
    );
    return Response(
      data: (response.data as List?)
          ?.map((item) => MonitorData.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取GPU监控数据
  ///
  /// 获取GPU监控指标数据
  /// @param request GPU监控搜索请求
  /// @return GPU监控数据
  Future<Response<MonitorGPUData>> getGPUMonitorData(MonitorGPUSearch request) async {
    final response = await _client.post(
      ApiConstants.buildApiPath('/hosts/monitor/gpu/search'),
      data: request.toJson(),
    );
    return Response(
      data: MonitorGPUData.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 清理监控数据
  ///
  /// 清理历史监控数据
  /// @return 清理结果
  Future<Response> cleanMonitorData() async {
    return await _client.post(
      ApiConstants.buildApiPath('/hosts/monitor/clean'),
    );
  }

  /// 获取监控设置
  ///
  /// 获取系统监控设置
  /// @return 监控设置
  Future<Response<MonitorSetting>> getMonitorSetting() async {
    final response = await _client.get(
      ApiConstants.buildApiPath('/hosts/monitor/setting'),
    );
    return Response(
      data: MonitorSetting.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 更新监控设置
  ///
  /// 更新系统监控设置
  /// @param request 监控设置更新请求
  /// @return 更新结果
  Future<Response> updateMonitorSetting(MonitorSettingUpdate request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/hosts/monitor/setting/update'),
      data: request.toJson(),
    );
  }

  /// 获取系统指标
  ///
  /// 获取系统监控指标数据
  /// @param metricType 指标类型（可选）
  /// @param timeRange 时间范围（可选，默认为1h）
  /// @return 系统指标数据
  Future<Response<SystemMetrics>> getSystemMetrics({
    MetricType? metricType,
    String timeRange = '1h',
  }) async {
    final request = MonitorSearch(
      timeRange: timeRange,
      metricType: metricType?.value,
    );
    final response = await _client.post(
      ApiConstants.buildApiPath('/hosts/monitor/search'),
      data: request.toJson(),
    );
    return Response(
      data: SystemMetrics.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取CPU指标
  ///
  /// 获取CPU监控指标数据
  /// @param timeRange 时间范围（可选，默认为1h）
  /// @return CPU指标数据
  Future<Response<CPUMetrics>> getCPUMetrics({String timeRange = '1h'}) async {
    final request = MonitorSearch(timeRange: timeRange);
    final response = await _client.post(
      ApiConstants.buildApiPath('/hosts/monitor/search'),
      data: request.toJson(),
    );
    return Response(
      data: CPUMetrics.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取内存指标
  ///
  /// 获取内存监控指标数据
  /// @param timeRange 时间范围（可选，默认为1h）
  /// @return 内存指标数据
  Future<Response<MemoryMetrics>> getMemoryMetrics({String timeRange = '1h'}) async {
    final request = MonitorSearch(timeRange: timeRange);
    final response = await _client.post(
      ApiConstants.buildApiPath('/hosts/monitor/search'),
      data: request.toJson(),
    );
    return Response(
      data: MemoryMetrics.fromJson(response.data as Map<String, dynamic>),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取磁盘指标
  ///
  /// 获取磁盘监控指标数据
  /// @param device 磁盘设备（可选）
  /// @param timeRange 时间范围（可选，默认为1h）
  /// @return 磁盘指标数据
  Future<Response<List<DiskMetrics>>> getDiskMetrics({
    String? device,
    String timeRange = '1h',
  }) async {
    final request = MonitorSearch(
      timeRange: timeRange,
      device: device,
    );
    final response = await _client.post(
      ApiConstants.buildApiPath('/hosts/monitor/search'),
      data: request.toJson(),
    );
    return Response(
      data: (response.data as List?)
          ?.map((item) => DiskMetrics.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取网络指标
  ///
  /// 获取网络监控指标数据
  /// @param interface 网络接口（可选）
  /// @param timeRange 时间范围（可选，默认为1h）
  /// @return 网络指标数据
  Future<Response<List<NetworkMetrics>>> getNetworkMetrics({
    String? interface,
    String timeRange = '1h',
  }) async {
    final request = MonitorSearch(
      timeRange: timeRange,
      networkInterface: interface,
    );
    final response = await _client.post(
      ApiConstants.buildApiPath('/hosts/monitor/search'),
      data: request.toJson(),
    );
    return Response(
      data: (response.data as List?)
          ?.map((item) => NetworkMetrics.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }
}

/// 监控搜索请求
class MonitorSearch {
  final String? timeRange;
  final String? metricType;
  final String? device;
  final String? networkInterface;

  const MonitorSearch({
    this.timeRange,
    this.metricType,
    this.device,
    this.networkInterface,
  });

  Map<String, dynamic> toJson() => {
        if (timeRange != null) 'timeRange': timeRange,
        if (metricType != null) 'metricType': metricType,
        if (device != null) 'device': device,
        if (networkInterface != null) 'networkInterface': networkInterface,
      };
}

/// GPU监控搜索请求
class MonitorGPUSearch {
  final String? timeRange;

  const MonitorGPUSearch({this.timeRange});

  Map<String, dynamic> toJson() => {
        if (timeRange != null) 'timeRange': timeRange,
      };
}

/// 监控数据
class MonitorData {
  final String? time;
  final double? cpu;
  final double? memory;
  final double? disk;
  final double? network;

  const MonitorData({
    this.time,
    this.cpu,
    this.memory,
    this.disk,
    this.network,
  });

  factory MonitorData.fromJson(Map<String, dynamic> json) {
    return MonitorData(
      time: json['time'] as String?,
      cpu: (json['cpu'] as num?)?.toDouble(),
      memory: (json['memory'] as num?)?.toDouble(),
      disk: (json['disk'] as num?)?.toDouble(),
      network: (json['network'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        if (time != null) 'time': time,
        if (cpu != null) 'cpu': cpu,
        if (memory != null) 'memory': memory,
        if (disk != null) 'disk': disk,
        if (network != null) 'network': network,
      };
}

/// GPU监控数据
class MonitorGPUData {
  final List<GPUInfo>? data;

  const MonitorGPUData({this.data});

  factory MonitorGPUData.fromJson(Map<String, dynamic> json) {
    return MonitorGPUData(
      data: (json['data'] as List?)
          ?.map((item) => GPUInfo.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        if (data != null)
          'data': data!.map((item) => item.toJson()).toList(),
      };
}

/// GPU信息
class GPUInfo {
  final String? name;
  final double? utilization;
  final double? memory;
  final double? temperature;

  const GPUInfo({
    this.name,
    this.utilization,
    this.memory,
    this.temperature,
  });

  factory GPUInfo.fromJson(Map<String, dynamic> json) {
    return GPUInfo(
      name: json['name'] as String?,
      utilization: (json['utilization'] as num?)?.toDouble(),
      memory: (json['memory'] as num?)?.toDouble(),
      temperature: (json['temperature'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        if (name != null) 'name': name,
        if (utilization != null) 'utilization': utilization,
        if (memory != null) 'memory': memory,
        if (temperature != null) 'temperature': temperature,
      };
}

/// 监控设置
class MonitorSetting {
  final int? interval;
  final int? retention;
  final bool? enabled;

  const MonitorSetting({
    this.interval,
    this.retention,
    this.enabled,
  });

  factory MonitorSetting.fromJson(Map<String, dynamic> json) {
    return MonitorSetting(
      interval: json['interval'] as int?,
      retention: json['retention'] as int?,
      enabled: json['enabled'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
        if (interval != null) 'interval': interval,
        if (retention != null) 'retention': retention,
        if (enabled != null) 'enabled': enabled,
      };
}

/// 监控设置更新请求
class MonitorSettingUpdate {
  final int? interval;
  final int? retention;
  final bool? enabled;

  const MonitorSettingUpdate({
    this.interval,
    this.retention,
    this.enabled,
  });

  Map<String, dynamic> toJson() => {
        if (interval != null) 'interval': interval,
        if (retention != null) 'retention': retention,
        if (enabled != null) 'enabled': enabled,
      };
}
