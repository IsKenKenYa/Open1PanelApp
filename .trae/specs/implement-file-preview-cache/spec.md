# 文件预览混合缓存方案 Spec

## Why
当前文件预览每次都下载文件到临时目录，没有缓存机制，导致：
1. 重复预览同一文件时需要重新下载，浪费带宽和时间
2. 无法支持离线查看
3. 用户体验不佳

需要实现内存缓存 + 硬盘缓存的双模式方案，优化文件预览体验。

## What Changes
- 创建 `FilePreviewCacheManager` 单例类，实现 LRU 内存缓存
- 集成 `flutter_cache_manager` 实现硬盘缓存
- 修改 `FilePreviewPage` 使用缓存机制
- 提供用户选项控制缓存行为

## Impact
- Affected code:
  - `lib/features/files/file_preview_page.dart`
  - `lib/core/services/cache/` (新建)
  - `pubspec.yaml`

## ADDED Requirements
### Requirement: 内存缓存
系统 SHALL 提供 LRU 内存缓存机制，用于临时文件预览。

#### Scenario: 首次预览文件
- **WHEN** 用户首次预览文件
- **THEN** 系统应下载文件并缓存到内存

#### Scenario: 再次预览同一文件
- **WHEN** 用户再次预览同一文件
- **THEN** 系统应从内存缓存加载，无需重新下载

#### Scenario: 内存缓存达到上限
- **WHEN** 内存缓存达到配置的上限
- **THEN** 系统应使用 LRU 算法淘汰最久未使用的缓存项

### Requirement: 硬盘缓存
系统 SHALL 提供可选的硬盘缓存机制，用于离线查看。

#### Scenario: 用户启用硬盘缓存
- **WHEN** 用户选择"缓存到本地"
- **THEN** 系统应将文件持久化到硬盘缓存

#### Scenario: 离线预览
- **WHEN** 用户在离线状态下预览已缓存的文件
- **THEN** 系统应从硬盘缓存加载文件

### Requirement: 缓存优先级
系统 SHALL 按照内存缓存 > 硬盘缓存 > 网络下载的优先级加载文件。

#### Scenario: 加载文件
- **WHEN** 系统加载预览文件
- **THEN** 应优先检查内存缓存，其次硬盘缓存，最后才从网络下载

## MODIFIED Requirements
### Requirement: FilePreviewPage 缓存集成
系统 SHALL 在 FilePreviewPage 中集成缓存机制。

#### Scenario: 预览文件时使用缓存
- **WHEN** 用户预览文件
- **THEN** 系统应使用 FilePreviewCacheManager 加载文件
