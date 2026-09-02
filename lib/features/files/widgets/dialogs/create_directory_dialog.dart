import 'package:flutter/material.dart';
import 'package:onepanel_client/core/i18n/l10n_x.dart';
import 'package:onepanel_client/core/utils/snackbar_utils.dart';
import 'package:onepanel_client/core/services/logger/logger_service.dart';
import 'package:onepanel_client/features/files/files_provider.dart';
import 'package:onepanel_client/shared/widgets/forms/app_form_dialog.dart';

void showCreateDirectoryDialog(BuildContext context, FilesProvider provider) {
  appLogger.dWithPackage(
      'create_directory_dialog', 'showCreateDirectoryDialog: 打开创建文件夹对话框');
  final controller = TextEditingController();
  showAppFormDialog(
    context,
    title: context.l10n.filesActionNewFolder,
    confirmLabel: context.l10n.commonCreate,
    content: TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: context.l10n.filesNameLabel,
        hintText: context.l10n.filesNameHint,
      ),
      autofocus: true,
    ),
    onConfirm: () async {
      final name = controller.text.trim();
      if (name.isEmpty) {
        // 保持对话框打开，等待有效输入。
        throw const _EmptyInputSilent();
      }
      appLogger.dWithPackage('create_directory_dialog',
          'showCreateDirectoryDialog: 用户输入名称=$name');
      try {
        await provider.createDirectory(name);
        appLogger.iWithPackage(
            'create_directory_dialog', 'showCreateDirectoryDialog: 创建成功');
      } catch (e, stackTrace) {
        appLogger.eWithPackage('create_directory_dialog',
            'showCreateDirectoryDialog: 创建失败',
            error: e, stackTrace: stackTrace);
        if (context.mounted) {
          SnackBarUtils.showErrorWithDebugDetails(context,
              context.l10n.filesCreateFailed, error: e, stackTrace: stackTrace);
        }
        // 保持打开以便修正输入；防重态已由 helper 复位。
        rethrow;
      }
    },
  );
}

class _EmptyInputSilent implements Exception {
  const _EmptyInputSilent();
}
