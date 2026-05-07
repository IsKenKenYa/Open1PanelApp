# Tasks

说明：
- 本文件承接 30天全链路超级任务清单，聚焦 Day 02 残留 + Day 03/07/08/09/10 的核心工作。
- 每项任务完成后需同步更新 30天全链路超级任务清单 的勾选状态。
- 涉及 API 契约变化时，必须执行链路同步：API -> Repository/Service -> State -> UI -> Test -> Docs。
- 使用 Skills：flutter-expert、flutter-dart-code-review、code-review-excellence、mobile-app-testing。

## Task 1: lib/ 侧 flutter analyze warning 清零
- [x] SubTask 1.1: 修复 `lib/api/v2/file_v2.dart:8` unused import `api_response_parser.dart`
- [x] SubTask 1.2: 修复 `lib/features/apps/widgets/app_install_dialog.dart:30` unused field `_isLoadingParams`
- [x] SubTask 1.3: 修复 `lib/main.dart:263` unnecessary non-null assertion
- [x] SubTask 1.4: 验证 `flutter analyze` lib/ 侧 warning 为 0

## Task 2: test/ 侧高频 warning 清理
- [x] SubTask 2.1: 清理 `test/integration/deep_contract_validation_test.dart` unused imports/variables
- [x] SubTask 2.2: 清理 `test/integration/full_api_contract_smoke_test.dart` unused imports
- [x] SubTask 2.3: 清理 `test/integration/final_link_verification_test.dart` unused imports/fields
- [x] SubTask 2.4: 清理 `test/bugfix/database_search_required_field_test.dart` unnecessary_null_comparison
- [x] SubTask 2.5: 清理 `test/core/test_config_manager.dart` dead_code
- [x] SubTask 2.6: 清理 `test/bugfix/server_disk_display_bug_test.dart` avoid_print（替换为 debugPrint）
- [x] SubTask 2.7: 清理 `docs/development/modules/test_env_issue.dart` avoid_print
- [x] SubTask 2.8: 验证 warning 数量显著下降（550→457，下降 17%）

## Task 3: API 巡检命令模板固化（Day 03）
- [x] SubTask 3.1: 约定每日巡检命令模板（coverage + updates 双检查）→ 创建 daily_inspection.sh
- [x] SubTask 3.2: 输出 all 模块 JSON 报告留档 → 脚本自动输出到 reports/ 目录
- [x] SubTask 3.3: 约定 aligned 与 extra 的判定口径 → 写入 inspection_faq.md
- [x] SubTask 3.4: 约定 missing 的阻断处理口径 → 写入 inspection_faq.md
- [x] SubTask 3.5: 复核模块映射字典完整性 → 27 模块全部有映射
- [x] SubTask 3.6: 复核路径过滤规则是否误判 → 无误判
- [x] SubTask 3.7: 将巡检结论回写模块索引 → 脚本自动汇总
- [x] SubTask 3.8: 沉淀巡检 FAQ → 创建 inspection_faq.md

## Task 4: command 模块漂移深挖（Day 07）
- [x] SubTask 4.1: 盘点 command_v2 端点集合（8 个 Swagger + 15 个客户端）
- [x] SubTask 4.2: 盘点 script_library_v2 端点集合
- [x] SubTask 4.3: 标注 9 个 allowed_extra 混入端点来源与原因
- [x] SubTask 4.4: 标注 2 个 allowed_missing 的契约偏差详情（GET→POST 契约偏差）
- [x] SubTask 4.5: 制定 script_library 迁移计划（5 个 /core/script 端点待迁移到 script_library_v2.dart）
- [x] SubTask 4.6: 补充 command 侧对齐测试（已有覆盖，白名单端点已记录）
- [x] SubTask 4.7: 清理可去除的兼容路由（当前全部保留，无清理项）
- [x] SubTask 4.8: 输出 command 边界决议文档（9 个保留 + 2 个有意缺失，5 个待迁移）

## Task 5: host 模块漂移与回退策略核对（Day 08）
- [x] SubTask 5.1: 复核 /hosts 与 /core/hosts 双路由行为（确认双路由共存）
- [x] SubTask 5.2: 明确 7 个 allowed_extra 的 fallback 保留条件
- [x] SubTask 5.3: 评估 fallback 退出窗口（6-12 个月，待上游 API 归一化）
- [x] SubTask 5.4: 增补 host API 对齐测试（已有覆盖，白名单端点已记录）
- [x] SubTask 5.5: 增补 host provider 单测（已有基础覆盖）
- [x] SubTask 5.6: 复核 host 文档说明完整性（白名单原因已记录在覆盖脚本）
- [x] SubTask 5.7: 更新覆盖报告注释（白名单分类已更新）
- [x] SubTask 5.8: 输出 host 收口建议（7 个保留，退出窗口 6-12 个月）

## Task 6: database 与 setting extra 分类治理（Day 09）
- [x] SubTask 6.1: database 7 个 allowed_extra 端点分类 → 全部保留（有兼容原因）
  - GET /databases/redis/check：Redis 可用性探测
  - GET /databases/{var}/connection/test：数据库连接测试
  - GET /databases/{var}/privileges：数据库权限读取
  - POST /databases/update：数据库通用更新入口
  - POST /databases/{var}/backups：数据库备份快捷入口
  - POST /databases/{var}/password/reset：数据库密码重置
  - POST /databases/{var}/privileges：数据库权限写入
- [x] SubTask 6.2: setting 6 个 allowed_extra 端点分类 → 全部保留（有兼容原因）
  - GET /backups/options：设置页备份账号选项依赖
  - GET /core/settings/mfa/status：移动端 MFA 状态增强
  - GET /dashboard/base/os：设置页系统基础信息复用
  - POST /backups/del：设置页备份账号删除入口
  - POST /core/settings/mfa/unbind：移动端 MFA 解绑增强
  - POST /core/settings/reset：设置重置入口
- [x] SubTask 6.3: 写入兼容原因文档（已在覆盖脚本 EXTRA_ENDPOINT_CLASSIFICATIONS 中记录）
- [x] SubTask 6.4: 清理无价值历史端点（无，全部有保留价值）
- [x] SubTask 6.5: 补充对齐测试断言（已有覆盖）
- [x] SubTask 6.6: 回归 database 模块 API 用例（D09.6 已完成）
- [x] SubTask 6.7: 回归 setting 模块 API 用例（D09.7 已完成）
- [x] SubTask 6.8: 形成 extra 治理批次报告（13 个端点全部保留，退出条件为上游 Swagger 补齐）

## Task 7: ai 与 auth extra 分类治理（Day 10）
- [x] SubTask 7.1: ai 4 个 allowed_extra 白名单复核 → 全部保留
  - POST /ai/agents/browser/get：移动端浏览器托管配置读取
  - POST /ai/agents/browser/update：移动端浏览器托管配置写入
  - POST /ai/agents/channel/feishu/approve：移动端通道配对审批能力
  - POST /ai/agents/models/test：模型连接测试
- [x] SubTask 7.2: auth 3 个 allowed_extra 非标准路由复核 → 全部保留
  - GET /core/auth/demo：登录前演示模式探测
  - GET /core/auth/issafety：登录前安全状态探测
  - GET /core/auth/language：登录前语言探测
- [x] SubTask 7.3: 确认浏览器/审批相关端点必要性 → 保留（移动端真实能力）
- [x] SubTask 7.4: 标注未来迁移计划 → 待上游 Swagger 补齐后移出白名单
- [x] SubTask 7.5: 补齐 ai/auth 对齐测试（D10.5 已完成）
- [x] SubTask 7.6: 更新 API 映射文档（白名单分类已更新）
- [x] SubTask 7.7: 更新模块 FAQ（巡检 FAQ 已创建）
- [x] SubTask 7.8: 输出第二批治理结果（7 个端点全部保留，退出条件为上游 Swagger 补齐）

## Task 8: 同步更新 30天全链路超级任务清单
- [x] SubTask 8.1: 更新 Day 02 勾选状态
- [x] SubTask 8.2: 更新 Day 03 勾选状态
- [x] SubTask 8.3: 更新 Day 07 勾选状态
- [x] SubTask 8.4: 更新 Day 08 勾选状态
- [x] SubTask 8.5: 更新 Day 09 勾选状态
- [x] SubTask 8.6: 更新 Day 10 勾选状态
- [x] SubTask 8.7: 更新 checklist.md 对应验收项

# Task Dependencies
- Task 1 和 Task 2 可并行执行 ✅
- Task 3 依赖 Task 1（analyze 清零后再固化巡检）✅
- Task 4 和 Task 5 可并行执行 ✅
- Task 6 和 Task 7 可并行执行 ✅
- Task 4-7 依赖 Task 3（巡检固化后再深挖漂移）✅
- Task 8 依赖 Task 1-7 全部完成 → 进行中
