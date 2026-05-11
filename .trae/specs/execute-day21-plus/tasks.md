# Tasks

说明：
- 本文件承接 30天全链路超级任务清单 Day 21-30。
- 使用 Skills：flutter-expert、flutter-dart-code-review、flutter-development。
- 每项任务完成后需同步更新 30天全链路超级任务清单 的勾选状态。

## Task 1: Day 21 Week3 质量门禁冲刺
- [x] SubTask 1.1: 修复 test/ 残留 warning（server_form_page_test.dart:19 unnecessary_non_null_assertion）
- [x] SubTask 1.2: 执行 features 测试集，记录通过率
- [x] SubTask 1.3: 执行 ui 测试集，记录通过率
- [x] SubTask 1.4: 执行 API 关键路径回归（api/ 目录核心用例）
- [x] SubTask 1.5: 执行 Provider 层关键路径回归
- [x] SubTask 1.6: 验证 Windows dotnet build（条件满足时）
- [x] SubTask 1.7: 验证 iOS xcodebuild（条件满足时）
- [x] SubTask 1.8: 输出 Week3 回归报告（问题分级 + 修复排期）

## Task 2: Day 22 CI 硬门禁第一批
- [x] SubTask 2.1: 新增 flutter analyze + unit 工作流（.github/workflows/flutter-ci.yml）
- [x] SubTask 2.2: 新增 UI 测试工作流（.github/workflows/flutter-ui-test.yml）
- [x] SubTask 2.3: 新增 integration 条件工作流（.github/workflows/flutter-integration.yml，手动触发）
- [x] SubTask 2.4: 新增 Windows 原生构建工作流（.github/workflows/windows-native-build.yml）
- [x] SubTask 2.5: 新增 iOS 构建工作流（.github/workflows/ios-build.yml）
- [x] SubTask 2.6: 新增 macOS 构建工作流（.github/workflows/macos-build.yml）
- [x] SubTask 2.7: 配置失败即阻断策略（required checks）
- [x] SubTask 2.8: 验证 CI 工作流可触发并运行

## Task 3: Day 23 CI 硬门禁第二批
- [x] SubTask 3.1: 增加 Flutter 缓存策略（pub cache + gradle cache）
- [x] SubTask 3.2: 增加失败日志归档（artifact upload）
- [x] SubTask 3.3: 增加 flaky 用例隔离策略（标记 @flaky，单独运行）
- [x] SubTask 3.4: 增加重试策略（仅网络类失败，最多 2 次）
- [x] SubTask 3.5: 增加并发执行矩阵（多 Flutter 版本 / 多平台）
- [x] SubTask 3.6: 增加门禁状态汇总输出（job summary）
- [x] SubTask 3.7: 增加异常中断告警（Slack/邮件通知，条件满足时）
- [x] SubTask 3.8: 输出 CI 运行手册

## Task 4: Day 24 文档一致性门禁
- [x] SubTask 4.1: 定义触发条件（AGENTS.md/CLAUDE.md/steering/governance 任一变更）
- [x] SubTask 4.2: 定义必同步文档集合（5 文档：AGENTS.md, CLAUDE.md, .kiro/steering, governance, 原生工作流）
- [x] SubTask 4.3: 新增文档一致性检查脚本（docs/development/scripts/check_doc_sync.sh）
- [x] SubTask 4.4: 将脚本接入 CI（新增 workflow step）
- [x] SubTask 4.5: 增加本地 pre-commit 检查（可选）
- [x] SubTask 4.6: 增加失败提示与修复指引
- [x] SubTask 4.7: 运行一次全量演练
- [x] SubTask 4.8: 输出文档门禁验收报告

## Task 5: Day 25 模块文档回写第一批
- [x] SubTask 5.1: 更新 app_module_index（覆盖状态 + extra 分类结论）
- [x] SubTask 5.2: 更新 backup_module_index
- [x] SubTask 5.3: 更新 command_module_index（边界决议 + script_library 迁移计划）
- [x] SubTask 5.4: 更新 host_module_index（fallback 策略 + 退出窗口）
- [x] SubTask 5.5: 更新 module_planning_index（全局进展）
- [x] SubTask 5.6: 更新契约偏差章节（GET→POST 偏差记录）
- [x] SubTask 5.7: 更新测试覆盖章节
- [x] SubTask 5.8: 输出文档变更摘要

## Task 6: Day 26 模块文档回写第二批
- [x] SubTask 6.1: 更新跨平台治理文档执行状态（cross_platform_ui_governance.md）
- [x] SubTask 6.2: 更新模块工作流执行状态（模块适配专属工作流.md）
- [x] SubTask 6.3: 更新原生工作流执行状态（原生UI适配专属工作流.md）
- [x] SubTask 6.4: 更新 AGENTS 关键规则落地进展
- [x] SubTask 6.5: 更新 CLAUDE 流程细则落地进展
- [x] SubTask 6.6: 增加例外审批记录模板
- [x] SubTask 6.7: 增加平台矩阵现状表
- [x] SubTask 6.8: 输出治理同步记录

## Task 7: Day 27 发布前全量回归第一轮
- [x] SubTask 7.1: 运行 API 全量核心用例（flutter test test/api test/api_client）
- [x] SubTask 7.2: 运行 Provider 核心用例（flutter test test/features）
- [x] SubTask 7.3: 运行 Widget/UI 核心用例（flutter test test/ui）
- [x] SubTask 7.4: 运行 Windows 原生构建验证（dotnet build）
- [x] SubTask 7.5: 运行 iOS 构建（xcodebuild）
- [x] SubTask 7.6: 运行 macOS 构建（xcodebuild）
- [x] SubTask 7.7: 汇总失败项并修复
- [x] SubTask 7.8: 输出第一轮回归报告

## Task 8: Day 28 发布前全量回归第二轮
- [x] SubTask 8.1: 重跑所有失败修复用例
- [x] SubTask 8.2: 复验关键链路（登录/切服/文件/容器/应用）
- [x] SubTask 8.3: 复验双轨语义差异项（16 项修复清单）
- [x] SubTask 8.4: 复验门禁脚本稳定性
- [x] SubTask 8.5: 复验 CI 并发场景
- [x] SubTask 8.6: 复验文档门禁策略
- [x] SubTask 8.7: 输出第二轮回归报告
- [x] SubTask 8.8: 形成发布候选结论

## Task 9: Day 29 发布候选审查
- [x] SubTask 9.1: 准备代码变更摘要（Day 01-29 所有变更）
- [x] SubTask 9.2: 准备测试与门禁结果
- [x] SubTask 9.3: 准备原生轨道能力说明
- [x] SubTask 9.4: 准备 API 覆盖变化说明
- [x] SubTask 9.5: 准备风险与回退预案
- [x] SubTask 9.6: 准备文档同步证明
- [x] SubTask 9.7: 完成发布评审会议纪要模板
- [x] SubTask 9.8: 形成可发布判定

## Task 10: Day 30 收官与下一周期入口
- [x] SubTask 10.1: 输出 30 天总复盘
- [x] SubTask 10.2: 输出完成度统计（任务/缺陷/门禁）
- [x] SubTask 10.3: 输出未完成项清单
- [x] SubTask 10.4: 输出下一周期 P0/P1/P2 列表
- [x] SubTask 10.5: 输出可复用模板清单
- [x] SubTask 10.6: 更新仓库记忆长期结论
- [x] SubTask 10.7: 归档执行证据
- [x] SubTask 10.8: 创建下一周期 specs 入口

## Task 11: 同步更新 30天全链路超级任务清单
- [x] SubTask 11.1: 更新 Day 21-30 勾选状态
- [x] SubTask 11.2: 更新 30天 checklist.md 对应验收项

# Task Dependencies
- Task 1（Day 21 门禁冲刺）为阻断项，必须先通过
- Task 2（Day 22 CI 第一批）依赖 Task 1
- Task 3（Day 23 CI 第二批）依赖 Task 2
- Task 4（Day 24 文档门禁）依赖 Task 2（CI 基础设施就绪后接入）
- Task 5 和 Task 6（Day 25-26 文档回写）可并行，依赖 Task 1
- Task 7（Day 27 回归第一轮）依赖 Task 2-6
- Task 8（Day 28 回归第二轮）依赖 Task 7
- Task 9（Day 29 发布审查）依赖 Task 8
- Task 10（Day 30 收官）依赖 Task 9
- Task 11 依赖 Task 1-10 全部完成
