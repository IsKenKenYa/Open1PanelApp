import 'package:flutter/material.dart';
import 'package:onepanel_client/core/i18n/l10n_x.dart';
import 'package:onepanel_client/core/utils/snackbar_utils.dart';
import 'package:onepanel_client/core/services/logger/logger_service.dart';
import 'package:onepanel_client/data/models/file_models.dart';
import 'package:onepanel_client/features/files/files_provider.dart';
import 'package:onepanel_client/shared/widgets/forms/app_form_dialog.dart';

class _SilentValidation implements Exception {
  const _SilentValidation();
}

void showRenameDialog(
  BuildContext context,
  FilesProvider provider,
  FileInfo file,
  AppLocalizations l10n,
) {
  appLogger.dWithPackage(
      'rename_dialog', 'showRenameDialog: 打开重命名对话框, file=${file.path}');
  final controller = TextEditingController(text: file.name);
  showAppFormDialog(
    context,
    title: l10n.filesActionRename,
    confirmLabel: l10n.commonSave,
    content: TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: l10n.filesNameLabel,
      ),
      autofocus: true,
    ),
    onConfirm: () async {
      final newName = controller.text.trim();
      if (newName.isEmpty || newName == file.name) {
        throw const _SilentValidation();
      }
      appLogger.dWithPackage(
          'rename_dialog', 'showRenameDialog: 用户输入新名称=$newName');
      try {
        await provider.renameFile(file.path, newName);
        appLogger.iWithPackage('rename_dialog', 'showRenameDialog: 重命名成功');
      } catch (e, stackTrace) {
        appLogger.eWithPackage('rename_dialog', 'showRenameDialog: 重命名失败',
            error: e, stackTrace: stackTrace);
        if (context.mounted) {
          SnackBarUtils.showErrorWithDebugDetails(context, l10n.filesRenameFailed,
              error: e, stackTrace: stackTrace);
        }
        rethrow;
      }
    },
  );
}
