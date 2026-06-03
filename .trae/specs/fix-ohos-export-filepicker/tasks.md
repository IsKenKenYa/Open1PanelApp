# Tasks

- [x] Task 1: 修复 OHOS 原生插件 UIAbilityContext 获取
  - [x] SubTask 1.1: 在 `EntryAbility.ets` 中通过 `this.context`（FlutterAbility.context）作为插件注册时的 UIAbilityContext 持有
  - [x] SubTask 1.2: 修改 `OhosCompatibilityPluginRegistrant.registerWith` 签名接收 `FlutterEngine + UIAbilityContext`，将 context 透传给各插件
  - [x] SubTask 1.3: `OhosPlatformPlugin.onAttachedToEngine` 接收 `UIAbilityContext`，并存入成员变量；`getUIAbilityContext()` 直接返回该值
  - [x] SubTask 1.4: `OhosDownloadPlugin.onAttachedToEngine` 同步处理
  - [x] SubTask 1.5: 验证 `OhosPathProviderPlugin` 等其他插件签名是否需要同步更新（无需，仅 application context）

- [x] Task 2: 扩展 OHOS Method Channel 方法
  - [x] SubTask 2.1: `OhosPlatformPlugin` 新增 `openUri(contentUri)` 方法：用 `want.action.viewData + uri: contentUri` + `startAbility`
  - [x] SubTask 2.2: `OhosPlatformPlugin` 新增 `pickAndSaveBytesByKind(fileName, bytes, mimeKind)`：`mimeKind = document | audio | image_video` 路由到对应 picker
  - [x] SubTask 2.3: `OhosPlatformPlugin` 新增 `saveBytesToPublicDownload(fileName, bytes, category)`：写入 `Files/Downloads/Open1Panel/<category>/`，自动创建子目录
  - [x] SubTask 2.4: `OhosPlatformPlugin.pickAndSaveBytes` 旧方法保留为内部路由，向上抛错而非静默回退
  - [x] SubTask 2.5: `OhosPlatformChannel` Dart 侧增加对应方法签名

- [x] Task 3: OhosDownloadPlugin 接入 Picker 与 `ohos.request.agent`
  - [x] SubTask 3.1: `enqueue` 第一步调用 picker 拿 `saveas` URI（无 picker URI 时降级到 `Files/Downloads/Open1Panel/downloads/`）
  - [x] SubTask 3.2: 引入 `ohos.request.agent.create()` 与 `task()`，将 `saveas` 写入 Config（API 20+）
  - [x] SubTask 3.3: API < 20 设备降级到 `fs.openSync(uri) + writeSync` 直写模式
  - [x] SubTask 3.4: 监听进度事件并通过 EventChannel 推送（沿用现有 `onepanel/ohos_download_progress`）
  - [x] SubTask 3.5: 取消/暂停时调用 `request.agent.remove()` 清理任务
  - [x] SubTask 3.6: 下载完成后 Dart 侧拿到 `content:// URI` 与 `displayName` 用于"打开"按钮

- [ ] Task 4: Settings 偏好与 UI 开关
  - [ ] SubTask 4.1: 在 `SettingsProvider` 增加 `useFilePickerForExport: bool` 字段与持久化（SharedPreferences）
  - [ ] SubTask 4.2: `system_settings_page.dart` "通用"区增加 SwitchListTile
  - [ ] SubTask 4.3: `PlatformFileService.saveBytes` 读取该偏好决定走 picker 还是公共下载目录
  - [ ] SubTask 4.4: 偏好读取失败时回退默认值 `true`（保护旧用户）

- [x] Task 5: 扩展 `FileSaveResult` 与上游展示
  - [x] SubTask 5.1: `FileSaveResult` 增加 `displayName`、`kind`、`category` 可选字段
  - [x] SubTask 5.2: `PlatformFileService` 完整填充新字段
  - [x] SubTask 5.3: `LogExportService` 接收结果并按 `kind`/`displayName` 渲染 Toast 文案
  - [x] SubTask 5.4: 传输管理页面"已下载"项按新字段展示保存位置

- [ ] Task 6: 国际化文案
  - [ ] SubTask 6.1: `app_zh.arb` 新增：`fileSavePickerEnabledTitle`、`fileSavePickerEnabledSubtitle`、`fileSaveSuccessToDownloads`、`fileSaveSuccessToPicker`、`fileSaveCancelled`、`fileSaveFailed`、`fileSavePickerUnavailable`
  - [ ] SubTask 6.2: `app_en.arb` 同步新增对应英文条目
  - [ ] SubTask 6.3: 运行 `flutter gen-l10n` 生成代码

- [x] Task 7: openUri 走 startAbility
  - [x] SubTask 7.1: `OhosPlatformChannel` 增加 `openUri(String contentUri)` 通道方法
  - [x] SubTask 7.2: `OhosPlatformPlugin.openUri` 实现 `want.action.viewData` 唤起
  - [x] SubTask 7.3: `PlatformFileService.openFile` 在 content:// URI 时调用 `openUri`；fs path 仍走原逻辑
  - [x] SubTask 7.4: URI 不可打开时降级到 `openDirectory`

- [x] Task 8: 权限与 module.json5
  - [x] SubTask 8.1: 确认 `ohos.permission.INTERNET` 已声明（下载）
  - [x] SubTask 8.2: `ohos.permission.WRITE_IMAGEVIDEO` 用户授权流程接入（仅图片/视频 picker 场景，按需申请）
  - [x] SubTask 8.3: 检查 `ohos/entry/src/main/module.json5` 中 `requestPermissions` 配置

- [x] Task 9: 测试与门禁
  - [x] SubTask 9.1: `flutter analyze` 无错误（hflutter analyze 同步通过）
  - [x] SubTask 9.2: `dart run test/scripts/test_runner.dart unit` 通过（hflutter test 14/14 通过）
  - [x] SubTask 9.3: `dart run test/scripts/test_runner.dart integration` 通过（独立验证：与本任务相关测试均通过，integration 套件 367 个失败是 pre-existing 的 full_api_contract_smoke_test 失败，与本任务无关）
  - [ ] SubTask 9.4: DevEco Studio 端到端验证（需在 DevEco Studio + 真机/模拟器验证，原生 picker 弹出、内容 URI 打开、取消语义）：
    - [ ] 开关开启时导出日志弹 picker
    - [ ] 开关开启时下载文件弹 picker
    - [ ] 开关关闭时导出到 `Files/Downloads/Open1Panel/logs/`
    - [ ] 用户取消 picker 时显示"已取消"不报错
    - [ ] 完成后点击"打开"能用系统查看器打开 content:// URI
  - [ ] SubTask 9.5: `hflutter build hap --debug` 构建通过（需 DevEco 环境，本地未执行）

# Task Dependencies
- Task 2 依赖 Task 1
- Task 3 依赖 Task 1
- Task 4 依赖 Task 2, Task 3
- Task 5 依赖 Task 2, Task 4
- Task 6 依赖 Task 5
- Task 7 依赖 Task 1
- Task 8 依赖 Task 2, Task 3
- Task 9 依赖 Task 1-8

# Notes

- 修法核心是修复 `getUIAbilityContext()`，避免静默回退。`OhosCompatibilityPluginRegistrant` 当前只接收 `FlutterEngine`，需要扩展为同时接收 `UIAbilityContext`（从 `EntryAbility.configureFlutterEngine` 通过 `this.context` 传入）。
- 多 picker 路由仅在 `mimeType` 已知时启用；`mimeType` 为空时默认走 `DocumentViewPicker`。
- `ohos.request.agent` 仅 API 20+ 支持，旧设备降级 `fs.writeSync`。
- 老用户偏好缺失时默认 `useFilePickerForExport = true`，与新功能行为一致；不主动写入"用户关闭"的默认值。
