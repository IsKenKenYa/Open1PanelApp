# Tasks

- [ ] Task 1: 紧急修复 OHOS 下载崩溃（移除 `getDownloadsDirectory`）
  - [ ] SubTask 1.1: 在 `lib/core/platform/services/platform_system_paths.dart` 新增 `PlatformSystemPaths` 抽象
  - [ ] SubTask 1.2: 实现 `defaultDownloadDir()` for Android / iOS / macOS / Windows / Linux
  - [ ] SubTask 1.3: 实现 OHOS `defaultDownloadDir()` via MethodChannel（先 stub，Task 4 完善）
  - [ ] SubTask 1.4: 替换 `lib/core/platform/services/platform_file_service.dart:356` 与 `lib/features/files/services/file_transfer_service.dart:155` 的 `getDownloadsDirectory()` 调用
  - [ ] SubTask 1.5: 替换 `lib/features/files/providers/files_provider_system_part.dart:128,181` 的 `getDownloadsDirectory()` 调用

- [ ] Task 2: 引入 `file_picker` 插件
  - [ ] SubTask 2.1: `pubspec.yaml` 添加 `file_picker: ^8.1.4` 依赖
  - [ ] SubTask 2.2: 验证 Android / iOS / macOS / Windows / Linux 各端均无需额外配置
  - [ ] SubTask 2.3: 跑 `flutter pub get` 拉取依赖

- [ ] Task 3: 实现 `PlatformFileSaveService`
  - [ ] SubTask 3.1: 新增 `lib/core/platform/services/platform_file_save_service.dart`
  - [ ] SubTask 3.2: 实现 `saveFile({fileName, bytes, mimeType, subDir, category})` 统一接口
  - [ ] SubTask 3.3: 实现 Android / iOS / macOS / Windows / Linux 端走 `file_picker`
  - [ ] SubTask 3.4: 实现 OHOS 端走 `OhosPlatformPlugin`（保留已有 picker 实现）
  - [ ] SubTask 3.5: 开关 OFF 时走 `PlatformSystemPaths.defaultDownloadDir()` + 子目录
  - [ ] SubTask 3.6: 失败时回退 `getApplicationDocumentsDirectory()` + Toast 提示

- [ ] Task 4: OHOS 原生 `getPublicDownloadDir()` 实现
  - [ ] SubTask 4.1: 在 `ohos/entry/src/main/ets/plugins/OhosPlatformPlugin.ets` 新增 `getPublicDownloadDir()` MethodChannel 方法
  - [ ] SubTask 4.2: 路径不存在时 `fs.mkdirSync(path, true)` 递归创建
  - [ ] SubTask 4.3: 返回 `{ path, displayName: '下载' }` JSON
  - [ ] SubTask 4.4: 在 Dart 端 `OhosPlatformChannel` 添加对应方法

- [ ] Task 5: 合并 `useFilePickerForFileOperations` 开关
  - [ ] SubTask 5.1: `AppPreferencesService` 新增 `loadUseFilePickerForFileOperations()` / `saveUseFilePickerForFileOperations(bool)`
  - [ ] SubTask 5.2: 首次加载时从 `useFilePickerForExport` 迁移，删除旧键
  - [ ] SubTask 5.3: `useFilePickerForExport` 方法标记 `@Deprecated`，保留过渡期
  - [ ] SubTask 5.4: 单元测试覆盖：迁移路径 / 默认值

- [ ] Task 6: 新增子目录名偏好 `fileSaveSubDirectoryName`
  - [ ] SubTask 6.1: `AppPreferencesService` 新增 `loadFileSaveSubDirectoryName()` / `saveFileSaveSubDirectoryName(String)`
  - [ ] SubTask 6.2: 默认值 `1Panel-Client`
  - [ ] SubTask 6.3: 加载与保存走 prefs，无历史时返回默认
  - [ ] SubTask 6.4: 单元测试覆盖：默认值 / 自定义 / 空字符串回退

- [ ] Task 7: 系统设置页 UI 升级
  - [ ] SubTask 7.1: 替换「导出/下载时使用文件选择器」开关为新文案「保存文件时使用文件选择器」
  - [ ] SubTask 7.2: 新增「默认子目录名」TextField 绑定 `fileSaveSubDirectoryName`
  - [ ] SubTask 7.3: 子目录名输入校验：非法字符替换 + Toast 提示
  - [ ] SubTask 7.4: 子目录名留空时显示默认占位符 `1Panel-Client`

- [ ] Task 8: 业务调用点迁移
  - [ ] SubTask 8.1: `lib/features/files/providers/files_provider_system_part.dart` 全部下载入口改用 `PlatformFileSaveService`
  - [ ] SubTask 8.2: `lib/features/files/services/file_transfer_service.dart` 改用 `PlatformFileSaveService`
  - [ ] SubTask 8.3: `lib/core/services/logger/log_export_service.dart` 改用 `PlatformFileSaveService`
  - [ ] SubTask 8.4: 全量 audit：`grep -RIn 'getDownloadsDirectory' lib/ ohos/` 无残留

- [ ] Task 9: 验证与回归
  - [ ] SubTask 9.1: `flutter analyze` 无错误
  - [ ] SubTask 9.2: `dart run test/scripts/test_runner.dart unit` 通过
  - [ ] SubTask 9.3: 新增单元测试 `test/core/platform/services/platform_system_paths_test.dart` 覆盖各平台 stub
  - [ ] SubTask 9.4: 新增单元测试 `test/core/platform/services/platform_file_save_service_test.dart` 覆盖 picker 取消 / 子目录 / 失败回退
  - [ ] SubTask 9.5: OHOS 模拟器手动验证：文件下载不再崩溃，子目录模式写入 `Files/Downloads/1Panel-Client/files/...`，picker 模式仍可调起
  - [ ] SubTask 9.6: 至少一个桌面平台（macOS / Windows / Linux 任一）手动验证 picker 调起 + 写入成功

# Task Dependencies

- [Task 2] depends on [Task 1]
- [Task 3] depends on [Task 2]
- [Task 4] depends on [Task 3]
- [Task 5] depends on [Task 4]
- [Task 6] depends on [Task 5]
- [Task 7] depends on [Task 6]
- [Task 8] depends on [Task 7]
- [Task 9] depends on [Task 8]
