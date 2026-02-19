# 增强文件预览功能 Spec

## Why
当前 `FilePreviewPage` 仅支持图片和文本/代码预览，缺少视频、Markdown、PDF 和音频等常见文件类型的预览功能。需要扩展预览能力以提供更好的用户体验。

## What Changes
- 添加视频预览支持（使用 `video_player` + `chewie`）
- 添加 Markdown 渲染支持（使用 `flutter_markdown`）
- 添加 PDF 预览支持（使用 `pdf_render` 或 `syncfusion_flutter_pdfviewer`）
- 添加音频预览支持（使用 `audioplayers`）
- 重构 `FilePreviewPage` 以支持更多文件类型

## Impact
- Affected code:
  - `lib/features/files/file_preview_page.dart`
  - `pubspec.yaml`

## ADDED Requirements
### Requirement: 视频预览
系统 SHALL 支持常见视频格式的预览播放。

#### Scenario: 预览视频文件
- **WHEN** 用户点击视频文件（mp4, mov, avi, mkv, webm 等）
- **THEN** 系统应显示视频播放器，支持播放/暂停、进度控制、全屏等功能

### Requirement: Markdown 渲染
系统 SHALL 支持 Markdown 文件的渲染预览。

#### Scenario: 预览 Markdown 文件
- **WHEN** 用户点击 .md 文件
- **THEN** 系统应渲染 Markdown 内容，支持标题、列表、代码块、链接等语法

### Requirement: PDF 预览
系统 SHALL 支持 PDF 文件的预览。

#### Scenario: 预览 PDF 文件
- **WHEN** 用户点击 .pdf 文件
- **THEN** 系统应显示 PDF 内容，支持翻页、缩放等功能

### Requirement: 音频预览
系统 SHALL 支持常见音频格式的预览播放。

#### Scenario: 预览音频文件
- **WHEN** 用户点击音频文件（mp3, wav, ogg, m4a 等）
- **THEN** 系统应显示音频播放器，支持播放/暂停、进度控制

## MODIFIED Requirements
### Requirement: 文件类型检测
系统 SHALL 正确识别更多文件类型并选择合适的预览方式。

#### Scenario: 识别文件类型
- **WHEN** 用户打开文件
- **THEN** 系统应根据文件扩展名选择正确的预览组件
