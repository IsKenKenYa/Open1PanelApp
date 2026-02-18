# 修复文件操作对话框无法打开问题 Spec

## Why
在 `_showCreateOptions` 方法中，`showModalBottomSheet` 的 `builder` 参数使用 `context` 作为参数名，覆盖了外部的 `context`。当 `Navigator.pop(context)` 关闭 bottomSheet 后，这个 context 就失效了，导致后续的 `showDialog` 无法正常显示对话框。

## What Changes
- 修改 `_showCreateOptions` 方法，将 `builder` 的参数名从 `context` 改为 `sheetContext`
- 在 `onTap` 回调中使用外部的 `context` 来调用对话框方法
- 确保对话框使用正确的 context 显示

## Impact
- Affected code: `lib/features/files/files_page.dart`
- 修复新建文件夹、新建文件、文件上传三个功能的对话框显示问题

## ADDED Requirements

### Requirement: 对话框 Context 作用域正确
系统应确保对话框使用有效的 BuildContext 显示。

#### Scenario: 新建文件夹对话框正常显示
- **WHEN** 用户点击右下角加号按钮，然后点击"新建文件夹"
- **THEN** bottomSheet 关闭后，新建文件夹对话框正常显示

#### Scenario: 新建文件对话框正常显示
- **WHEN** 用户点击右下角加号按钮，然后点击"新建文件"
- **THEN** bottomSheet 关闭后，新建文件对话框正常显示

#### Scenario: 文件上传对话框正常显示
- **WHEN** 用户点击右下角加号按钮，然后点击"上传文件"
- **THEN** bottomSheet 关闭后，文件上传对话框正常显示
