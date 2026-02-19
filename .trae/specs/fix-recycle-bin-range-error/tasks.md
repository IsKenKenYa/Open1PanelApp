# Tasks

- [x] Task 1: 在 FileInfo 模型中添加 from 字段
  - [x] SubTask 1.1: 在 `file_info.dart` 中添加 `from` 字段
  - [x] SubTask 1.2: 在 `fromJson` 方法中解析 `from` 字段
  - [x] SubTask 1.3: 在 `toJson` 方法中序列化 `from` 字段

- [x] Task 2: 更新 searchRecycleBin 解析逻辑
  - [x] SubTask 2.1: 确保 `from` 字段正确映射到 `FileInfo`

- [x] Task 3: 修复 recycle_bin_page.dart 中的 from 字段使用
  - [x] SubTask 3.1: 使用 `f.from` 替代字符串计算
  - [x] SubTask 3.2: 添加空值处理逻辑

- [x] Task 4: 验证修复结果
  - [x] SubTask 4.1: 运行 flutter analyze
  - [x] SubTask 4.2: 测试回收站页面正常显示

# Task Dependencies
- Task 2 依赖 Task 1
- Task 3 依赖 Task 1 和 Task 2
- Task 4 依赖 Task 1, Task 2, Task 3
