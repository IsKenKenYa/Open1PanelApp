import 'package:flutter/material.dart';
import 'package:onepanel_client/core/i18n/l10n_x.dart';
import 'package:onepanel_client/core/utils/snackbar_utils.dart';
import 'package:onepanel_client/core/services/logger/logger_service.dart';
import 'package:onepanel_client/features/files/files_provider.dart';
import 'package:onepanel_client/shared/widgets/forms/app_form_dialog.dart';

class _SilentValidation implements Exception {
  const _SilentValidation();
}

void showCompressDialog(
  BuildContext context,
  FilesProvider provider,
  List<String> files,
  AppLocalizations l10n,
) {
  appLogger.dWithPackage(
      'compress_dialog', 'showCompressDialog: 打开压缩对话框, files=$files');
  final nameController = TextEditingController();
  var type = 'zip';
  showAppFormDialog(
    context,
    title: l10n.filesActionCompress,
    confirmLabel: l10n.commonConfirm,
    content: StatefulBuilder(
      builder: (context, setDialogState) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: l10n.filesNameLabel,
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: type,
            decoration: InputDecoration(labelText: l10n.filesCompressType),
            items: const [
              DropdownMenuItem(value: 'zip', child: Text('ZIP')),
              DropdownMenuItem(value: 'tar', child: Text('TAR')),
              DropdownMenuItem(value: 'tar.gz', child: Text('TAR.GZ')),
              DropdownMenuItem(value: '7z', child: Text('7Z')),
            ],
            onChanged: (value) {
              setDialogState(() => type = value ?? 'zip');
            },
          ),
        ],
      ),
    ),
    onConfirm: () async {
      final name = nameController.text.trim();
      if (name.isEmpty) {
        throw const _SilentValidation();
      }
      appLogger.dWithPackage(
          'compress_dialog', 'showCompressDialog: 用户输入名称=$name, type=$type');
      try {
        await provider.compressFiles(
            files, provider.data.currentPath, name, type);
        appLogger.iWithPackage('compress_dialog', 'showCompressDialog: 压缩成功');
      } catch (e, stackTrace) {
        appLogger.eWithPackage('compress_dialog', 'showCompressDialog: 压缩失败',
            error: e, stackTrace: stackTrace);
        if (context.mounted) {
          SnackBarUtils.showErrorWithDebugDetails(
              context, l10n.filesCompressFailed,
              error: e, stackTrace: stackTrace);
        }
        rethrow;
      }
    },
  );
}
