import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:onepanelapp_app/core/theme/app_design_tokens.dart';
import 'package:onepanelapp_app/core/i18n/l10n_x.dart';
import 'package:onepanelapp_app/data/models/file_models.dart';
import 'package:onepanelapp_app/features/files/files_provider.dart';
import 'package:onepanelapp_app/features/files/files_service.dart';
import 'package:onepanelapp_app/features/files/file_preview_page.dart';
import 'package:onepanelapp_app/features/files/file_editor_page.dart';
import 'package:onepanelapp_app/features/files/favorites_page.dart';
import 'package:onepanelapp_app/features/files/recycle_bin_page.dart';
import 'package:onepanelapp_app/core/utils/debug_error_dialog.dart';
import 'package:onepanelapp_app/core/config/api_config.dart';
import 'package:onepanelapp_app/core/services/logger/logger_service.dart';

export 'files_provider.dart' show WgetDownloadState;

class FilesPage extends StatelessWidget {
  const FilesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final provider = FilesProvider();
        provider.loadServer();
        provider.loadFiles();
        return provider;
      },
      child: const FilesView(),
    );
  }
}

class FilesView extends StatefulWidget {
  const FilesView({super.key});

  @override
  State<FilesView> createState() => _FilesViewState();
}

class _FilesViewState extends State<FilesView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<FilesProvider>().loadServer().then((_) {
          if (mounted) {
            context.read<FilesProvider>().loadFiles();
            context.read<FilesProvider>().loadFavorites();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    final canPop = Navigator.of(context).canPop();
    return Scaffold(
      appBar: AppBar(
        leading: canPop
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).maybePop(),
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              )
            : null,
        title: Consumer<FilesProvider>(
          builder: (context, provider, _) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.filesPageTitle,
                overflow: TextOverflow.ellipsis,
              ),
              if (provider.data.currentServer != null)
                Text(
                  provider.data.currentServer!.name,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
        actions: [
          if (canPop)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => _showSearchDialog(context),
              tooltip: l10n.filesActionSearch,
            ),
          _buildServerSelector(context),
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            onPressed: () => context.read<FilesProvider>().refresh(),
            tooltip: l10n.systemSettingsRefresh,
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showMoreOptions(context),
          ),
        ],
      ),
      body: Consumer<FilesProvider>(
        builder: (context, provider, _) {
          if (provider.data.isLoading && provider.data.files.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.data.error != null) {
            return _buildContentScaffold(
              context,
              provider,
              theme,
              l10n,
              child: _buildErrorState(context, provider, theme),
            );
          }

          if (provider.data.files.isEmpty) {
            return _buildContentScaffold(
              context,
              provider,
              theme,
              l10n,
              child: _buildEmptyState(context, l10n, theme),
            );
          }

          return _buildFileList(context, provider, theme, l10n);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateOptions(context),
        icon: const Icon(Icons.add),
        label: Text(l10n.filesActionNew),
      ),
      bottomNavigationBar: Consumer<FilesProvider>(
        builder: (context, provider, _) {
          if (!provider.data.hasSelection) {
            return const SizedBox.shrink();
          }
          return _buildSelectionBar(context, provider, l10n);
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, FilesProvider provider, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
          const SizedBox(height: 16),
          Text(provider.data.error!, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => provider.loadFiles(),
            child: Text(context.l10n.commonRetry),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n, ThemeData theme) {
    final provider = context.read<FilesProvider>();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open_outlined,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(l10n.filesEmptyTitle),
          const SizedBox(height: 8),
          Text(l10n.filesEmptyDesc, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton.icon(
                onPressed: () => _showCreateDirectoryDialog(context, provider),
                icon: const Icon(Icons.create_new_folder_outlined),
                label: Text(l10n.filesActionNewFolder),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () => _showCreateFileDialog(context, provider),
                icon: const Icon(Icons.note_add_outlined),
                label: Text(l10n.filesActionNewFile),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFileList(BuildContext context, FilesProvider provider, ThemeData theme, AppLocalizations l10n) {
    return _buildContentScaffold(
      context,
      provider,
      theme,
      l10n,
      child: RefreshIndicator(
        onRefresh: () => provider.refresh(),
        child: ListView.builder(
          padding: AppDesignTokens.pagePadding,
          itemCount: provider.data.files.length,
          itemBuilder: (context, index) {
            final file = provider.data.files[index];
            return _buildFileItem(context, provider, file, theme, l10n);
          },
        ),
      ),
    );
  }

  Widget _buildContentScaffold(
    BuildContext context,
    FilesProvider provider,
    ThemeData theme,
    AppLocalizations l10n, {
    required Widget child,
  }) {
    return _buildResponsiveBody(
      context,
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildPathBreadcrumb(context, provider, theme, l10n),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildResponsiveBody(BuildContext context, Widget child) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 840;
        final maxWidth = isWide ? 760.0 : double.infinity;
        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: child,
          ),
        );
      },
    );
  }

  Widget _buildPathBreadcrumb(BuildContext context, FilesProvider provider, ThemeData theme, AppLocalizations l10n) {
    final segments = provider.data.currentPath.split('/');
    segments.removeWhere((s) => s.isEmpty);

    final colorScheme = theme.colorScheme;
    final buttonStyle = TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      visualDensity: VisualDensity.compact,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      foregroundColor: colorScheme.onSurface,
    );
    final breadcrumbTextStyle = theme.textTheme.labelLarge;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDesignTokens.spacingLg,
        AppDesignTokens.spacingMd,
        AppDesignTokens.spacingLg,
        AppDesignTokens.spacingSm,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Material(
          color: colorScheme.surfaceContainerLow,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  TextButton.icon(
                    onPressed: () => provider.navigateTo('/'),
                    style: buttonStyle,
                    icon: Icon(
                      Icons.home_outlined,
                      size: 18,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    label: Text(l10n.filesRoot, style: breadcrumbTextStyle),
                  ),
                  for (int i = 0; i < segments.length; i++) ...[
                    Icon(
                      Icons.chevron_right,
                      size: 18,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    TextButton(
                      onPressed: () {
                        final path = '/${segments.sublist(0, i + 1).join('/')}';
                        provider.navigateTo(path);
                      },
                      style: buttonStyle,
                      child: Text(segments[i], style: breadcrumbTextStyle),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFileItem(BuildContext context, FilesProvider provider, FileInfo file, ThemeData theme, AppLocalizations l10n) {
    final isSelected = provider.data.isSelected(file.path);
    final isDir = file.isDir;
    final colorScheme = theme.colorScheme;
    final isFavorite = provider.data.isFavorite(file.path);
    final metadata = <String>[
      isDir ? l10n.filesTypeDirectory : _formatFileSize(file.size),
    ];
    final modifiedLabel = _formatModifiedAt(file.modifiedAt);
    if (modifiedLabel != null) {
      metadata.add(modifiedLabel);
    }

    return Card(
      margin: const EdgeInsets.only(bottom: AppDesignTokens.spacingXs),
      color: isSelected ? colorScheme.primaryContainer : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Icon(
          isDir ? Icons.folder_outlined : _getFileIcon(file.name),
          color: isDir ? colorScheme.primary : _getFileIconColor(file.name, colorScheme),
          size: 32,
        ),
        title: Row(
          children: [
            Expanded(child: Text(file.name)),
            if (isFavorite)
              Icon(
                Icons.star,
                size: 18,
                color: colorScheme.primary,
              ),
          ],
        ),
        subtitle: Text(
          metadata.join(' · '),
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handleFileAction(context, provider, file, value, l10n),
          itemBuilder: (context) => [
            if (isDir)
              PopupMenuItem(value: 'open', child: Text(l10n.filesActionOpen)),
            if (!isDir)
              PopupMenuItem(value: 'download', child: Text(l10n.filesActionDownload)),
            PopupMenuItem(
              value: 'favorite',
              child: Text(isFavorite ? l10n.filesRemoveFromFavorites : l10n.filesAddToFavorites),
            ),
            PopupMenuItem(value: 'rename', child: Text(l10n.filesActionRename)),
            PopupMenuItem(value: 'copy', child: Text(l10n.filesActionCopy)),
            PopupMenuItem(value: 'move', child: Text(l10n.filesActionMove)),
            if (!isDir && _isCompressedFile(file.name))
              PopupMenuItem(value: 'extract', child: Text(l10n.filesActionExtract)),
            PopupMenuItem(value: 'compress', child: Text(l10n.filesActionCompress)),
            PopupMenuItem(value: 'permission', child: Text(l10n.filesPermissionTitle)),
            const PopupMenuDivider(),
            PopupMenuItem(
              value: 'delete',
              child: Text(
                l10n.filesActionDelete,
                style: TextStyle(color: colorScheme.error),
              ),
            ),
          ],
        ),
        onLongPress: () => provider.toggleSelection(file.path),
        onTap: () {
          if (provider.data.hasSelection) {
            provider.toggleSelection(file.path);
          } else if (isDir) {
            provider.navigateTo(file.path);
          }
        },
      ),
    );
  }

  Widget _buildSelectionBar(BuildContext context, FilesProvider provider, AppLocalizations l10n) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.15),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Text('${provider.data.selectionCount} ${l10n.filesSelected}'),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.folder_zip_outlined),
            onPressed: () => _showCompressDialog(context, provider, provider.data.selectedFiles.toList(), l10n),
            tooltip: l10n.filesActionCompress,
          ),
          IconButton(
            icon: const Icon(Icons.content_copy),
            onPressed: () => _showBatchCopyDialog(context, provider, l10n),
            tooltip: l10n.filesActionCopy,
          ),
          IconButton(
            icon: const Icon(Icons.drive_file_move_outline),
            onPressed: () => _showBatchMoveDialog(context, provider, l10n),
            tooltip: l10n.filesActionMove,
          ),
          IconButton(
            icon: const Icon(Icons.select_all),
            onPressed: () => provider.selectAll(),
            tooltip: l10n.filesActionSelectAll,
          ),
          IconButton(
            icon: const Icon(Icons.deselect),
            onPressed: () => provider.clearSelection(),
            tooltip: l10n.filesActionDeselect,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _showDeleteConfirmDialog(context, provider, l10n),
            tooltip: l10n.filesActionDelete,
          ),
        ],
      ),
    );
  }

  IconData _getFileIcon(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    switch (ext) {
      case 'pdf':
        return Icons.picture_as_pdf_outlined;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'webp':
        return Icons.image_outlined;
      case 'mp4':
      case 'avi':
      case 'mkv':
      case 'mov':
        return Icons.video_file_outlined;
      case 'mp3':
      case 'wav':
      case 'flac':
        return Icons.audio_file_outlined;
      case 'zip':
      case 'tar':
      case 'gz':
      case '7z':
      case 'rar':
        return Icons.folder_zip_outlined;
      case 'dart':
      case 'js':
      case 'ts':
      case 'py':
      case 'java':
      case 'swift':
      case 'kt':
        return Icons.code_outlined;
      case 'json':
      case 'yaml':
      case 'yml':
      case 'xml':
        return Icons.data_object_outlined;
      case 'md':
      case 'txt':
        return Icons.description_outlined;
      default:
        return Icons.insert_drive_file_outlined;
    }
  }

  Color _getFileIconColor(String fileName, ColorScheme colorScheme) {
    final ext = fileName.split('.').last.toLowerCase();
    switch (ext) {
      case 'pdf':
        return colorScheme.error;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'webp':
        return colorScheme.primary;
      case 'mp4':
      case 'avi':
      case 'mkv':
      case 'mov':
        return colorScheme.tertiary;
      case 'mp3':
      case 'wav':
      case 'flac':
        return colorScheme.secondary;
      case 'zip':
      case 'tar':
      case 'gz':
      case '7z':
      case 'rar':
        return colorScheme.tertiaryContainer;
      case 'dart':
        return colorScheme.primary;
      case 'js':
      case 'ts':
        return colorScheme.secondary;
      case 'py':
        return colorScheme.tertiary;
      case 'json':
      case 'yaml':
      case 'yml':
        return colorScheme.secondaryContainer;
      default:
        return colorScheme.onSurfaceVariant;
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  String? _formatModifiedAt(DateTime? time) {
    if (time == null) return null;
    final year = time.year.toString().padLeft(4, '0');
    final month = time.month.toString().padLeft(2, '0');
    final day = time.day.toString().padLeft(2, '0');
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$year-$month-$day $hour:$minute';
  }

  bool _isCompressedFile(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    return ['zip', 'tar', 'gz', 'bz2', 'xz', '7z', 'rar'].contains(ext);
  }

  void _handleFileAction(BuildContext context, FilesProvider provider, FileInfo file, String action, AppLocalizations l10n) {
    switch (action) {
      case 'open':
        if (file.isDir) provider.navigateTo(file.path);
        break;
      case 'download':
        _startDownload(context, provider, file, l10n);
        break;
      case 'preview':
        _openFilePreview(context, file);
        break;
      case 'edit':
        _openFileEditor(context, file);
        break;
      case 'favorite':
        _toggleFavorite(context, provider, file, l10n);
        break;
      case 'rename':
        _showRenameDialog(context, provider, file, l10n);
        break;
      case 'copy':
        _showCopyDialog(context, provider, file, l10n);
        break;
      case 'move':
        _showMoveDialog(context, provider, file, l10n);
        break;
      case 'extract':
        _showExtractDialog(context, provider, file, l10n);
        break;
      case 'compress':
        _showCompressDialog(context, provider, [file.path], l10n);
        break;
      case 'permission':
        _showPermissionDialog(context, provider, file, l10n);
        break;
      case 'delete':
        provider.toggleSelection(file.path);
        _showDeleteConfirmDialog(context, provider, l10n);
        break;
    }
  }

  void _openFilePreview(BuildContext context, FileInfo file) {
    appLogger.dWithPackage('files_page', '_openFilePreview: 打开预览 ${file.path}');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FilePreviewPage(
          filePath: file.path,
          fileName: file.name,
        ),
      ),
    );
  }

  void _openFileEditor(BuildContext context, FileInfo file) {
    appLogger.dWithPackage('files_page', '_openFileEditor: 打开编辑器 ${file.path}');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FileEditorPage(
          filePath: file.path,
          fileName: file.name,
        ),
      ),
    );
  }

  void _startDownload(BuildContext context, FilesProvider provider, FileInfo file, AppLocalizations l10n) {
    appLogger.dWithPackage('files_page', '_startDownload: 开始下载 ${file.name}');
    
    ScaffoldMessenger.of(context).clearSnackBars();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: ListenableBuilder(
          listenable: provider,
          builder: (context, _) {
            if (provider.data.isDownloading) {
              final progress = (provider.data.downloadProgress * 100).toInt();
              return Row(
                children: [
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(l10n.filesDownloadProgress(progress)),
                  ),
                ],
              );
            }
            return Text(l10n.filesDownloadSuccess);
          },
        ),
        duration: const Duration(seconds: 30),
        action: SnackBarAction(
          label: l10n.commonCancel,
          onPressed: () {
            provider.cancelDownload();
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );

    provider.downloadFile(file).then((savePath) {
      if (savePath != null && context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.filesDownloadSuccess),
            action: SnackBarAction(
              label: l10n.commonConfirm,
              onPressed: () {},
            ),
          ),
        );
      }
    }).catchError((e, stackTrace) async {
      appLogger.eWithPackage('files_page', '_startDownload: 下载失败', error: e, stackTrace: stackTrace);
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        final errorMsg = e.toString();
        if (errorMsg.contains('cancelled')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.filesDownloadCancelled)),
          );
        } else if (errorMsg.contains('storage_permission_denied')) {
          final isPermanentlyDenied = await provider.isStoragePermissionPermanentlyDenied();
          if (isPermanentlyDenied && context.mounted) {
            _showPermissionSettingsDialog(context, l10n);
          } else if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('存储权限被拒绝，无法下载文件'),
                action: SnackBarAction(
                  label: '设置',
                  onPressed: () => _showPermissionSettingsDialog(context, l10n),
                ),
              ),
            );
          }
        } else {
          DebugErrorDialog.show(context, l10n.filesDownloadFailed, e, stackTrace: stackTrace);
        }
      }
    });
  }

  void _showPermissionSettingsDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('存储权限'),
        content: const Text('请在设置中授予存储权限以保存下载文件'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Permission.storage.request().then((_) {
                Permission.manageExternalStorage.request();
              });
            },
            child: const Text('打开设置'),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleFavorite(BuildContext context, FilesProvider provider, FileInfo file, AppLocalizations l10n) async {
    appLogger.dWithPackage('files_page', '_toggleFavorite: path=${file.path}');
    
    final isFavorite = provider.data.isFavorite(file.path);
    
    if (isFavorite) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.filesFavoritesAdded)),
        );
      }
      return;
    }
    
    try {
      await provider.addToFavorites(file);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.filesFavoritesAdded)),
        );
      }
    } on DioException catch (e) {
      appLogger.eWithPackage('files_page', '_toggleFavorite: 失败', error: e);
      if (context.mounted) {
        final errorMsg = e.response?.data?.toString() ?? e.message ?? '';
        if (errorMsg.contains('已收藏') || errorMsg.contains('already')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.filesFavoritesAdded)),
          );
        } else {
          DebugErrorDialog.show(context, l10n.filesFavoritesLoadFailed, e);
        }
      }
    } catch (e, stackTrace) {
      appLogger.eWithPackage('files_page', '_toggleFavorite: 失败', error: e, stackTrace: stackTrace);
      if (context.mounted) {
        final errorMsg = e.toString();
        if (errorMsg.contains('已收藏') || errorMsg.contains('already')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.filesFavoritesAdded)),
          );
        } else {
          DebugErrorDialog.show(context, l10n.filesFavoritesLoadFailed, e, stackTrace: stackTrace);
        }
      }
    }
  }

  void _showCreateOptions(BuildContext context) {
    final provider = context.read<FilesProvider>();
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.create_new_folder_outlined),
              title: Text(context.l10n.filesActionNewFolder),
              onTap: () {
                Navigator.pop(sheetContext);
                _showCreateDirectoryDialog(context, provider);
              },
            ),
            ListTile(
              leading: const Icon(Icons.note_add_outlined),
              title: Text(context.l10n.filesActionNewFile),
              onTap: () {
                Navigator.pop(sheetContext);
                _showCreateFileDialog(context, provider);
              },
            ),
            ListTile(
              leading: const Icon(Icons.upload_file_outlined),
              title: Text(context.l10n.filesActionUpload),
              onTap: () {
                Navigator.pop(sheetContext);
                _showUploadDialog(context, provider);
              },
            ),
            ListTile(
              leading: const Icon(Icons.cloud_download_outlined),
              title: Text(context.l10n.filesActionWgetDownload),
              onTap: () {
                Navigator.pop(sheetContext);
                _showWgetDialog(context, provider);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateDirectoryDialog(BuildContext context, FilesProvider provider) {
    appLogger.dWithPackage('files_page', '_showCreateDirectoryDialog: 打开创建文件夹对话框');
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.filesActionNewFolder),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: context.l10n.filesNameLabel,
            hintText: context.l10n.filesNameHint,
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(context.l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () async {
              if (controller.text.isEmpty) return;
              appLogger.dWithPackage('files_page', '_showCreateDirectoryDialog: 用户输入名称=${controller.text}');
              Navigator.pop(dialogContext);
              try {
                await provider.createDirectory(controller.text);
                appLogger.iWithPackage('files_page', '_showCreateDirectoryDialog: 创建成功');
              } catch (e, stackTrace) {
                appLogger.eWithPackage('files_page', '_showCreateDirectoryDialog: 创建失败', error: e, stackTrace: stackTrace);
                if (context.mounted) {
                  DebugErrorDialog.show(context, context.l10n.filesCreateFailed, e, stackTrace: stackTrace);
                }
              }
            },
            child: Text(context.l10n.commonCreate),
          ),
        ],
      ),
    );
  }

  void _showCreateFileDialog(BuildContext context, FilesProvider provider) {
    appLogger.dWithPackage('files_page', '_showCreateFileDialog: 打开创建文件对话框');
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.filesActionNewFile),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: context.l10n.filesNameLabel,
            hintText: context.l10n.filesNameHint,
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(context.l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () async {
              if (controller.text.isEmpty) return;
              appLogger.dWithPackage('files_page', '_showCreateFileDialog: 用户输入名称=${controller.text}');
              Navigator.pop(dialogContext);
              try {
                await provider.createFile(controller.text);
                appLogger.iWithPackage('files_page', '_showCreateFileDialog: 创建成功');
              } catch (e, stackTrace) {
                appLogger.eWithPackage('files_page', '_showCreateFileDialog: 创建失败', error: e, stackTrace: stackTrace);
                if (context.mounted) {
                  DebugErrorDialog.show(context, context.l10n.filesCreateFailed, e, stackTrace: stackTrace);
                }
              }
            },
            child: Text(context.l10n.commonCreate),
          ),
        ],
      ),
    );
  }

  void _showRenameDialog(BuildContext context, FilesProvider provider, FileInfo file, AppLocalizations l10n) {
    appLogger.dWithPackage('files_page', '_showRenameDialog: 打开重命名对话框, file=${file.path}');
    final controller = TextEditingController(text: file.name);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.filesActionRename),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: l10n.filesNameLabel,
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () async {
              if (controller.text.isEmpty || controller.text == file.name) return;
              appLogger.dWithPackage('files_page', '_showRenameDialog: 用户输入新名称=${controller.text}');
              Navigator.pop(dialogContext);
              try {
                await provider.renameFile(file.path, controller.text);
                appLogger.iWithPackage('files_page', '_showRenameDialog: 重命名成功');
              } catch (e, stackTrace) {
                appLogger.eWithPackage('files_page', '_showRenameDialog: 重命名失败', error: e, stackTrace: stackTrace);
                if (context.mounted) {
                  DebugErrorDialog.show(context, l10n.filesRenameFailed, e, stackTrace: stackTrace);
                }
              }
            },
            child: Text(l10n.commonSave),
          ),
        ],
      ),
    );
  }

  void _showMoveDialog(BuildContext context, FilesProvider provider, FileInfo file, AppLocalizations l10n) {
    appLogger.dWithPackage('files_page', '_showMoveDialog: 打开移动对话框, file=${file.path}');
    final controller = TextEditingController(text: provider.data.currentPath);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.filesActionMove),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${l10n.filesNameLabel}: ${file.name}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: l10n.filesTargetPath,
                prefixIcon: const Icon(Icons.folder_outlined),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.folder_open),
                  onPressed: () async {
                    final selectedPath = await _showPathSelectorDialog(context, provider, controller.text, l10n);
                    if (selectedPath != null) {
                      controller.text = selectedPath;
                    }
                  },
                  tooltip: l10n.filesSelectPath,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () async {
              appLogger.dWithPackage('files_page', '_showMoveDialog: 用户选择目标路径=${controller.text}');
              Navigator.pop(dialogContext);
              try {
                await provider.moveFile(file.path, controller.text);
                appLogger.iWithPackage('files_page', '_showMoveDialog: 移动成功');
              } catch (e, stackTrace) {
                appLogger.eWithPackage('files_page', '_showMoveDialog: 移动失败', error: e, stackTrace: stackTrace);
                if (context.mounted) {
                  DebugErrorDialog.show(context, l10n.filesMoveFailed, e, stackTrace: stackTrace);
                }
              }
            },
            child: Text(l10n.commonConfirm),
          ),
        ],
      ),
    );
  }

  void _showCopyDialog(BuildContext context, FilesProvider provider, FileInfo file, AppLocalizations l10n) {
    appLogger.dWithPackage('files_page', '_showCopyDialog: 打开复制对话框, file=${file.path}');
    final controller = TextEditingController(text: provider.data.currentPath);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.filesActionCopy),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${l10n.filesNameLabel}: ${file.name}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: l10n.filesTargetPath,
                prefixIcon: const Icon(Icons.folder_outlined),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.folder_open),
                  onPressed: () async {
                    final selectedPath = await _showPathSelectorDialog(context, provider, controller.text, l10n);
                    if (selectedPath != null) {
                      controller.text = selectedPath;
                    }
                  },
                  tooltip: l10n.filesSelectPath,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () async {
              appLogger.dWithPackage('files_page', '_showCopyDialog: 用户选择目标路径=${controller.text}');
              Navigator.pop(dialogContext);
              try {
                await provider.copyFile(file.path, controller.text);
                appLogger.iWithPackage('files_page', '_showCopyDialog: 复制成功');
              } catch (e, stackTrace) {
                appLogger.eWithPackage('files_page', '_showCopyDialog: 复制失败', error: e, stackTrace: stackTrace);
                if (context.mounted) {
                  DebugErrorDialog.show(context, l10n.filesCopyFailed, e, stackTrace: stackTrace);
                }
              }
            },
            child: Text(l10n.commonConfirm),
          ),
        ],
      ),
    );
  }

  Future<String?> _showPathSelectorDialog(BuildContext context, FilesProvider provider, String currentPath, AppLocalizations l10n) async {
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

  void _showExtractDialog(BuildContext context, FilesProvider provider, FileInfo file, AppLocalizations l10n) {
    appLogger.dWithPackage('files_page', '_showExtractDialog: 打开解压对话框, file=${file.path}');
    final controller = TextEditingController(text: provider.data.currentPath);
    
    String getCompressType(String filename) {
      if (filename.endsWith('.tar.gz')) return 'tar.gz';
      if (filename.endsWith('.tar')) return 'tar';
      if (filename.endsWith('.zip')) return 'zip';
      if (filename.endsWith('.7z')) return '7z';
      if (filename.endsWith('.gz')) return 'gz';
      if (filename.endsWith('.bz2')) return 'bz2';
      if (filename.endsWith('.xz')) return 'xz';
      return 'zip';
    }
    
    final type = getCompressType(file.name);
    
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
              appLogger.dWithPackage('files_page', '_showExtractDialog: 用户选择目标路径=${controller.text}, type=$type');
              Navigator.pop(dialogContext);
              try {
                await provider.extractFile(file.path, controller.text, type);
                appLogger.iWithPackage('files_page', '_showExtractDialog: 解压成功');
              } catch (e, stackTrace) {
                appLogger.eWithPackage('files_page', '_showExtractDialog: 解压失败', error: e, stackTrace: stackTrace);
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

  void _showCompressDialog(BuildContext context, FilesProvider provider, List<String> files, AppLocalizations l10n) {
    appLogger.dWithPackage('files_page', '_showCompressDialog: 打开压缩对话框, files=$files');
    final nameController = TextEditingController();
    String type = 'zip';
    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(l10n.filesActionCompress),
          content: Column(
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
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l10n.commonCancel),
            ),
            FilledButton(
              onPressed: () async {
                if (nameController.text.isEmpty) return;
                final name = nameController.text;
                appLogger.dWithPackage('files_page', '_showCompressDialog: 用户输入名称=$name, type=$type');
                Navigator.pop(dialogContext);
                try {
                  await provider.compressFiles(files, provider.data.currentPath, name, type);
                  appLogger.iWithPackage('files_page', '_showCompressDialog: 压缩成功');
                } catch (e, stackTrace) {
                  appLogger.eWithPackage('files_page', '_showCompressDialog: 压缩失败', error: e, stackTrace: stackTrace);
                  if (context.mounted) {
                    DebugErrorDialog.show(context, l10n.filesCompressFailed, e, stackTrace: stackTrace);
                  }
                }
              },
              child: Text(l10n.commonConfirm),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmDialog(BuildContext context, FilesProvider provider, AppLocalizations l10n) {
    appLogger.dWithPackage('files_page', '_showDeleteConfirmDialog: 打开删除确认对话框, 选中${provider.data.selectionCount}个文件');
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.filesDeleteTitle),
        content: Text(l10n.filesDeleteConfirm(provider.data.selectionCount)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              appLogger.dWithPackage('files_page', '_showDeleteConfirmDialog: 用户确认删除');
              Navigator.pop(dialogContext);
              try {
                await provider.deleteSelected();
                appLogger.iWithPackage('files_page', '_showDeleteConfirmDialog: 删除成功');
              } catch (e, stackTrace) {
                appLogger.eWithPackage('files_page', '_showDeleteConfirmDialog: 删除失败', error: e, stackTrace: stackTrace);
                if (context.mounted) {
                  DebugErrorDialog.show(context, l10n.filesDeleteFailed, e, stackTrace: stackTrace);
                }
              }
            },
            child: Text(l10n.commonDelete),
          ),
        ],
      ),
    );
  }

  void _showBatchMoveDialog(BuildContext context, FilesProvider provider, AppLocalizations l10n) {
    final controller = TextEditingController(text: provider.data.currentPath);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.filesActionMove),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${l10n.filesSelected}: ${provider.data.selectionCount}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: l10n.filesTargetPath,
                prefixIcon: const Icon(Icons.folder_outlined),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              try {
                await provider.moveSelected(controller.text);
              } catch (e, stackTrace) {
                if (context.mounted) {
                  DebugErrorDialog.show(context, l10n.filesMoveFailed, e, stackTrace: stackTrace);
                }
              }
            },
            child: Text(l10n.commonConfirm),
          ),
        ],
      ),
    );
  }

  void _showBatchCopyDialog(BuildContext context, FilesProvider provider, AppLocalizations l10n) {
    final controller = TextEditingController(text: provider.data.currentPath);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.filesActionCopy),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${l10n.filesSelected}: ${provider.data.selectionCount}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: l10n.filesTargetPath,
                prefixIcon: const Icon(Icons.folder_outlined),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              try {
                await provider.copySelected(controller.text);
              } catch (e, stackTrace) {
                if (context.mounted) {
                  DebugErrorDialog.show(context, l10n.filesCopyFailed, e, stackTrace: stackTrace);
                }
              }
            },
            child: Text(l10n.commonConfirm),
          ),
        ],
      ),
    );
  }

  void _showUploadDialog(BuildContext context, FilesProvider provider) {
    appLogger.dWithPackage('files_page', '_showUploadDialog: 打开上传对话框');
    final l10n = context.l10n;
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.filesActionUpload),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${l10n.filesTargetPath}: ${provider.data.currentPath}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(l10n.filesActionUpload),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              try {
                final result = await FilePicker.platform.pickFiles(
                  allowMultiple: true,
                );
                
                if (result != null && result.files.isNotEmpty) {
                  final filePaths = result.files
                      .where((f) => f.path != null)
                      .map((f) => f.path!)
                      .toList();
                  
                  if (filePaths.isNotEmpty) {
                    appLogger.dWithPackage('files_page', '_showUploadDialog: 选择${filePaths.length}个文件');
                    await provider.uploadFiles(filePaths);
                    appLogger.iWithPackage('files_page', '_showUploadDialog: 上传成功');
                  }
                }
              } catch (e, stackTrace) {
                appLogger.eWithPackage('files_page', '_showUploadDialog: 上传失败', error: e, stackTrace: stackTrace);
                if (context.mounted) {
                  DebugErrorDialog.show(context, l10n.filesCreateFailed, e, stackTrace: stackTrace);
                }
              }
            },
            child: Text(l10n.filesActionUpload),
          ),
        ],
      ),
    );
  }

  void _showWgetDialog(BuildContext context, FilesProvider provider) {
    appLogger.dWithPackage('files_page', '_showWgetDialog: 打开wget下载对话框');
    final l10n = context.l10n;
    
    final urlController = TextEditingController();
    final nameController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.filesActionWgetDownload),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: urlController,
                decoration: InputDecoration(
                  labelText: l10n.filesWgetUrl,
                  hintText: l10n.filesWgetUrlHint,
                  prefixIcon: const Icon(Icons.link),
                ),
                autofocus: true,
                keyboardType: TextInputType.url,
                onChanged: (value) {
                  if (nameController.text.isEmpty && value.isNotEmpty) {
                    try {
                      final uri = Uri.parse(value);
                      final pathSegments = uri.pathSegments;
                      if (pathSegments.isNotEmpty) {
                        nameController.text = pathSegments.last;
                      }
                    } catch (_) {}
                  }
                },
              ),
              const SizedBox(height: 16),
              Text(
                '${l10n.filesTargetPath}: ${provider.data.currentPath}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: l10n.filesWgetFilename,
                  hintText: l10n.filesWgetFilenameHint,
                  prefixIcon: const Icon(Icons.insert_drive_file_outlined),
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
            onPressed: () async {
              if (urlController.text.isEmpty || nameController.text.isEmpty) return;
              
              final url = urlController.text.trim();
              final name = nameController.text.trim();
              
              appLogger.dWithPackage('files_page', '_showWgetDialog: url=$url, name=$name');
              Navigator.pop(dialogContext);
              
              try {
                await provider.wgetDownload(
                  url: url,
                  name: name,
                );
                
                if (context.mounted) {
                  final status = provider.data.wgetStatus;
                  if (status != null && status.state == WgetDownloadState.success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.check_circle, color: Theme.of(context).colorScheme.onPrimary),
                            const SizedBox(width: 8),
                            Expanded(child: Text(status.message ?? l10n.filesWgetSuccess(status.filePath ?? ''))),
                          ],
                        ),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        action: SnackBarAction(
                          label: l10n.commonConfirm,
                          textColor: Theme.of(context).colorScheme.onPrimary,
                          onPressed: () {},
                        ),
                      ),
                    );
                  } else if (status != null && status.state == WgetDownloadState.error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.error_outline, color: Theme.of(context).colorScheme.onError),
                            const SizedBox(width: 8),
                            Expanded(child: Text(status.message ?? l10n.filesWgetFailed)),
                          ],
                        ),
                        backgroundColor: Theme.of(context).colorScheme.error,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        action: SnackBarAction(
                          label: l10n.commonConfirm,
                          textColor: Theme.of(context).colorScheme.onError,
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: status.message ?? ''));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.commonCopied),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }
                }
                appLogger.iWithPackage('files_page', '_showWgetDialog: wget下载完成');
              } catch (e, stackTrace) {
                appLogger.eWithPackage('files_page', '_showWgetDialog: wget下载失败', error: e, stackTrace: stackTrace);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.error_outline, color: Theme.of(context).colorScheme.onError),
                          const SizedBox(width: 8),
                          Expanded(child: Text(e.toString())),
                        ],
                      ),
                      backgroundColor: Theme.of(context).colorScheme.error,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      action: SnackBarAction(
                        label: l10n.commonConfirm,
                        textColor: Theme.of(context).colorScheme.onError,
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: e.toString()));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.commonCopied),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }
              }
            },
            child: Text(l10n.filesWgetDownload),
          ),
        ],
      ),
    );
  }

  void _showMoreOptions(BuildContext context) {
    final provider = context.read<FilesProvider>();
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.star_outline),
              title: Text(sheetContext.l10n.filesFavorites),
              onTap: () {
                Navigator.pop(sheetContext);
                _openFavorites(context, provider);
              },
            ),
            ListTile(
              leading: const Icon(Icons.sort),
              title: Text(sheetContext.l10n.filesActionSort),
              onTap: () {
                Navigator.pop(sheetContext);
                _showSortOptions(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: Text(sheetContext.l10n.filesActionSearch),
              onTap: () {
                Navigator.pop(sheetContext);
                _showSearchDialog(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: Text(sheetContext.l10n.filesRecycleBin),
              onTap: () {
                Navigator.pop(sheetContext);
                _openRecycleBin(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _openFavorites(BuildContext context, FilesProvider provider) async {
    appLogger.dWithPackage('files_page', '_openFavorites: 打开收藏夹页面');
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (context) => const FavoritesPage(),
      ),
    );

    if (result != null && mounted) {
      appLogger.dWithPackage('files_page', '_openFavorites: 导航到路径=$result');
      provider.navigateTo(result);
    }
  }

  void _openRecycleBin(BuildContext context) {
    appLogger.dWithPackage('files_page', '_openRecycleBin: 打开回收站页面');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const RecycleBinPage(),
      ),
    );
  }

  void _showSortOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.filesActionSort),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(context.l10n.filesSortByName),
              onTap: () {
                Navigator.pop(context);
                context.read<FilesProvider>().setSorting('name', 'asc');
              },
            ),
            ListTile(
              title: Text(context.l10n.filesSortBySize),
              onTap: () {
                Navigator.pop(context);
                context.read<FilesProvider>().setSorting('size', 'desc');
              },
            ),
            ListTile(
              title: Text(context.l10n.filesSortByDate),
              onTap: () {
                Navigator.pop(context);
                context.read<FilesProvider>().setSorting('modifiedAt', 'desc');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.filesActionSearch),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: context.l10n.filesSearchHint,
            prefixIcon: const Icon(Icons.search),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<FilesProvider>().setSearchQuery(null);
            },
            child: Text(context.l10n.filesSearchClear),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<FilesProvider>().setSearchQuery(controller.text);
              context.read<FilesProvider>().loadFiles();
            },
            child: Text(context.l10n.commonSearch),
          ),
        ],
      ),
    );
  }

  Widget _buildServerSelector(BuildContext context) {
    return Consumer<FilesProvider>(
      builder: (context, provider, _) {
        final server = provider.data.currentServer;
        return FutureBuilder<List<ApiConfig>>(
          future: ApiConfigManager.getConfigs(),
          builder: (context, snapshot) {
            final servers = snapshot.data ?? [];
            return PopupMenuButton<String>(
              icon: Icon(
                Icons.dns_outlined,
                color: server != null ? null : Theme.of(context).colorScheme.error,
              ),
              tooltip: context.l10n.serverPageTitle,
              onSelected: (serverId) async {
                await ApiConfigManager.setCurrentConfig(serverId);
                provider.onServerChanged();
              },
              itemBuilder: (context) {
                if (servers.isEmpty) {
                  return [
                    PopupMenuItem(
                      enabled: false,
                      child: Text(
                        context.l10n.serverListEmptyTitle,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ];
                }
                return servers.map((s) => PopupMenuItem<String>(
                  value: s.id,
                  child: Row(
                    children: [
                      Icon(
                        s.id == server?.id 
                            ? Icons.check_circle 
                            : Icons.circle_outlined,
                        size: 18,
                        color: s.id == server?.id 
                            ? Theme.of(context).colorScheme.primary 
                            : null,
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Text(s.name)),
                    ],
                  ),
                )).toList();
              },
            );
          },
        );
      },
    );
  }

  void _showPermissionDialog(BuildContext context, FilesProvider provider, FileInfo file, AppLocalizations l10n) {
    appLogger.dWithPackage('files_page', '_showPermissionDialog: 打开权限管理对话框, file=${file.path}');
    
    showDialog(
      context: context,
      builder: (dialogContext) => _PermissionDialog(
        file: file,
        provider: provider,
        l10n: l10n,
      ),
    );
  }
}

class _PermissionDialog extends StatefulWidget {
  final FileInfo file;
  final FilesProvider provider;
  final AppLocalizations l10n;

  const _PermissionDialog({
    required this.file,
    required this.provider,
    required this.l10n,
  });

  @override
  State<_PermissionDialog> createState() => _PermissionDialogState();
}

class _PermissionDialogState extends State<_PermissionDialog> {
  FileUserGroupResponse? _userGroup;
  bool _isLoading = true;
  String? _error;
  
  int _ownerRead = 0;
  int _ownerWrite = 0;
  int _ownerExecute = 0;
  int _groupRead = 0;
  int _groupWrite = 0;
  int _groupExecute = 0;
  int _otherRead = 0;
  int _otherWrite = 0;
  int _otherExecute = 0;
  
  String? _selectedUser;
  String? _selectedGroup;
  bool _recursive = false;

  @override
  void initState() {
    super.initState();
    _loadPermissionData();
  }

  Future<void> _loadPermissionData() async {
    try {
      final results = await Future.wait([
        widget.provider.getFilePermission(widget.file.path),
        widget.provider.getUserGroup(),
      ]);
      
      final permission = results[0] as FilePermission;
      final userGroup = results[1] as FileUserGroupResponse;
      
      final mode = permission.permission ?? widget.file.permission ?? widget.file.mode ?? '755';
      _parseMode(mode);
      
      setState(() {
        _userGroup = userGroup;
        _selectedUser = permission.user ?? widget.file.user;
        _selectedGroup = permission.group ?? widget.file.group;
        _isLoading = false;
      });
    } catch (e, stackTrace) {
      appLogger.eWithPackage('files_page', '_loadPermissionData: 加载失败', error: e, stackTrace: stackTrace);
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _parseMode(String mode) {
    String cleanMode = mode;
    if (cleanMode.length > 3) {
      cleanMode = cleanMode.substring(cleanMode.length - 3);
    }
    
    int modeValue = int.tryParse(cleanMode, radix: 8) ?? 493;
    
    final ownerBits = (modeValue >> 6) & 7;
    final groupBits = (modeValue >> 3) & 7;
    final otherBits = modeValue & 7;
    
    _ownerRead = (ownerBits >> 2) & 1;
    _ownerWrite = (ownerBits >> 1) & 1;
    _ownerExecute = ownerBits & 1;
    
    _groupRead = (groupBits >> 2) & 1;
    _groupWrite = (groupBits >> 1) & 1;
    _groupExecute = groupBits & 1;
    
    _otherRead = (otherBits >> 2) & 1;
    _otherWrite = (otherBits >> 1) & 1;
    _otherExecute = otherBits & 1;
  }

  String _calculateMode() {
    final owner = (_ownerRead << 2) | (_ownerWrite << 1) | _ownerExecute;
    final group = (_groupRead << 2) | (_groupWrite << 1) | _groupExecute;
    final other = (_otherRead << 2) | (_otherWrite << 1) | _otherExecute;
    return '$owner$group$other';
  }

  Future<void> _savePermission() async {
    final mode = _calculateMode();
    appLogger.dWithPackage('files_page', '_savePermission: mode=$mode, user=$_selectedUser, group=$_selectedGroup, recursive=$_recursive');
    
    try {
      if (_selectedUser != null || _selectedGroup != null) {
        await widget.provider.changeFileOwner(
          widget.file.path,
          user: _selectedUser,
          group: _selectedGroup,
          recursive: _recursive,
        );
      }
      
      await widget.provider.changeFileMode(
        widget.file.path,
        mode,
        recursive: _recursive,
      );
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.l10n.filesPermissionSuccess)),
        );
      }
    } catch (e, stackTrace) {
      appLogger.eWithPackage('files_page', '_savePermission: 保存失败', error: e, stackTrace: stackTrace);
      if (mounted) {
        DebugErrorDialog.show(context, widget.l10n.filesPermissionFailed, e, stackTrace: stackTrace);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.lock_outline, color: colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              widget.l10n.filesPermissionTitle,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      content: _buildContent(theme, colorScheme),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(widget.l10n.commonCancel),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _savePermission,
          child: Text(widget.l10n.commonSave),
        ),
      ],
    );
  }

  Widget _buildContent(ThemeData theme, ColorScheme colorScheme) {
    if (_isLoading) {
      return const SizedBox(
        width: 400,
        height: 300,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return SizedBox(
        width: 400,
        height: 200,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: colorScheme.error),
              const SizedBox(height: 16),
              Text(widget.l10n.filesPermissionLoadFailed),
              const SizedBox(height: 8),
              Text(_error!, style: theme.textTheme.bodySmall, textAlign: TextAlign.center),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFileInfo(theme, colorScheme),
            const SizedBox(height: 16),
            _buildModeSection(theme, colorScheme),
            const SizedBox(height: 16),
            _buildOwnerSection(theme, colorScheme),
            const SizedBox(height: 16),
            _buildRecursiveOption(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildFileInfo(ThemeData theme, ColorScheme colorScheme) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.file.name,
              style: theme.textTheme.titleMedium,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              widget.file.path,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeSection(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(widget.l10n.filesPermissionMode, style: theme.textTheme.titleSmall),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _calculateMode(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildPermissionTable(theme, colorScheme),
      ],
    );
  }

  Widget _buildPermissionTable(ThemeData theme, ColorScheme colorScheme) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _buildPermissionHeader(theme),
            const Divider(),
            _buildPermissionRow(
              widget.l10n.filesPermissionOwnerLabel,
              _ownerRead, _ownerWrite, _ownerExecute,
              (r, w, x) => setState(() {
                _ownerRead = r;
                _ownerWrite = w;
                _ownerExecute = x;
              }),
              colorScheme,
            ),
            _buildPermissionRow(
              widget.l10n.filesPermissionGroupLabel,
              _groupRead, _groupWrite, _groupExecute,
              (r, w, x) => setState(() {
                _groupRead = r;
                _groupWrite = w;
                _groupExecute = x;
              }),
              colorScheme,
            ),
            _buildPermissionRow(
              widget.l10n.filesPermissionOtherLabel,
              _otherRead, _otherWrite, _otherExecute,
              (r, w, x) => setState(() {
                _otherRead = r;
                _otherWrite = w;
                _otherExecute = x;
              }),
              colorScheme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionHeader(ThemeData theme) {
    return Row(
      children: [
        const Expanded(child: SizedBox()),
        SizedBox(
          width: 60,
          child: Text(
            widget.l10n.filesPermissionRead,
            style: theme.textTheme.labelSmall,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          width: 60,
          child: Text(
            widget.l10n.filesPermissionWrite,
            style: theme.textTheme.labelSmall,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          width: 60,
          child: Text(
            widget.l10n.filesPermissionExecute,
            style: theme.textTheme.labelSmall,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionRow(
    String label,
    int read, int write, int execute,
    void Function(int, int, int) onChanged,
    ColorScheme colorScheme,
  ) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        SizedBox(
          width: 60,
          child: Checkbox(
            value: read == 1,
            onChanged: (v) => onChanged(v == true ? 1 : 0, write, execute),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        SizedBox(
          width: 60,
          child: Checkbox(
            value: write == 1,
            onChanged: (v) => onChanged(read, v == true ? 1 : 0, execute),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        SizedBox(
          width: 60,
          child: Checkbox(
            value: execute == 1,
            onChanged: (v) => onChanged(read, write, v == true ? 1 : 0),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ],
    );
  }

  Widget _buildOwnerSection(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.l10n.filesPermissionChangeOwner, style: theme.textTheme.titleSmall),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                key: ValueKey('user-$_selectedUser'),
                initialValue: _selectedUser,
                decoration: InputDecoration(
                  labelText: widget.l10n.filesPermissionUser,
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: _userGroup?.users.map((u) => DropdownMenuItem(
                  value: u.user,
                  child: Text(u.user),
                )).toList() ?? [],
                onChanged: (v) => setState(() => _selectedUser = v),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<String>(
                key: ValueKey('group-$_selectedGroup'),
                initialValue: _selectedGroup,
                decoration: InputDecoration(
                  labelText: widget.l10n.filesPermissionGroup,
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: _userGroup?.groups.map((g) => DropdownMenuItem(
                  value: g,
                  child: Text(g),
                )).toList() ?? [],
                onChanged: (v) => setState(() => _selectedGroup = v),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecursiveOption(ThemeData theme) {
    return Card(
      margin: EdgeInsets.zero,
      child: SwitchListTile(
        title: Text(widget.l10n.filesPermissionRecursive),
        subtitle: Text(
          widget.file.isDir 
            ? widget.l10n.filesPermissionRecursive
            : widget.l10n.filesPermissionRecursive,
          style: theme.textTheme.bodySmall,
        ),
        value: _recursive,
        onChanged: widget.file.isDir 
          ? (v) => setState(() => _recursive = v)
          : null,
      ),
    );
  }
}
