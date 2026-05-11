# 回归测试报告 - Round 1 (Day 27)

**日期**: 2026-05-08
**项目**: Open1PanelApp
**测试环境**: macOS (Darwin)

---

## 1. Flutter Analyze 结果

| 级别 | 数量 |
|------|------|
| Error | 8 |
| Warning | 0 |
| Info | 448 |
| **合计** | **456** |

### Error 详情

全部 8 个 error 集中在 `test/debug/app_detail_debug.dart`，属于调试文件的过时引用:

| 文件 | 行号 | 规则 | 说明 |
|------|------|------|------|
| test/debug/app_detail_debug.dart | 17 | new_with_undefined_constructor_default | TestConfigManager 无无名构造函数 |
| test/debug/app_detail_debug.dart | 20 | undefined_getter | TestConfigManager 无 hasApiKey |
| test/debug/app_detail_debug.dart | 26 | undefined_getter | TestConfigManager 无 baseUrl |
| test/debug/app_detail_debug.dart | 27 | undefined_getter | TestConfigManager 无 apiKey |
| test/debug/app_detail_debug.dart | 34 | undefined_getter | TestConfigManager 无 hasApiKey |
| test/debug/app_detail_debug.dart | 61 | undefined_getter | AppItem 无 downloadUrl |
| test/debug/app_detail_debug.dart | 94 | undefined_getter | TestConfigManager 无 hasApiKey |
| test/debug/app_detail_debug.dart | 101 | undefined_function | AppSearchRequest 未定义 |

### Info 详情

448 个 info 全部为 `avoid_print`，分布在 `test/debug/` 目录下的调试文件中:
- `test/debug/monitor_data_debug.dart`
- `test/debug/monitor_io_network_debug.dart`
- `test/debug/monitor_settings_debug.dart`
- `test/debug/update_monitor_settings_debug.dart`

这些均为调试脚本中使用 `print()` 而非 `appLogger`，不影响功能正确性。

---

## 2. 测试套件结果

### 2.1 Features 测试 (`test/features`)

| 指标 | 结果 |
|------|------|
| 通过 | 789 |
| 失败 | 0 |
| **总计** | **789** |
| **通过率** | **100%** |

覆盖模块: 服务器管理、容器管理、应用管理、文件管理、数据库管理、备份管理、网站管理、引导流程等。

### 2.2 UI 测试 (`test/ui`)

| 指标 | 结果 |
|------|------|
| 通过 | 8 |
| 失败 | 0 |
| **总计** | **8** |
| **通过率** | **100%** |

覆盖内容: UiTargetResolver 平台解析、UiRouteHost 路由构建、桌面 Shell 页面。

### 2.3 API / Core / Data 测试 (`test/api` + `test/core` + `test/data`)

| 指标 | 结果 |
|------|------|
| 通过 | 219 |
| 失败 | 0 |
| **总计** | **219** |
| **通过率** | **100%** |

覆盖内容: API 客户端、网络层、存储层、配置管理、数据仓库、数据模型。

### 2.4 Auth / Config / Shared 测试 (`test/auth` + `test/config` + `test/shared`)

| 指标 | 结果 |
|------|------|
| 通过 | 33 |
| 失败 | 0 |
| **总计** | **33** |
| **通过率** | **100%** |

覆盖内容: Token 认证机制、路由配置、安全网关、日志查看器控制器。

---

## 3. 汇总

| 测试套件 | 通过 | 失败 | 总计 | 通过率 |
|----------|------|------|------|--------|
| test/features | 789 | 0 | 789 | 100% |
| test/ui | 8 | 0 | 8 | 100% |
| test/api + test/core + test/data | 219 | 0 | 219 | 100% |
| test/auth + test/config + test/shared | 33 | 0 | 33 | 100% |
| **合计** | **1049** | **0** | **1049** | **100%** |

---

## 4. 已知问题

1. **api_client 需要服务器**: API 客户端测试通过 mock 方式运行，实际网络请求依赖真实 1Panel 服务器，集成测试需单独配置环境。
2. **调试文件过时引用**: `test/debug/app_detail_debug.dart` 中引用了已重构的 `TestConfigManager` 和 `AppItem` 接口（8 个 error），属于调试辅助文件，不影响生产代码。
3. **调试文件使用 print**: `test/debug/` 下 4 个文件共 448 处 `avoid_print` 提示，属于调试脚本，不纳入生产代码质量评估。

---

## 5. 结论

**PASS**

- 全部 1049 个测试用例通过，通过率 100%
- Flutter analyze 的 8 个 error 均位于调试辅助文件，不影响生产代码
- 448 个 info 均为调试脚本的 `avoid_print`，不构成质量风险
- 生产代码零 error、零 warning
