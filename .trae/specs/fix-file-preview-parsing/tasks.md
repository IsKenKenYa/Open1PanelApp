# Tasks

- [x] Task 1: 修复 getFileContent 方法的 JSON 解析
  - [x] SubTask 1.1: 修改 `file_v2.dart` 中的 `getFileContent` 方法
  - [x] SubTask 1.2: 正确解析 JSON 响应并提取 `data.content` 字段

- [x] Task 2: 修复 _getFileUrl 方法的 apiKey 参数格式
  - [x] SubTask 2.1: 检查并修复 `file_preview_page.dart` 中的 `_getFileUrl` 方法
  - [x] SubTask 2.2: 确保 apiKey 参数格式为 `apiKey=xxx`

- [x] Task 3: 验证修复
  - [x] SubTask 3.1: 运行 flutter analyze
  - [x] SubTask 3.2: 测试文本文件预览
  - [x] SubTask 3.3: 测试图片预览

# Task Dependencies
- Task 3 依赖 Task 1 和 Task 2
