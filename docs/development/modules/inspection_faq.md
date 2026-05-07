# API 巡检 FAQ

## 每日巡检命令模板

```bash
# 每日巡检（推荐）
cd docs/development/modules
bash daily_inspection.sh

# 手动执行覆盖检查
python3 check_module_client_coverage.py --all --json

# 手动执行更新检查
python3 check_module_api_updates.py --all --json

# 单模块检查
python3 check_module_client_coverage.py ai --json
python3 check_module_api_updates.py ai --json
```

## 状态判定口径

### aligned（对齐）
- Swagger 端点与客户端 method/path 完全匹配
- 允许白名单中的 allowed_extra_in_client 和 allowed_missing_in_client
- **判定**：无需操作

### extra_in_client（客户端多余）
- 客户端存在 Swagger 中没有的端点
- **处理**：
  1. 检查是否为兼容旧路由或客户端增强能力
  2. 如有合理原因，加入 allowedExtraInClient 白名单
  3. 如无保留价值，制定清理计划

### missing_in_client（客户端缺失）
- Swagger 存在但客户端未实现的端点
- **处理**：**阻断项**，必须在进入 API 测试阶段前清零
- 修复流程：实现端点 -> 补充测试 -> 验证覆盖

### missing_baseline（基线缺失）
- 尚未生成该模块的分析基线文件
- **处理**：运行 `python3 analyze_module_api.py <模块关键词>`

### updated（Swagger 已更新）
- 当前 Swagger 中存在新增/删除端点
- **处理**：重新运行 `python3 analyze_module_api.py <模块关键词>`

### unchanged（无变化）
- 当前分析文件与 Swagger 一致
- **判定**：无需操作

## 白名单管理规范

### allowed_extra_in_client
- 每个白名单端点必须有明确的保留原因
- 保留原因分类：
  - **兼容旧路由**：服务端双路由共存期的兼容入口
  - **客户端增强**：移动端独有能力（如浏览器托管、审批等）
  - **契约偏差**：Swagger 文档与真实行为不一致，客户端按真实行为实现
- 白名单退出条件：
  - 上游 Swagger 补齐对应端点后移出白名单
  - 兼容旧路由退出窗口到期后清理

### allowed_missing_in_client
- 每个白名单端点必须有明确的有意缺失原因
- 典型场景：Swagger 标注 GET 但运行时真实接口为 POST

## 报告归档

- JSON 报告存储在 `docs/development/modules/reports/`
- 命名格式：`coverage_YYYYMMDD.json`、`updates_YYYYMMDD.json`
- 保留最近 30 天的报告

## 常见问题

### Q: 覆盖检查显示 extra 但实际是合理的怎么办？
A: 在 `check_module_client_coverage.py` 的 `ALLOWED_EXTRA` 字典中添加白名单条目，包含端点信息和保留原因。

### Q: Swagger 与真实行为不一致怎么办？
A: 以真实 API 测试结果为准，在客户端兼容真实行为。禁止修改 `docs/OpenSource/1Panel/**`。

### Q: 每天需要跑几次巡检？
A: 建议每天两次：开始工作前和结束工作后各一次。开始前确认基线，结束后确认无新增漂移。
