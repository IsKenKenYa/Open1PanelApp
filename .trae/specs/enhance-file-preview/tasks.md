# Tasks

- [x] Task 1: 添加预览相关依赖
  - [x] SubTask 1.1: 添加 `video_player` 和 `chewie` 用于视频预览
  - [x] SubTask 1.2: 添加 `flutter_markdown` 用于 Markdown 渲染
  - [x] SubTask 1.3: 添加 `syncfusion_flutter_pdfviewer` 用于 PDF 预览
  - [x] SubTask 1.4: 添加 `audioplayers` 用于音频预览
  - [x] SubTask 1.5: 运行 `flutter pub get`

- [x] Task 2: 重构 FilePreviewPage 文件类型检测
  - [x] SubTask 2.1: 添加视频文件扩展名识别
  - [x] SubTask 2.2: 添加音频文件扩展名识别
  - [x] SubTask 2.3: 添加 PDF 文件扩展名识别
  - [x] SubTask 2.4: 更新 FileType 枚举

- [x] Task 3: 实现视频预览组件
  - [x] SubTask 3.1: 创建 `_buildVideoPreview` 方法
  - [x] SubTask 3.2: 实现视频加载和播放控制
  - [x] SubTask 3.3: 添加全屏切换功能

- [x] Task 4: 实现 Markdown 预览组件
  - [x] SubTask 4.1: 创建 `_buildMarkdownPreview` 方法
  - [x] SubTask 4.2: 配置 Markdown 样式和主题

- [x] Task 5: 实现 PDF 预览组件
  - [x] SubTask 5.1: 创建 `_buildPdfPreview` 方法
  - [x] SubTask 5.2: 实现从网络加载 PDF

- [x] Task 6: 实现音频预览组件
  - [x] SubTask 6.1: 创建 `_buildAudioPreview` 方法
  - [x] SubTask 6.2: 实现音频播放控制

- [x] Task 7: 更新 _buildBody 方法
  - [x] SubTask 7.1: 添加新文件类型的 case 分支
  - [x] SubTask 7.2: 处理加载状态和错误

- [x] Task 8: 验证功能
  - [x] SubTask 8.1: 运行 `flutter analyze`
  - [x] SubTask 8.2: 测试各类型文件预览

# Task Dependencies
- Task 2 依赖 Task 1
- Task 3, 4, 5, 6 依赖 Task 2
- Task 7 依赖 Task 3, 4, 5, 6
- Task 8 依赖 Task 7
