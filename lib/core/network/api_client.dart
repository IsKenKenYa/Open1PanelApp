import 'package:dio/dio.dart';
import 'dio_client.dart';
import 'network_exceptions.dart';

/// 1Panel API客户端 - 基于Dio的现代化网络客户端
///
/// 提供完整的HTTP请求功能，包括：
/// - 自动认证（MD5 Token生成）
/// - 请求重试机制
/// - 错误处理和异常转换
/// - 日志记录
/// - 超时控制
class ApiClient {
  final DioClient _dioClient;

  /// 获取Dio实例（用于高级用法）
  Dio get dio => _dioClient.dio;

  ApiClient({
    required String baseUrl,
    required String apiKey,
  }) : _dioClient = DioClient(baseUrl: baseUrl, apiKey: apiKey);

  /// 发送POST请求
  Future<Response> post(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) async {
    try {
      return await _dioClient.post<Response>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      throw _convertException(e);
    }
  }

  /// 发送GET请求
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters, Options? options}) async {
    try {
      return await _dioClient.get<Response>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      throw _convertException(e);
    }
  }

  /// 发送PUT请求
  Future<Response> put(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) async {
    try {
      return await _dioClient.put<Response>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      throw _convertException(e);
    }
  }

  /// 发送DELETE请求
  Future<Response> delete(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) async {
    try {
      return await _dioClient.delete<Response>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      throw _convertException(e);
    }
  }

  /// 转换异常为统一的网络异常类型
  Exception _convertException(dynamic error) {
    if (error is NetworkException) {
      return error;
    }

    if (error is HttpException) {
      return error;
    }

    return HttpException('网络请求失败: ${error.toString()}');
  }

  /// 更新API认证密钥
  void updateApiKey(String apiKey) {
    _dioClient.updateAuth(apiKey);
  }
}

