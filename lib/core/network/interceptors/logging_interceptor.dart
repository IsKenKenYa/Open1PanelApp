import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../services/logger/logger_service.dart';

/// 简化的日志拦截器
class LoggingInterceptor extends Interceptor {
  final bool enabled;

  LoggingInterceptor([this.enabled = true]);

  /// 安全日志输出
  void _safeLog(String level, String message) {
    if (!enabled) return;
    
    try {
      final logger = AppLogger();
      switch (level) {
        case 'd':
          logger.d(message);
          break;
        case 'i':
          logger.i(message);
          break;
        case 'e':
          logger.e(message);
          break;
        default:
          logger.i(message);
      }
    } catch (e) {
      // 忽略日志错误，使用print作为后备
      debugPrint('[$level] $message');
    }
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _safeLog('d', '[network] ${options.method} ${options.path}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _safeLog('i', '[network] ${response.statusCode} ${response.requestOptions.path}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _safeLog('e', '[network] ${err.type} ${err.requestOptions.path}: ${err.message}');
    super.onError(err, handler);
  }
}
