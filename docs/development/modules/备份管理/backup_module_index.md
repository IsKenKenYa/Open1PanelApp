# 备份管理模块索引

## 模块定位

备份管理模块负责备份账户管理、备份记录查询与恢复操作，提供完整的数据保护与恢复能力。

## 子模块结构

| 子模块 | 端点 | 数据结构 | 说明 |
|--------|------|----------|------|
| 备份账户 | `/backups/*`, `/core/backups/*` | `BackupAccount*` | 账户 CRUD、搜索、连通性测试 |
| 备份记录 | `/backups/records/*` | `BackupRecord*` | 记录查询、按类型筛选 |
| 备份恢复 | `/backups/recover/*` | `BackupRecover*` | 恢复提交、按类型恢复 |

## 已有落地

- `BackupAccountsPage` - 备份账户列表
- `BackupAccountFormPage` - 备份账户表单
- `BackupRecordsPage` - 备份记录列表
- `BackupRecoverPage` - 备份恢复操作
- `BackupRepository / BackupAccountService / BackupRecordService / BackupRecoverService`

## Swagger-客户端覆盖状态

- 覆盖状态: aligned
- 额外端点: 无
- 缺失端点: 无
- 测试覆盖: API 测试通过
- 双轨状态: N/A（尚无原生轨道）

## 关联文档

- 架构设计: docs/development/modules/备份账户管理/backup_account_module_architecture.md
- API 分析: docs/development/modules/备份账户管理/backup_api_analysis.md
- 开发计划: docs/development/modules/备份账户管理/backup_account_plan.md
- FAQ: docs/development/modules/备份账户管理/backup_account_faq.md

## 备注

- 旧文档里的 `/backup/accounts/*` 口径已经废弃，当前仓库统一以 `/backups/*` 和 `/core/backups/*` 为真值
- legacy `backup_account_page.dart` 不再是产品入口

---

**文档版本**: 1.0
**最后更新**: 2026-05-08
