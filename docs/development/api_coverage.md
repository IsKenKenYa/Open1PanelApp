# 1Panel V2 API 覆盖度追踪

## 概览

- 来源: docs/1PanelOpenAPI/1PanelV2OpenAPI.json
- 端点总数: 546
- 标签数: 52
- 覆盖口径: 已实现=存在API调用与数据模型，已测试=具备单元/集成/端到端测试，已文档=包含使用说明与已知限制

## 优先级规则

- P0: 核心业务链路与主流程依赖（认证、仪表盘、应用、容器、网站、文件、系统设置、数据库、运行时、监控、备份账户）
- P1: 高价值扩展与运维能力（OpenResty、SSL、SSH、日志、任务、脚本、容器细分能力）
- P2: 工具类或低频能力（设备、Clam、Fail2ban、FTP、磁盘、菜单设置等）

## 标签覆盖清单

| 标签 | 端点数 | 优先级 | 已实现 | 已测试 | 已文档 |
| --- | --- | --- | --- | --- | --- |
| Website | 54 | P0 | 0 | 0 | 0 |
| System Setting | 43 | P0 | 0 | 0 | 0 |
| File | 37 | P0 | 0 | 0 | 0 |
| App | 30 | P0 | 0 | 0 | 0 |
| Backup Account | 25 | P0 | 0 | 0 | 0 |
| Runtime | 25 | P0 | 0 | 0 | 0 |
| Container | 19 | P0 | 0 | 0 | 0 |
| Cronjob | 16 | P1 | 0 | 0 | 0 |
| Firewall | 15 | P1 | 0 | 0 | 0 |
| Database Mysql | 14 | P0 | 0 | 0 | 0 |
| Clam | 12 | P2 | 0 | 0 | 0 |
| Dashboard | 12 | P0 | 0 | 0 | 0 |
| Device | 12 | P2 | 0 | 0 | 0 |
| SSH | 12 | P1 | 0 | 0 | 0 |
| Website SSL | 11 | P1 | 0 | 0 | 0 |
| AI | 10 | P1 | 0 | 0 | 0 |
| Container Image | 10 | P1 | 0 | 0 | 0 |
| Host | 10 | P1 | 0 | 0 | 0 |
| OpenResty | 10 | P1 | 0 | 0 | 0 |
| Database | 9 | P0 | 0 | 0 | 0 |
| Database PostgreSQL | 9 | P0 | 0 | 0 | 0 |
| Command | 8 | P1 | 0 | 0 | 0 |
| Container Docker | 8 | P1 | 0 | 0 | 0 |
| FTP | 8 | P2 | 0 | 0 | 0 |
| McpServer | 8 | P2 | 0 | 0 | 0 |
| System Group | 8 | P2 | 0 | 0 | 0 |
| Database Redis | 7 | P0 | 0 | 0 | 0 |
| Fail2ban | 7 | P2 | 0 | 0 | 0 |
| Host tool | 7 | P2 | 0 | 0 | 0 |
| Website CA | 7 | P1 | 0 | 0 | 0 |
| Container Compose-template | 6 | P1 | 0 | 0 | 0 |
| Container Image-repo | 6 | P1 | 0 | 0 | 0 |
| Auth | 5 | P0 | 0 | 0 | 0 |
| Container Compose | 5 | P1 | 0 | 0 | 0 |
| Monitor | 5 | P0 | 0 | 0 | 0 |
| ScriptLibrary | 5 | P1 | 0 | 0 | 0 |
| Container Network | 4 | P1 | 0 | 0 | 0 |
| Container Volume | 4 | P1 | 0 | 0 | 0 |
| Disk Management | 4 | P2 | 0 | 0 | 0 |
| Logs | 4 | P1 | 0 | 0 | 0 |
| PHP Extensions | 4 | P2 | 0 | 0 | 0 |
| Website Acme | 4 | P1 | 0 | 0 | 0 |
| Website DNS | 4 | P1 | 0 | 0 | 0 |
| Website Domain | 4 | P1 | 0 | 0 | 0 |
| Website Nginx | 4 | P1 | 0 | 0 | 0 |
| untagged | 4 | P2 | 0 | 0 | 0 |
| Database Common | 3 | P0 | 0 | 0 | 0 |
| Process | 2 | P1 | 0 | 0 | 0 |
| TaskLog | 2 | P1 | 0 | 0 | 0 |
| Website HTTPS | 2 | P1 | 0 | 0 | 0 |
| Menu Setting | 1 | P2 | 0 | 0 | 0 |
| Website PHP | 1 | P1 | 0 | 0 | 0 |

## 更新机制

- 新增功能必须同步更新 api_coverage.json 与本表
- 每个端点需要标记实现、测试、文档三个维度
- 以标签为最小单元推进覆盖率，同时维护端点级补充清单
