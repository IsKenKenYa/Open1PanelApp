# 修复文件保存API与重构设置页面 Spec

## Why
1. 文件编辑保存失败，API 路径错误：当前使用 `/files/content/update`，正确路径应为 `/files/save`
2. 设置页面缓存设置直接展示在主页面，缺乏分类，后续设置项增多时会导致页面混乱

## What Changes
- 修复 `file_v2.dart` 中的 `updateFileContent` 方法，使用正确的 API 路径 `/files/save`
- 创建缓存设置二级页面 `CacheSettingsPage`
- 重构设置页面，将缓存设置移至二级页面

## Impact
- Affected code:
  - `lib/api/v2/file_v2.dart`
  - `lib/pages/settings/settings_page.dart`
  - `lib/pages/settings/cache_settings_page.dart` (新建)

## ADDED Requirements
### Requirement: 缓存设置二级页面
系统 SHALL 提供独立的缓存设置二级页面。

#### Scenario: 进入缓存设置
- **WHEN** 用户在设置页面点击"缓存设置"
- **THEN** 系统应导航到缓存设置二级页面

### Requirement: 设置页面分类
系统 SHALL 对设置项进行分类组织。

#### Scenario: 查看设置页面
- **WHEN** 用户打开设置页面
- **THEN** 系统应显示分类的设置项列表，而非所有设置项

## MODIFIED Requirements
### Requirement: 文件保存 API
系统 SHALL 使用正确的 API 路径保存文件。

#### Scenario: 保存文件
- **WHEN** 用户编辑文件并保存
- **THEN** 系统应调用 `/files/save` API
