# Tasks

- [ ] Task 1: 修复文件保存 API 路径
  - [ ] SubTask 1.1: 修改 `file_v2.dart` 中的 `updateFileContent` 方法
  - [ ] SubTask 1.2: 将 API 路径从 `/files/content/update` 改为 `/files/save`

- [ ] Task 2: 创建缓存设置二级页面
  - [ ] SubTask 2.1: 创建 `lib/pages/settings/cache_settings_page.dart`
  - [ ] SubTask 2.2: 将缓存策略、缓存大小、清除缓存等功能移至新页面

- [ ] Task 3: 重构设置页面
  - [ ] SubTask 3.1: 移除设置页面中的缓存设置 UI
  - [ ] SubTask 3.2: 添加缓存设置入口 ListTile

- [ ] Task 4: 更新路由配置
  - [ ] SubTask 4.1: 在路由中添加缓存设置页面

- [ ] Task 5: 验证修复
  - [ ] SubTask 5.1: 运行 flutter analyze
  - [ ] SubTask 5.2: 测试文件保存功能
  - [ ] SubTask 5.3: 测试缓存设置页面导航

# Task Dependencies
- Task 2 独立
- Task 3 依赖 Task 2
- Task 4 依赖 Task 2
- Task 5 依赖 Task 1, 3, 4
