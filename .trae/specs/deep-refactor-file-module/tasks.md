# Tasks

## Phase 1: 模型文件拆分

- [x] Task 1: 分析 file_models.dart 结构
  - [x] SubTask 1.1: 识别所有模型类和功能领域
  - [x] SubTask 1.2: 制定拆分计划

- [x] Task 2: 创建模型目录结构
  - [x] SubTask 2.1: 创建 `lib/data/models/file/` 目录
  - [x] SubTask 2.2: 创建子目录（info, operation, permission, transfer 等）

- [x] Task 3: 拆分模型文件
  - [x] SubTask 3.1: 拆分 FileInfo 相关模型
  - [x] SubTask 3.2: 拆分 FileOperation 相关模型
  - [x] SubTask 3.3: 拆分 FilePermission 相关模型
  - [x] SubTask 3.4: 拆分 FileTransfer 相关模型
  - [x] SubTask 3.5: 拆分 RecycleBin 相关模型
  - [x] SubTask 3.6: 拆分 Favorite 相关模型
  - [x] SubTask 3.7: 拆分 Wget 相关模型
  - [x] SubTask 3.8: 创建 file_models.dart 导出文件

- [x] Task 4: 更新导入引用
  - [x] SubTask 4.1: 更新所有引用 file_models.dart 的文件
  - [x] SubTask 4.2: 验证编译通过

## Phase 2: Provider 精简

- [x] Task 5: 分析 files_provider.dart 结构
  - [x] SubTask 5.1: 识别可提取的服务逻辑
  - [x] SubTask 5.2: 制定精简计划

- [x] Task 6: 精简 Provider
  - [x] SubTask 6.1: 提取可复用逻辑到服务层
  - [x] SubTask 6.2: 保持 Provider 职责单一

## Phase 3: 测试覆盖

- [x] Task 7: 创建测试目录结构
  - [x] SubTask 7.1: 创建 `test/features/files/widgets/` 目录
  - [x] SubTask 7.2: 创建 `test/features/files/widgets/dialogs/` 目录

- [x] Task 8: UI 组件单元测试
  - [x] SubTask 8.1: file_list_item_test.dart
  - [x] SubTask 8.2: path_breadcrumb_test.dart
  - [x] SubTask 8.3: selection_bar_test.dart
  - [x] SubTask 8.4: server_selector_test.dart
  - [x] SubTask 8.5: empty_state_test.dart
  - [x] SubTask 8.6: error_state_test.dart

- [x] Task 9: 对话框组件单元测试
  - [x] SubTask 9.1: permission_dialog_test.dart
  - [x] SubTask 9.2: create_directory_dialog_test.dart
  - [x] SubTask 9.3: create_file_dialog_test.dart
  - [x] SubTask 9.4: rename_dialog_test.dart
  - [x] SubTask 9.5: move_dialog_test.dart
  - [x] SubTask 9.6: copy_dialog_test.dart
  - [x] SubTask 9.7: extract_dialog_test.dart
  - [x] SubTask 9.8: compress_dialog_test.dart
  - [x] SubTask 9.9: delete_confirm_dialog_test.dart
  - [x] SubTask 9.10: batch_move_dialog_test.dart
  - [x] SubTask 9.11: batch_copy_dialog_test.dart
  - [x] SubTask 9.12: upload_dialog_test.dart
  - [x] SubTask 9.13: wget_dialog_test.dart
  - [x] SubTask 9.14: search_dialog_test.dart
  - [x] SubTask 9.15: sort_options_dialog_test.dart
  - [x] SubTask 9.16: path_selector_dialog_test.dart

- [x] Task 10: 集成测试
  - [x] SubTask 10.1: files_page_integration_test.dart
  - [x] SubTask 10.2: file_operations_integration_test.dart

- [x] Task 11: 性能测试
  - [x] SubTask 11.1: 文件列表加载性能测试
  - [x] SubTask 11.2: 大量文件渲染性能测试

## Phase 4: 验证与文档

- [x] Task 12: 验证重构结果
  - [x] SubTask 12.1: 运行所有测试
  - [x] SubTask 12.2: 验证代码覆盖率
  - [x] SubTask 12.3: 运行 `flutter analyze`

- [x] Task 13: 更新文档
  - [x] SubTask 13.1: 更新 file_module_architecture.md
  - [x] SubTask 13.2: 更新 file_api_analysis.md

# Task Dependencies
- Task 2-4 可并行执行
- Task 5-6 可与 Task 2-4 并行
- Task 7-11 依赖 Task 1-6
- Task 12-13 依赖 Task 7-11
