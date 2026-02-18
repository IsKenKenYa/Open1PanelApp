# Tasks

- [x] Task 1: 添加复制功能i18n文案
  - [x] SubTask 1.1: 在 `app_zh.arb` 中添加 `filesActionCopy` 文案
  - [x] SubTask 1.2: 在 `app_en.arb` 中添加 `filesActionCopy` 文案
  - [x] SubTask 1.3: 重新生成 l10n 代码

- [x] Task 2: 在 FilesService 中添加复制方法
  - [x] SubTask 2.1: 添加 `copyFiles` 方法，调用 API 时使用 `type: 'copy'`

- [x] Task 3: 在 FilesProvider 中添加复制方法
  - [x] SubTask 3.1: 添加 `copyFiles` 方法
  - [x] SubTask 3.2: 添加 `copySelected` 方法

- [x] Task 4: 在 FilesPage 中添加复制菜单项
  - [x] SubTask 4.1: 在文件操作菜单中添加"复制"选项
  - [x] SubTask 4.2: 在批量操作栏中添加"复制"按钮
  - [x] SubTask 4.3: 实现复制目标路径选择对话框

- [x] Task 5: 验证功能
  - [x] SubTask 5.1: 运行 `flutter analyze` 验证代码
  - [ ] SubTask 5.2: 手动测试复制功能

# Task Dependencies
- Task 2 依赖 Task 1（i18n 字符串需要先更新）
- Task 3 依赖 Task 2
- Task 4 依赖 Task 3
- Task 5 依赖 Task 1, 2, 3, 4
