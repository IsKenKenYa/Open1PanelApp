# 平台矩阵状态

本文件记录各平台当前的功能覆盖与构建状态。

---

## 功能矩阵

| 平台 | UI 模式 | 导航 | 数据渲染 | 交互 | 构建状态 |
|------|---------|------|----------|------|----------|
| Android | MDUI3 | 已完成 | 已完成 | 已完成 | 已完成 |
| iOS | Native/MDUI3 | 已完成 | 已完成（只读） | 部分完成 | 待 xcodebuild 验证 |
| macOS | Native/MDUI3 | 已完成 | 已完成 | 部分完成 | 待 xcodebuild 验证 |
| Windows | Native/MDUI3 | 已完成 | 已完成（首批） | 已完成（首批） | 待 dotnet build 验证 |
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

## 构建门禁命令

| 平台 | 命令 |
|------|------|
| Flutter 通用 | `flutter analyze && flutter test` |
| Windows 原生 | `dotnet build windows/runner/native_host/OnePanelNativeHost/OnePanelNativeHost.csproj -c Debug` |
| iOS 原生 | `xcodebuild -workspace ios/Runner.xcworkspace -scheme Runner -configuration Debug -sdk iphonesimulator build` |
| macOS 原生 | `xcodebuild -workspace macos/Runner.xcworkspace -scheme Runner -configuration Debug build` |

> 最后更新：2026-05-08
