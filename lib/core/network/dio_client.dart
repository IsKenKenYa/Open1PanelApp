import 'dart:convert';
import 'package:dio/dio.dart';
import '../services/logger_service.dart';
import '../config/api_constants.dart';
import 'network_exceptions.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/retry_interceptor.dart';

/// 基于Dio的HTTP客户端 - 支持1Panel API认证
class DioClient {
  final Dio _dio;
  final Logger _logger = appLogger;
  late AuthInterceptor _authInterceptor;

  DioClient({String? baseUrl, String? apiKey})
      : _dio = Dio(_createBaseOptions(baseUrl)) {
    _authInterceptor = AuthInterceptor(apiKey);
    _addInterceptors();
  }

  /// 创建基础配置
  BaseOptions _createBaseOptions(String? baseUrl) {
    return BaseOptions(
      baseUrl: baseUrl ?? ApiConstants.defaultBaseUrl,
      connectTimeout: const Duration(seconds: ApiConstants.connectTimeout),
      receiveTimeout: const Duration(seconds: ApiConstants.receiveTimeout),
      sendTimeout: const Duration(seconds: ApiConstants.sendTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'User-Agent': ApiConstants.userAgent,
      },
      responseType: ResponseType.json,
      validateStatus: (status) => status != null && status >= 200 && status < 300,
    );
  }

  /// 添加拦截器
  void _addInterceptors() {
    _dio.interceptors.add(_authInterceptor);
    _dio.interceptors.add(LoggingInterceptor(ApiConstants.isDebugMode));
    _dio.interceptors.add(RetryInterceptor());
  }

  /// 执行请求并统一处理错误
  Future<T> _executeRequest<T>(
    Future<Response<T>> Function() requestFunction,
  ) async {
    try {
      final response = await requestFunction();
      return response.data!;
    } on DioException catch (e) {
      throw _convertException(e);
    }
  }

  /// 转换DioException为自定义异常
  Exception _convertException(DioException e) {
    final statusCode = e.response?.statusCode;

    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return NetworkConnectionException(
        '网络连接失败: ${e.message}',
        requestOptions: e.requestOptions,
      );
    }

    if (statusCode == 401) {
      return AuthException(
        '认证失败',
        requestOptions: e.requestOptions,
        statusCode: statusCode,
      );
    }

    if (statusCode != null && statusCode >= 500) {
      return ServerException(
        '服务器错误: ${e.message}',
        requestOptions: e.requestOptions,
        statusCode: statusCode,
      );
    }

    return HttpException(
      '请求失败: ${e.message}',
      requestOptions: e.requestOptions,
      statusCode: statusCode,
    );
  }

  /// GET请求
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _executeRequest(() => _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
    ));
  }

  /// POST请求
  Future<T> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _executeRequest(() => _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    ));
  }

  /// PUT请求
  Future<T> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _executeRequest(() => _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    ));
  }

  /// DELETE请求
  Future<T> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _executeRequest(() => _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    ));
  }

  /// PATCH请求
  Future<T> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _executeRequest(() => _dio.patch<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    ));
  }

  /// 文件上传
  Future<T> upload<T>(
    String path,
    FormData formData, {
    ProgressCallback? onSendProgress,
    Options? options,
  }) {
    return _executeRequest(() => _dio.post<T>(
      path,
      data: formData,
      options: options,
      onSendProgress: onSendProgress,
    ));
  }

  /// 文件下载
  Future<Response> download(
    String urlPath,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    Options? options,
  }) async {
    try {
      return await _dio.download(
        urlPath,
        savePath,
        onReceiveProgress: onReceiveProgress,
        options: options,
      );
    } on DioException catch (e) {
      throw _convertException(e);
    }
  }

  /// 更新认证信息
  void updateAuth(String? apiKey) {
    _authInterceptor.updateApiKey(apiKey);
    _logger.d('[network] Auth updated with new API key');
  }

  /// 获取Dio实例（用于高级用法）
  Dio get dio => _dio;
}