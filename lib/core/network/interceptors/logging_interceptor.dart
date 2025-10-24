import 'package:dio/dio.dart';
import '../../services/logger_service.dart';

/// 简化的日志拦截器
class LoggingInterceptor extends Interceptor {
  final bool enabled;
  final Logger _logger = appLogger;

  LoggingInterceptor([this.enabled = true]);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (enabled) {
      _logger.d('[network] ${options.method} ${options.path}');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (enabled) {
      _logger.i('[network] ${response.statusCode} ${response.requestOptions.path}');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (enabled) {
      _logger.e('[network] ${err.type} ${err.requestOptions.path}: ${err.message}');
    }
    super.onError(err, handler);
  }
}