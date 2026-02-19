# 修复回收站数据解析问题 Spec

## Why
回收站页面 API 返回了正确的数据（8 个文件），但页面显示 0 个文件。原因是 `searchRecycleBin` 方法的响应解析逻辑没有正确处理嵌套的 `{data: {items: [...]}}` 数据结构。

## What Changes
- 修复 `file_v2.dart` 中 `searchRecycleBin` 方法的响应解析逻辑
- 正确处理 `{code: 200, data: {total: 8, items: [...]}}` 嵌套结构

## Impact
- Affected code:
  - `lib/api/v2/file_v2.dart` - searchRecycleBin 方法

## ADDED Requirements

### Requirement: 回收站数据正确解析
系统应正确解析回收站 API 返回的嵌套数据结构。

#### Scenario: API 返回嵌套数据
- **WHEN** API 返回 `{code: 200, data: {total: 8, items: [...]}}`
- **THEN** 系统应正确提取 `items` 数组并显示在页面上

## 问题分析

从日志可见：
```
Response: {code: 200, message: , data: {total: 8, items: [{name: 78898, ...}]}}
```

当前代码逻辑：
```dart
final data = response.data;  // {code: 200, data: {total: 8, items: [...]}}
final itemsRaw = data['items'] ?? data['data'] ?? data['files'];
// data['items'] = null
// data['data'] = {total: 8, items: [...]}  <- 这是 Map，不是 List！
if (itemsRaw is List) {  // 检查失败
  files = itemsRaw.map(...).toList();
}
```

需要修改为：
```dart
final data = response.data;
if (data is Map<String, dynamic>) {
  // 首先检查嵌套的 data 字段
  final dataWrapper = data['data'];
  if (dataWrapper is Map<String, dynamic>) {
    final itemsRaw = dataWrapper['items'];
    if (itemsRaw is List) {
      files = itemsRaw.map(...).toList();
    }
  }
  // 兼容其他格式
  if (files.isEmpty) {
    final itemsRaw = data['items'] ?? data['files'];
    if (itemsRaw is List) {
      files = itemsRaw.map(...).toList();
    }
  }
}
```
