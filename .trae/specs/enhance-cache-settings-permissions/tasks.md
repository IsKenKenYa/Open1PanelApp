# Tasks

- [x] Task 1: 扩展 AppSettingsController 添加缓存设置
  - [x] SubTask 1.1: 添加缓存策略枚举（memoryOnly, diskOnly, hybrid）
  - [x] SubTask 1.2: 添加缓存大小限制设置
  - [x] SubTask 1.3: 更新 AppPreferencesService 支持缓存设置存储

- [x] Task 2: 完善内存缓存过期机制
  - [x] SubTask 2.1: 添加2分钟过期机制
  - [x] SubTask 2.2: 添加定时清理任务
  - [x] SubTask 2.3: 添加应用生命周期监听，关闭时清理

- [x] Task 3: 更新设置页面添加缓存设置 UI
  - [x] SubTask 3.1: 添加缓存策略选择器
  - [x] SubTask 3.2: 添加缓存大小限制设置
  - [x] SubTask 3.3: 添加清除缓存按钮
  - [x] SubTask 3.4: 显示当前缓存使用情况

- [x] Task 4: 更新 FilePreviewCacheManager 使用设置
  - [x] SubTask 4.1: 根据用户设置选择缓存策略
  - [x] SubTask 4.2: 添加文件哈希验证机制
  - [x] SubTask 4.3: 实现缓存索引正确映射

- [x] Task 5: 完善文件下载权限处理
  - [x] SubTask 5.1: 检查并优化 `downloadFileToDevice` 权限处理
  - [x] SubTask 5.2: 添加权限引导对话框

- [x] Task 6: 添加国际化文本
  - [x] SubTask 6.1: 添加中文缓存设置文本
  - [x] SubTask 6.2: 添加英文缓存设置文本

- [x] Task 7: 验证功能
  - [x] SubTask 7.1: 运行 flutter analyze
  - [x] SubTask 7.2: 测试缓存设置切换
  - [x] SubTask 7.3: 测试内存缓存过期机制
  - [x] SubTask 7.4: 测试文件下载权限流程

# Task Dependencies
- Task 2 独立
- Task 3 依赖 Task 1
- Task 4 依赖 Task 1 和 Task 2
- Task 6 独立
- Task 7 依赖 Task 1-6
