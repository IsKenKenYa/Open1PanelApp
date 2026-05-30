import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../theme/app_design_tokens.dart';
import 'debug_error_dialog.dart';

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
        message: message,
        icon: Icons.error_outline,
        backgroundColor: Theme.of(context).colorScheme.error,
        action: action,
        duration: const Duration(seconds: 5));
  }

  static void showWarning(BuildContext context, String message,
      {SnackBarAction? action}) {
    _show(context,
        message: message,
        icon: Icons.warning_amber_outlined,
        backgroundColor: AppDesignTokens.warning,
        action: action);
  }

  static void showInfo(BuildContext context, String message,
      {SnackBarAction? action}) {
    _show(context,
        message: message,
        icon: Icons.info_outline,
        backgroundColor: Theme.of(context).colorScheme.inverseSurface,
        action: action);
  }

  static void showErrorWithDebugDetails(
    BuildContext context,
    String message, {
    dynamic error,
    StackTrace? stackTrace,
  }) {
    if (!kDebugMode) {
      showError(context, message);
      return;
    }
    _show(context,
        message: message,
        icon: Icons.error_outline,
        backgroundColor: Theme.of(context).colorScheme.error,
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: '详情',
          onPressed: () =>
              DebugErrorDialog.show(context, message, error,
                  stackTrace: stackTrace),
        ));
  }

  static void _show(
    BuildContext context, {
    required String message,
    required IconData icon,
    required Color backgroundColor,
    SnackBarAction? action,
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
