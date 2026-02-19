import 'package:flutter/material.dart';
import 'package:onepanelapp_app/core/i18n/l10n_x.dart';
import 'package:onepanelapp_app/data/models/file_models.dart';
import 'package:onepanelapp_app/features/files/files_provider.dart';
import 'package:onepanelapp_app/features/files/files_service.dart';

Future<String?> showPathSelectorDialog(
  BuildContext context,
  FilesProvider provider,
  String currentPath,
  AppLocalizations l10n,
) async {
  String selectedPath = currentPath;
  
  return showDialog<String>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setDialogState) {
        return AlertDialog(
          title: Text(l10n.filesPathSelectorTitle),
          content: SizedBox(
            width: 300,
            height: 400,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.folder),
                  title: Text(l10n.filesCurrentFolder),
                  subtitle: Text(selectedPath, style: Theme.of(context).textTheme.bodySmall),
                  onTap: () {
                    Navigator.pop(dialogContext, selectedPath);
                  },
                ),
                const Divider(),
                Expanded(
                  child: FutureBuilder<List<FileInfo>>(
                    future: _loadSubfolders(selectedPath),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final folders = snapshot.data ?? [];
                      if (folders.isEmpty) {
                        return Center(child: Text(l10n.filesNoSubfolders));
                      }
                      return ListView.builder(
                        itemCount: folders.length,
                        itemBuilder: (context, index) {
                          final folder = folders[index];
                          return ListTile(
                            leading: const Icon(Icons.folder_outlined),
                            title: Text(folder.name),
                            onTap: () {
                              setDialogState(() {
                                selectedPath = folder.path;
                              });
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l10n.commonCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, selectedPath),
              child: Text(l10n.commonConfirm),
            ),
          ],
        );
      },
    ),
  );
}

Future<List<FileInfo>> _loadSubfolders(String path) async {
  try {
    final service = FilesService();
    final files = await service.getFiles(path: path);
    return files.where((f) => f.isDir).toList();
  } catch (e) {
    return [];
  }
}
