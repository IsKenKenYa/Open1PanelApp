import 'package:flutter/material.dart';
import 'package:onepanelapp_app/core/i18n/l10n_x.dart';
import 'package:onepanelapp_app/core/utils/debug_error_dialog.dart';
import 'package:onepanelapp_app/core/services/logger/logger_service.dart';
import 'package:onepanelapp_app/data/models/file_models.dart';
import 'package:onepanelapp_app/features/files/files_provider.dart';

String _getCompressType(String filename) {
  if (filename.endsWith('.tar.gz')) return 'tar.gz';
  if (filename.endsWith('.tar')) return 'tar';
  if (filename.endsWith('.zip')) return 'zip';
  if (filename.endsWith('.7z')) return '7z';
  if (filename.endsWith('.gz')) return 'gz';
  if (filename.endsWith('.bz2')) return 'bz2';
  if (filename.endsWith('.xz')) return 'xz';
  return 'zip';
}

void showExtractDialog(
  BuildContext context,
  FilesProvider provider,
  FileInfo file,
  AppLocalizations l10n,
) {
  appLogger.dWithPackage('extract_dialog', 'showExtractDialog: 打开解压对话框, file=${file.path}');
  final controller = TextEditingController(text: provider.data.currentPath);
  
  final type = _getCompressType(file.name);
  
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(l10n.filesActionExtract),
      content: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: l10n.filesTargetPath,
          prefixIcon: const Icon(Icons.folder_outlined),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          onPressed: () async {
            appLogger.dWithPackage('extract_dialog', 'showExtractDialog: 用户选择目标路径=${controller.text}, type=$type');
            Navigator.pop(dialogContext);
            try {
              await provider.extractFile(file.path, controller.text, type);
              appLogger.iWithPackage('extract_dialog', 'showExtractDialog: 解压成功');
            } catch (e, stackTrace) {
              appLogger.eWithPackage('extract_dialog', 'showExtractDialog: 解压失败', error: e, stackTrace: stackTrace);
              if (context.mounted) {
                DebugErrorDialog.show(context, l10n.filesExtractFailed, e, stackTrace: stackTrace);
              }
            }
          },
          child: Text(l10n.commonConfirm),
        ),
      ],
    ),
  );
}
