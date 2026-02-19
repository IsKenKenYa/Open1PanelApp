# Tasks

- [x] Task 1: 创建 widgets 目录结构
  - [x] SubTask 1.1: 创建 `lib/features/files/widgets/` 目录
  - [x] SubTask 1.2: 创建 `lib/features/files/widgets/dialogs/` 目录
  - [x] SubTask 1.3: 创建 `widgets.dart` 导出文件

- [x] Task 2: 拆分 UI 组件
  - [x] SubTask 2.1: 创建 `file_list_item.dart` - 文件列表项组件
  - [x] SubTask 2.2: 创建 `path_breadcrumb.dart` - 路径面包屑组件
  - [x] SubTask 2.3: 创建 `selection_bar.dart` - 选择操作栏组件
  - [x] SubTask 2.4: 创建 `server_selector.dart` - 服务器选择器组件
  - [x] SubTask 2.5: 创建 `empty_state.dart` - 空状态视图组件
  - [x] SubTask 2.6: 创建 `error_state.dart` - 错误状态视图组件

- [x] Task 3: 拆分对话框组件
  - [x] SubTask 3.1: 创建 `permission_dialog.dart` - 权限管理对话框
  - [x] SubTask 3.2: 创建 `create_directory_dialog.dart` - 创建目录对话框
  - [x] SubTask 3.3: 创建 `create_file_dialog.dart` - 创建文件对话框
  - [x] SubTask 3.4: 创建 `rename_dialog.dart` - 重命名对话框
  - [x] SubTask 3.5: 创建 `move_dialog.dart` - 移动对话框
  - [x] SubTask 3.6: 创建 `copy_dialog.dart` - 复制对话框
  - [x] SubTask 3.7: 创建 `extract_dialog.dart` - 解压对话框
  - [x] SubTask 3.8: 创建 `compress_dialog.dart` - 压缩对话框
  - [x] SubTask 3.9: 创建 `delete_confirm_dialog.dart` - 删除确认对话框
  - [x] SubTask 3.10: 创建 `batch_move_dialog.dart` - 批量移动对话框
  - [x] SubTask 3.11: 创建 `batch_copy_dialog.dart` - 批量复制对话框
  - [x] SubTask 3.12: 创建 `upload_dialog.dart` - 上传对话框
  - [x] SubTask 3.13: 创建 `wget_dialog.dart` - wget 下载对话框
  - [x] SubTask 3.14: 创建 `search_dialog.dart` - 搜索对话框
  - [x] SubTask 3.15: 创建 `sort_options_dialog.dart` - 排序选项对话框
  - [x] SubTask 3.16: 创建 `path_selector_dialog.dart` - 路径选择对话框

- [x] Task 4: 重构 files_page.dart
  - [x] SubTask 4.1: 移除已拆分的组件代码
  - [x] SubTask 4.2: 导入拆分后的组件
  - [x] SubTask 4.3: 保持页面框架逻辑

- [x] Task 5: 验证重构结果
  - [x] SubTask 5.1: 运行 `flutter analyze` 验证代码
  - [x] SubTask 5.2: 确保所有功能正常工作

# Task Dependencies
- Task 2-3 已并行执行
- Task 4 依赖 Task 1-3
- Task 5 依赖 Task 4
