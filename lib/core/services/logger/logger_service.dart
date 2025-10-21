import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import '../../config/logger_config.dart';

/// 统一日志服务类
/// 根据不同的构建模式（debug/release）配置不同的日志级别
class AppLogger {
  static final AppLogger _instance = AppLogger._internal();
  factory AppLogger() => _instance;
  AppLogger._internal();

  late Logger _logger;
  static const String _defaultPackageName = '[core.services]';

  /// 初始化日志服务
  void init() {
    // 根据构建模式设置日志级别
    Level logLevel;
    
    if (kReleaseMode) {
      // Release模式：只输出错误和警告级别
      logLevel = Level.warning;
    } else if (kProfileMode) {
      // Profile模式：输出信息、警告和错误级别
      logLevel = Level.info;
    } else {
      // Debug模式：输出所有级别的日志
      logLevel = Level.trace;
    }

    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: LoggerConfig.maxMethodCount,
        errorMethodCount: LoggerConfig.maxErrorMethodCount,
        lineLength: LoggerConfig.lineLength,
        colors: LoggerConfig.enableColors,
        printEmojis: LoggerConfig.enableEmojis,
        printTime: LoggerConfig.enableTimeStamps,
      ),
      level: logLevel,
      filter: _CustomLogFilter(),
    );
  }

  /// 输出Trace级别日志
  void t(dynamic message, {dynamic error, StackTrace? stackTrace}) {
    if (!kReleaseMode) {
      _logMessage(Level.trace, '【Open1PanelMobile】$message', error: error, stackTrace: stackTrace);
    }
  }

  /// 输出Debug级别日志
  void d(dynamic message, {dynamic error, StackTrace? stackTrace}) {
    if (!kReleaseMode) {
      _logMessage(Level.debug, '【Open1PanelMobile】$message', error: error, stackTrace: stackTrace);
    }
  }

  /// 输出Info级别日志
  void i(dynamic message, {dynamic error, StackTrace? stackTrace}) {
    if (!kReleaseMode) {
      _logMessage(Level.info, '【Open1PanelMobile】$message', error: error, stackTrace: stackTrace);
    }
  }

  /// 输出Warning级别日志
  void w(dynamic message, {dynamic error, StackTrace? stackTrace}) {
    _logMessage(Level.warning, '【Open1PanelMobile】$message', error: error, stackTrace: stackTrace);
  }

  /// 输出Error级别日志
  void e(dynamic message, {dynamic error, StackTrace? stackTrace}) {
    _logMessage(Level.error, '【Open1PanelMobile】$message', error: error, stackTrace: stackTrace);
  }

  /// 输出Fatal级别日志
  void f(dynamic message, {dynamic error, StackTrace? stackTrace}) {
    _logMessage(Level.fatal, '【Open1PanelMobile】$message', error: error, stackTrace: stackTrace);
  }

  /// 输出带包名的Trace级别日志
  void tWithPackage(String packageName, dynamic message, {dynamic error, StackTrace? stackTrace}) {
    if (!kReleaseMode) {
      _logMessage(Level.trace, '【Open1PanelMobile】[$packageName] $message', error: error, stackTrace: stackTrace);
    }
  }

  /// 输出带包名的Debug级别日志
  void dWithPackage(String packageName, dynamic message, {dynamic error, StackTrace? stackTrace}) {
    if (!kReleaseMode) {
      _logMessage(Level.debug, '【Open1PanelMobile】[$packageName] $message', error: error, stackTrace: stackTrace);
    }
  }

  /// 输出带包名的Info级别日志
  void iWithPackage(String packageName, dynamic message, {dynamic error, StackTrace? stackTrace}) {
    if (!kReleaseMode) {
      _logMessage(Level.info, '【Open1PanelMobile】[$packageName] $message', error: error, stackTrace: stackTrace);
    }
  }

  /// 输出带包名的Warning级别日志
  void wWithPackage(String packageName, dynamic message, {dynamic error, StackTrace? stackTrace}) {
    _logMessage(Level.warning, '【Open1PanelMobile】[$packageName] $message', error: error, stackTrace: stackTrace);
  }

  /// 输出带包名的Error级别日志
  void eWithPackage(String packageName, dynamic message, {dynamic error, StackTrace? stackTrace}) {
    _logMessage(Level.error, '【Open1PanelMobile】[$packageName] $message', error: error, stackTrace: stackTrace);
  }

  /// 输出带包名的Fatal级别日志
  void fWithPackage(String packageName, dynamic message, {dynamic error, StackTrace? stackTrace}) {
    _logMessage(Level.fatal, '【Open1PanelMobile】[$packageName] $message', error: error, stackTrace: stackTrace);
  }

  /// 统一日志输出方法，包含过滤逻辑
  void _logMessage(Level level, dynamic message, {dynamic error, StackTrace? stackTrace}) {
    final messageStr = message.toString();
    
    // 检查是否需要过滤此日志
    if (LoggerConfig.shouldFilterLog(messageStr)) {
      return;
    }
    
    // 如果消息不包含包名，则添加默认包名
    final formattedMessage = messageStr.startsWith('[') && messageStr.contains(']') 
        ? messageStr 
        : '$_defaultPackageName $messageStr';
    
    // 根据日志级别调用相应的日志方法
    switch (level) {
      case Level.trace:
        _logger.t(formattedMessage, error: error, stackTrace: stackTrace);
        break;
      case Level.debug:
        _logger.d(formattedMessage, error: error, stackTrace: stackTrace);
        break;
      case Level.info:
        _logger.i(formattedMessage, error: error, stackTrace: stackTrace);
        break;
      case Level.warning:
        _logger.w(formattedMessage, error: error, stackTrace: stackTrace);
        break;
      case Level.error:
        _logger.e(formattedMessage, error: error, stackTrace: stackTrace);
        break;
      case Level.fatal:
        _logger.f(formattedMessage, error: error, stackTrace: stackTrace);
        break;
      default:
        _logger.i(formattedMessage, error: error, stackTrace: stackTrace);
    }
  }
}

/// 自定义日志过滤器
class _CustomLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    // 检查是否需要过滤此日志
    if (LoggerConfig.shouldFilterLog(event.message.toString())) {
      return false;
    }
    
    // 默认返回true，允许所有未被过滤的日志
    return true;
  }
}

/// 全局日志实例
final appLogger = AppLogger();