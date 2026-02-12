import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import '../../config/logger_config.dart';

/// 统一日志服务类
/// 根据不同的构建模式（debug/release）配置不同的日志级别
class AppLogger {
  static final AppLogger _instance = AppLogger._internal();
  factory AppLogger() => _instance;
  AppLogger._internal();

  Logger? _logger;
  static const String _defaultPackageName = '[core.services]';
  bool _initialized = false;

  /// 初始化日志服务
  void init() {
    if (_initialized) return;
    _initialized = true;
    
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
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
      level: logLevel,
      filter: _CustomLogFilter(),
    );
  }

  /// 确保日志器已初始化
  void _ensureInitialized() {
    if (_logger == null) {
      init();
    }
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

  /// 带包名的Trace级别日志
  void tWithPackage(String packageName, dynamic message, {dynamic error, StackTrace? stackTrace}) {
    if (!kReleaseMode) {
      _logMessage(Level.trace, '[$packageName] $message', error: error, stackTrace: stackTrace);
    }
  }

  /// 带包名的Debug级别日志
  void dWithPackage(String packageName, dynamic message, {dynamic error, StackTrace? stackTrace}) {
    if (!kReleaseMode) {
      _logMessage(Level.debug, '[$packageName] $message', error: error, stackTrace: stackTrace);
    }
  }

  /// 带包名的Info级别日志
  void iWithPackage(String packageName, dynamic message, {dynamic error, StackTrace? stackTrace}) {
    if (!kReleaseMode) {
      _logMessage(Level.info, '[$packageName] $message', error: error, stackTrace: stackTrace);
    }
  }

  /// 带包名的Warning级别日志
  void wWithPackage(String packageName, dynamic message, {dynamic error, StackTrace? stackTrace}) {
    _logMessage(Level.warning, '[$packageName] $message', error: error, stackTrace: stackTrace);
  }

  /// 带包名的Error级别日志
  void eWithPackage(String packageName, dynamic message, {dynamic error, StackTrace? stackTrace}) {
    _logMessage(Level.error, '[$packageName] $message', error: error, stackTrace: stackTrace);
  }

  /// 带包名的Fatal级别日志
  void fWithPackage(String packageName, dynamic message, {dynamic error, StackTrace? stackTrace}) {
    _logMessage(Level.fatal, '[$packageName] $message', error: error, stackTrace: stackTrace);
  }

  void _logMessage(Level level, dynamic message, {dynamic error, StackTrace? stackTrace}) {
    _ensureInitialized();
    _logger?.log(level, message, error: error, stackTrace: stackTrace);
  }
}

/// 自定义日志过滤器
class _CustomLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    // 在Release模式下只输出warning及以上级别
    if (kReleaseMode) {
      return event.level.index >= Level.warning.index;
    }
    // 在其他模式下输出所有日志
    return true;
  }
}

/// 全局日志实例
final AppLogger appLogger = AppLogger();
