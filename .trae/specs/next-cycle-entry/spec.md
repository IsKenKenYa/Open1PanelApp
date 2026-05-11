# Next Cycle - Deep Feature Alignment & CI Verification

## Why

30 天全链路实施路线已完成基础建设阶段，但仍有以下关键遗留项：

1. **CI 验证未完成**：Windows dotnet build、iOS xcodebuild、macOS xcodebuild 均未在 CI 环境中验证通过，发布候选评审结论为"有条件可发布"，前置条件 C1/C2 未满足。
2. **双轨审计差异未解决**：16 项差异（6 High / 7 Medium / 3 Low）仍待修复，其中 6 项 High 优先级直接影响 iOS 平台核心功能可用性。
3. **原生轨道功能深度不足**：当前原生轨道以"壳 + 基础数据渲染"为主，缺少深度交互功能（如 iOS 的添加/删除服务器、目录导航、安装卸载等）。

## What Changes

- 修复 6 项 High 优先级双轨审计差异，确保 iOS 平台核心模块功能可用
- 完成 CI 构建验证（Windows dotnet build、iOS xcodebuild、macOS xcodebuild），满足发布候选前置条件
- 扩展原生轨道深度交互能力（Servers/Files/Settings 深度对齐，Containers/Apps/Websites 原生扩展）
- 修复 7 项 Medium 优先级双轨审计差异
- 搭建 api_client 集成测试环境

## Impact

- Affected specs:
  - .trae/specs/30天全链路超级任务清单/checklist.md（验收项状态更新）
  - docs/development/dual_track_audit_report.md（审计项状态更新）
  - docs/development/release_candidate_review.md（前置条件状态更新）
- Affected code:
  - ios/Runner/（iOS 原生 View 功能补齐）
  - macos/Runner/（macOS 原生 View 功能补齐）
  - windows/runner/native_host/（Windows 原生功能补齐）
  - lib/features/（Dart 层状态与服务支持）
- Affected CI:
  - .github/workflows/windows-native-build.yml（验证与修复）
  - .github/workflows/ios-build.yml（验证与修复）
  - .github/workflows/macos-build.yml（验证与修复）

## Scope

### In Scope

- CI 构建验证与修复（P0）
- 6 项 High 优先级双轨审计差异修复（P0）
- 7 项 Medium 优先级双轨审计差异修复（P1）
- Servers/Files/Settings 模块深度对齐（P0-P1）
- Containers/Apps/Websites 模块原生扩展（P1）
- api_client 集成测试环境搭建（P1）
- 发布候选前置条件满足验证（P0）

### Out of Scope

- 3 项 Low 优先级双轨审计差异（排入 P2）
- test/debug/ 过期引用清理（排入 P2）
- info 级别 analyze 问题清理（排入 P2）
- 性能与稳定性验收（排入 P2）
- 新模块的原生轨道建设（排入后续周期）
- Web 端适配

## ADDED Requirements

### Requirement: CI 构建验证必须通过

Windows dotnet build、iOS xcodebuild、macOS xcodebuild 必须在 CI 环境中验证通过，满足发布候选前置条件 C1/C2。

### Requirement: High 优先级双轨差异必须修复

6 项 High 优先级双轨审计差异必须在本周期内修复，确保 iOS 平台核心模块功能可用：
- Servers: iOS 添加/删除服务器
- Servers: iOS 错误反馈机制
- Files: iOS 目录导航交互
- Containers: iOS 操作功能
- Apps: iOS 安装卸载
- Websites: iOS CRUD

### Requirement: 原生轨道深度交互扩展

在现有壳 + 基础数据渲染的基础上，扩展原生轨道的深度交互能力，使核心模块的原生体验接近 MDUI3 轨道功能水平。

## Initial Tasks

### Phase 1: CI 验证 (P0)

| 编号 | 任务 | 预计工期 | 依赖 |
|------|------|---------|------|
| T1 | Windows dotnet build CI 验证与修复 | 2 天 | CI 环境 |
| T2 | iOS xcodebuild CI 验证与修复 | 2 天 | CI 环境 |
| T3 | macOS xcodebuild CI 验证与修复 | 1 天 | CI 环境 |

### Phase 2: Servers/Files/Settings 深度对齐 (P0)

| 编号 | 任务 | 预计工期 | 依赖 |
|------|------|---------|------|
| T4 | Servers 模块 iOS 添加/删除服务器 | 2 天 | 无 |
| T5 | Servers 模块 iOS 错误反馈机制 | 1 天 | 无 |
| T6 | Files 模块 iOS 目录导航交互 | 2 天 | 无 |
| T7 | Servers 模块 macOS 切换确认对话框 | 1 天 | 无 |
| T8 | Servers 模块 Windows 添加/删除服务器 | 2 天 | T1 |

### Phase 3: Containers/Apps/Websites 原生扩展 (P0-P1)

| 编号 | 任务 | 预计工期 | 依赖 |
|------|------|---------|------|
| T9 | Containers 模块 iOS 操作功能 | 2 天 | 无 |
| T10 | Apps 模块 iOS 安装卸载 | 2 天 | 无 |
| T11 | Websites 模块 iOS CRUD | 2 天 | 无 |
| T12 | Monitoring 模块 iOS 实时数据展示 | 2 天 | 无 |
| T13 | Files 模块 macOS 上传下载 | 2 天 | 无 |
| T14 | Containers 模块 macOS 日志查看 | 1 天 | 无 |
| T15 | Apps 模块 macOS 安装进度 | 1 天 | 无 |
| T16 | Websites 模块 macOS 配置编辑 | 2 天 | 无 |

### Phase 4: 集成测试与收口 (P1)

| 编号 | 任务 | 预计工期 | 依赖 |
|------|------|---------|------|
| T17 | api_client 集成测试环境搭建 | 3 天 | 服务端环境 |
| T18 | 发布候选前置条件验证 | 1 天 | T1-T3 |
| T19 | Checklist 验收项状态更新 | 1 天 | T1-T16 |

## Success Criteria

1. Windows dotnet build 在 CI 上通过
2. iOS xcodebuild 在 CI 上通过
3. macOS xcodebuild 在 CI 上通过
4. 6 项 High 优先级双轨审计差异全部修复
5. 发布候选评审前置条件 C1/C2/C3 满足
6. 双轨审计差异总数降至 10 项以下（7M+3L）
