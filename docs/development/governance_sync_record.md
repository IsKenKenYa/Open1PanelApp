# 治理同步记录

本文件记录所有治理文档的更新历史，确保 `AGENTS.md`、`CLAUDE.md` 及配套文档之间的一致性。

---

## 同步记录

| 日期 | 变更来源 | 变更内容 | 涉及文档 | 同步状态 |
|------|----------|----------|----------|----------|
| 2026-07-24 | 实时规划收敛 | 退役工作流引用迁移到 `AGENTS.md`，以阶段总计划承载实时批次状态与证据 | `AGENTS.md`、`CLAUDE.md`、`.kiro/steering/development_workflow.md`、`docs/development/modules/阶段总计划.md` | 已同步 |
| 2026-05-08 | Day 26 文档回写（批次 2） | 追加执行状态章节 | `docs/development/cross_platform_ui_governance.md` | 已同步 |
| 2026-05-08 | Day 26 文档回写（批次 2） | 历史：旧模块工作流追加执行状态附录；已于 2026-07-24 合并并退役 | 退役文档（见 `AGENTS.md` 活规范） | 已迁移 |
| 2026-05-08 | Day 26 文档回写（批次 2） | 历史：旧原生 UI 工作流追加执行状态附录；已于 2026-07-24 合并并退役 | 退役文档（见 `AGENTS.md` 活规范） | 已迁移 |
| 2026-05-08 | Day 26 文档回写（批次 2） | 追加落地进展章节 | `AGENTS.md` | 已同步 |
| 2026-05-08 | Day 26 文档回写（批次 2） | 追加流程细则落地进展章节 | `CLAUDE.md` | 已同步 |
| 2026-05-08 | Day 26 文档回写（批次 2） | 新建例外审批记录模板 | `docs/development/exception_approval_template.md` | 新建 |
| 2026-05-08 | Day 26 文档回写（批次 2） | 新建平台矩阵状态表 | `docs/development/platform_matrix_status.md` | 新建 |
| 2026-05-08 | Day 26 文档回写（批次 2） | 新建治理同步记录 | `docs/development/governance_sync_record.md` | 新建 |

## 一致性检查

本次更新后，以下文档组已保持一致：

- `AGENTS.md` 落地进展 <-> `CLAUDE.md` 流程细则落地进展
- `cross_platform_ui_governance.md` 平台策略 <-> `AGENTS.md` 跨平台 UI 治理
- `阶段总计划.md` 实时批次状态 <-> API 覆盖脚本与测试门禁结果
- `exception_approval_template.md` <-> `AGENTS.md` 文档治理章节

> 最后更新：2026-07-24
