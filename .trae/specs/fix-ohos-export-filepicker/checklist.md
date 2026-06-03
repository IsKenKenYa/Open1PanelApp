# Checklist

## OHOS 原生 Picker 修复
- [x] `EntryAbility.ets` 持有 `UIAbilityContext` 并通过 `configureFlutterEngine` 注入
- [x] `OhosCompatibilityPluginRegistrant.registerWith` 接收 `UIAbilityContext`
- [x] `OhosPlatformPlugin.getUIAbilityContext()` 返回非 null
- [x] `OhosDownloadPlugin` 同样持有 `UIAbilityContext`
- [x] `OhosPathProviderPlugin`、`OhosSecureStoragePlugin` 等其他插件签名同步
- [x] 旧的 `getUIAbility(appContext)` 兜底逻辑保留（防止极端情况）

## Settings 开关
- [x] `SettingsProvider` 持久化 `useFilePickerForExport`（在 `AppPreferencesService` 中）
- [x] 开关默认 `true`（首次启动）
- [x] `system_settings_page.dart` 通用区增加 SwitchListTile
- [x] 关闭后导出/下载不再弹 picker
- [x] 偏好写入 SharedPreferences，重启保留

## Picker 路由
- [x] `DocumentViewPicker.save()` 用于文本/日志/通用
- [x] `AudioViewPicker.save()` 用于音频
- [x] `PhotoAccessHelper.createAsset()` 用于图片/视频
- [x] `WRITE_IMAGEVIDEO` 权限按需申请
- [x] 用户取消 picker → `null` 返回 + Toast "已取消"

## 下载走 Picker + `ohos.request.agent`
- [x] `enqueue` 先弹 picker 拿 saveas URI
- [x] API 20+ 用 `request.agent.create()` + `task()`
- [x] API < 20 降级到 `fs.openSync/writeSync` 直写
- [x] 取消/暂停调用 `request.agent.remove()`
- [x] EventChannel 进度推送不丢消息
- [x] 下载完成返回 content:// URI 与 displayName

## 非 Picker 模式
- [x] 写入 `${filesDir}/exports/<category>/`
- [x] 子目录按 `logs/` `files/` `images/` `downloads/` 分类
- [x] `mkdirSync(path, true)` 递归创建
- [x] 文件名冲突追加 `_1` `_2` ...

## FileSaveResult 字段扩展
- [x] `displayName` 字段填充
- [x] `SaveLocationKind` 枚举：pickerUri / publicDownloadDir / privateFallback / other
- [x] `category` 字段填充
- [x] 老调用方只读 `success` + `filePath` 行为不变

## UI 国际化
- [x] `app_zh.arb` 新增 7 条文案
- [x] `app_en.arb` 新增 7 条对应英文
- [x] `flutter gen-l10n` 生成代码无错误
- [x] Toast 展示 picker displayName 而非私有路径
- [x] 失败走 `SnackBarUtils` + `ErrorMessageUtils` 截断 120 字符

## openUri
- [x] `OhosPlatformChannel.openUri` 方法
- [x] `OhosPlatformPlugin.openUri` 实现 `want.action.viewData`
- [x] `PlatformFileService.openFile` 自动识别 content:// URI
- [x] URI 不可打开降级到 `openDirectory`

## 权限
- [x] `ohos.permission.INTERNET` 已声明
- [x] `ohos.permission.WRITE_IMAGEVIDEO` 动态申请逻辑
- [x] `module.json5` `requestPermissions` 配置正确

## 测试与门禁
- [x] `hflutter analyze` 无新错误
- [x] `hflutter test` 14/14 通过（10 新 + 4 回归）
- [ ] DevEco Studio 端到端验证 5 个场景全部通过（需 DevEco 环境）
- [ ] `hflutter build hap --debug` 构建通过（需 DevEco 环境）
