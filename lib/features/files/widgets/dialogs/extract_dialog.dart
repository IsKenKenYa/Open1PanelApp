import 'package:flutter/material.dart';
import 'package:onepanel_client/core/i18n/l10n_x.dart';
import 'package:onepanel_client/core/utils/snackbar_utils.dart';
import 'package:onepanel_client/core/services/logger/logger_service.dart';
import 'package:onepanel_client/data/models/file_models.dart';
import 'package:onepanel_client/features/files/files_provider.dart';
import 'package:onepanel_client/shared/widgets/forms/app_form_dialog.dart';

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
  appLogger.dWithPackage(
      'extract_dialog', 'showExtractDialog: 打开解压对话框, file=${file.path}');
  final controller = TextEditingController(text: provider.data.currentPath);

  final type = _getCompressType(file.name);

  showAppFormDialog(
    context,
    title: l10n.filesActionExtract,
    confirmLabel: l10n.commonConfirm,
    content: TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: l10n.filesTargetPath,
        prefixIcon: const Icon(Icons.folder_outlined),
      ),
    ),
    onConfirm: () async {
      appLogger.dWithPackage('extract_dialog',
          'showExtractDialog: 用户选择目标路径=${controller.text}, type=$type');
      try {
        await provider.extractFile(file.path, controller.text, type);
        appLogger.iWithPackage('extract_dialog', 'showExtractDialog: 解压成功');
      } catch (e, stackTrace) {
        appLogger.eWithPackage('extract_dialog', 'showExtractDialog: 解压失败',
            error: e, stackTrace: stackTrace);
        if (context.mounted) {
          SnackBarUtils.showErrorWithDebugDetails(
              context, l10n.filesExtractFailed,
              error: e, stackTrace: stackTrace);
        }
        rethrow;
      }
    },
  );
}
