# OHOS 导出/下载文件不唤起 FilePicker 修复 Spec

## Why

当前 Open1PanelApp 在 HarmonyOS / OpenHarmony 设备上导出日志、文件、或者下载网络资源时，**OHOS 原生 picker (DocumentViewPicker / AudioViewPicker / PhotoAccessHelper) 永远不会弹出来**。日志 `pickAndSaveBytes failed: Error: UIAbility not found — picker requires ability context, falling back to private dir` 表明：插件拿不到 UIAbilityContext，picker 调用被 try/catch 静默吞掉后回退到 `/data/storage/el2/base/files/exports/` 私有目录。用户感知不到失败过程，也无法选择导出/下载位置。

需要让 OHOS 平台上的"导出"和"下载"行为对用户可见、可选，符合用户明确表达的"给用户选择权"原则。

## What Changes

- **OHOS 原生修复**：让 `OhosPlatformPlugin` 与 `OhosDownloadPlugin` 能正确获取 UIAbilityContext，picker API 真正可调用
- **新增 settings 开关**："导出/下载时使用文件选择器"，默认 `true`，关闭时走公共下载目录
- **Picker 路由**：根据 MIME 类型自动选择合适的 OHOS picker
  - 文档/通用 → `DocumentViewPicker.save()`
  - 音频 → `AudioViewPicker.save()`
  - 图片/视频 → `PhotoAccessHelper.createAsset()`
- **下载走 picker**：`OhosDownloadPlugin` 在 `enqueue` 时先弹 picker 拿 `saveas` URI，再调用 `ohos.request.agent` 写入
- **非 picker 模式**（开关关闭）：写入公共下载目录 `Files/Downloads/Open1Panel/`，可按文件类型/时间创建子目录
- **UI 展示修复**：保存成功提示从 `保存成功: /data/storage/...` 改为 `已保存到 XXX 的下载`，走 `appLogger` + 国际化 ARB
- **openUri 走 startAbility**：picker 返回的 content:// URI 用 `want.action.viewData` 唤起系统查看器
- **BREAKING**：`FileSaveResult.filePath` 在 OHOS + picker 模式下从"文件系统路径"变为"content:// URI 或 picker 返回的 URI 字符串"。上层需要按新字段处理；旧的私有目录回退路径在 picker 关闭时仍保留

## Impact

- Affected specs: 无（全新 spec）
- Affected code:
  - `ohos/entry/src/main/ets/entryability/EntryAbility.ets`（获取并注入 UIAbilityContext）
  - `ohos/entry/src/main/ets/plugins/OhosPlatformPlugin.ets`（修复 `getUIAbilityContext()`，新增多 picker 路由、`openUri`）
  - `ohos/entry/src/main/ets/plugins/OhosDownloadPlugin.ets`（enqueue 时弹 picker + 走 `ohos.request.agent`）
  - `ohos/entry/src/main/module.json5`（确认/添加 `ohos.permission.INTERNET` 权限）
  - `lib/core/platform/services/ohos_platform_channel.dart`（新增 `openUri`、`pickAndSaveBytesToPublic`、调整 `saveBytes` 语义）
  - `lib/core/platform/services/platform_file_service.dart`（picker 关闭时回退到公共下载目录，返回结构化 `FileSaveOutcome`）
  - `lib/core/services/file_save_service.dart`（扩展 `FileSaveResult` 字段：保存位置展示名、URI 类型、是否使用 picker）
  - `lib/core/services/logger/log_export_service.dart`（调用新的保存服务，按开关决定走 picker）
  - `lib/features/settings/settings_provider.dart`（新增 `useFilePickerForExport` 偏好）
  - `lib/features/settings/system_settings_page.dart`（设置页增加开关）
  - `lib/features/files/transfer_manager_page.dart`（下载完成后打开按钮兼容 content:// URI）
  - `lib/l10n/app_zh.arb` + `lib/l10n/app_en.arb`（新增 ARB 条目）

## ADDED Requirements

### Requirement: Settings 开关 `useFilePickerForExport`

The system SHALL provide a settings toggle `useFilePickerForExport`.

#### Scenario: 首次进入设置
- **WHEN** 用户进入"系统设置 → 通用"页
- **THEN** 看到"导出/下载时使用文件选择器"开关，默认开启（值为 `true`）

#### Scenario: 用户关闭开关
- **WHEN** 用户关闭该开关
- **THEN** 后续所有导出/下载不再弹 picker；保存到 `Files/Downloads/Open1Panel/`（或子目录），提示"已保存到下载目录"
- **AND** 偏好持久化到本地存储，重启 App 后仍生效

#### Scenario: 旧版本用户升级
- **WHEN** 用户从旧版本升级到新版本
- **THEN** 开关默认为 `true`（首次读不到偏好时使用默认值）

### Requirement: OHOS 原生 Picker 真正可调用

The system SHALL ensure `OhosPlatformPlugin` and `OhosDownloadPlugin` can obtain a valid `UIAbilityContext` so picker APIs succeed.

#### Scenario: 启动后首次调用 picker
- **WHEN** Flutter 端调用 `pickAndSaveBytes`
- **THEN** `getUIAbilityContext()` 返回非空 `common.UIAbilityContext`
- **AND** `DocumentViewPicker.save({ newFileNames: [...] })` 正常弹出 picker UI

#### Scenario: UIAbilityContext 获取失败兜底
- **WHEN** 由于 OHOS SDK 版本或异常导致 `getUIAbility` 仍返回 `null`
- **THEN** 记录 `Log.e` 错误，**不再**静默回退到私有目录；返回 `ohos_platform_error: UIAbility not ready`，由 Dart 侧 Toast 提示并提供"前往设置"或"取消"按钮

### Requirement: 多类型 Picker 路由

The system SHALL route picker selection based on file MIME type.

#### Scenario: 文本/日志/通用文档
- **WHEN** 保存文件 MIME 为 `text/plain` / `application/*` / `*/*`
- **THEN** 调用 `DocumentViewPicker.save({ newFileNames: [fileName] })`

#### Scenario: 音频文件
- **WHEN** MIME 以 `audio/` 开头
- **THEN** 调用 `AudioViewPicker.save({ newFileNames: [fileName] })`

#### Scenario: 图片或视频
- **WHEN** MIME 以 `image/` 或 `video/` 开头
- **THEN** 走 `PhotoAccessHelper.createAsset()`，并先申请 `ohos.permission.WRITE_IMAGEVIDEO` 用户授权

#### Scenario: 用户取消 picker
- **WHEN** 用户在 picker 中点击"取消"
- **THEN** MethodChannel 返回 `null`；Dart 侧展示"已取消"提示，**不报错**

### Requirement: 下载走 Picker 与 `ohos.request.agent`

The system SHALL use `ohos.request.agent` to download network resources to the user-picked URI.

#### Scenario: 用户触发文件下载
- **WHEN** 用户在文件管理或传输管理页面点击"下载"
- **THEN** `OhosDownloadPlugin.enqueue` 流程：
  1. 弹 `DocumentViewPicker.save()` 拿到 saveas URI
  2. 创建 `request.agent.create()` Config，传入 `saveas` 字段
  3. 启动 `request.agent.task()`，监听进度推送
  4. 完成后通过 EventChannel 通知 Dart 侧

#### Scenario: 下载过程中取消
- **WHEN** 用户取消下载
- **THEN** 调用 `request.agent.remove()` 清理任务并删除已下载的临时数据

### Requirement: 非 Picker 模式 → 公共下载目录

The system SHALL save to `Files/Downloads/Open1Panel/...` when the toggle is off or picker mode is unavailable.

#### Scenario: 开关关闭
- **WHEN** `useFilePickerForExport = false`
- **THEN** 写入 `Files/Downloads/Open1Panel/<category>/<fileName>`，其中 category 按 MIME 划分（如 `logs/`、`files/`、`images/`）

#### Scenario: 子目录不存在
- **WHEN** 目标子目录不存在
- **THEN** 使用 `fs.mkdirSync(path, true)` 递归创建

#### Scenario: 文件名冲突
- **WHEN** 同名文件已存在
- **THEN** 追加 `_1`, `_2`, ... 后缀避免覆盖（沿用现有 `nextAvailablePath` 逻辑）

### Requirement: 国际化保存成功提示

The system SHALL display human-readable saved-location messages using ARB.

#### Scenario: Picker 模式保存成功
- **WHEN** picker 返回 URI 且写入完成
- **THEN** Toast 展示 `已保存到 ${displayName} 的下载`（中文）/ `Saved to ${displayName} Downloads`（英文）
- **AND** 不再显示 `/data/storage/el2/base/files/exports/...` 私有路径

#### Scenario: 非 picker 模式保存成功
- **WHEN** 写入公共下载目录完成
- **THEN** Toast 展示 `已保存到下载目录` / `Saved to Downloads`

#### Scenario: 失败提示
- **WHEN** 保存失败（非取消）
- **THEN** 走 `SnackBarUtils` L1 反馈，错误消息经 `ErrorMessageUtils` 截断 120 字符
- **AND** 完整错误经 `appLogger.eWithPackage` 记录

### Requirement: openUri 走 startAbility

The system SHALL open content:// URIs via `want.action.viewData`.

#### Scenario: 用户点击"打开"按钮
- **WHEN** 用户在传输管理页面点击已完成下载的"打开"按钮
- **THEN** Dart 端调用 `openUri(contentUri)` → MethodChannel → 原生用 `want.action.viewData + uri: contentUri` + `startAbility`
- **AND** 不需要持久化权限；OHOS 系统自动以 viewer 身份持有读取权限

#### Scenario: URI 不可打开
- **WHEN** startAbility 抛出异常或返回失败
- **THEN** 静默降级到 `openDirectory`（打开父目录），若父目录也不可打开则 Toast "无法打开该文件"

## MODIFIED Requirements

### Requirement: `FileSaveResult` 字段扩展（MODIFIED）

旧定义：
```dart
class FileSaveResult {
  final String? filePath;     // 文件系统路径或 content:// URI 字符串
  final bool success;
  final String? errorMessage;
}
```

新定义（向后兼容，添加可选字段）：
```dart
class FileSaveResult {
  final String? filePath;     // 文件系统路径（picker 关闭 / 非 OHOS 时）或 content:// URI
  final bool success;
  final String? errorMessage;
  final String? displayName;  // picker 返回的展示名（用于 Toast "已保存到 XXX 的下载"）
  final SaveLocationKind kind; // publicDownloadDir / pickerUri / privateFallback / other
  final String? category;     // 分类子目录名（logs/files/images...）
}
```

#### Scenario: 老调用方未读新字段
- **WHEN** 上层代码只读 `success` 与 `filePath`
- **THEN** 行为与旧版本一致，无破坏

#### Scenario: 调用方按新字段展示
- **WHEN** `kind == pickerUri`
- **THEN** UI 使用 `displayName` 渲染 Toast/对话框

### Requirement: `PlatformFileService.saveBytes` 行为（MODIFIED）

旧实现：OHOS 走 `pickAndSaveBytes` → 失败回退到 `_saveToFallbackDirectory`（私有目录）。

新实现：
1. 读 `useFilePickerForExport` 偏好
2. `true` → 走 picker；返回 `SaveLocationKind.pickerUri`
3. `false` → 走 `_saveToPublicDownloadDirectory`（公共下载目录 + 子目录）；返回 `SaveLocationKind.publicDownloadDir`
4. picker 失败/取消时仍可降级，但必须报错**或**返回 `null` + `errorMessage`，不再静默回退到私有目录

## REMOVED Requirements

无（保留旧私有目录回退路径作为 picker 完全不可用时的最后兜底，但实际不再触发）。

## Cross-cutting

### Logging
- 关键节点 `getUIAbilityContext`、`DocumentViewPicker.save`、`request.agent.task` 必须有 `appLogger`/`Log.i` 日志
- 取消与失败的日志必须区分

### Testing
- OHOS 端无完整 Dart 测试能力，需要在 DevEco Studio 端到端验证
- 关键门禁：`hflutter build hap --release` 或 `hflutter build hap --debug` 必须通过
- `flutter analyze` 不得引入新错误

### Permissions
- `ohos.permission.INTERNET` — 下载所需
- `ohos.permission.WRITE_IMAGEVIDEO` — 图片/视频 picker 仅在该场景下申请
- 模块权限在 `module.json5` 中声明

### Performance
- picker 不在 Widget build 阶段调用，全部走异步 MethodChannel
- 进度事件通过 EventChannel 推送，避免主线程阻塞

## Open Risks

- **API 20 兼容**：`ohos.request.agent` 接收 saveas 需要 API 20+，旧设备需降级到 `fs.writeSync` 直写 picker URI（content:// URI 用 `fs.openSync(uri, ...)` 在 OHOS 也可工作）
- **跨设备 picker 显示**：`DocumentViewPicker` 在折叠屏/平板上可能需要配置 `select` 参数
- **多 Picker UX 差异**：用户在 picker 内可以重命名/换目录，URI 不稳定，UI 展示要靠 `displayName` 而非 URI
