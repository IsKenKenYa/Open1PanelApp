import 'package:flutter/material.dart';
import 'package:onepanel_client/core/i18n/l10n_x.dart';
import 'package:onepanel_client/core/utils/snackbar_utils.dart';
import 'package:onepanel_client/data/models/container_models.dart';
import 'package:onepanel_client/core/layout/adaptive_layout.dart';

/// 编排模版创建/编辑对话框。
/// 对齐 1Panel 前端 `container/template/operate/index.vue`：name/description/content。
/// 返回填写完成的请求；取消时返回 null。
Future<ContainerTemplateOperate?> showComposeTemplateEditDialog(
  BuildContext context, {
  ContainerTemplate? template,
}) {
  final l10n = context.l10n;
  final nameController = TextEditingController(text: template?.name ?? '');
  final descriptionController =
      TextEditingController(text: template?.description ?? '');
  final contentController =
      TextEditingController(text: template?.content ?? '');
  return showDialog<ContainerTemplateOperate>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(
          template == null ? l10n.composeTemplateCreate : l10n.composeTemplateEdit),
      content: SizedBox(width: AdaptiveLayoutSpec.of(context).dialogConstraints.maxWidth, 
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: l10n.commonName,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: l10n.commonDescription,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: contentController,
                maxLines: 10,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                decoration: InputDecoration(
                  labelText: l10n.composeTemplateContent,
                  alignLabelWithHint: true,
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          onPressed: () {
            final name = nameController.text.trim();
            if (name.isEmpty) {
              SnackBarUtils.showError(
                  dialogContext, l10n.composeTemplateNameRequired);
              return;
            }
            Navigator.of(dialogContext).pop(ContainerTemplateOperate(
              id: template?.id,
              name: name,
              description: descriptionController.text.trim(),
              content: contentController.text,
            ));
          },
          child: Text(l10n.commonSave),
        ),
      ],
    ),
  );
}
