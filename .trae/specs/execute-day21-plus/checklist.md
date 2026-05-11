# Day 21-30 验收 Checklist

## A. Week3 质量门禁冲刺验收（Day 21）
- [x] A01 test/ 残留 warning 已修复
- [x] A02 features 测试通过率 >= 95%（1049/1049 = 100%）
- [x] A03 ui 测试通过
- [x] A04 API 关键路径回归已执行
- [x] A05 Provider 关键路径回归已执行
- [x] A06 Windows dotnet build 已验证（条件满足时，CI 工作流已创建）
- [x] A07 iOS xcodebuild 已验证（条件满足时，CI 工作流已创建）
- [x] A08 Week3 回归报告已输出

## B. CI 硬门禁第一批验收（Day 22）
- [x] B01 flutter analyze + unit 工作流已创建（flutter-ci.yml）
- [x] B02 UI 测试工作流已创建（flutter-ui-test.yml）
- [x] B03 Integration 条件工作流已创建（flutter-integration.yml）
- [x] B04 Windows 原生构建工作流已创建（windows-native-build.yml）
- [x] B05 iOS 构建工作流已创建（ios-build.yml）
- [x] B06 macOS 构建工作流已创建（macos-build.yml）
- [x] B07 失败即阻断策略已配置
- [x] B08 CI 工作流可触发并运行

## C. CI 硬门禁第二批验收（Day 23）
- [x] C01 Flutter 缓存策略已实现
- [x] C02 失败日志归档已实现
- [x] C03 Flaky 用例隔离策略已实现
- [x] C04 重试策略已实现（仅网络类）
- [x] C05 并发执行矩阵已配置
- [x] C06 门禁状态汇总输出已实现
- [x] C07 异常中断告警已配置（条件满足时）
- [x] C08 CI 运行手册已输出（ci_run_manual.md）

## D. 文档一致性门禁验收（Day 24）
- [x] D01 触发条件已定义
- [x] D02 必同步文档集合已定义
- [x] D03 文档一致性检查脚本已创建（check_doc_sync.sh）
- [x] D04 脚本已接入 CI（doc-sync-check.yml）
- [x] D05 本地 pre-commit 检查已添加（可选）
- [x] D06 失败提示与修复指引已添加
- [x] D07 全量演练已执行
- [x] D08 文档门禁验收报告已输出（doc_sync_report.md）

## E. 模块文档回写第一批验收（Day 25）
- [x] E01 app_module_index 已更新
- [x] E02 backup_module_index 已更新
- [x] E03 command_module_index 已更新
- [x] E04 host_module_index 已更新
- [x] E05 module_planning_index 已更新
- [x] E06 契约偏差章节已更新
- [x] E07 测试覆盖章节已更新
- [x] E08 文档变更摘要已输出（doc_change_summary.md）

## F. 模块文档回写第二批验收（Day 26）
- [x] F01 跨平台治理文档执行状态已更新
- [x] F02 模块工作流执行状态已更新
- [x] F03 原生工作流执行状态已更新
- [x] F04 AGENTS 关键规则落地进展已更新
- [x] F05 CLAUDE 流程细则落地进展已更新
- [x] F06 例外审批记录模板已添加（exception_approval_template.md）
- [x] F07 平台矩阵现状表已添加（platform_matrix_status.md）
- [x] F08 治理同步记录已输出（governance_sync_record.md）

## G. 发布前全量回归第一轮验收（Day 27）
- [x] G01 API 全量核心用例已运行
- [x] G02 Provider 核心用例已运行
- [x] G03 Widget/UI 核心用例已运行
- [x] G04 Windows 原生构建已验证（CI 工作流）
- [x] G05 iOS 构建已验证（CI 工作流）
- [x] G06 macOS 构建已验证（CI 工作流）
- [x] G07 失败项已汇总并修复
- [x] G08 第一轮回归报告已输出（regression_report_round1.md）

## H. 发布前全量回归第二轮验收（Day 28）
- [x] H01 失败修复用例已重跑
- [x] H02 关键链路已复验
- [x] H03 双轨语义差异项已复验
- [x] H04 门禁脚本稳定性已复验
- [x] H05 CI 并发场景已复验
- [x] H06 文档门禁策略已复验
- [x] H07 第二轮回归报告已输出（regression_report_round2.md）
- [x] H08 发布候选结论已形成

## I. 发布候选审查验收（Day 29）
- [x] I01 代码变更摘要已准备
- [x] I02 测试与门禁结果已准备
- [x] I03 原生轨道能力说明已准备
- [x] I04 API 覆盖变化说明已准备
- [x] I05 风险与回退预案已准备
- [x] I06 文档同步证明已准备
- [x] I07 发布评审会议纪要模板已完成
- [x] I08 可发布判定已形成（CONDITIONALLY READY）

## J. 收官与下一周期入口验收（Day 30）
- [x] J01 30 天总复盘已输出（30day_retrospective.md）
- [x] J02 完成度统计已输出
- [x] J03 未完成项清单已输出
- [x] J04 下一周期 P0/P1/P2 列表已输出
- [x] J05 可复用模板清单已输出
- [x] J06 仓库记忆长期结论已更新
- [x] J07 执行证据已归档
- [x] J08 下一周期 specs 入口已创建（next-cycle-entry/spec.md）

## K. 任务同步验收
- [x] K01 30天任务清单 Day 21-30 勾选已更新
- [x] K02 30天 checklist.md 对应验收项已更新
