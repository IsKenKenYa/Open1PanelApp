# Tasks

- [x] Task 1: 新增 `LogCategory` 枚举与映射表
  - [ ] SubTask 1.1: 新增 `lib/core/services/logger/log_category.dart`，定义枚举 `LogCategory { network, ui, fileIo, db, auth, crash, system, unclassified }`
  - [ ] SubTask 1.2: 在 `lib/core/config/logger_config.dart` 新增 `defaultCategoryForPackage(String pkg)` 静态方法与映射表
  - [ ] SubTask 1.3: 单元测试 `defaultCategoryForPackage` 覆盖所有映射分支

- [x] Task 2: 新增自定义 `AppLogPrinter` 替换 `PrettyPrinter`
  - [ ] SubTask 1.1: 新增 `lib/core/services/logger/app_log_printer.dart`，实现 `LogPrinter` 接口
  - [ ] SubTask 1.2: 输出格式：`{timestamp} [{LEVEL}][{CATEGORY}:{package}] {message} [| err=... | at frame1, at frame2, at frame3]`
  - [ ] SubTask 1.3: 错误堆栈截断到前 3 帧，多帧用 `, ` 分隔
  - [ ] SubTask 1.4: 颜色仅在 terminal 启用，控制台与文件均不写 ANSI 码到文件
  - [ ] SubTask 1.5: 单元测试覆盖：Info / Error+stack / 显式 category / 未知 package

- [x] Task 3: 改造 `AppLogger` 接入新 Printer
  - [ ] SubTask 3.1: 修改 `lib/core/services/logger/logger_service.dart` `init()`，将 `PrettyPrinter` 替换为 `AppLogPrinter`
  - [ ] SubTask 3.2: 在 `t/d/i/w/e/f` / `*WithPackage` 方法族新增可选 `category: LogCategory?` 命名参数
  - [ ] SubTask 3.3: 未传 `category` 时调用 `LoggerConfig.defaultCategoryForPackage(packageName)`
  - [ ] SubTask 3.4: 保持 IP 脱敏逻辑不变（继续在 `_AppLogOutput` 输出层）
  - [ ] SubTask 3.5: 保持错误写入文件路径（`LogFileManagerService.appendLine`）

- [x] Task 4: 拆分日志文件输出为人读 / AI Agent 双格式
  - [ ] SubTask 4.1: 新增 `lib/core/services/logger/log_format.dart`，定义 `LogFormat { humanReadable, aiAgent }`
  - [ ] SubTask 4.2: 新增 `LogFormat.formatLine(LogEvent, LogCategory)` 静态方法
  - [ ] SubTask 4.3: `LogFileManagerService` 接受 `LogFormat` 参数，支持按格式写入
  - [ ] SubTask 4.4: 默认运行期写入 `aiAgent` 格式（节省 token 存储）

- [x] Task 5: 改造 `LogExportService` 支持双格式导出
  - [ ] SubTask 5.1: `exportLogs` 方法新增 `LogFormat format` 参数
  - [ ] SubTask 5.2: AI Agent 格式导出文件名后缀加 `_ai.txt`
  - [ ] SubTask 5.3: 保持通过 picker 选择保存位置的能力
  - [ ] SubTask 5.4: 单元测试覆盖：人读导出 / AI Agent 导出 / picker 失败回退

- [x] Task 6: 系统设置页增加「导出预览」入口
  - [ ] SubTask 6.1: 在 `lib/features/settings/system_settings_page.dart` 「应用日志」区域增加「导出预览」按钮
  - [ ] SubTask 6.2: 新增 `LogPreviewDialog` Widget，两个 Tab（人读 / AI Agent）
  - [ ] SubTask 6.3: 预览仅读取日志文件最后 200 行（不读取全部）
  - [ ] SubTask 6.4: 「保存此格式」按钮触发 picker 保存对应格式的日志
  - [ ] SubTask 6.5: 国际化文案（`app_zh.arb` / `app_en.arb`）：`systemSettingsLogsPreviewButton` / `systemSettingsLogsPreviewTabHuman` / `systemSettingsLogsPreviewTabAi` / `systemSettingsLogsPreviewSave` / `systemSettingsLogsPreviewAiFileNameSuffix`

- [x] Task 7: 全量 audit：禁止 `print()` / `debugPrint()` / `stdout.writeln()` 散落
  - [ ] SubTask 7.1: 在 `analysis_options.yaml` 启用 `avoid_print` lint
  - [ ] SubTask 7.2: 编写一次性 grep 审计脚本（`tool/audit_no_print.sh`）扫描 `lib/` 全部 dart 文件
  - [ ] SubTask 7.3: 运行 `flutter analyze` 确认无 `avoid_print` 违规
  - [ ] SubTask 7.4: 如发现违规，迁移到 `appLogger.*WithPackage(...)` 并打 changelog

- [x] Task 8: 验证与回归
  - [ ] SubTask 8.1: `flutter analyze` 无错误
  - [ ] SubTask 8.2: `dart run test/scripts/test_runner.dart unit` 通过
  - [ ] SubTask 8.3: 新增单元测试 `test/core/services/logger/`：`log_category_test.dart` / `app_log_printer_test.dart` / `log_export_service_format_test.dart`
  - [ ] SubTask 8.4: 手动验证 OHOS 模拟器：日志单行输出且无 `├` `└` 字符

# Task Dependencies

- [Task 2] depends on [Task 1]
- [Task 3] depends on [Task 2]
- [Task 4] depends on [Task 3]
- [Task 5] depends on [Task 4]
- [Task 6] depends on [Task 5]
- [Task 7] depends on [Task 6]
- [Task 8] depends on [Task 7]
