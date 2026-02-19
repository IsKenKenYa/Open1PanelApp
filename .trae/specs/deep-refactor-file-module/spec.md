# 文件管理模块深度重构与测试 Spec

## Why
file_models.dart 有 2404 行代码，严重违反单一职责原则。files_provider.dart 有 829 行接近阈值。需要系统性拆分并添加完整的测试覆盖。

## What Changes
- 拆分 file_models.dart 为多个功能领域模型文件
- 为拆分后的 widgets 组件添加单元测试
- 添加集成测试验证组件协作
- 添加性能测试确保重构后性能不下降

## Impact
- Affected code:
  - `lib/data/models/file_models.dart` - 拆分为多个文件
  - `lib/features/files/files_provider.dart` - 可能需要精简
  - `test/features/files/` - 新增测试文件
  - `docs/development/modules/文件管理/` - 更新文档

## ADDED Requirements

### Requirement: 模型文件拆分
file_models.dart 应按功能领域拆分为独立文件。

#### Scenario: 模型文件拆分
- **WHEN** 完成拆分
- **THEN** 每个模型文件不超过 500 行

### Requirement: 测试覆盖
所有拆分后的组件应有完整的测试覆盖。

#### Scenario: 单元测试
- **WHEN** 运行单元测试
- **THEN** 覆盖率不低于 80%

#### Scenario: 集成测试
- **WHEN** 运行集成测试
- **THEN** 所有组件协作正常

## 文件行数统计

| 文件 | 当前行数 | 目标行数 |
|------|----------|----------|
| file_models.dart | 2404 | < 500 (拆分后) |
| files_page.dart | 988 | ✅ 已达标 |
| files_provider.dart | 829 | < 500 |
| files_service.dart | 675 | ✅ 可接受 |
