# 修复回收站 RangeError 错误 Spec

## Why
回收站页面在加载文件时抛出 `RangeError (end): Invalid value: Only valid value is 0: -1` 错误。原因是 `recycle_bin_page.dart` 第 79 行尝试通过 `f.path.substring(0, f.path.lastIndexOf('/'))` 计算 `from` 字段，当路径不包含 `/` 时会失败。API 实际上已经返回了 `from` 字段，应该直接使用。

另外，恢复回收站文件时失败，错误为 `Key: 'RecycleBinReduce.RName' Error:Field validation for 'RName' failed on the 'required' tag`。原因是 `rName` 字段没有被正确解析，代码使用 `f.gid` 作为 `rName` 的备选，但 API 返回的是独立的 `rName` 字段。

## What Changes
- 在 `FileInfo` 模型中添加 `from` 字段（回收站来源路径）
- 在 `FileInfo` 模型中添加 `rName` 字段（回收站文件唯一标识）
- 在 `file_v2.dart` 的 `searchRecycleBin` 解析逻辑中正确映射 `from` 和 `rName` 字段
- 在 `recycle_bin_page.dart` 中使用 API 返回的 `from` 和 `rName` 字段，而不是自己计算

## Impact
- Affected specs: fix-recycle-bin-parsing
- Affected code:
  - `lib/data/models/file/file_info.dart`
  - `lib/api/v2/file_v2.dart`
  - `lib/features/files/recycle_bin_page.dart`

## ADDED Requirements
### Requirement: FileInfo 模型支持回收站来源路径
系统 SHALL 在 `FileInfo` 模型中提供 `from` 字段，用于存储回收站文件的原始来源目录。

#### Scenario: API 返回 from 字段
- **WHEN** API 返回回收站文件数据包含 `from` 字段
- **THEN** `FileInfo.from` 应正确解析并存储该值

#### Scenario: API 未返回 from 字段
- **WHEN** API 返回的数据不包含 `from` 字段
- **THEN** `FileInfo.from` 应为 null 或空字符串

### Requirement: FileInfo 模型支持回收站文件唯一标识
系统 SHALL 在 `FileInfo` 模型中提供 `rName` 字段，用于存储回收站文件的唯一标识符。

#### Scenario: API 返回 rName 字段
- **WHEN** API 返回回收站文件数据包含 `rName` 字段
- **THEN** `FileInfo.rName` 应正确解析并存储该值

#### Scenario: API 未返回 rName 字段
- **WHEN** API 返回的数据不包含 `rName` 字段
- **THEN** `FileInfo.rName` 应为 null 或空字符串

### Requirement: 回收站页面使用 API 返回的字段
系统 SHALL 在回收站页面直接使用 API 返回的 `from` 和 `rName` 字段，而不是通过字符串操作计算。

#### Scenario: 正常显示回收站文件
- **WHEN** 用户打开回收站页面
- **THEN** 文件列表应正确显示，不会因路径字符串操作失败而崩溃

#### Scenario: from 字段为空
- **WHEN** API 返回的 `from` 字段为空或 null
- **THEN** 应使用合理的默认值（如根目录 `/`）

#### Scenario: 恢复回收站文件
- **WHEN** 用户点击恢复文件
- **THEN** 应使用正确的 `rName` 字段调用 API，恢复操作应成功
