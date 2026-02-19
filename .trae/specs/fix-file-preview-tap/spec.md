# 修复文件点击预览链路 Spec

## Why
当前点击文件时不会打开预览页面，因为 `files_page.dart` 中的 `onTap` 回调只处理了目录导航，缺少文件预览的逻辑。同时需要确保 `.sh` 等脚本文件被正确识别为文本文件。

## What Changes
- 修复 `files_page.dart` 中的 `onTap` 回调，添加文件预览逻辑
- 确保 `file_preview_page.dart` 正确识别 `.sh` 等脚本文件为文本文件

## Impact
- Affected code:
  - `lib/features/files/files_page.dart`
  - `lib/features/files/file_preview_page.dart`

## ADDED Requirements
### Requirement: 文件点击预览
系统 SHALL 在用户点击文件时打开预览页面。

#### Scenario: 点击文件
- **WHEN** 用户点击文件（非目录）
- **THEN** 系统应打开文件预览页面

#### Scenario: 点击目录
- **WHEN** 用户点击目录
- **THEN** 系统应导航到该目录

### Requirement: 脚本文件识别
系统 SHALL 正确识别脚本文件为文本文件。

#### Scenario: 识别 .sh 文件
- **WHEN** 用户打开 .sh 文件
- **THEN** 系统应使用文本预览模式

#### Scenario: 识别其他脚本文件
- **WHEN** 用户打开 .bat, .ps1, .vbs 等脚本文件
- **THEN** 系统应使用文本预览模式
