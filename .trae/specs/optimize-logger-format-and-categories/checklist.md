# Checklist

## Category 与映射
- [x] `LogCategory` 枚举已定义且至少包含 NETWORK / UI / FILE_IO / DB / AUTH / CRASH / SYSTEM / UNCLASSIFIED
- [x] `LoggerConfig.defaultCategoryForPackage` 已实现并覆盖所有标准 package 前缀
- [x] `LogCategory` 与 `package` 前缀映射的单元测试通过

## 自定义 Printer
- [x] `AppLogPrinter` 已实现并替换 `PrettyPrinter`
- [x] 单行格式正确：`{timestamp} [{LEVEL}][{CATEGORY}:{package}] {message}`
- [x] 错误日志带 `| err=... | at frame1, at frame2, at frame3` 段
- [x] 错误堆栈截断到前 3 帧
- [x] 不出现 `├` `┄` `└` `─` 等 box-drawing 字符
- [x] 文件输出不含 ANSI 颜色码

## AppLogger 兼容性
- [x] `t/d/i/w/e/f` / `*WithPackage` 方法签名保持向后兼容
- [x] 新增可选 `category: LogCategory?` 参数
- [x] 未传 category 时正确走隐式推断
- [x] IP 脱敏逻辑未变更
- [x] 文件写入路径未变更

## 双格式导出
- [x] `LogFormat` 枚举（humanReadable / aiAgent）已定义
- [x] 默认运行期写入 AI Agent 格式
- [x] `LogExportService.exportLogs(format: LogFormat.aiAgent)` 可生成 `_ai.txt` 文件
- [x] picker 保存位置能力未变更
- [x] 双格式导出单元测试通过

## 系统设置预览
- [x] 系统设置 → 应用日志区域增加「导出预览」按钮
- [x] 预览对话框含「人读」「AI Agent」两个 Tab
- [x] 预览仅读取日志文件最后 200 行
- [x] 预览渲染完成时间 < 200ms
- [x] 「保存此格式」按钮触发 picker 保存
- [x] 国际化文案已添加（zh / en）

## 全量 audit
- [x] `analysis_options.yaml` 启用 `avoid_print` lint
- [x] `tool/audit_no_print.sh` 扫描脚本就绪
- [x] `flutter analyze` 无 `print()` / `debugPrint()` / `stdout.writeln()` 违规
- [x] 现有 `appLogger` 调用点保持兼容

## 验证
- [x] `flutter analyze` 无错误（仅遗留的 info 级别提示）
- [x] `dart run test/scripts/test_runner.dart unit` 通过
- [x] 新增单元测试文件均通过（17/17）
- [ ] OHOS 模拟器手动验证：日志单行输出且无装饰横线（待 dev 环境）
- [x] 通过 picker 导出日志功能未回归
