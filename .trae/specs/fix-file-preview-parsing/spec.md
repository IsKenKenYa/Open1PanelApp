# 修复文件预览解析和认证问题 Spec

## Why
文件预览存在两个问题：
1. 文本文件内容被错误解析：`getFileContent` API 返回的是完整的 JSON 响应 `{code: 200, message: "", data: {...}}`，但代码直接使用 `response.data?.toString()` 来获取内容，导致显示的是整个 JSON 对象而不是文件内容
2. 图片预览 401 错误：URL 中 `apiKey` 参数格式错误，缺少 `=` 号

## What Changes
- 修复 `file_v2.dart` 中的 `getFileContent` 方法，正确解析 JSON 响应并提取 `data.content` 字段
- 修复 `file_preview_page.dart` 中的 `_getFileUrl` 方法，确保 `apiKey` 参数格式正确

## Impact
- Affected code:
  - `lib/api/v2/file_v2.dart`
  - `lib/features/files/file_preview_page.dart`

## ADDED Requirements
### Requirement: 文件内容正确解析
系统 SHALL 正确解析 API 返回的 JSON 响应并提取文件内容。

#### Scenario: 获取文本文件内容
- **WHEN** 用户预览文本文件
- **THEN** 系统应正确解析 JSON 响应，显示 `data.content` 字段的内容

### Requirement: 文件下载 URL 认证正确
系统 SHALL 生成带有正确认证参数的文件下载 URL。

#### Scenario: 生成图片下载 URL
- **WHEN** 用户预览图片文件
- **THEN** 系统应生成正确的 URL，包含 `apiKey=xxx` 格式的认证参数
