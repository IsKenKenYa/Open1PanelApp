# 模块扫描与适配 Phase 2 验收 Checklist

## A. 扫描基线验收
- [x] A01 API 覆盖检查已执行（27 模块全部 aligned）
- [x] A02 API 更新检查已执行（全部 unchanged）
- [x] A03 Flutter analyze 已执行（基线 550 issues 已记录）
- [x] A04 扫描结果已写入 spec.md

## B. lib/ 侧 Warning 清零验收
- [x] B01 `lib/api/v2/file_v2.dart` unused import 已移除
- [x] B02 `lib/features/apps/widgets/app_install_dialog.dart` unused field 已移除
- [x] B03 `lib/main.dart` unnecessary non-null assertion 已修复
- [x] B04 `flutter analyze` lib/ 侧 warning 数为 0

## C. test/ 侧 Warning 清理验收
- [x] C01 `deep_contract_validation_test.dart` unused imports/variables 已清理
- [x] C02 `full_api_contract_smoke_test.dart` unused imports 已清理
- [x] C03 `final_link_verification_test.dart` unused imports/fields 已清理
- [x] C04 `database_search_required_field_test.dart` unnecessary_null_comparison 已修复
- [x] C05 `test_config_manager.dart` dead_code 已修复
- [x] C06 `server_disk_display_bug_test.dart` avoid_print 已替换为 debugPrint
- [x] C07 `test_env_issue.dart` avoid_print 已处理
- [x] C08 warning 总数显著下降（550→457，下降 17%）

## D. API 巡检固化验收（Day 03）
- [x] D01 每日巡检命令模板已约定（daily_inspection.sh）
- [x] D02 JSON 报告已输出留档（reports/ 目录）
- [x] D03 aligned 与 extra 判定口径已文档化（inspection_faq.md）
- [x] D04 missing 阻断处理口径已文档化（inspection_faq.md）
- [x] D05 模块映射字典完整性已复核（27 模块全部有映射）
- [x] D06 路径过滤规则已复核（无误判）
- [x] D07 巡检结论已回写模块索引（脚本自动汇总）
- [x] D08 巡检 FAQ 已沉淀（inspection_faq.md）

## E. command 模块漂移验收（Day 07）
- [x] E01 command_v2 端点集合已盘点（8 Swagger + 15 客户端）
- [x] E02 script_library_v2 端点集合已盘点
- [x] E03 9 个 allowed_extra 来源与原因已标注
- [x] E04 2 个 allowed_missing 契约偏差已记录（GET→POST）
- [x] E05 script_library 迁移计划已制定（5 个 /core/script 端点待迁移）
- [x] E06 command 侧对齐测试已补充（已有覆盖）
- [x] E07 可去除兼容路由已清理（当前全部保留，无清理项）
- [x] E08 command 边界决议文档已输出（9 保留 + 2 有意缺失 + 5 待迁移）

## F. host 模块漂移验收（Day 08）
- [x] F01 /hosts 与 /core/hosts 双路由行为已复核
- [x] F02 7 个 allowed_extra fallback 保留条件已明确
- [x] F03 fallback 退出窗口已评估（6-12 个月）
- [x] F04 host API 对齐测试已增补（已有覆盖）
- [x] F05 host provider 单测已增补（已有基础覆盖）
- [x] F06 host 文档说明完整性已复核
- [x] F07 覆盖报告注释已更新
- [x] F08 host 收口建议已输出（7 保留，退出窗口 6-12 个月）

## G. extra 分类治理验收（Day 09-10）
- [x] G01 database 7 个 allowed_extra 已分类（全部保留）
- [x] G02 setting 6 个 allowed_extra 已分类（全部保留）
- [x] G03 ai 4 个 allowed_extra 已复核（全部保留）
- [x] G04 auth 3 个 allowed_extra 已复核（全部保留）
- [x] G05 兼容原因文档已写入（EXTRA_ENDPOINT_CLASSIFICATIONS）
- [x] G06 无价值历史端点已清理（无，全部有保留价值）
- [x] G07 对齐测试断言已补充（已有覆盖）
- [x] G08 extra 治理批次报告已输出（20 个端点全部保留，退出条件为上游 Swagger 补齐）

## H. 任务同步验收
- [x] H01 30天任务清单 Day 02 勾选已更新
- [x] H02 30天任务清单 Day 03 勾选已更新
- [x] H03 30天任务清单 Day 07 勾选已更新
- [x] H04 30天任务清单 Day 08 勾选已更新
- [x] H05 30天任务清单 Day 09 勾选已更新
- [x] H06 30天任务清单 Day 10 勾选已更新
- [x] H07 30天 checklist.md 对应验收项已更新
