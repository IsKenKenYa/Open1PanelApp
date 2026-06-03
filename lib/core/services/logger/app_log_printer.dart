import 'package:logger/logger.dart';

import 'log_format.dart';

/// 自定义 `LogPrinter`，输出**单行结构化**格式，替代 `package:logger`
/// 的 `PrettyPrinter`。
///
/// 设计目标：
/// - 移除 box-drawing 装饰字符（`├` `┄` `└` `─`）以减少 AI Agent 解析 token
/// - 单条日志固定 1 行，便于 `tail -f` / `grep` / AI Agent 解析
/// - 错误堆栈压成 1 行紧凑形式，最多保留前 3 帧
/// - 文件输出不含 ANSI 颜色码
///
/// 典型输出（AI Agent 格式）：
/// ```
/// 2026-06-03 18:06:12.353 [INFO ][UI:features.dashboard] Extracted metrics: cpu=10%
/// 2026-06-03 18:06:12.460 [ERROR][NET:core.network.dio] Request failed | err=SocketException(...) | at frame1, at frame2, at frame3
/// ```
class AppLogPrinter extends LogPrinter {
  AppLogPrinter({
    this.format = LogFormat.aiAgent,
    this.maxStackFrames = 3,
    this.colors = false,
  });

  /// 日志格式（人读 / AI Agent）。
  final LogFormat format;

  /// 错误堆栈保留的最大帧数。
  final int maxStackFrames;

  /// 是否在终端输出 ANSI 颜色码（仅控制台生效，文件始终无颜色）。
  final bool colors;

  @override
  List<String> log(LogEvent event) {
    final formatted = format.format(
      event: event,
      maxStackFrames: maxStackFrames,
      colorize: colors,
    );
    return [formatted];
  }
}
