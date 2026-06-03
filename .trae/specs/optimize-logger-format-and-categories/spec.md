# 日志格式与分类优化 Spec

## Why

当前日志系统（`lib/core/services/logger/`）存在以下可优化项：

1. **横向装饰字符消耗 token**：`package:logger` 的 `PrettyPrinter` 默认输出 `├┄┄┄┄` / `└──────` 等 box-drawing 字符。OHOS/Pura90 模拟器导出的 43MB 日志中，横向装饰字符占用了大量行。AI Agent 阅读时每个日志事件被切成 3-4 行（顶线 + 消息 + 底线），不必要地消耗 token。
2. **缺少功能域分类维度**：当前仅有 `package` 来源标识（如 `data.repositories.dashboard`），但 `LogViewer` 面板、用户过滤、错误归因都需要更上层的功能域分类（NETWORK / UI / FILE_IO / DB / CRASH / AUTH / SYSTEM）。现有 `package` 名称层级较深（4-5 段），用户无法按域快速筛选。
3. **错误堆栈多行缩进**：`PrettyPrinter` 对 stack trace 逐帧缩进展开，单条错误日志可占 10+ 行，AI Agent 阅读时上下文碎片化。
4. **格式不可被 AI Agent 稳定解析**：当前输出以 `🐛` emoji + 颜色码 + 缩进组成，无结构化分隔符，AI Agent 需逐行合并后才能解析，效率低。
5. **缺乏「人读 vs AI 易读」双格式导出**：用户反馈日志导出后给自己看与给 AI Agent 看，所需格式不同，但当前仅一种格式。

约束：保留当前已实现的「通过 picker 导出到用户指定位置」能力，不破坏文件保存链路。

## What Changes

### 核心改造
- **弃用** `package:logger` 的 `PrettyPrinter`，改用自定义 `AppLogPrinter`，输出**单行结构化**格式
- **新增** `LogCategory` 枚举：NETWORK / UI / FILE_IO / DB / AUTH / CRASH / SYSTEM / UNCLASSIFIED
- **新增** `defaultCategoryForPackage(String pkg)` 静态映射表，集中维护 `package` 前缀段 → `LogCategory` 的映射
- **新增** `category` 可选参数到 `AppLogger` 方法族，显式覆盖隐式推断
- **压缩** 错误堆栈为 1 行紧凑形式，最多保留前 3 帧

### 双格式导出
- **保留** 现有「人读」格式（emoji + 缩进）作为导出时的可选格式
- **新增** 「AI Agent 易读」格式（单行结构化）作为另一种导出选项
- **新增** 系统设置页「导出预览」入口，预览仅读取日志文件最后 200 行，渲染时间 < 200ms
- **新增** 预览对话框中两个 Tab：「人读格式」「AI Agent 格式」，可一键保存

### 覆盖度审计
- **新增** 全量静态扫描：检查 `lib/` 全部 dart 文件，确保无 `print()` / `debugPrint()` / `stdout.writeln()` 散落
- **新增** 自定义 lint 规则（`analysis_options.yaml` 扩展），禁止在业务代码中直接调用 `print()`

### 不变更
- 不修改 `LogFileManagerService` 的文件轮转、保留策略
- 不修改 `LogPreferencesService` 的偏好持久化
- 不修改 `LogExportService` 的文件保存链路（picker 行为保持）
- 不修改 `appLogger` 已有的方法签名（向后兼容，新增 `category` 为可选参数）

## Impact

- Affected code:
  - `lib/core/services/logger/logger_service.dart`（核心改造）
  - `lib/core/services/logger/log_category.dart`（新增枚举）
  - `lib/core/services/logger/app_log_printer.dart`（新增 LogPrinter 实现）
  - `lib/core/services/logger/log_format.dart`（新增格式工具）
  - `lib/core/services/logger/log_export_service.dart`（新增双格式导出）
  - `lib/core/config/logger_config.dart`（新增 category 映射表）
  - `lib/features/settings/system_settings_page.dart`（新增预览按钮）
  - `analysis_options.yaml`（新增 lint 规则）
  - 全量 `appLogger` 调用点（多数向后兼容，可选传入 category）

- Affected specs:
  - 替代/叠加 `optimize-logger-module`（已完成）：前者侧重删除手搓代码，本 spec 侧重输出格式与分类

## ADDED Requirements

### Requirement: 单行结构化日志输出
系统 SHALL 通过自定义 `AppLogPrinter` 输出单行结构化格式，不再使用 `package:logger` 的 `PrettyPrinter`。

#### Scenario: 默认 Info 级别输出
- **WHEN** 调用 `appLogger.iWithPackage('data.repositories.dashboard', 'Extracted metrics: cpu=10%')`
- **THEN** 实际写入日志行的格式为 `2026-06-03 18:06:12.353 [INFO ][UI:data.repositories.dashboard] Extracted metrics: cpu=10%`
- **AND** 单条日志仅占 1 行
- **AND** 行中不出现 `├` `┄` `└` `─` 等 box-drawing 字符

#### Scenario: Error 级别带堆栈压缩
- **WHEN** 调用 `appLogger.eWithPackage('network.api', 'Request failed', error: e, stackTrace: st)` 其中 `e` 为 `SocketException`、stackTrace 共 10 帧
- **THEN** 输出格式为 `2026-06-03 18:06:12.353 [ERROR][NETWORK:network.api] Request failed | err=SocketException(...) | at frame1, at frame2, at frame3`
- **AND** 堆栈截断到前 3 帧
- **AND** 整条日志仍在 1 行内

#### Scenario: 显式 Category 覆盖
- **WHEN** 调用 `appLogger.iWithPackage('features.dashboard', 'clicked button', category: LogCategory.ui)`
- **THEN** 输出中 category 字段为 `UI`，覆盖隐式推断结果

#### Scenario: IP 脱敏仍生效
- **WHEN** 日志消息中包含公网 IPv4 `203.0.113.45`
- **THEN** 写入文件时替换为 `***.***.***.***`
- **AND** 控制台输出同样脱敏

### Requirement: Category 静态映射表
系统 SHALL 在 `lib/core/config/logger_config.dart` 提供 `defaultCategoryForPackage(String packageName)` 静态方法，按 package 前缀段归类。

#### Scenario: 标准映射
- **GIVEN** package 名为 `features.dashboard.dashboard_provider`
- **WHEN** 调用 `defaultCategoryForPackage(pkg)`
- **THEN** 返回 `LogCategory.ui`

#### Scenario: 网络模块映射
- **GIVEN** package 名为 `core.network.dio_client`
- **WHEN** 调用 `defaultCategoryForPackage(pkg)`
- **THEN** 返回 `LogCategory.network`

#### Scenario: 未知 package 兜底
- **GIVEN** package 名为 `mypackage.something`
- **WHEN** 调用 `defaultCategoryForPackage(pkg)`
- **THEN** 返回 `LogCategory.unclassified`

#### Scenario: 核心映射表
- 映射表（实现期细化）至少包含：
  - `features.*` → `UI`
  - `core.network.*` / `features.*.api.*` → `NETWORK`
  - `core.services.file*` / `features.files.*` / `features.transfers.*` → `FILE_IO`
  - `data.repositories.*` / `features.databases.*` → `DB`
  - `features.auth.*` / `core.security.*` → `AUTH`
  - `core.services.logger.*` → `SYSTEM`
  - 其余 → `UNCLASSIFIED`

### Requirement: 错误堆栈压缩为单行
系统 SHALL 在 `Error` / `Fatal` 级别日志中，将 `stackTrace` 压缩为单行紧凑形式，截断到前 3 帧。

#### Scenario: 短堆栈全部保留
- **GIVEN** stackTrace 共 1 帧
- **WHEN** 输出错误日志
- **THEN** 日志行尾追加 ` | at <frame>`

#### Scenario: 长堆栈截断
- **GIVEN** stackTrace 共 10 帧
- **WHEN** 输出错误日志
- **THEN** 日志行尾追加 ` | at frame1, at frame2, at frame3`

#### Scenario: 无 stackTrace
- **GIVEN** 未传入 stackTrace
- **WHEN** 输出错误日志
- **THEN** 不追加 `| at ...` 段

### Requirement: 双格式导出能力
系统 SHALL 暴露「人读」与「AI Agent 易读」两种格式的导出能力。

#### Scenario: 默认人读格式
- **WHEN** 用户在系统设置点击「导出日志」按钮
- **THEN** 生成可读的日志文件（保留 emoji、缩进、堆栈），文件名为 `app_logs_<yyyyMMdd_HHmmss>.txt`
- **AND** 通过 picker 触发用户选择保存位置

#### Scenario: 切换为 AI Agent 格式
- **WHEN** 用户在预览对话框选择「AI Agent 格式」Tab 并点击「保存此格式」
- **THEN** 生成单行结构化格式的日志文件
- **AND** 通过 picker 触发用户选择保存位置
- **AND** 文件名后缀标记为 `_ai.txt`（如 `app_logs_<timestamp>_ai.txt`）

#### Scenario: 预览性能
- **WHEN** 用户点击「导出预览」
- **THEN** 仅读取当前日志文件**最后 200 行**（不读取全部）
- **AND** 预览渲染完成时间 < 200ms
- **AND** 预览渲染不阻塞 UI 主线程

### Requirement: 系统设置预览入口
系统 SHALL 在 `lib/features/settings/system_settings_page.dart` 的「应用日志」区域提供「导出预览」按钮。

#### Scenario: 入口位置
- **WHEN** 用户打开系统设置 → 应用日志
- **THEN** 可见「导出预览」按钮，置于「导出日志」按钮旁

#### Scenario: 预览对话框交互
- **WHEN** 用户点击「导出预览」
- **THEN** 弹出对话框，包含两个 Tab：「人读格式」「AI Agent 格式」
- **AND** 默认显示「AI Agent 格式」Tab（前 200 行单行结构化预览）
- **AND** 提供「保存此格式」与「取消」按钮

### Requirement: 全量 audit
系统 SHALL 通过自定义 lint 规则禁止业务代码中直接调用 `print()` / `debugPrint()` / `stdout.writeln()`。

#### Scenario: 自定义 lint 生效
- **WHEN** 业务代码包含 `print('hello')`
- **THEN** `flutter analyze` 报告 `avoid_print` 违规并指向该行
- **AND** 给出建议：「Use appLogger.iWithPackage() instead」

#### Scenario: 现有代码审计通过
- **WHEN** 执行 `flutter analyze` 在全量 lib/ 目录
- **THEN** 无 `print()` / `debugPrint()` / `stdout.writeln()` 散落违规
- **AND** 现有 `appLogger.*WithPackage(...)` 调用点保持兼容（无需修改）

### Requirement: 性能边界
系统 SHALL 在日志写入路径上控制开销，确保不影响应用性能。

#### Scenario: 写入性能
- **WHEN** 持续以 100 条/秒速率输出 Info 级别日志
- **THEN** 文件写入不影响 UI 60fps
- **AND** 写入采用单线程串行队列（已有 `_writeQueue` 模式）

#### Scenario: 内存占用
- **WHEN** 日志文件达 10MB 触发轮转
- **THEN** 不阻塞主线程（轮转在 IO 异步执行）

## MODIFIED Requirements

### Requirement: `AppLogger` 方法族向后兼容
原方法 `t/d/i/w/e/f` / `tWithPackage` / `dWithPackage` / ... 全部保留原签名；新增可选命名参数 `category: LogCategory?`，未传入时使用隐式推断。

#### Scenario: 不传 category
- **WHEN** 调用 `appLogger.iWithPackage('features.dashboard', 'clicked')`
- **THEN** category 由 `defaultCategoryForPackage('features.dashboard')` 推断为 `UI`

#### Scenario: 显式传 category
- **WHEN** 调用 `appLogger.iWithPackage('features.dashboard', 'clicked', category: LogCategory.crash)`
- **THEN** category 显示为 `CRASH`

## REMOVED Requirements

无。

# Task Dependencies

- [Task 2] depends on [Task 1]
- [Task 3] depends on [Task 2]
- [Task 4] depends on [Task 3]
- [Task 5] depends on [Task 4]
- [Task 6] depends on [Task 5]
- [Task 7] depends on [Task 6]
