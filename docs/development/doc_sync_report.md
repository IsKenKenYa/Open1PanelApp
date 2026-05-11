# 文档同步验证报告

## 需要保持同步的文档

以下 5 份文档必须在内容变更时保持同步：

| 序号 | 文档路径 | 职责 |
|------|----------|------|
| 1 | `AGENTS.md` | 所有 AI IDE 的主要参考，包含强制规则、架构规范、测试门禁 |
| 2 | `CLAUDE.md` | Claude Code 专用补充说明 |
| 3 | `.kiro/steering/development_workflow.md` | Kiro 自动包含的开发工作流指导 |
| 4 | `.kiro/steering/functional_test_rules.md` | Kiro 自动包含的功能测试规则 |
| 5 | `docs/development/cross_platform_ui_governance.md` | 跨平台 UI 治理策略 |

## 同步触发条件

当以上任一文档发生变更时，应检查其余文档是否需要同步更新。具体触发场景：

### 必须同步的场景

1. **架构规则变更**：如分层架构调整、依赖方向变更 → 需更新 AGENTS.md、CLAUDE.md、.kiro/steering/*.md
2. **测试门禁变更**：如新增测试命令、修改门禁条件 → 需更新 AGENTS.md、CLAUDE.md、.kiro/steering/functional_test_rules.md
3. **跨平台 UI 策略变更**：如新增平台支持、设计系统调整 → 需更新 AGENTS.md、CLAUDE.md、docs/development/cross_platform_ui_governance.md
4. **文件规模阈值调整**：如修改 LOC 限制 → 需更新 AGENTS.md、CLAUDE.md
5. **开发流程变更**：如新增自动化步骤 → 需更新 AGENTS.md、CLAUDE.md、.kiro/steering/development_workflow.md

### 无需同步的场景

1. 仅修改文档排版、格式、错别字
2. 新增不影响其他文档的独立章节
3. 更新文档中的示例代码（除非涉及架构变更）

## 同步检查机制

### 本地检查

运行同步检查脚本：

```bash
chmod +x docs/development/scripts/check_doc_sync.sh
./docs/development/scripts/check_doc_sync.sh
```

脚本逻辑：

- 比较所有 5 份文档的最后修改时间
- 如果任一文档比最新文档落后超过 1 天，判定为不同步
- 输出不同步的文档列表
- 退出码：0 = 同步，1 = 不同步

### CI 自动检查

当 PR 修改了以下路径时，自动触发文档同步检查：

- `AGENTS.md`
- `CLAUDE.md`
- `.kiro/**`
- `docs/development/**`

CI 工作流文件：`.github/workflows/doc-sync-check.yml`

CI 行为：

1. 运行 `check_doc_sync.sh` 脚本
2. 如果检查失败，在 PR 中自动添加评论，列出需要更新的文档
3. 评论中包含本报告的链接，方便开发者了解修复方法

## 修复同步问题

### 步骤

1. **确认变更来源**：查看最新修改的文档，了解变更内容
2. **评估影响范围**：判断变更是否影响其他文档
3. **逐个更新**：按以下优先级更新文档：
   - `AGENTS.md`（最高优先级，主文档）
   - `CLAUDE.md`
   - `.kiro/steering/*.md`
   - `docs/development/cross_platform_ui_governance.md`
4. **验证同步**：运行 `check_doc_sync.sh` 确认所有文档已同步
5. **提交变更**：在同一 PR 中提交所有文档更新

### 注意事项

- 不要仅更新时间戳来"通过"检查，必须确保内容真正同步
- 如果变更仅涉及某份文档的独有内容，可在 PR 描述中说明无需同步的原因
- 文档更新应与代码变更在同一 PR 中完成，避免分拆导致中间状态

## 文档职责分工

| 文档 | 独有内容 | 与其他文档共享的内容 |
|------|----------|---------------------|
| `AGENTS.md` | 强制规则、文件阈值、命名约定、提交规范 | 架构分层、测试门禁、跨平台策略 |
| `CLAUDE.md` | Claude Code 特定流程、项目概述 | 架构分层、测试命令、1Panel 适配基线 |
| `.kiro/steering/development_workflow.md` | Kiro 特定开发流程 | 开发流程、测试规范 |
| `.kiro/steering/functional_test_rules.md` | Kiro 特定测试规则 | 测试门禁、测试命令 |
| `cross_platform_ui_governance.md` | 详细平台适配策略、设计系统细节 | 跨平台策略概要 |
