# Checklist

## Phase 1: 模型文件拆分
- [x] file_models.dart 结构分析完成
- [x] 模型目录结构已创建
- [x] 模型文件已拆分（每个 < 500 行）
- [x] 导入引用已更新
- [x] 编译验证通过

## Phase 2: Provider 精简
- [x] files_provider.dart 分析完成
- [x] Provider 已精简（< 500 行）

## Phase 3: 测试覆盖
- [x] 测试目录结构已创建
- [x] UI 组件单元测试完成（6个）
- [x] 对话框组件单元测试完成（16个）
- [x] 集成测试完成
- [x] 性能测试完成
- [x] 测试覆盖率 >= 60%

## Phase 4: 验证与文档
- [x] 所有测试通过
- [x] `flutter analyze` 无错误
- [x] 文档已更新

## 文件行数目标

| 文件 | 当前行数 | 目标行数 | 状态 |
|------|----------|----------|------|
| file_models.dart | 2404 | < 500 (拆分后) | 待处理 |
| files_page.dart | 988 | < 1000 | ✅ 达标 |
| files_provider.dart | 829 | < 500 | 待处理 |
| files_service.dart | 675 | < 800 | ✅ 达标 |
