# Tasks

- [x] Task 1: 添加缓存相关依赖
  - [x] SubTask 1.1: 确认 `flutter_cache_manager` 已添加到 pubspec.yaml
  - [x] SubTask 1.2: 运行 `flutter pub get`

- [x] Task 2: 创建内存缓存管理器
  - [x] SubTask 2.1: 创建 `lib/core/services/cache/memory_cache_manager.dart`
  - [x] SubTask 2.2: 实现 LRU 缓存算法
  - [x] SubTask 2.3: 配置缓存容量和大小限制

- [x] Task 3: 创建文件预览缓存管理器
  - [x] SubTask 3.1: 创建 `lib/core/services/cache/file_preview_cache_manager.dart`
  - [x] SubTask 3.2: 集成内存缓存和硬盘缓存
  - [x] SubTask 3.3: 实现缓存优先级加载逻辑

- [x] Task 4: 修改 FilePreviewPage 使用缓存
  - [x] SubTask 4.1: 替换直接下载为缓存加载
  - [x] SubTask 4.2: 添加缓存状态显示

- [x] Task 5: 验证缓存功能
  - [x] SubTask 5.1: 运行 flutter analyze
  - [x] SubTask 5.2: 测试首次预览（下载并缓存）
  - [x] SubTask 5.3: 测试再次预览（从缓存加载）

# Task Dependencies
- Task 2 独立
- Task 3 依赖 Task 1 和 Task 2
- Task 4 依赖 Task 3
- Task 5 依赖 Task 4
