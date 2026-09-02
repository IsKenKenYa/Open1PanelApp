import 'package:flutter/material.dart';
import 'package:onepanel_client/core/i18n/l10n_x.dart';

/// 统一对话框表单（M3 Expressive / MDUI3 轨道标准件）。
///
/// 全仓所有「AlertDialog 内表单」必须复用本组件（或
/// [showAppFormDialog] helper），统一：
/// - actions 行：取消 TextButton + 确认 FilledButton；
/// - 防重复提交：[isSaving] 为 true 时确认按钮禁用并内嵌 spinner；
/// - 圆角/背景：由全局 dialogTheme 承担（radiusXl=28）。
class AppFormDialog extends StatelessWidget {
  const AppFormDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onConfirm,
    this.isSaving = false,
    this.confirmLabel,
    this.confirmButtonKey,
  });

  final String title;
  final Widget content;
  final Future<void> Function() onConfirm;
  final bool isSaving;
  final String? confirmLabel;
  final Key? confirmButtonKey;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(title),
      content: content,
      actions: [
        TextButton(
          onPressed: isSaving
              ? null
              : () => Navigator.of(context).pop(false),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          key: confirmButtonKey,
          onPressed: isSaving ? null : () => onConfirm(),
          child: SizedBox(
            height: 24,
            child: Center(
              child: isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(confirmLabel ?? l10n.commonConfirm),
            ),
          ),
        ),
      ],
    );
  }
}

/// [AppFormDialog] 的便捷 helper：确认后 pop(true)，取消 pop(false)。
Future<bool> showAppFormDialog(
  BuildContext context, {
  required String title,
  required Widget content,
  required Future<void> Function() onConfirm,
  bool isSaving = false,
  String? confirmLabel,
  Key? confirmButtonKey,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AppFormDialog(
      title: title,
      content: content,
      onConfirm: () async {
        await onConfirm();
        if (dialogContext.mounted) Navigator.of(dialogContext).pop(true);
      },
      isSaving: isSaving,
      confirmLabel: confirmLabel,
      confirmButtonKey: confirmButtonKey,
    ),
  );
  return result ?? false;
}
