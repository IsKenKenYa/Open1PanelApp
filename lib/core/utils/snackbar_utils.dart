import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../theme/app_design_tokens.dart';
import 'debug_error_dialog.dart';
import 'error_message_utils.dart';

class SnackBarUtils {
  const SnackBarUtils._();

  static void showSuccess(BuildContext context, String message,
      {SnackBarAction? action}) {
    _show(context,
        message: message,
        icon: Icons.check_circle_outline,
        backgroundColor: AppDesignTokens.success,
        action: action);
  }

  static void showError(BuildContext context, String message,
      {SnackBarAction? action}) {
    _show(context,
        message: ErrorMessageUtils.truncateForToast(message),
        icon: Icons.error_outline,
        backgroundColor: Theme.of(context).colorScheme.error,
        action: action,
        duration: const Duration(seconds: 5));
  }

  static void showWarning(BuildContext context, String message,
      {SnackBarAction? action}) {
    _show(context,
        message: ErrorMessageUtils.truncateForToast(message),
        icon: Icons.warning_amber_outlined,
        backgroundColor: AppDesignTokens.warning,
        action: action);
  }

  static void showInfo(BuildContext context, String message,
      {SnackBarAction? action}) {
    _show(context,
        message: ErrorMessageUtils.truncateForToast(message),
        icon: Icons.info_outline,
        backgroundColor: Theme.of(context).colorScheme.inverseSurface,
        action: action);
  }

  static void showErrorWithRetry(
    BuildContext context,
    String message,
    VoidCallback onRetry, {
    Object? details,
    StackTrace? stackTrace,
    String? retryLabel,
  }) {
    final displayMessage = ErrorMessageUtils.truncateForToast(message);
    final label = retryLabel ?? '重试';

    if (details != null && kDebugMode) {
      _show(context,
          message: displayMessage,
          icon: Icons.error_outline,
          backgroundColor: Theme.of(context).colorScheme.error,
          duration: const Duration(seconds: 5),
          trailing: TextButton(
            onPressed: () => DebugErrorDialog.show(
              context,
              displayMessage,
              details,
              stackTrace: stackTrace,
            ),
            child: const Text('详情', style: TextStyle(color: Colors.white)),
          ),
          action: SnackBarAction(label: label, onPressed: onRetry));
      return;
    }

    _show(context,
        message: displayMessage,
        icon: Icons.error_outline,
        backgroundColor: Theme.of(context).colorScheme.error,
        duration: const Duration(seconds: 5),
        action: SnackBarAction(label: label, onPressed: onRetry));
  }

  static void showErrorWithDebugDetails(
    BuildContext context,
    String message, {
    dynamic error,
    StackTrace? stackTrace,
  }) {
    final displayMessage = ErrorMessageUtils.truncateForToast(message);
    if (!kDebugMode) {
      showError(context, displayMessage);
      return;
    }
    _show(context,
        message: displayMessage,
        icon: Icons.error_outline,
        backgroundColor: Theme.of(context).colorScheme.error,
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: '详情',
          onPressed: () =>
              DebugErrorDialog.show(context, displayMessage, error,
                  stackTrace: stackTrace),
        ));
  }

  static void _show(
    BuildContext context, {
    required String message,
    required IconData icon,
    required Color backgroundColor,
    SnackBarAction? action,
    Widget? trailing,
    Duration? duration,
  }) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
            if (trailing != null) trailing,
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radiusSm),
        ),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        showCloseIcon: true,
        action: action,
        duration: duration ?? const Duration(seconds: 4),
      ));
  }
}
