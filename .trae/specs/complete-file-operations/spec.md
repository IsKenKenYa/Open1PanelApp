# 完善文件操作功能 Spec

## Why
1. 复制文件到当前目录时会报错"same file"，需要自动重命名
2. 新建文件夹和新建文件功能只是占位，需要具体实现
3. 文件上传功能需要实现

## What Changes
- 复制文件到当前目录时自动添加后缀重命名（如 `file.txt` → `file (1).txt`）
- 实现新建文件夹功能（调用 `POST /files` API）
- 实现新建文件功能（调用 `POST /files` API）
- 实现文件上传功能（使用 `file_picker` + `dio` 上传到 `POST /files/upload`）

## Impact
- Affected specs: 文件管理模块
- Affected code:
  - `lib/features/files/files_page.dart` - 实现创建和上传对话框
  - `lib/features/files/files_provider.dart` - 添加创建和上传方法
  - `lib/features/files/files_service.dart` - 添加创建和上传API调用
  - `lib/api/v2/file_v2.dart` - 添加上传API
  - `pubspec.yaml` - 添加 `file_picker` 依赖

## ADDED Requirements

### Requirement: 复制文件自动重命名
当用户复制文件到源文件所在目录时，系统应自动为新文件添加后缀以避免冲突。

#### Scenario: 复制到当前目录
- **WHEN** 用户复制文件到文件所在目录
- **THEN** 系统自动为新文件添加 `(1)` 后缀
- **AND** 如果 `(1)` 已存在，则使用 `(2)`，以此类推

#### Technical Implementation
- 在 `FilesService.copyFiles` 中检测目标路径是否与源路径相同
- 使用 `FileMove` 模型的 `name` 参数传递新文件名

### Requirement: 新建文件夹
系统应允许用户在当前目录创建新文件夹。

#### Scenario: 创建文件夹成功
- **WHEN** 用户输入文件夹名称并确认
- **THEN** 系统在当前目录创建指定名称的文件夹
- **AND** 刷新文件列表显示新文件夹

#### Technical Implementation
- API: `POST /files`
- 请求体: `{path: "/path/to/folder", isDir: true}`

### Requirement: 新建文件
系统应允许用户在当前目录创建新文件。

#### Scenario: 创建文件成功
- **WHEN** 用户输入文件名称并确认
- **THEN** 系统在当前目录创建指定名称的空文件
- **AND** 刷新文件列表显示新文件

#### Technical Implementation
- API: `POST /files`
- 请求体: `{path: "/path/to/file", isDir: false}`

### Requirement: 文件上传
系统应允许用户从本地设备上传文件到当前目录。

#### Scenario: 上传单个文件
- **WHEN** 用户选择文件并确认上传
- **THEN** 系统将文件上传到当前目录
- **AND** 显示上传进度
- **AND** 上传完成后刷新文件列表

#### Scenario: 上传多个文件
- **WHEN** 用户选择多个文件并确认上传
- **THEN** 系统依次上传所有文件
- **AND** 显示总体上传进度

#### Technical Implementation
- 使用 `file_picker` 包选择文件（推荐，支持多平台）
- API: `POST /files/upload` (multipart/form-data)
- 参数: `file` (文件), `path` (目标目录)
- 使用 `dio` 的 `MultipartFile` 进行上传

## MODIFIED Requirements

### Requirement: FileMove API
`FileMove` 模型已支持 `name` 参数，可用于指定复制后的新文件名。

## Dependencies
- `file_picker: ^8.0.0` - 用于选择文件（跨平台支持）
- `dio: ^5.9.1` - 已存在，用于文件上传
