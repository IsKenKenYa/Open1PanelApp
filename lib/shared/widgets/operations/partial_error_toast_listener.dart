import 'package:flutter/material.dart';
import 'package:onepanel_client/core/i18n/l10n_x.dart';
import 'package:onepanel_client/core/utils/error_message_utils.dart';
import 'package:onepanel_client/core/utils/snackbar_utils.dart';

/// Schedules a snackbar when [errorMessage] becomes non-null while [hasCachedData] is true.
///
/// Does not participate in layout; safe to place in a [Stack] beside list content.
class PartialErrorToastListener extends StatefulWidget {
  const PartialErrorToastListener({
    super.key,
    required this.errorMessage,
    required this.hasCachedData,
    this.onRetry,
    this.fallbackTitle,
    this.child = const SizedBox.shrink(),
  });

  final String? errorMessage;
  final bool hasCachedData;
  final VoidCallback? onRetry;
  final String? fallbackTitle;
  final Widget child;

  @override
  State<PartialErrorToastListener> createState() =>
      _PartialErrorToastListenerState();
}

class _PartialErrorToastListenerState extends State<PartialErrorToastListener> {
  /// 内容级去重登记表（跨所有 listener 实例共享）：
  /// key 为最终展示的消息内容，value 为该 Toast 的展示截止时间。
  ///
  /// 背景（真机走查 P2-4）：多 keep-alive 页面各自挂 listener，轮询失败时
  /// 按 listener 实例去重导致同一错误消息被反复 clearSnackBars + showSnackBar
  /// 重置计时，错误 Toast 跨页"永驻"。改为按消息内容去重：同消息已展示期间
  /// 不重复弹。
  static final Map<String, DateTime> _shownUntilByMessage = {};
  static const Duration _displayWindow = Duration(seconds: 5);

  // Incremented on each schedule call; stale callbacks check this to bail out
  int _toastScheduleGeneration = 0;

  @override
  void initState() {
    super.initState();
    _scheduleMaybeShowToast();
  }

  @override
  void didUpdateWidget(covariant PartialErrorToastListener oldWidget) {
    super.didUpdateWidget(oldWidget);
    final errorChanged = oldWidget.errorMessage != widget.errorMessage;
    final cacheBecameAvailable =
        !oldWidget.hasCachedData && widget.hasCachedData;

    if (errorChanged || cacheBecameAvailable) {
      _scheduleMaybeShowToast();
    }
  }

  void _scheduleMaybeShowToast() {
    final generation = ++_toastScheduleGeneration;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || generation != _toastScheduleGeneration) {
        return;
      }
      _maybeShowToast();
    });
  }

  void _maybeShowToast() {
    final error = widget.errorMessage;
    if (!widget.hasCachedData || error == null || error.isEmpty) {
      return;
    }

    final l10n = context.l10n;
    final message = ErrorMessageUtils.truncateForToast(
      error,
      maxLength: 120,
    );
    final title = widget.fallbackTitle ?? l10n.commonLoadFailedTitle;
    final displayMessage = message.isEmpty ? title : '$title: $message';

    // 内容级去重：同一消息在展示期间不重复弹（跨 listener 实例共享）。
    final now = DateTime.now();
    _shownUntilByMessage
        .removeWhere((_, shownUntil) => !now.isBefore(shownUntil));
    if (_shownUntilByMessage.containsKey(displayMessage)) {
      return;
    }
    _shownUntilByMessage[displayMessage] = now.add(_displayWindow);

    if (widget.onRetry == null) {
      SnackBarUtils.showError(context, displayMessage);
      return;
    }

    SnackBarUtils.showErrorWithRetry(
      context,
      displayMessage,
      widget.onRetry!,
      retryLabel: l10n.commonRetry,
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
