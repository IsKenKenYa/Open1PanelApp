# 平台矩阵状态

本文件记录各平台当前的功能覆盖与构建状态。

---

## 功能矩阵

| 平台 | UI 模式 | 导航 | 数据渲染 | 交互 | 构建状态 |
|------|---------|------|----------|------|----------|
| Android | MDUI3 | 已完成 | 已完成 | 已完成 | 已完成 |
| iOS | Native/MDUI3 | 已完成 | 已完成（只读） | 部分完成 | 待 xcodebuild 验证 |
| macOS | Native/MDUI3 | 已完成 | 已完成 | 部分完成 | 待 xcodebuild 验证 |
| Windows | Native/MDUI3 双模式 | 已完成（单例页面直赋，导航 10 项） | 已完成（10 页） | 已完成（CRUD） | 已完成（dotnet build 0 错误 + xUnit 26/26） |
| Linux | MDUI3 | 已完成 | 已完成 | 已完成 | 已完成 |
| HarmonyOS | 占位 | 占位 | 占位 | 占位 | 未启动 |

## 状态说明

- **已完成**：功能已实现并通过测试门禁。
- **部分完成**：核心功能已实现，部分高级交互待补充。
- **已完成（只读）**：数据展示已实现，写入操作待后续迭代。
- **已完成（首批）**：首批模块已实现，后续模块持续接入中。
- **待验证**：代码已就绪，需在对应平台环境执行构建门禁。
- **占位**：路由/通道/Provider 占位已建立，原生实施按里程碑推进。
- **未启动**：尚未进入开发阶段。

## Windows 原生轨道补充说明（2026-09-07）

- 宿主：`OnePanelNativeHost`（WindowsAppSDK 2.4.0 stable、WindowsAppSDKSelfContained、win-x64、unpackaged），进程内经胶水 DLL `flutter_headless_host` 运行无 view headless Flutter 引擎。
- 通道：`com.onepanel.client/method`（与 iOS/macOS 同源），方法集对齐 Dart `NativeChannelManager`；`StandardMethodCodec` golden 向量双向锁定。
- 导航：单例页面 + `Frame.Content` 直赋（本环境 `Frame.Navigate` 存在 native AV 缺陷，详见 `windows_native_architecture.md`「环境约束与规避」）。
- 导航覆盖 10 项：Dashboard / Monitoring 已接入（Phase 3 第一组）；时间序列图表属后续批次。
- 底衬：官方 SystemBackdrop API（Mica Base / MicaAlt / DesktopAcrylic / None）+ LocalSettings 持久化。
- 端到端冒烟：启动 `OnePanelNativeHost.exe` → ServersPage 渲染真实服务器列表。

## 构建门禁命令

| 平台 | 命令 |
|------|------|
| Flutter 通用 | `flutter analyze && flutter test` |
| Windows 原生 | `dotnet build windows/runner/native_host/OnePanelNativeHost/OnePanelNativeHost.csproj -c Debug` |
| Windows 原生测试 | `dotnet test windows/runner/native_host/OnePanelNativeHost.Tests/OnePanelNativeHost.Tests.csproj -c Debug` |
| iOS 原生 | `xcodebuild -workspace ios/Runner.xcworkspace -scheme Runner -configuration Debug -sdk iphonesimulator build` |
| macOS 原生 | `xcodebuild -workspace macos/Runner.xcworkspace -scheme Runner -configuration Debug build` |

> 最后更新：2026-09-07
