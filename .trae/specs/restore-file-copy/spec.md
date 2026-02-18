# 恢复文件复制功能 Spec

## Why
1Panel API的 `/files/move` 端点实际上支持两种操作类型：
- `type: 'cut'` - 移动/剪切文件
- `type: 'copy'` - 复制文件

之前错误地认为只支持移动操作，需要恢复复制功能。

## What Changes
- 在文件操作菜单中添加"复制"选项
- 在 `FilesProvider` 中添加 `copyFiles` 方法
- 在 `FilesService` 中添加 `copyFiles` 方法
- 更新 `FileMove` 模型以正确支持 `copy` 类型
- 添加复制功能的i18n文案

## Impact
- Affected specs: 文件管理模块
- Affected code:
  - `lib/features/files/files_page.dart` - 添加复制菜单项
  - `lib/features/files/files_provider.dart` - 添加复制方法
  - `lib/features/files/files_service.dart` - 添加复制API调用
  - `lib/l10n/app_*.arb` - 添加复制相关文案

## ADDED Requirements

### Requirement: 文件复制功能
系统应当提供文件/文件夹复制功能，允许用户将文件复制到指定目录。

#### Scenario: 复制单个文件
- **WHEN** 用户选择一个文件并点击"复制"
- **THEN** 系统显示目标路径选择对话框
- **AND** 用户确认后，文件被复制到目标路径

#### Scenario: 复制多个文件
- **WHEN** 用户选择多个文件并点击"复制"
- **THEN** 系统显示目标路径选择对话框
- **AND** 用户确认后，所有选中文件被复制到目标路径

#### Scenario: 复制到同名路径
- **WHEN** 用户复制文件到存在同名文件的目录
- **THEN** 系统根据 `cover` 参数决定是否覆盖

## MODIFIED Requirements

### Requirement: FileMove 模型
`FileMove` 模型已更新，支持以下字段：
- `type`: 操作类型，`'cut'` 表示移动，`'copy'` 表示复制
- `oldPaths`: 源文件路径列表
- `newPath`: 目标路径
- `name`: 可选，新文件名
- `cover`: 可选，是否覆盖同名文件
