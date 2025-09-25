/// 文件管理页面
/// 
/// 此文件定义文件管理页面，管理服务器文件和目录。

import 'package:flutter/material.dart';
import '../../shared/widgets/app_card.dart';
import '../../widgets/main_layout.dart';

class FilesPage extends StatelessWidget {
  const FilesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentIndex: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('文件管理'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // 搜索文件
              },
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                // 刷新文件列表
              },
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                // 处理菜单选择
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'upload',
                  child: Row(
                    children: [
                      Icon(Icons.upload_file),
                      SizedBox(width: 8),
                      Text('上传文件'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'new_folder',
                  child: Row(
                    children: [
                      Icon(Icons.create_new_folder),
                      SizedBox(width: 8),
                      Text('新建文件夹'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'new_file',
                  child: Row(
                    children: [
                      Icon(Icons.note_add),
                      SizedBox(width: 8),
                      Text('新建文件'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        body: const Column(
          children: [
            // 路径导航栏
            _PathNavigator(),
            // 文件列表
            Expanded(
              child: _FileList(),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // 上传文件
          },
          child: const Icon(Icons.upload_file),
        ),
      ),
    );
  }
}

/// 路径导航栏组件
class _PathNavigator extends StatelessWidget {
  const _PathNavigator();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
      ),
      child: Row(
        children: [
          const Icon(Icons.home, size: 20),
          const SizedBox(width: 4),
          const Text('/'),
          const SizedBox(width: 4),
          const Text('home', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 4),
          const Text('/'),
          const SizedBox(width: 4),
          const Text('user', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 4),
          const Text('/'),
          const SizedBox(width: 4),
          const Text('projects', style: TextStyle(fontWeight: FontWeight.bold)),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.arrow_upward, size: 20),
            onPressed: () {
              // 返回上一级目录
            },
          ),
        ],
      ),
    );
  }
}

/// 文件列表组件
class _FileList extends StatelessWidget {
  const _FileList();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 文件夹
        _FileItem(
          name: 'documents',
          type: FileType.folder,
          size: '4项',
          modified: '2023-10-15 14:30',
        ),
        const SizedBox(height: 8),
        
        _FileItem(
          name: 'downloads',
          type: FileType.folder,
          size: '12项',
          modified: '2023-10-14 09:15',
        ),
        const SizedBox(height: 8),
        
        _FileItem(
          name: 'pictures',
          type: FileType.folder,
          size: '86项',
          modified: '2023-10-12 16:45',
        ),
        const SizedBox(height: 8),
        
        // 文件
        _FileItem(
          name: 'README.md',
          type: FileType.document,
          size: '4.2 KB',
          modified: '2023-10-15 10:20',
        ),
        const SizedBox(height: 8),
        
        _FileItem(
          name: 'project-plan.pdf',
          type: FileType.pdf,
          size: '2.1 MB',
          modified: '2023-10-14 15:30',
        ),
        const SizedBox(height: 8),
        
        _FileItem(
          name: 'screenshot.png',
          type: FileType.image,
          size: '856 KB',
          modified: '2023-10-13 11:45',
        ),
        const SizedBox(height: 8),
        
        _FileItem(
          name: 'data.csv',
          type: FileType.spreadsheet,
          size: '124 KB',
          modified: '2023-10-12 09:30',
        ),
        const SizedBox(height: 8),
        
        _FileItem(
          name: 'archive.zip',
          type: FileType.archive,
          size: '15.3 MB',
          modified: '2023-10-10 14:20',
        ),
      ],
    );
  }
}

/// 文件项组件
class _FileItem extends StatelessWidget {
  final String name;
  final FileType type;
  final String size;
  final String modified;

  const _FileItem({
    required this.name,
    required this.type,
    required this.size,
    required this.modified,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: name,
      subtitle: Row(
        children: [
          Icon(type.icon),
          const SizedBox(width: 8),
          Expanded(child: Text(name)),
        ],
      ),
      trailing: PopupMenuButton<String>(
        onSelected: (value) {
          // 处理菜单选择
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'open',
            child: Text('打开'),
          ),
          const PopupMenuItem(
            value: 'rename',
            child: Text('重命名'),
          ),
          const PopupMenuItem(
            value: 'copy',
            child: Text('复制'),
          ),
          const PopupMenuItem(
            value: 'move',
            child: Text('移动'),
          ),
          const PopupMenuItem(
            value: 'download',
            child: Text('下载'),
          ),
          const PopupMenuItem(
            value: 'delete',
            child: Text('删除'),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            size,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
          Text(
            modified,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

/// 文件类型枚举
enum FileType {
  folder,
  document,
  pdf,
  image,
  spreadsheet,
  archive,
  code,
  video,
  audio,
  other;

  IconData get icon {
    switch (this) {
      case FileType.folder:
        return Icons.folder;
      case FileType.document:
        return Icons.description;
      case FileType.pdf:
        return Icons.picture_as_pdf;
      case FileType.image:
        return Icons.image;
      case FileType.spreadsheet:
        return Icons.table_chart;
      case FileType.archive:
        return Icons.archive;
      case FileType.code:
        return Icons.code;
      case FileType.video:
        return Icons.video_file;
      case FileType.audio:
        return Icons.audio_file;
      case FileType.other:
        return Icons.insert_drive_file;
    }
  }
}