# Day 11+ Week2 回归门禁与原生轨道建设 Spec

## Why
30天全链路超级任务清单 Day 01-10 已全部完成（API 覆盖收口 + extra 分类治理 + 巡检固化）。本规格覆盖 Day 11-20，核心目标：**Week2 回归门禁落地 → Windows 原生轨道从占位升级到可演示 → Apple 原生轨道结构拆分与语义对齐 → 双轨模块对账**。

## 当前项目状态摘要（2026-05-07）

### 代码质量
- flutter analyze: 457 issues（0 error, 1 warning in test/, ~456 info），lib/ 侧 warning 已清零
- API 覆盖: 27 模块全部 aligned，missing_in_client = 0
- API 更新: 全部 unchanged

### Windows 原生轨道现状
- WinUI3 壳已创建（OnePanelNativeHost.csproj，net8.0 + WindowsAppSDK 1.6）
- NavigationView 已有 8 个菜单项（Servers/Files/Containers/Apps/Websites/AI/Security/Settings）
- **内容区仍为 TextBlock 占位**（`$"WinUI3 Native Module: {item.Content}"`）
- 无桥接层、无真实数据、无状态管理

### iOS 原生轨道现状
- AppDelegate.swift 为单文件（~610 行），包含所有 View 定义
- TabView 结构已搭建（7 个 Tab + Flutter 回退 + Settings）
- Channel 通信已建立（getServers/getFiles/getContainers/getApps/getWebsites/getMonitoring）
- render mode 切换已可用（native/md3）
- **未拆分**：所有 View/ViewModel 仍在 AppDelegate.swift 中

### macOS 原生轨道现状
- 已完成结构拆分：Core/Modules/Components/Shell 目录
- ChannelManager/ThemeManager/TranslationsManager 已独立
- 14 个模块 View+ViewModel 已独立文件
- MainShellView 侧边栏导航已实现
- render mode 切换已可用
- **语义对齐待做**：iOS 与 macOS 的导航/错误/空态/国际化尚未对齐

### CI 现状
- 仅有 android-tag-release.yml（tag 驱动发布）
- 无 flutter analyze/unit/ui/integration 工作流
- 无 Windows/iOS/macOS 构建工作流

## What Changes
- Day 11: 执行 Week2 回归门禁（analyze + unit + ui + integration）
- Day 12: Windows 原生轨道架构设计冻结
- Day 13: Windows Shell 页面分发升级（TextBlock → 真实页面容器）
- Day 14: Windows 与 Dart 桥接首批打通
- Day 15: Windows 首批模块真实数据渲染
- Day 16: Windows 交互能力补齐
- Day 17: Apple 轨道结构拆分设计
- Day 18: iOS 拆分实施
- Day 19: macOS 轨道语义对齐
- Day 20: 双轨（Native vs MDUI3）模块对账

## Impact
- Affected specs: 30天全链路超级任务清单（Day 11-20）
- Affected code:
  - `windows/runner/native_host/OnePanelNativeHost/`（架构升级）
  - `ios/Runner/AppDelegate.swift`（拆分重构）
  - `macos/Runner/UI/`（语义对齐）
  - `.github/workflows/`（新增 CI 工作流）
  - `test/`（回归测试修复）

## ADDED Requirements

### Requirement: Week2 回归门禁执行
The system SHALL pass flutter analyze, unit tests, and ui tests as a gate for Week2 progression.

#### Scenario: 门禁通过
- **WHEN** 执行 flutter analyze + unit + ui 测试
- **THEN** 无阻断级失败（error = 0，测试通过率 >= 95%）

### Requirement: Windows 原生轨道架构冻结
The system SHALL have a frozen architecture document for Windows native track covering module scope, navigation structure, C#-Dart bridge boundary, and state sync strategy.

#### Scenario: 架构文档冻结
- **WHEN** 完成 Windows 原生轨道架构设计
- **THEN** 文档覆盖模块范围、导航结构、桥接边界、状态同步、异常降级、验收标准

### Requirement: Windows Shell 页面分发升级
The system SHALL replace TextBlock placeholders with real page container objects in the WinUI3 NavigationView content frame.

#### Scenario: 页面分发可用
- **WHEN** 用户点击 NavigationView 菜单项
- **THEN** 内容区显示对应模块的页面容器（含空态/错误态/加载态组件）

### Requirement: Windows Dart 桥接首批打通
The system SHALL establish MethodChannel bridge between WinUI3 C# layer and Dart business logic layer for Servers/Settings/Files modules.

#### Scenario: 桥接连通
- **WHEN** WinUI3 页面请求数据
- **THEN** 通过桥接调用 Dart Provider/Service 获取真实数据并渲染

### Requirement: iOS 原生代码拆分
The system SHALL split the monolithic AppDelegate.swift into Core/Modules/ViewModels directory structure matching macOS pattern.

#### Scenario: 拆分完成
- **WHEN** iOS 项目编译
- **THEN** ChannelManager/ViewModels/模块 View 均为独立文件，render mode 切换仍可用

### Requirement: macOS 与 iOS 语义对齐
The system SHALL align navigation naming, error feedback, loading/empty states, and i18n key usage between macOS and iOS native tracks.

#### Scenario: 语义一致
- **WHEN** 对比 iOS 与 macOS 同一模块的交互行为
- **THEN** 导航层级、错误提示、加载空态、国际化 key 语义一致

### Requirement: 双轨模块对账
The system SHALL verify that Native and MDUI3 tracks for each module have consistent entry semantics, main flow, and error feedback.

#### Scenario: 对账完成
- **WHEN** 切换到 MDUI3 模式
- **THEN** 各模块的入口语义、主流程、错误反馈与 Native 模式一致

## MODIFIED Requirements
(none)

## REMOVED Requirements
(none)
