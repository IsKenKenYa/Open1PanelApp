# Day 21-30 Week3 质量门禁冲刺与发布准备 Spec

## Why
30天全链路超级任务清单 Day 01-20 已全部完成（API 覆盖收口 + 原生轨道建设 + 双轨对账）。本规格覆盖 Day 21-30，核心目标：**质量门禁冲刺 → CI 硬门禁落地 → 文档一致性守卫 → 全量回归 → 发布候选审查 → 收官复盘**。

## 当前项目状态摘要（2026-05-08）

### 代码质量
- flutter analyze: 457 issues（0 error, 1 warning in test/, ~456 info）
- lib/ 侧 warning 已清零
- test/ 侧残留 1 warning: `test/features/server/server_form_page_test.dart:19` unnecessary_non_null_assertion

### 测试状态
- features 测试: 789/789 全通过
- ui 测试: 8/8 全通过
- api_client 测试: 212/452（需真实服务器环境）

### CI 现状
- 仅有 `.github/workflows/android-tag-release.yml`
- 无 flutter analyze/unit/ui/integration 工作流
- 无 Windows/iOS/macOS 构建工作流

### 原生轨道状态
- Windows: Shell + 桥接 + 数据渲染 + 交互已完成（需 dotnet build 验证）
- iOS: 已拆分为 21 文件模块化结构（需 xcodebuild 验证）
- macOS: 语义对齐已完成（12 个模块 View 统一组件 + i18n）

### 双轨对账状态
- Servers/Files/Settings: ⚠️ 部分对齐
- Containers/Apps/Websites/Monitoring: ❌ 未对齐
- 16 项修复清单（6 High / 7 Medium / 3 Low）

### 巡检与文档
- daily_inspection.sh 已创建
- inspection_faq.md 已创建
- reports/ 目录尚未生成首次报告

## What Changes
- Day 21: Week3 质量门禁冲刺（测试矩阵强化 + 问题分级修复）
- Day 22: CI 硬门禁第一批（analyze + unit + ui + 原生构建工作流）
- Day 23: CI 硬门禁第二批（缓存/重试/矩阵/告警增强）
- Day 24: 文档一致性门禁（五文档同步守卫）
- Day 25: 模块文档回写第一批（API 模块索引更新）
- Day 26: 模块文档回写第二批（原生 UI 与治理文档更新）
- Day 27: 发布前全量回归第一轮
- Day 28: 发布前全量回归第二轮（复验与稳定性确认）
- Day 29: 发布候选审查（审批资料准备）
- Day 30: 收官与下一周期入口

## Impact
- Affected specs: 30天全链路超级任务清单（Day 21-30）
- Affected code:
  - `.github/workflows/`（新增 6+ CI 工作流）
  - `test/`（修复残留 warning + 补充回归用例）
  - `docs/development/modules/`（模块索引更新 + 报告归档）
  - `docs/development/`（治理文档状态更新）

## ADDED Requirements

### Requirement: Week3 质量门禁冲刺
The system SHALL pass a comprehensive test matrix covering API/Provider/UI/Widget critical paths with >= 95% pass rate, and all native platform builds shall succeed.

#### Scenario: 质量门禁通过
- **WHEN** 执行全量测试矩阵
- **THEN** features 测试通过率 >= 95%，原生构建全部成功

### Requirement: CI 硬门禁落地
The system SHALL have CI workflows for flutter analyze, unit tests, ui tests, and native builds that block PRs on failure.

#### Scenario: CI 门禁阻断
- **WHEN** PR 提交触发 CI
- **THEN** analyze/unit/ui/构建失败时 PR 不可合并

### Requirement: 文档一致性守卫
The system SHALL enforce that AGENTS.md, CLAUDE.md, .kiro/steering/*.md, and cross-platform governance docs stay in sync when any one is modified.

#### Scenario: 文档同步检查
- **WHEN** 修改任一规范文档
- **THEN** CI 检查其余文档是否同步更新

### Requirement: 发布候选审查
The system SHALL produce a release candidate review package with code change summary, test results, native track capabilities, API coverage changes, and risk mitigation plan.

#### Scenario: 发布候选可判定
- **WHEN** 审查发布候选资料
- **THEN** 可明确判定是否可发布

## MODIFIED Requirements
(none)

## REMOVED Requirements
(none)
