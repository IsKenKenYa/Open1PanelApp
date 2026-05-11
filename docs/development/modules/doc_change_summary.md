# 文档变更摘要

> 更新时间: 2026-05-08

## 变更清单

### 1. 应用管理模块索引

- 文件: `docs/development/modules/应用管理/app_module_index.md`
- 操作: 更新
- 变更内容:
  - 新增"Swagger-客户端覆盖状态"章节
  - 覆盖状态: aligned，无额外端点，无缺失端点
  - 双轨状态: 不对齐（Windows 占位页面，iOS 仅只读列表）

### 2. 备份管理模块索引

- 文件: `docs/development/modules/备份管理/backup_module_index.md`
- 操作: 新建
- 变更内容:
  - 创建备份管理模块索引文档
  - 覆盖状态: aligned，无额外端点，无缺失端点
  - 双轨状态: N/A（尚无原生轨道）
  - 包含子模块结构、已有落地、关联文档

### 3. 命令管理模块索引

- 文件: `docs/development/modules/命令管理/command_module_index.md`
- 操作: 更新
- 变更内容:
  - 新增"Swagger-客户端覆盖状态"章节
  - 覆盖状态: aligned（含白名单）
  - 9 个白名单额外端点明细表（5 脚本库 legacy wrapper + 1 cronjob 兼容 + 3 POST-only 真实路由）
  - 2 个有意缺失端点（GET->POST 契约偏差）
  - 脚本库迁移计划: 5 个 `/core/script` 端点迁移到 `script_library_v2.dart`
  - 文档版本升级至 3.0

### 4. 主机管理模块索引

- 文件: `docs/development/modules/主机管理/host_module_index.md`
- 操作: 更新
- 变更内容:
  - 新增"Swagger-客户端覆盖状态"章节
  - 覆盖状态: aligned（含白名单）
  - 7 个白名单额外端点明细表（4 SSH 设置共用 + 2 双路由测试 + 1 fail2ban）
  - 双路由回退策略说明（主路由优先，6-12 个月退出窗口）
  - 文档版本升级至 3.0

### 5. 模块规划总览

- 文件: `docs/development/modules/module_planning_index.md`
- 操作: 更新
- 变更内容:
  - 新增"Swagger-客户端覆盖全局状态"章节
  - 27 个模块覆盖状态明细表
  - 汇总: 全部 aligned，0 意外缺失，所有额外端点在白名单中
  - 关键决策记录: 命令模块边界、主机模块双路由回退、数据库/设置/AI/认证额外端点分类
  - 下一步: Day 21-30 质量门禁计划

### 6. API 巡检 FAQ - 契约偏差章节

- 文件: `docs/development/modules/inspection_faq.md`
- 操作: 更新（追加）
- 变更内容:
  - 新增"契约偏差记录"章节
  - 命令模块 GET->POST 契约偏差详细记录
  - 涉及 2 个端点、偏差原因、客户端处理策略、有意设计理由
  - 上游与本仓 issue 跟踪编号

### 7. API 巡检 FAQ - 测试覆盖章节

- 文件: `docs/development/modules/inspection_faq.md`
- 操作: 更新（追加）
- 变更内容:
  - 新增"测试覆盖现状"章节
  - 当前测试结果: features 789/789, ui 8/8, api/core/data 219/219
  - api_client 集成测试: 212/452（需要服务端）
  - 测试命令参考
  - 集成测试环境配置说明

### 8. 文档变更摘要

- 文件: `docs/development/modules/doc_change_summary.md`
- 操作: 新建
- 变更内容: 本文件，记录所有变更

## 影响范围

本次文档更新仅涉及 `docs/development/modules/` 目录下的文档文件，不涉及任何代码变更。

## 数据来源

- `check_module_client_coverage.py` 中的 `EXTRA_ENDPOINT_CLASSIFICATIONS` 和 `MISSING_ENDPOINT_CLASSIFICATIONS`
- `dual_track_audit_report.md` 中的双轨审计结果
- 当前测试执行结果
