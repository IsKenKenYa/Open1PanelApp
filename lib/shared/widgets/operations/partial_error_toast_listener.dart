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
  String? _lastShownError;
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
    final errorCleared =
        oldWidget.errorMessage != null && widget.errorMessage == null;
    final errorChanged = oldWidget.errorMessage != widget.errorMessage;
    final cacheBecameAvailable =
        !oldWidget.hasCachedData && widget.hasCachedData;

    if (errorCleared) {
      _lastShownError = null;
    }

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
    // Deduplicate: only show each distinct error once until it clears
    if (_lastShownError == error) {
      return;
    }
    _lastShownError = error;

    final l10n = context.l10n;
    final message = ErrorMessageUtils.truncateForToast(
      error,
      maxLength: 120,
    );
    final title = widget.fallbackTitle ?? l10n.commonLoadFailedTitle;
    final displayMessage = message.isEmpty ? title : '$title: $message';

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
