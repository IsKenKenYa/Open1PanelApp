import 'package:flutter/material.dart';
import 'package:onepanel_client/core/i18n/l10n_x.dart';
import 'package:onepanel_client/core/utils/snackbar_utils.dart';
import 'package:onepanel_client/core/services/logger/logger_service.dart';
import 'package:onepanel_client/features/files/files_provider.dart';
import 'package:onepanel_client/shared/widgets/forms/app_form_dialog.dart';

void showCreateFileDialog(BuildContext context, FilesProvider provider) {
  appLogger.dWithPackage(
      'create_file_dialog', 'showCreateFileDialog: 打开创建文件对话框');
  final controller = TextEditingController();
  showAppFormDialog(
    context,
    title: context.l10n.filesActionNewFile,
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
        throw const _EmptyInputSilent();
      }
      appLogger.dWithPackage('create_file_dialog',
          'showCreateFileDialog: 用户输入名称=$name');
      try {
        await provider.createFile(name);
        appLogger.iWithPackage(
            'create_file_dialog', 'showCreateFileDialog: 创建成功');
      } catch (e, stackTrace) {
        appLogger.eWithPackage('create_file_dialog',
            'showCreateFileDialog: 创建失败',
            error: e, stackTrace: stackTrace);
        if (context.mounted) {
          SnackBarUtils.showErrorWithDebugDetails(context,
              context.l10n.filesCreateFailed, error: e, stackTrace: stackTrace);
        }
        rethrow;
      }
    },
  );
}

class _EmptyInputSilent implements Exception {
  const _EmptyInputSilent();
}
