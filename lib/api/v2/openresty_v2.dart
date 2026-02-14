import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import '../../core/config/api_constants.dart';

class OpenRestyV2Api {
  final DioClient _client;

  OpenRestyV2Api(this._client);

  /// 获取OpenResty状态
  Future<Response<Map<String, dynamic>>> getOpenRestyStatus() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiConstants.buildApiPath('/openresty'),
    );
    return Response(
      data: response.data?['data'] as Map<String, dynamic>? ?? {},
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取OpenResty构建状态
  Future<Response<Map<String, dynamic>>> getOpenRestyBuild() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiConstants.buildApiPath('/openresty/build'),
    );
    return Response(
      data: response.data?['data'] as Map<String, dynamic>? ?? {},
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取OpenResty配置文件
  Future<Response<String>> getOpenRestyFile() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiConstants.buildApiPath('/openresty/file'),
    );
    return Response(
      data: response.data?['data']?.toString() ?? '',
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取OpenResty HTTPS配置
  Future<Response<Map<String, dynamic>>> getOpenRestyHttps() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiConstants.buildApiPath('/openresty/https'),
    );
    return Response(
      data: response.data?['data'] as Map<String, dynamic>? ?? {},
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取OpenResty模块列表
  Future<Response<List<Map<String, dynamic>>>> getOpenRestyModules() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiConstants.buildApiPath('/openresty/modules'),
    );
    final data = response.data?['data'] as List?;
    return Response(
      data: data?.map((e) => e as Map<String, dynamic>).toList() ?? [],
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 更新OpenResty模块
  Future<Response<void>> updateOpenRestyModules(Map<String, dynamic> request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/openresty/modules/update'),
      data: request,
    );
  }

  /// 获取OpenResty作用域
  Future<Response<Map<String, dynamic>>> getOpenRestyScope() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiConstants.buildApiPath('/openresty/scope'),
    );
    return Response(
      data: response.data?['data'] as Map<String, dynamic>? ?? {},
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 获取OpenResty服务状态
  Future<Response<Map<String, dynamic>>> getOpenRestyServiceStatus() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiConstants.buildApiPath('/openresty/status'),
    );
    return Response(
      data: response.data?['data'] as Map<String, dynamic>? ?? {},
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      requestOptions: response.requestOptions,
    );
  }

  /// 更新OpenResty
  Future<Response<void>> updateOpenResty(Map<String, dynamic> request) async {
    return await _client.post(
      ApiConstants.buildApiPath('/openresty/update'),
      data: request,
    );
  }
}
