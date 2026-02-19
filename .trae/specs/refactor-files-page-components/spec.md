# 重构 files_page.dart 组件拆分 Spec

## Why
files_page.dart 文件超过 2300 行，包含大量对话框和 UI 组件，违反单一职责原则，难以维护。需要按照 Flutter 最佳实践将组件拆分为独立模块。

## What Changes
- 创建 `widgets/` 目录存放独立组件
- 拆分对话框组件为独立文件
- 拆分 UI 组件为独立文件
- 创建 widgets.dart 统一导出
- 保持 files_page.dart 只负责页面框架和主要逻辑

## Impact
- Affected code:
  - `lib/features/files/files_page.dart` - 精简为页面框架
  - `lib/features/files/widgets/` - 新建目录存放组件
  - `lib/features/files/widgets/widgets.dart` - 统一导出

## ADDED Requirements

### Requirement: 组件独立化
每个 UI 组件和对话框应独立为单独文件。

#### Scenario: 对话框组件
- **WHEN** 需要修改某个对话框
- **THEN** 只需修改对应的独立文件

#### Scenario: UI 组件
- **WHEN** 需要复用某个 UI 组件
- **THEN** 可以直接导入使用

## 组件拆分计划

### 对话框组件 (dialogs/)
1. `create_directory_dialog.dart` - 创建目录对话框
2. `create_file_dialog.dart` - 创建文件对话框
3. `rename_dialog.dart` - 重命名对话框
4. `move_dialog.dart` - 移动对话框
5. `copy_dialog.dart` - 复制对话框
6. `extract_dialog.dart` - 解压对话框
7. `compress_dialog.dart` - 压缩对话框
8. `delete_confirm_dialog.dart` - 删除确认对话框
9. `batch_move_dialog.dart` - 批量移动对话框
10. `batch_copy_dialog.dart` - 批量复制对话框
11. `upload_dialog.dart` - 上传对话框
12. `wget_dialog.dart` - wget 下载对话框
13. `permission_dialog.dart` - 权限管理对话框
14. `search_dialog.dart` - 搜索对话框
15. `sort_options_dialog.dart` - 排序选项对话框
16. `path_selector_dialog.dart` - 路径选择对话框

### UI 组件 (widgets/)
1. `file_list_item.dart` - 文件列表项
2. `path_breadcrumb.dart` - 路径面包屑
3. `selection_bar.dart` - 选择操作栏
4. `server_selector.dart` - 服务器选择器
5. `empty_state.dart` - 空状态视图
6. `error_state.dart` - 错误状态视图
