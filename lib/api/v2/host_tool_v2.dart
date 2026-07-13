import 'package:dio/dio.dart';

import '../../core/config/api_constants.dart';
import '../../core/network/dio_client.dart';
import '../../data/models/host_tool_models.dart';

/// 1Panel host tool management API client.
///
/// Controls host-level tools (e.g. Supervisor) including init, operate, and process management.
class HostToolV2Api {
  HostToolV2Api(this._client);

  final DioClient _client;

  Future<Response<HostToolStatusResponse>> getToolStatus(
    HostToolRequest request,
  ) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiConstants.buildApiPath('/hosts/tool/status'),
      data: request.toJson(),
    );
    final rawData = response.data?['data'] as Map<String, dynamic>? ??
        const <String, dynamic>{};
    return Response<HostToolStatusResponse>(
      data: HostToolStatusResponse.fromJson(rawData),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  Future<Response<HostToolConfigResponse>> getToolConfig(
    HostToolConfigRequest request,
  ) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiConstants.buildApiPath('/hosts/tool/config/get'),
      data: request.toJson(),
    );
    final rawData = response.data?['data'] as Map<String, dynamic>? ??
        const <String, dynamic>{};
    return Response<HostToolConfigResponse>(
      data: HostToolConfigResponse.fromJson(rawData),
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  Future<Response<void>> initTool(HostToolCreateRequest request) {
    return _client.post<void>(
      ApiConstants.buildApiPath('/hosts/tool/init'),
      data: request.toJson(),
    );
  }

  Future<Response<void>> operateTool(HostToolRequest request) {
    return _client.post<void>(
      ApiConstants.buildApiPath('/hosts/tool/operate'),
      data: request.toJson(),
    );
  }

  // Server returns a List when multiple processes exist, but a single Map
  // when only one process is configured.
  Future<Response<List<HostToolProcessConfig>>> getSupervisorProcesses() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiConstants.buildApiPath('/hosts/tool/supervisor/process'),
    );
    final rawData = response.data?['data'];
    final List<HostToolProcessConfig> items;
    if (rawData is List<dynamic>) {
      items = rawData
          .whereType<Map<String, dynamic>>()
          .map(HostToolProcessConfig.fromJson)
          .toList(growable: false);
    } else if (rawData is Map<String, dynamic>) {
      items = <HostToolProcessConfig>[HostToolProcessConfig.fromJson(rawData)];
    } else {
      items = const <HostToolProcessConfig>[];
    }
    return Response<List<HostToolProcessConfig>>(
      data: items,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  Future<Response<void>> upsertSupervisorProcess(
    HostToolProcessConfigRequest request,
  ) {
    return _client.post<void>(
      ApiConstants.buildApiPath('/hosts/tool/supervisor/process'),
      data: request.toJson(),
    );
  }

  Future<Response<void>> operateSupervisorProcess(
    HostToolProcessOperateRequest request,
  ) {
    return _client.post<void>(
      ApiConstants.buildApiPath('/hosts/tool/supervisor/process'),
      data: request.toJson(),
    );
  }

  Future<Response<String>> operateSupervisorProcessFile(
    HostToolProcessFileRequest request,
  ) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiConstants.buildApiPath('/hosts/tool/supervisor/process/file'),
      data: request.toJson(),
    );
    return Response<String>(
      data: response.data?['data']?.toString() ?? '',
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// Set host tool config (POST /hosts/tool/config/set).
  Future<Response<void>> setToolConfig(HostToolConfigRequest request) async {
    return await _client.post<void>(
      ApiConstants.buildApiPath('/hosts/tool/config/set'),
      data: request.toJson(),
    );
  }

  /// Get supervisor process config file content (POST /hosts/tool/supervisor/process/file/get).
  Future<Response<String>> getSupervisorProcessFile(
    HostToolProcessFileRequest request,
  ) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiConstants.buildApiPath('/hosts/tool/supervisor/process/file/get'),
      data: request.toJson(),
    );
    return Response<String>(
      data: response.data?['data']?.toString() ?? '',
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }
}
