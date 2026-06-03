import 'package:logger/logger.dart';

import 'log_category.dart';
import 'log_level.dart';

/// 日志输出格式。
///
/// - [humanReadable]: 保留 emoji、缩进、堆栈展开的 PrettyPrinter 风格。
///   适合直接 `cat` / `tail -f` 给人眼阅读。
/// - [aiAgent]: 单行结构化，无装饰字符，错误堆栈压成 1 行紧凑形式。
///   适合 tail / grep / AI Agent 解析。
enum LogFormat {
  humanReadable,
  aiAgent;

  /// 简短标签，用于内部标识。
  String get shortTag {
    switch (this) {
      case LogFormat.humanReadable:
        return 'human';
      case LogFormat.aiAgent:
        return 'ai';
    }
  }

  /// 默认运行期写入文件使用的格式。
  ///
  /// 选择 AI Agent 格式以节省存储与后续解析成本。
  static const LogFormat defaultRuntime = LogFormat.aiAgent;

  /// 将 `LogEvent` 格式化为单行字符串。
  ///
  /// 输出结构（AI Agent 格式）：
  /// ```
  /// {timestamp} [{LEVEL}][{CATEGORY}:{package}] {message}[ | err=... | at f1, at f2, at f3]
  /// ```
  ///
  /// 输出结构（人读格式）：
  /// ```
  /// {emoji} {LEVEL} [{CATEGORY}:{package}] {message}
  ///   | err=...
  ///   | at frame1
  ///   | at frame2
  /// ```
  String format({
    required LogEvent event,
    required int maxStackFrames,
    bool colorize = false,
  }) {
    final ts = _formatTimestamp(event.time);
    final level = _levelLabel(event.level, colorize: colorize);
    final cat = _resolveCategory(event);
    final pkg = _extractPackage(event.message);
    final body = _extractMessage(event.message);

    switch (this) {
      case LogFormat.aiAgent:
        return _formatAiAgent(
          ts: ts,
          level: level,
          cat: cat,
          pkg: pkg,
          body: body,
          event: event,
          maxStackFrames: maxStackFrames,
          colorize: colorize,
        );
      case LogFormat.humanReadable:
        return _formatHumanReadable(
          ts: ts,
          level: level,
          cat: cat,
          pkg: pkg,
          body: body,
          event: event,
          maxStackFrames: maxStackFrames,
          colorize: colorize,
        );
    }
  }

  // ---------------------------------------------------------------------------
  //  AI Agent 格式（单行结构化）
  // ---------------------------------------------------------------------------

  String _formatAiAgent({
    required String ts,
    required String level,
    required LogCategory cat,
    required String pkg,
    required String body,
    required LogEvent event,
    required int maxStackFrames,
    required bool colorize,
  }) {
    final buffer = StringBuffer()
      ..write(ts)
      ..write(' [')
      ..write(_padLevel(level))
      ..write('][')
      ..write(cat.shortTag)
      ..write(':')
      ..write(pkg)
      ..write('] ')
      ..write(body);

    final hasError = event.error != null;
    final hasStack = event.stackTrace != null && maxStackFrames > 0;
    if (hasError) {
      buffer.write(' | err=');
      buffer.write(_safeOneLine(event.error.toString()));
    }
    if (hasStack) {
      final frames = _truncateStack(event.stackTrace!, maxStackFrames);
      if (frames.isNotEmpty) {
        buffer.write(' | at ');
        buffer.write(frames.join(', '));
      }
    }
    return buffer.toString();
  }

  // ---------------------------------------------------------------------------
  //  人读格式（保留 emoji + 换行堆栈）
  // ---------------------------------------------------------------------------

  String _formatHumanReadable({
    required String ts,
    required String level,
    required LogCategory cat,
    required String pkg,
    required String body,
    required LogEvent event,
    required int maxStackFrames,
    required bool colorize,
  }) {
    final emoji = _emojiForLevel(event.level);
    final buffer = StringBuffer()
      ..write(emoji)
      ..write(' [')
      ..write(_padLevel(level))
      ..write('] [')
      ..write(cat.label)
      ..write(':')
      ..write(pkg)
      ..write('] ')
      ..write(body);

    final hasError = event.error != null;
    final hasStack = event.stackTrace != null && maxStackFrames > 0;
    if (hasError) {
      buffer.write('\n  err=');
      buffer.write(event.error.toString());
    }
    if (hasStack) {
      final frames = _truncateStack(event.stackTrace!, maxStackFrames);
      for (final frame in frames) {
        buffer.write('\n  at ');
        buffer.write(frame);
      }
    }
    return buffer.toString();
  }

  // ---------------------------------------------------------------------------
  //  工具方法
  // ---------------------------------------------------------------------------

  static String _formatTimestamp(DateTime? time) {
    final t = time ?? DateTime.now();
    String two(int n) => n.toString().padLeft(2, '0');
    String three(int n) => n.toString().padLeft(3, '0');
    return '${t.year}-${two(t.month)}-${two(t.day)} '
        '${two(t.hour)}:${two(t.minute)}:${two(t.second)}.${three(t.millisecond)}';
  }

  static String _levelLabel(Level level, {bool colorize = false}) {
    switch (level) {
      case Level.trace:
        return 'TRACE';
      case Level.debug:
        return 'DEBUG';
      case Level.info:
        return 'INFO';
      case Level.warning:
        return 'WARN';
      case Level.error:
        return 'ERROR';
      case Level.fatal:
        return 'FATAL';
      default:
        return level.toString().toUpperCase();
    }
  }

  static String _padLevel(String label) => label.padRight(5);

  static String _emojiForLevel(Level level) {
    switch (level) {
      case Level.trace:
        return '🔍';
      case Level.debug:
        return '🐛';
      case Level.info:
        return 'ℹ️';
      case Level.warning:
        return '⚠️';
      case Level.error:
        return '❌';
      case Level.fatal:
        return '💀';
      default:
        return '•';
    }
  }

  /// 从原始 `message` 中提取 `[(CATEGORY:)package] body` 形式的前缀。
  ///
  /// - `[features.dashboard] msg` → 推断 category，按 package 映射
  /// - `[NET:features.dashboard] msg` → 显式 category = NET（= `network.shortTag`）
  /// - `msg`（无方括号）→ package = `app`
  static (String, LogCategory, String) splitPackageCategoryMessage(
    dynamic rawMessage,
  ) {
    final text = rawMessage?.toString() ?? '';
    final match = RegExp(r'^\[(([A-Z]+):)?([^\]]+)\]\s*(.*)$', dotAll: true)
        .firstMatch(text);
    if (match == null) {
      return ('app', LogCategory.unclassified, text);
    }
    final catTag = match.group(2);
    final pkg = match.group(3) ?? 'app';
    final body = match.group(4) ?? '';
    LogCategory category;
    if (catTag != null && catTag.isNotEmpty) {
      category = LogCategory.values.firstWhere(
        (c) => c.shortTag == catTag,
        orElse: () => LoggerCategoryLookup.resolve(pkg),
      );
    } else {
      category = LoggerCategoryLookup.resolve(pkg);
    }
    return (pkg, category, body);
  }

  static String _extractPackage(dynamic rawMessage) =>
      splitPackageCategoryMessage(rawMessage).$1;

  static String _extractMessage(dynamic rawMessage) =>
      splitPackageCategoryMessage(rawMessage).$3;

  static LogCategory _resolveCategory(LogEvent event) {
    return splitPackageCategoryMessage(event.message).$2;
  }

  static String _safeOneLine(String text) =>
      text.replaceAll(RegExp(r'[\r\n]+'), ' ');

  static List<String> _truncateStack(StackTrace stack, int maxFrames) {
    final text = stack.toString();
    final lines = text
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();
    if (lines.length <= maxFrames) return lines;
    return lines.sublist(0, maxFrames);
  }
}

/// 解析 LogCategory 的辅助类，独立出来便于测试覆盖。
class LoggerCategoryLookup {
  LoggerCategoryLookup._();

  static LogCategory resolve(String packageName) {
    if (packageName.isEmpty) return LogCategory.unclassified;
    final segments = packageName.split('.');
    final candidates = <String>[];
    final buffer = StringBuffer();
    for (final segment in segments) {
      if (buffer.isNotEmpty) buffer.write('.');
      buffer.write(segment);
      candidates.add(buffer.toString());
    }
    for (var i = candidates.length - 1; i >= 0; i--) {
      final hit = _table[candidates[i]];
      if (hit != null) return hit;
    }
    return LogCategory.unclassified;
  }

  static const Map<String, LogCategory> _table = {
    'features': LogCategory.ui,
    'shared': LogCategory.ui,
    'pages': LogCategory.ui,
    'features.auth': LogCategory.auth,
    'core.network': LogCategory.network,
    'core.api': LogCategory.network,
    'core.services.file': LogCategory.fileIo,
    'core.file': LogCategory.fileIo,
    'data': LogCategory.db,
    'core.services.cache': LogCategory.db,
    'core.security': LogCategory.auth,
    'core.services.logger': LogCategory.system,
    'core.channel': LogCategory.system,
    'core.platform': LogCategory.system,
    'core.config': LogCategory.system,
    'core.i18n': LogCategory.system,
  };
}

/// 将 AI Agent 格式的日志原文重排为人读格式。
///
/// 输入（AI Agent 格式）：
/// ```
/// 2026-06-03 18:06:12.353 [INFO ][UI:features.dashboard] Extracted metrics: cpu=10%
/// 2026-06-03 18:06:12.460 [ERROR][NET:core.network.dio] Request failed | err=SocketException(...) | at frame1, at frame2, at frame3
/// ```
///
/// 输出（人读格式）：
/// ```
/// ℹ️  [INFO ] [UI:features.dashboard] 2026-06-03 18:06:12.353 Extracted metrics: cpu=10%
/// ❌ [ERROR] [NET:core.network.dio] 2026-06-03 18:06:12.460 Request failed
///   err=SocketException(...)
///   at frame1
///   at frame2
///   at frame3
/// ```
String reformatAiAgentToHumanReadable(String aiAgentText) {
  final buffer = StringBuffer();
  for (final rawLine in aiAgentText.split('\n')) {
    if (rawLine.isEmpty) continue;
    final parsed = _parseAiAgentLine(rawLine);
    if (parsed == null) {
      buffer.writeln(rawLine);
      continue;
    }
    buffer.writeln(_aiAgentLineToHumanReadable(parsed));
  }
  return buffer.toString();
}

class _AiAgentLine {
  _AiAgentLine({
    required this.timestamp,
    required this.level,
    required this.category,
    required this.package,
    required this.body,
    required this.error,
    required this.stackFrames,
  });

  final String timestamp;
  final String level;
  final String category;
  final String package;
  final String body;
  final String? error;
  final List<String> stackFrames;
}

AppLogLevel _levelToAppLog(String label) {
  switch (label) {
    case 'TRACE':
      return AppLogLevel.trace;
    case 'DEBUG':
      return AppLogLevel.debug;
    case 'INFO':
      return AppLogLevel.info;
    case 'WARN':
      return AppLogLevel.warning;
    case 'ERROR':
      return AppLogLevel.error;
    case 'FATAL':
      return AppLogLevel.fatal;
    default:
      return AppLogLevel.info;
  }
}

const _levelEmojis = <AppLogLevel, String>{
  AppLogLevel.trace: '🔍',
  AppLogLevel.debug: '🐛',
  AppLogLevel.info: 'ℹ️',
  AppLogLevel.warning: '⚠️',
  AppLogLevel.error: '❌',
  AppLogLevel.fatal: '💀',
};

_AiAgentLine? _parseAiAgentLine(String line) {
  // 期望：{ts} [{LEVEL}][{CAT}:{pkg}] {body} [| err=... | at f1, f2, f3]
  final match = RegExp(
    r'^(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d{3}) \[([A-Z ]+)\]\[([A-Z]+):([^\]]+)\] (.*)$',
  ).firstMatch(line);
  if (match == null) return null;
  final ts = match.group(1) ?? '';
  final level = (match.group(2) ?? '').trim();
  final cat = match.group(3) ?? 'UNC';
  final pkg = match.group(4) ?? 'app';
  final rest = match.group(5) ?? '';
  String? err;
  List<String> frames = const [];
  if (rest.contains(' | at ')) {
    final parts = rest.split(' | ');
    final body = parts.first;
    for (final p in parts.skip(1)) {
      if (p.startsWith('err=')) {
        err = p.substring(4);
      } else if (p.startsWith('at ')) {
        frames = p.substring(3).split(', ').map((s) => s.trim()).toList();
      }
    }
    return _AiAgentLine(
      timestamp: ts,
      level: level,
      category: cat,
      package: pkg,
      body: body,
      error: err,
      stackFrames: frames,
    );
  }
  return _AiAgentLine(
    timestamp: ts,
    level: level,
    category: cat,
    package: pkg,
    body: rest,
    error: null,
    stackFrames: const [],
  );
}

String _aiAgentLineToHumanReadable(_AiAgentLine line) {
  final appLevel = _levelToAppLog(line.level);
  final emoji = _levelEmojis[appLevel] ?? '•';
  final buffer = StringBuffer()
    ..write(emoji)
    ..write(' [')
    ..write(line.level.padRight(5))
    ..write('] [')
    ..write(line.category)
    ..write(':')
    ..write(line.package)
    ..write('] ')
    ..write(line.timestamp)
    ..write(' ')
    ..write(line.body);
  if (line.error != null) {
    buffer.write('\n  err=');
    buffer.write(line.error);
  }
  for (final frame in line.stackFrames) {
    buffer.write('\n  at ');
    buffer.write(frame);
  }
  return buffer.toString();
}
