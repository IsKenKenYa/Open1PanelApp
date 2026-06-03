import 'dart:io' as io;
import 'package:flutter/foundation.dart';
import '../services/logger/log_category.dart';

/// 日志配置常量
class LoggerConfig {
  LoggerConfig._();

  /// 是否为桌面平台（有终端）
  static bool get _isDesktopPlatform {
    return !kIsWeb &&
        (io.Platform.isLinux || io.Platform.isMacOS || io.Platform.isWindows);
  }

  /// 日志格式配置
  static bool get enableColors {
    if (kIsWeb) return false;
    if (_isDesktopPlatform) {
      try {
        return io.stdout.supportsAnsiEscapes;
      } catch (_) {
        return false;
      }
    }
    return false;
  }

  static const bool enableEmojis = true;
  static const int maxMethodCount = 0;
  static const int maxErrorMethodCount = 8;
  static const int maxStackFrames = 3;

  static int get lineLength {
    if (kIsWeb) return 120;
    if (_isDesktopPlatform) {
      try {
        final columns = io.stdout.terminalColumns;
        return columns > 0 ? columns : 120;
      } catch (_) {
        return 120;
      }
    }
    return 120;
  }

  /// 日志输出配置
  static const bool enableConsoleOutput = true;
  /// 开启文件日志以支持用户在遇到问题时导出反馈
  static const bool enableFileOutput = true;
  static const String logFileName = 'app_logs.txt';
  static const int maxLogFileSize = 10 * 1024 * 1024;
  static const int maxLogFiles = 5;
  static const int logRetentionDays = 30;

  /// Noisy platform-specific tags that clutter logs without adding value.
  static const List<String> excludedLogTags = [
    'MESA',
    'exportSyncFdForQSRILocked',
  ];

  static bool shouldFilterLog(String message) {
    for (final tag in excludedLogTags) {
      if (message.contains(tag)) {
        return true;
      }
    }
    return false;
  }

  /// package 前缀段 → `LogCategory` 的隐式映射表。
  ///
  /// 匹配规则：自**最长前缀**向短前缀查找，命中即返回。
  /// 更具体的前缀（多段）可覆盖更通用的前缀（少段）。
  static const Map<String, LogCategory> _categoryByPrefix = {
    // UI - features 全部归 UI（页面、Provider、Widget）
    'features': LogCategory.ui,
    'shared': LogCategory.ui,
    'pages': LogCategory.ui,
    // features.auth 覆盖 features → AUTH
    'features.auth': LogCategory.auth,

    // 网络层
    'core.network': LogCategory.network,
    'core.api': LogCategory.network,

    // 文件 IO
    'core.services.file': LogCategory.fileIo,
    'core.file': LogCategory.fileIo,

    // 数据库 / Repository
    'data': LogCategory.db,
    'core.services.cache': LogCategory.db,

    // 鉴权
    'core.security': LogCategory.auth,

    // 日志 / 平台通道 / 启动
    'core.services.logger': LogCategory.system,
    'core.channel': LogCategory.system,
    'core.platform': LogCategory.system,
    'core.config': LogCategory.system,
    'core.i18n': LogCategory.system,
  };

  /// 根据 package 名称推断功能域分类。
  ///
  /// 规则：枚举所有可拼接的前缀（如 `features.dashboard.provider` 包含
  /// `features`、`features.dashboard`、`features.dashboard.provider`），
  /// 命中映射表时取**最长前缀**的命中项；未命中则返回 `LogCategory.unclassified`。
  ///
  /// 示例：
  /// - `features.dashboard.dashboard_provider` → `features.dashboard` 命中（如有），
  ///   否则 `features` → `UI`
  /// - `features.auth.login_provider` → `features.auth` 命中 → `AUTH`（覆盖 `features` → `UI`）
  /// - `core.network.dio_client` → 命中 `core.network` → `NETWORK`
  /// - `mypackage.something` → 无命中 → `UNCLASSIFIED`
  static LogCategory defaultCategoryForPackage(String packageName) {
    if (packageName.isEmpty) return LogCategory.unclassified;
    final segments = packageName.split('.');
    final candidates = <String>[];
    final buffer = StringBuffer();
    for (final segment in segments) {
      if (buffer.isNotEmpty) buffer.write('.');
      buffer.write(segment);
      candidates.add(buffer.toString());
    }
    // 自最长前缀向短前缀查找，命中即返回。
    for (var i = candidates.length - 1; i >= 0; i--) {
      final hit = _categoryByPrefix[candidates[i]];
      if (hit != null) return hit;
    }
    return LogCategory.unclassified;
  }
}
