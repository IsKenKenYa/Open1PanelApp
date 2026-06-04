# 跨平台文件保存/下载统一化 Spec

## Why

当前跨平台文件保存路径存在以下问题：

1. **OHOS 模拟器下载崩溃**：`FilesProviderSystemMixin._downloadWithOhosNative` 与 `OhosDownloadPlugin` 内部调用了 `path_provider.getDownloadsDirectory()`，但 `getDownloadsDirectory` 仅在 macOS 实现，其他平台（OHOS / Android / iOS / Windows / Linux）调用即抛 `Unsupported operation: Functionality only available on macOS`，导致用户在鸿蒙模拟器下载文件直接失败。`lib/core/platform/services/platform_file_service.dart` 与 `lib/features/files/services/file_transfer_service.dart` 中也存在相同隐患。
2. **现有 picker 修复仅覆盖 OHOS**：`fix-ohos-export-filepicker` 通过 `OhosPlatformPlugin`/`OhosDownloadPlugin` 在 OHOS 唤起 `DocumentViewPicker` 与 `AudioViewPicker`。但 Android / iOS / macOS / Windows / Linux 仍走 `path_provider` 的 `getDownloadsDirectory()` 或私有目录，体验割裂。
3. **开关语义模糊**：当前 `useFilePickerForExport` 仅控制「导出」是否弹 picker，「下载」不受其控制，用户体感不一致。
4. **缺乏跨平台子目录约定**：当用户关闭 picker 时，下载/导出分别落到 `Files/Downloads/Open1Panel/<category>/`（OHOS）或 `getDownloadsDirectory()/exports/...`（macOS），命名、层级、提示文案不统一。
5. **`file_picker` 插件未被引入**：项目目前依赖自研 MethodChannel 实现 OHOS picker，Android/iOS/desktop 端无统一路径。`file_picker` 插件在每个平台均封装了系统原生 Picker（Android SAF / iOS `UIDocumentPickerViewController` / macOS `NSSavePanel` / Windows `IFileSaveDialog` / Linux GTK Portal），符合「各平台原生体验 + 单一调用入口」要求。

约束：保留当前已实现的「通过 picker 导出到用户指定位置」能力（OHOS 上已稳定运行的部分），不破坏文件保存链路。用户选择权优先：可一键切换「弹 picker / 直存子目录」。

## What Changes

### 核心改造
- **弃用** 5 处 `path_provider.getDownloadsDirectory()` 调用，改用平台抽象 `PlatformSystemPaths.defaultDownloadDir()`（见下）。**BREAKING**：`getDownloadsDirectory` 调用点全部下线。
- **新增** `PlatformSystemPaths` 抽象：在 Dart 侧提供 `defaultDownloadDir()` 与 `subDirectory(name)`，封装各平台「系统下载目录」拼装逻辑：
  - Android: `getExternalStorageDirectory()/Download`（私有外部存储，避免权限问题）
  - iOS: `getApplicationDocumentsDirectory()`（iOS 无公共下载目录）
  - macOS: `~/Downloads`（通过 `Platform.environment['HOME']`）
  - Windows: `%USERPROFILE%/Downloads`
  - Linux: `${XDG_DOWNLOAD_DIR:-~/Downloads}`（`$HOME/Downloads` 兜底）
  - OHOS: `${filesDir}/../Download`（实际映射 `Files/Downloads/`，OHOS 端由原生 `OhosPlatformPlugin.getPublicDownloadDir()` 注入）
- **新增** 跨平台 picker 统一封装 `PlatformFileSaveService`：
  - 默认实现基于 `file_picker` 插件（Android SAF / iOS `UIDocumentPickerViewController` / macOS `NSSavePanel` / Windows `IFileSaveDialog` / Linux GTK Portal）
  - OHOS 端通过 `OhosPlatformPlugin` 复用 `DocumentViewPicker` / `AudioViewPicker`
  - 接口：`saveFile({required String fileName, required Uint8List bytes, String? mimeType, String? subDir})` → `SaveOutcome`（含 `pickerUri` / `publicDir` / `privateFallback` 三种 kind）
- **新增** 全局开关 `useFilePickerForFileOperations`（替换 `useFilePickerForExport`），覆盖「导出 + 下载」两类操作。首次启动默认值 `true`。`useFilePickerForExport` 旧偏好自动迁移并移除。

### 子目录配置
- **新增** 用户偏好 `fileSaveSubDirectoryName`，默认 `1Panel-Client`。当开关关闭时，所有平台按 `defaultDownloadDir()/fileSaveSubDirectoryName/<category>/<fileName>` 落盘。
- **保留** `category` 维度（`logs/` / `files/` / `images/` / `databases/`），由 MIME 类型自动归类，沿用现有 `nextAvailablePath` 冲突解决。

### 行为一致性
- **统一** 保存成功提示文案：picker 模式显示 `已保存到 ${displayName}`（不暴露私有路径）；子目录模式显示 `已保存到 ${subDirName}`。
- **统一** 失败/取消反馈：取消走 `SnackBarUtils.showInfo('已取消')`；失败走 `SnackBarUtils.showError` + `ErrorMessageUtils` 截断 + 完整错误 `appLogger.eWithPackage` 记录。

### 不变更
- 现有 OHOS `OhosPlatformPlugin` / `OhosDownloadPlugin` 实现保留（作为 OHOS 端 `PlatformFileSaveService` 的后端）。
- `LogExportService` 的日志导出链路保留 picker 行为。
- 现有 `nextAvailablePath` 文件名冲突解决逻辑保留。
- 现有 IP 脱敏 / 日志分类（`LogCategory`）逻辑保留。

## Impact

- Affected code:
  - `lib/core/platform/services/platform_file_service.dart`（弃用 `getDownloadsDirectory`，接入 `PlatformFileSaveService`）
  - `lib/core/platform/services/platform_system_paths.dart`（**新增** 平台下载目录抽象）
  - `lib/core/services/app_preferences_service.dart`（合并 `useFilePickerForExport` → `useFilePickerForFileOperations`，新增 `fileSaveSubDirectoryName`）
  - `lib/features/files/services/file_transfer_service.dart`（弃用 `getDownloadsDirectory`）
  - `lib/features/files/providers/files_provider_system_part.dart`（`_downloadWithOhosNative` / `_downloadWithFlutterDownloader` 接入统一 `PlatformFileSaveService`）
  - `lib/features/settings/system_settings_page.dart`（「使用文件选择器」开关文案升级、新增子目录名设置项）
  - `pubspec.yaml`（新增 `file_picker: ^8.x.x` 依赖）
  - `ohos/entry/src/main/ets/plugins/OhosPlatformPlugin.ets`（新增 `getPublicDownloadDir()` 与 `pickAndSaveBytes` 入口；保持与 Dart 端 `PlatformFileSaveService` 对接）
  - `ohos/entry/src/main/ets/plugins/OhosDownloadPlugin.ets`（picker 模式直接写入 `saveas` URI；非 picker 模式调用 `getPublicDownloadDir()` + 子目录）
  - `lib/l10n/app_zh.arb` / `app_en.arb`（新增子目录名设置项文案）
  - `lib/core/services/logger/widgets/log_preview_dialog.dart`（**轻微调整**：导出格式选择走 `PlatformFileSaveService`）

- Affected specs:
  - **替代/扩展** `fix-ohos-export-filepicker`（OHOS-specific）：本 spec 在其基础上做全平台泛化
  - **依赖** `optimize-logger-format-and-categories`（已完成）：日志导出仍走 picker，与本 spec 的 picker 路径复用

## ADDED Requirements

### Requirement: 跨平台系统下载目录统一抽象
系统 SHALL 通过 `PlatformSystemPaths.defaultDownloadDir()` 返回各平台「系统下载目录」的等效路径，不依赖 `path_provider.getDownloadsDirectory()`。

#### Scenario: Android
- **GIVEN** 当前平台为 Android
- **WHEN** 调用 `PlatformSystemPaths.defaultDownloadDir()`
- **THEN** 返回 `getExternalStorageDirectory()/Download`（私有外部存储下的 Download 目录，无需 READ/WRITE_EXTERNAL_STORAGE 权限）

#### Scenario: iOS
- **GIVEN** 当前平台为 iOS
- **WHEN** 调用 `PlatformSystemPaths.defaultDownloadDir()`
- **THEN** 返回 `getApplicationDocumentsDirectory()`（iOS 应用沙箱内；无公共下载目录）

#### Scenario: macOS
- **GIVEN** 当前平台为 macOS
- **WHEN** 调用 `PlatformSystemPaths.defaultDownloadDir()`
- **THEN** 返回 `${Platform.environment['HOME']}/Downloads`

#### Scenario: Windows
- **GIVEN** 当前平台为 Windows
- **WHEN** 调用 `PlatformSystemPaths.defaultDownloadDir()`
- **THEN** 返回 `${Platform.environment['USERPROFILE']}/Downloads`

#### Scenario: Linux
- **GIVEN** 当前平台为 Linux
- **WHEN** 调用 `PlatformSystemPaths.defaultDownloadDir()`
- **THEN** 返回 `${XDG_DOWNLOAD_DIR}`，若环境变量缺失则返回 `${HOME}/Downloads`

#### Scenario: OHOS
- **GIVEN** 当前平台为 OHOS
- **WHEN** 调用 `PlatformSystemPaths.defaultDownloadDir()`
- **THEN** 通过 MethodChannel 调用 `OhosPlatformPlugin.getPublicDownloadDir()`，返回 `Files/Downloads/...` 等效路径

#### Scenario: 路径不存在自动创建
- **WHEN** `defaultDownloadDir()` 返回的路径在磁盘上不存在
- **THEN** 自动 `mkdirSync(path, recursive: true)` 递归创建

### Requirement: 跨平台文件保存服务 `PlatformFileSaveService`
系统 SHALL 提供 `PlatformFileSaveService.saveFile(...)` 统一接口，封装 picker 模式与子目录模式两条路径。

#### Scenario: 开关 ON + picker 模式
- **GIVEN** `useFilePickerForFileOperations = true`
- **WHEN** 调用 `saveFile(fileName: 'a.txt', bytes: ..., mimeType: 'text/plain')`
- **THEN** 调起各平台原生 Picker：
  - Android: `ACTION_CREATE_DOCUMENT` (SAF)
  - iOS: `UIDocumentPickerViewController` (export)
  - macOS: `NSSavePanel`
  - Windows: `IFileSaveDialog`
  - Linux: `GTK Portal SaveFile` (`org.freedesktop.portal.FileChooser`)
  - OHOS: `DocumentViewPicker.save()` 或 `AudioViewPicker.save()`
- **AND** 用户选定 URI 后写入 bytes
- **AND** 返回 `SaveOutcome(kind: 'pickerUri', uri, displayName)`

#### Scenario: 用户取消 picker
- **WHEN** 用户在原生 Picker 中点击「取消」
- **THEN** 返回 `SaveOutcome.cancelled()`
- **AND** Dart 侧显示「已取消」Toast，不写入文件，不报错

#### Scenario: 开关 OFF + 子目录模式
- **GIVEN** `useFilePickerForFileOperations = false`，`fileSaveSubDirectoryName = '1Panel-Client'`，`category = 'logs'`
- **WHEN** 调用 `saveFile(fileName: 'app.log', bytes: ..., mimeType: 'text/plain')`
- **THEN** 写入 `defaultDownloadDir()/1Panel-Client/logs/app.log`
- **AND** 返回 `SaveOutcome(kind: 'publicDir', uri, displayName: '1Panel-Client/logs/app.log')`

#### Scenario: 写入失败回退
- **WHEN** 子目录模式写入因权限或磁盘问题失败
- **THEN** 回退写入 `getApplicationDocumentsDirectory()/exports/<category>/<fileName>`，返回 `SaveOutcome(kind: 'privateFallback', uri, displayName: '应用私有目录')`
- **AND** Toast 提示「已保存到应用私有目录」

### Requirement: 全局统一开关 `useFilePickerForFileOperations`
系统 SHALL 暴露单一全局开关 `useFilePickerForFileOperations`，控制「导出 + 下载」两类操作是否走 picker。

#### Scenario: 默认开启
- **WHEN** 用户首次安装（无历史偏好）
- **THEN** `useFilePickerForFileOperations = true`

#### Scenario: 老用户迁移
- **GIVEN** 用户从旧版本升级，存在 `useFilePickerForExport` 偏好
- **WHEN** 启动时加载偏好
- **THEN** 复用 `useFilePickerForExport` 值作为 `useFilePickerForFileOperations`
- **AND** 同时清除旧键 `useFilePickerForExport` 避免重复

#### Scenario: 开关影响下载
- **GIVEN** 开关为 `true`
- **WHEN** 用户在文件管理页触发下载
- **THEN** 走 picker（同导出）
- **GIVEN** 开关为 `false`
- **WHEN** 用户触发下载
- **THEN** 直接写入 `defaultDownloadDir()/1Panel-Client/files/...`

#### Scenario: 开关影响导出
- **GIVEN** 开关为 `true`
- **WHEN** 用户导出日志
- **THEN** 走 picker
- **GIVEN** 开关为 `false`
- **WHEN** 用户导出日志
- **THEN** 直接写入 `defaultDownloadDir()/1Panel-Client/logs/...`

### Requirement: 可配置全局子目录名
系统 SHALL 在系统设置「文件保存」区域暴露 `fileSaveSubDirectoryName` 设置项，默认 `1Panel-Client`。

#### Scenario: 默认值
- **WHEN** 用户首次安装
- **THEN** `fileSaveSubDirectoryName = '1Panel-Client'`

#### Scenario: 自定义子目录名
- **GIVEN** 用户在设置中将子目录改为 `MyPanel`
- **WHEN** 关闭 picker 后触发导出/下载
- **THEN** 写入 `defaultDownloadDir()/MyPanel/<category>/<fileName>`

#### Scenario: 子目录名空时回退
- **GIVEN** 用户将子目录名清空
- **WHEN** 关闭 picker 后触发保存
- **THEN** 写入 `defaultDownloadDir()/<category>/<fileName>`（无父目录）

#### Scenario: 非法字符
- **GIVEN** 用户输入的子目录名包含 `\` `/` `:` `*` `?` `<` `>` `|` 等非法字符
- **WHEN** 触发保存
- **THEN** 子目录名经 `_sanitizeDirName()` 替换为 `_` 后落盘
- **AND** Toast 提示「子目录名包含非法字符，已自动替换」

### Requirement: OHOS `getPublicDownloadDir()` 原生支持
系统 SHALL 在 `OhosPlatformPlugin` 暴露 `getPublicDownloadDir()` MethodChannel 方法，返回 `Files/Downloads/` 等效的 fs 路径或 content URI 列表。

#### Scenario: 获取公共下载目录
- **WHEN** Dart 端调用 `OhosPlatformChannel.getPublicDownloadDir()`
- **THEN** 原生返回 `{ path: '/storage/emulated/0/Download/1Panel-Client', displayName: '下载' }`
- **AND** Dart 侧据此计算子目录路径

#### Scenario: 路径不存在自动创建
- **WHEN** `Files/Downloads/1Panel-Client` 在设备上不存在
- **THEN** 原生侧 `fs.mkdirSync` 递归创建后再返回

### Requirement: picker 跨平台一致性
系统 SHALL 在所有平台保持 picker 调起体验一致：每次调用都弹；用户取消不报错；成功返回 `SaveOutcome`。

#### Scenario: 五大桌面/移动平台 picker 调起
- **GIVEN** 平台为 Android / iOS / macOS / Windows / Linux
- **WHEN** 调用 `saveFile(...)` 且 `useFilePickerForFileOperations = true`
- **THEN** 各平台调起对应的**原生 Picker**：
  - Android SAF / iOS UIDocumentPickerViewController / macOS NSSavePanel / Windows IFileSaveDialog / Linux GTK Portal
- **AND** 经 `file_picker` 插件统一封装，Dart 侧接口一致

#### Scenario: OHOS picker 调起
- **GIVEN** 平台为 OHOS
- **WHEN** 调用 `saveFile(...)` 且 `useFilePickerForFileOperations = true`
- **THEN** 通过 `OhosPlatformPlugin.pickAndSaveBytes(...)` 调起 `DocumentViewPicker.save()`（非音频）或 `AudioViewPicker.save()`（音频）

### Requirement: 提示文案国际化
系统 SHALL 在 zh / en ARB 中维护 picker / 子目录两套成功提示文案。

#### Scenario: Picker 模式
- **WHEN** picker 保存成功
- **THEN** zh: `已保存到 ${displayName}`；en: `Saved to ${displayName}`

#### Scenario: 子目录模式
- **WHEN** 子目录模式保存成功
- **THEN** zh: `已保存到 ${subDirName}`；en: `Saved to ${subDirName}`

#### Scenario: 私有目录回退
- **WHEN** 保存回退到应用私有目录
- **THEN** zh: `已保存到应用私有目录`；en: `Saved to app private directory`

## MODIFIED Requirements

### Requirement: `getDownloadsDirectory()` 弃用
原 `path_provider.getDownloadsDirectory()` 调用在 macOS 以外的平台抛 `UnsupportedError`。本 spec 强制要求全部调用点替换为 `PlatformSystemPaths.defaultDownloadDir()`，不保留兼容路径。

#### Scenario: 替换前（崩溃）
- **GIVEN** 平台为 OHOS
- **WHEN** 调用 `path_provider.getDownloadsDirectory()`
- **THEN** 抛 `Unsupported operation: Functionality only available on macOS`

#### Scenario: 替换后（正常）
- **GIVEN** 平台为 OHOS
- **WHEN** 调用 `PlatformSystemPaths.defaultDownloadDir()`
- **THEN** 返回 `Files/Downloads/` 等效路径，不抛错

## REMOVED Requirements

无（OHOS 现有 picker 实现保留为 `PlatformFileSaveService` 的后端之一）。

# Task Dependencies

- [Task 2] depends on [Task 1]
- [Task 3] depends on [Task 2]
- [Task 4] depends on [Task 3]
- [Task 5] depends on [Task 4]
- [Task 6] depends on [Task 5]
- [Task 7] depends on [Task 6]
- [Task 8] depends on [Task 7]
- [Task 9] depends on [Task 8]
