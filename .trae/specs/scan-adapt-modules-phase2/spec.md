# 模块扫描与适配 Phase 2 Spec

## Why
30天全链路超级任务清单已推进至 Day 06（API 覆盖收口完成），Day 02 阻断项清理仍有残留。本规格基于 2026-05-07 全量扫描结果，聚焦下一阶段的核心工作：**阻断项清理 → API 巡检固化 → 模块漂移深挖 → extra 分类治理**，确保项目从"覆盖对齐"迈向"质量对齐"。

## 扫描结果摘要（2026-05-07）

### API 覆盖状态
- 全部 27 个模块状态为 `aligned`
- `missing_in_client` = 0（已归零）
- `extra_in_client` = 0（全部进入白名单）
- 白名单端点分布：
  - toolbox(14)、command(9)、database(7)、host(7)、setting(6)、ai(4)、ssl(4)、website_ssl(4)、auth(3)、log(2)、container(1)、file(1)
- command 模块有 2 个 `allowed_missing_in_client`（有意缺失，GET→POST 契约偏差）

### API 更新状态
- 全部模块 `unchanged`，Swagger 与基线无漂移

### Flutter Analyze 状态
- 550 issues（0 error, ~30 warning, ~520 info）
- lib/ 侧关键 warning：
  - `lib/api/v2/file_v2.dart:8` - unused import
  - `lib/features/apps/widgets/app_install_dialog.dart:30` - unused field `_isLoadingParams`
  - `lib/main.dart:263` - unnecessary non-null assertion
- test/ 侧大量 unused import / unused variable / avoid_print

### 测试状态
- unit 测试：待确认（编译中）
- ui 测试：D02.7 已验证可通过
- integration 测试：依赖环境配置

## What Changes
- 修复 lib/ 侧 flutter analyze warning（3 项）
- 清理 test/ 侧高频 warning（unused import / unused variable / avoid_print）
- 固化 API 巡检命令模板与判定口径
- 深挖 command 模块漂移（9 个 allowed_extra + 2 个 allowed_missing）
- 深挖 host 模块漂移（7 个 allowed_extra）
- 分类治理 database/setting extra 端点
- 分类治理 ai/auth extra 端点
- 更新 tasks.md 和 checklist.md 勾选状态

## Impact
- Affected specs: 30天全链路超级任务清单
- Affected code:
  - `lib/api/v2/file_v2.dart`（移除 unused import）
  - `lib/features/apps/widgets/app_install_dialog.dart`（移除 unused field）
  - `lib/main.dart`（移除 unnecessary non-null assertion）
  - `test/` 下多个测试文件（清理 warning）
  - `docs/development/modules/check_module_client_coverage.py`（巡检固化）

## ADDED Requirements

### Requirement: lib/ 侧 analyze warning清零
The system SHALL have zero warnings in `lib/` directory from `flutter analyze`.

#### Scenario: lib/ warning 清零
- **WHEN** 运行 `flutter analyze`
- **THEN** `lib/` 目录下无 warning 级别问题

### Requirement: API 巡检命令模板固化
The system SHALL provide a standardized daily inspection command template that covers coverage check and update check for all modules.

#### Scenario: 每日巡检执行
- **WHEN** 执行每日巡检
- **THEN** 覆盖检查和更新检查结果可输出为 JSON 报告

### Requirement: command 模块漂移决议
The system SHALL produce a boundary resolution document for command module, classifying each allowed_extra endpoint as "保留" or "待迁移" with explicit timeline.

#### Scenario: command 边界分类完成
- **WHEN** 审查 command 模块 9 个 allowed_extra 端点
- **THEN** 每个端点有明确的保留原因或迁移计划

### Requirement: host 模块漂移决议
The system SHALL produce a fallback strategy document for host module, covering dual-route behavior and fallback exit window.

#### Scenario: host 迁移残留分类完成
- **WHEN** 审查 host 模块 7 个 allowed_extra 端点
- **THEN** 每个端点有明确的保留原因或退出窗口

### Requirement: extra 分类治理（database/setting/ai/auth）
The system SHALL classify all allowed_extra endpoints in database, setting, ai, and auth modules as "保留（有兼容原因）" or "清理（无保留价值）" with documented justification.

#### Scenario: extra 分类完成
- **WHEN** 审查四个模块的 allowed_extra 端点
- **THEN** 每个端点有分类结论和兼容原因文档

## MODIFIED Requirements

### Requirement: 阻断项清理范围
由"全量修复"调整为"lib/ warning 清零 + test/ 高频 warning 清理"，避免过度投入测试文件美化。

## REMOVED Requirements
(none)
