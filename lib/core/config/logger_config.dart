/// 日志级别枚举
enum LogLevel {
  trace(0),
  debug(1),
  info(2),
  warning(3),
  error(4),
  fatal(5),
  off(6);

  final int value;
  const LogLevel(this.value);
}

/// 构建模式枚举
enum BuildMode {
  debug,
  profile,
  release;

  static BuildMode fromString(String mode) {
    switch (mode.toLowerCase()) {
      case 'debug':
        return BuildMode.debug;
      case 'profile':
        return BuildMode.profile;
      case 'release':
        return BuildMode.release;
      default:
        return BuildMode.debug;
    }
  }
}

/// 日志配置常量
class LoggerConfig {
  /// 根据构建模式获取日志级别
  static LogLevel getLogLevelForBuildMode(BuildMode buildMode) {
    switch (buildMode) {
      case BuildMode.debug:
        // Debug模式：输出所有级别的日志
        return LogLevel.trace;
      case BuildMode.profile:
        // Profile模式：输出信息、警告和错误级别
        return LogLevel.info;
      case BuildMode.release:
        // Release模式：只输出错误和警告级别
        return LogLevel.warning;
    }
  }

  /// 日志格式配置
  static const bool enableColors = true;
  static const bool enableEmojis = true;
  static const bool enableTimeStamps = true;
  static const int maxMethodCount = 3;
  static const int maxErrorMethodCount = 8;
  static const int lineLength = 120;

  /// 日志输出配置
  static const bool enableConsoleOutput = true;
  static const bool enableFileOutput = false;
  static const String logFileName = 'app_logs.txt';
  static const int maxLogFileSize = 10 * 1024 * 1024; // 10MB
  static const int maxLogFiles = 5;

  /// 日志过滤配置
  static const List<String> excludedLogTags = [
    'MESA', // 过滤MESA图形相关日志
    'exportSyncFdForQSRILocked', // 过滤特定图形系统日志
  ];

  /// 检查日志标签是否应该被过滤
  static bool shouldFilterLog(String message) {
    for (final tag in excludedLogTags) {
      if (message.contains(tag)) {
        return true;
      }
    }
    return false;
  }
}