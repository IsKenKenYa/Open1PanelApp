import 'package:flutter/material.dart';
import 'package:onepanel_client/core/i18n/l10n_x.dart';
import 'package:onepanel_client/core/utils/error_message_utils.dart';
import 'package:onepanel_client/core/utils/snackbar_utils.dart';

/// Shows a toast when [errorMessage] becomes non-null while [hasCachedData] is true.
class PartialErrorToastListener extends StatefulWidget {
  const PartialErrorToastListener({
    super.key,
    required this.errorMessage,
    required this.hasCachedData,
    required this.child,
    this.onRetry,
    this.fallbackTitle,
  });

  final String? errorMessage;
  final bool hasCachedData;
  final Widget child;
  final VoidCallback? onRetry;
  final String? fallbackTitle;

  @override
  State<PartialErrorToastListener> createState() =>
      _PartialErrorToastListenerState();
}

class _PartialErrorToastListenerState extends State<PartialErrorToastListener> {
  String? _lastShownError;

  @override
  void didUpdateWidget(covariant PartialErrorToastListener oldWidget) {
    super.didUpdateWidget(oldWidget);
    _maybeShowToast();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeShowToast());
  }

  void _maybeShowToast() {
    final error = widget.errorMessage;
    if (!widget.hasCachedData || error == null || error.isEmpty) {
      if (error == null) {
        _lastShownError = null;
      }
      return;
    }
    if (_lastShownError == error) {
      return;
    }
    _lastShownError = error;

    if (!mounted) {
      return;
    }

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
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
