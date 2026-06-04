# Checklist

## 紧急修复（崩溃）
- [x] `PlatformSystemPaths.defaultDownloadDir()` 已实现
- [x] `lib/core/platform/services/platform_file_service.dart:356` `getDownloadsDirectory()` 已替换
- [x] `lib/features/files/services/file_transfer_service.dart:155` `getDownloadsDirectory()` 已替换
- [x] `lib/features/files/providers/files_provider_system_part.dart:128,181` `getDownloadsDirectory()` 已替换
- [x] OHOS 模拟器下载不再崩溃（已编写代码与单测，待人工验证）

## file_picker 插件
- [x] `pubspec.yaml` 添加 `file_picker: ^8.1.4`
- [x] `flutter pub get` 成功

## PlatformFileSaveService
- [x] `lib/core/platform/services/platform_file_service.dart` 已实现 `saveBytesStructured`
- [x] 五大桌面/移动平台走 `file_picker`（Android SAF / iOS UIDocumentPickerViewController / macOS NSSavePanel / Windows IFileSaveDialog / Linux GTK Portal）
- [x] OHOS 走 `OhosPlatformPlugin`
- [x] 开关 OFF 走子目录（含 `fileSaveSubDirectoryName`）
- [x] 失败回退应用私有目录

## OHOS 原生
- [x] `OhosPlatformPlugin.getPublicDownloadDir()` 已实现
- [x] 路径不存在自动 mkdir
- [x] Dart 端 `OhosPlatformChannel` 同步添加

## 偏好合并
- [x] `useFilePickerForFileOperations` 替代 `useFilePickerForExport`（旧方法标记 `@Deprecated`）
- [x] 旧偏好自动迁移并清理
- [x] 默认值 `true`
- [x] 单元测试覆盖迁移

## 子目录配置
- [x] `fileSaveSubDirectoryName` 偏好默认 `1Panel-Client`
- [x] 自定义名称生效
- [x] 空字符串回退无父目录
- [x] 非法字符替换为 `_`

## 系统设置 UI
- [x] 开关文案升级
- [x] 子目录名 TextField
- [x] 非法字符校验
- [x] 国际化文案（zh / en）

## 业务调用点
- [x] `FilesProvider` 改用 `PlatformFileService.saveBytesStructured`
- [x] `FileTransferService` 改用 `PlatformFileService.saveBytesStructured`
- [x] `LogExportService` 改用 `PlatformFileService.saveBytesStructured`
- [x] 全量 audit 无 `getDownloadsDirectory` 残留

## 验证
- [x] `flutter analyze` 无错误（修改文件均无 issue）
- [x] `dart run test/scripts/test_runner.dart unit` 通过
- [x] 新增单元测试通过（`platform_system_paths_test.dart`、`app_preferences_file_save_test.dart`）
- [x] `flutter build apk --debug` 成功
- [ ] OHOS 模拟器手动验证：需 `hflutter build hap`，当前环境无 `hflutter`（需在 OHOS 工具链环境执行）
- [ ] 至少一个桌面平台（macOS / Windows / Linux）手动验证（`flutter build macos --debug` 受限于 `MonitoringView.swift: LoadingView` 预存在引用问题，已在静默日志中确认属于未提交到本工作树的预存缺陷）
