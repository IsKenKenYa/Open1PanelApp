# 缓存设置与文件下载权限优化 Spec

## Why
1. 用户无法自定义缓存策略（内存缓存、硬盘缓存、混合模式）
2. 文件下载功能需要完善权限处理，引导用户申请权限
3. 缓存文件需要确保正确性，避免打开错误的文件
4. 内存缓存需要完善清理机制，避免内存泄漏

## What Changes
- 在设置页面添加缓存策略选项（仅内存、仅硬盘、混合模式）
- 添加缓存大小限制设置
- 添加主动清除缓存功能
- 完善内存缓存过期机制（2分钟过期）
- 添加缓存文件哈希验证机制
- 完善文件下载权限处理流程

## Impact
- Affected code:
  - `lib/pages/settings/settings_page.dart`
  - `lib/core/services/app_settings_controller.dart`
  - `lib/core/services/app_preferences_service.dart`
  - `lib/core/services/cache/memory_cache_manager.dart`
  - `lib/core/services/cache/file_preview_cache_manager.dart`
  - `lib/features/files/files_service.dart`
  - `lib/l10n/app_zh.arb`
  - `lib/l10n/app_en.arb`

## ADDED Requirements
### Requirement: 缓存策略设置
系统 SHALL 允许用户选择缓存策略。

#### Scenario: 选择仅内存缓存
- **WHEN** 用户选择"仅内存缓存"
- **THEN** 文件只缓存到内存，不写入硬盘

#### Scenario: 选择仅硬盘缓存
- **WHEN** 用户选择"仅硬盘缓存"
- **THEN** 文件只缓存到硬盘，支持离线查看

#### Scenario: 选择混合模式
- **WHEN** 用户选择"混合模式"
- **THEN** 文件同时缓存到内存和硬盘

### Requirement: 缓存清除机制
系统 SHALL 提供缓存清除功能。

#### Scenario: 用户主动清除缓存
- **WHEN** 用户点击"清除缓存"按钮
- **THEN** 系统应清除所有缓存（内存和硬盘）

#### Scenario: 自动清除过期缓存
- **WHEN** 内存缓存超过2分钟未被访问
- **THEN** 系统应自动清除该缓存项

#### Scenario: 达到上限自动清除
- **WHEN** 缓存达到设定上限
- **THEN** 系统应使用 LRU 算法清除最早的缓存项

### Requirement: 内存缓存过期机制
系统 SHALL 实现内存缓存过期机制。

#### Scenario: 内存缓存2分钟过期
- **WHEN** 内存缓存项超过2分钟未被访问
- **THEN** 系统应自动清除该缓存项

#### Scenario: 应用关闭时清理内存缓存
- **WHEN** 应用关闭或进入后台
- **THEN** 系统应清理所有内存缓存

### Requirement: 缓存文件完整性验证
系统 SHALL 确保缓存文件的正确性。

#### Scenario: 验证缓存索引
- **WHEN** 从缓存加载文件
- **THEN** 系统应验证缓存索引正确映射到文件

#### Scenario: 验证文件哈希
- **WHEN** 从硬盘缓存加载文件
- **THEN** 系统应验证文件哈希，确保文件未被篡改

### Requirement: 文件下载权限引导
系统 SHALL 在下载文件时正确处理权限并引导用户。

#### Scenario: 首次下载文件
- **WHEN** 用户首次下载文件
- **THEN** 系统应请求存储权限（如需要）

#### Scenario: 权限被拒绝
- **WHEN** 用户拒绝存储权限
- **THEN** 系统应显示引导对话框，说明如何手动开启权限
