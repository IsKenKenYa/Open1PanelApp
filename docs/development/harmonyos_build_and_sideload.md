# HarmonyOS 构建与侧载指南

> 最后验证：2026-05-24

本文用于 HarmonyOS / OHOS HAP 构建、侧载分发与常见问题排障。HarmonyOS 在本项目中按一等平台处理：共享业务逻辑仍在 Dart 层，平台缺口优先通过 ArkTS Platform Bridge 补齐，不为 HarmonyOS 复制业务实现。

## 已验证构建基线

本机已验证命令：

```bash
hflutter build hap --release
```

等效完整路径命令：

```bash
/Volumes/FanXiangMac/DevTools/Flutter_HMOS/flutter_flutter/bin/flutter build hap --release
```

已验证 Flutter-OH：

```text
Flutter 3.35.8-ohos-0.0.3
Framework revision 8957a7cf95
Dart 3.9.2
```

输出产物：

```text
build/ohos/hap/entry-default-signed.hap
```

如果最新 Flutter-OH 出现第三方包或 SDK 兼容问题，优先回退到已验证 revision，再对比差异。

## macOS 与官方 Flutter 并存

推荐保留官方 Flutter 与 Flutter-OH 两套 SDK：

```bash
flutter --version
/Volumes/FanXiangMac/DevTools/Flutter_HMOS/flutter_flutter/bin/flutter --version
```

日常 Android/iOS/macOS/Windows/Linux 开发继续使用官方 `flutter`。HarmonyOS 构建必须使用 Flutter-OH，避免把官方 Flutter 的 `.dart_tool`、构建缓存和 OHOS 构建混用。

本机可以通过 shell 函数包装：

```bash
hflutter build hap --release
```

但文档和 CI 脚本应始终支持完整路径命令，避免依赖个人 shell 配置。

## Windows 构建方式

Windows 不要求配置 `hflutter` 函数，直接使用 Flutter-OH 的 `flutter.bat`：

```powershell
D:\Huawei\Flutter\flutter_flutter\bin\flutter.bat --version
D:\Huawei\Flutter\flutter_flutter\bin\flutter.bat pub get
D:\Huawei\Flutter\flutter_flutter\bin\flutter.bat build hap --release
```

同时检查 `ohos\local.properties`：

```properties
flutter.sdk=D:\\Huawei\\Flutter\\flutter_flutter
hwsdk.dir=D:\\Huawei\\DevEco Studio\\sdk
nodejs.dir=D:\\Huawei\\DevEco Studio\\tools\\node
```

`pubspec.lock` 必须随仓库一起使用。不要在排障时随意删除 lock 或升级依赖，否则可能把 `chewie`、`xterm`、`syncfusion_flutter_pdfviewer` 等包带到未验证版本，引发新的 `TargetPlatform.ohos` 编译错误。

## 常用清理与重建

```bash
hflutter clean
rm -rf .dart_tool/flutter_build build/ohos ohos/.hvigor ohos/entry/build
hflutter pub get
hflutter build hap --release
```

Windows 对应 PowerShell：

```powershell
D:\Huawei\Flutter\flutter_flutter\bin\flutter.bat clean
Remove-Item -Recurse -Force .dart_tool\flutter_build, build\ohos, ohos\.hvigor, ohos\entry\build -ErrorAction SilentlyContinue
D:\Huawei\Flutter\flutter_flutter\bin\flutter.bat pub get
D:\Huawei\Flutter\flutter_flutter\bin\flutter.bat build hap --release
```

## TargetPlatform.ohos 编译错误

典型错误：

```text
The type 'TargetPlatform' is not exhaustively matched by the switch cases
since it doesn't match 'TargetPlatform.ohos'.
```

处理顺序：

1. 确认正在使用仓库内 `pubspec.lock`，未隐式升级依赖。
2. 确认 Flutter-OH revision 与已验证基线一致，或记录最新 revision。
3. 如果错误来自项目代码，在 `switch (TargetPlatform)` 中增加 `default` 或显式 OHOS 兼容分支。
4. 如果错误来自第三方包，优先 pin 回 lock 中已验证版本；必要时使用项目自有 facade 或 ArkTS bridge 绕开该插件能力。

当前项目已经为 OHOS 增加 `PlatformCapabilities` 与 `onepanel/ohos_platform` 通道。业务层不得直接散落裸 `MethodChannel`。

## 项目 OHOS Platform Bridge

ArkTS 插件目录：

```text
ohos/entry/src/main/ets/plugins/
```

已注册兼容插件：

- `OhosSharedPreferencesPlugin`
- `OhosPathProviderPlugin`
- `OhosSecureStoragePlugin`
- `OhosPackageInfoPlugin`
- `OhosLocalAuthPlugin`
- `OhosPlatformPlugin`

Flutter 侧 facade：

- `PlatformFileService`
- `PlatformDiagnosticsService`
- `PlatformDownloadService`
- `PlatformMediaService`
- `OhosPlatformChannel`

当前 `OhosPlatformPlugin` 覆盖运行信息、文件保存、路径打开等基础能力。后续文件选择、系统分享、下载任务、媒体预览、终端 I/O、生物认证真机能力继续在该 bridge 下扩展。

## 侧载说明

开发者签名 HAP 位于：

```text
build/ohos/hap/entry-default-signed.hap
```

分发给真机用户时必须同时标注：

- Git commit
- Flutter-OH 版本与 framework revision
- DevEco SDK API 版本
- HAP 文件名和大小
- 已知限制与验证清单

真机验收最小清单：

- 添加服务器成功
- 清后台后重启，当前服务器与 API key 可恢复
- 请求头仍生成 `1Panel-Token` / `1Panel-Timestamp`
- 文件页可加载
- 应用日志可导出并返回有效路径
- 反馈模板包含 HarmonyOS 设备与构建字段

## 401 排障

如果清后台重启后出现 401：

1. 先导出应用日志，确认是否出现 secure storage 或 shared preferences 读取失败。
2. 检查当前服务器 ID 是否恢复，`api_configs` 中不应持久化明文 `apiKey`。
3. 检查 secure store / OHOS fallback 是否能读取对应 key。
4. 检查请求是否带有 `1Panel-Token` 和 `1Panel-Timestamp`。
5. 如果返回 HTML 401，优先排查反代路径、API 网关或登录页重定向。
6. 如果时间偏差超过 5 分钟，校准设备和服务器时间。
7. 检查 1Panel API key 是否重置、IP 白名单是否允许手机网络出口。

反馈时请提供：HAP commit、Flutter-OH 版本、设备型号、系统版本、复现步骤、是否清后台重启、脱敏日志与截图。
