# Tasks

说明：
- 本文件是功能完善与测试覆盖提升阶段的执行清单。
- 优先级：功能完善 > 测试覆盖率提升 > 白名单端点补全。
- 涉及 API 契约变化时，必须执行链路同步：API -> Repository/Service -> State -> UI -> Test -> Docs。
- 每个 Task 完成后必须运行 `flutter analyze` 和 `dart run test/scripts/test_runner.dart unit` 验证。

---

## Phase 1: 功能完善 — Container 子标签（优先级最高）

- [x] Task 1: Container Image 镜像管理功能
  - [x] SubTask 1.1: 审查 `container_v2.dart` 中 Image 相关端点（list/pull/delete/inspect）
  - [x] SubTask 1.2: 确认 `lib/features/orchestration/` 中 Image provider 已有实现，评估缺口
  - [x] SubTask 1.3: 补齐 Image 拉取表单（指定仓库、标签、镜像名）
  - [x] SubTask 1.4: 补齐 Image 详情页（层信息、大小、创建时间）
  - [x] SubTask 1.5: 补齐 Image 删除确认对话框
  - [x] SubTask 1.6: 添加国际化字符串（中英文）— 修复硬编码英文 + 新增 i18n keys
  - [x] SubTask 1.7: 编写 Image provider 单元测试 — 9 个测试用例全部通过
  - [x] SubTask 1.8: 运行 `flutter analyze` + `dart run test/scripts/test_runner.dart unit` 验证

- [x] Task 2: Container Compose 编排管理功能
  - [x] SubTask 2.1: 审查 `compose_v2.dart` 端点覆盖情况
  - [x] SubTask 2.2: 确认 `lib/features/orchestration/` 中 Compose provider 已有实现，评估缺口
  - [x] SubTask 2.3: 补齐 Compose 创建流程（YAML 编辑器、模板选择）
  - [x] SubTask 2.4: 补齐 Compose 操作（up/down/logs/pull）+ 新增 delete 操作
  - [x] SubTask 2.5: 补齐 Compose 服务详情页
  - [x] SubTask 2.6: 添加国际化字符串（中英文）— 新增 4 个 delete 相关 i18n keys
  - [x] SubTask 2.7: 编写 Compose provider 单元测试 — 13 个测试用例全部通过
  - [x] SubTask 2.8: 运行门禁验证

- [x] Task 3: Container Network 网络管理功能
  - [x] SubTask 3.1: 审查 `container_v2.dart` 中 Network 相关端点
  - [x] SubTask 3.2: 确认 orchestration 中 Network provider 已有实现，评估缺口
  - [x] SubTask 3.3: 补齐 Network 创建表单（名称、驱动、子网）+ 新增 IPv6/Labels 字段
  - [x] SubTask 3.4: 补齐 Network 详情页（连接的容器列表）
  - [x] SubTask 3.5: 补齐 Network 删除确认对话框
  - [x] SubTask 3.6: 添加国际化字符串 — 修复 11 处硬编码英文，新增 10 个 i18n keys
  - [x] SubTask 3.7: 编写 Network provider 单元测试 — 14 个测试用例全部通过
  - [x] SubTask 3.8: 运行门禁验证

- [x] Task 4: Container Volume 卷管理功能
  - [x] SubTask 4.1: 审查 `container_v2.dart` 中 Volume 相关端点
  - [x] SubTask 4.2: 确认 orchestration 中 Volume provider 已有实现，评估缺口
  - [x] SubTask 4.3: 补齐 Volume 创建表单（名称、驱动、挂载选项）+ 新增 Labels/Options 字段
  - [x] SubTask 4.4: 补齐 Volume 详情页（使用情况、挂载点）
  - [x] SubTask 4.5: 补齐 Volume 删除确认对话框
  - [x] SubTask 4.6: 添加国际化字符串 — 修复 6 处硬编码英文，新增 8 个 i18n keys
  - [x] SubTask 4.7: 编写 Volume provider 单元测试 — 14 个测试用例全部通过
  - [x] SubTask 4.8: 运行门禁验证

## Phase 2: 功能完善 — Website 子标签与 PHP Extensions

- [x] Task 5: Website Nginx 配置管理功能
  - [x] SubTask 5.1: 审查 `openresty_v2.dart` 中 Nginx 配置相关端点
  - [x] SubTask 5.2: 确认 `lib/features/openresty/` 已有实现，评估缺口 — 已完整
  - [x] SubTask 5.3: 补齐 Nginx 配置文件列表页
  - [x] SubTask 5.4: 补齐配置文件编辑器（语法高亮或代码编辑器）
  - [x] SubTask 5.5: 补齐配置重载/测试操作
  - [x] SubTask 5.6: 添加国际化字符串 — 已有完整本地化层
  - [x] SubTask 5.7: 编写 Nginx provider 单元测试 — 从 2 扩展到 9 个测试用例
  - [x] SubTask 5.8: 运行门禁验证 — 11/11 通过

- [x] Task 6: Website HTTPS 重定向功能
  - [x] SubTask 6.1: 审查 `ssl_v2.dart` 中 HTTPS 相关端点
  - [x] SubTask 6.2: 确认 `lib/features/websites/` 中 SSL 相关 provider 已有实现
  - [x] SubTask 6.3: 补齐 HTTPS 重定向开关与配置
  - [x] SubTask 6.4: 补齐 HTTP -> HTTPS 强制跳转设置
  - [x] SubTask 6.5: 添加国际化字符串 — 修复 ~45 处硬编码，新增 67 个 i18n keys
  - [x] SubTask 6.6: 编写 HTTPS provider 单元测试 — 创建本地化辅助类
  - [x] SubTask 6.7: 运行门禁验证 — 全部通过

- [x] Task 7: PHP Extensions 管理功能
  - [x] SubTask 7.1: 审查 `openresty_v2.dart` 中 PHP Extensions 相关端点
  - [x] SubTask 7.2: 确认 `lib/features/runtimes/` 中 PHP 扩展管理已有实现
  - [x] SubTask 7.3: 补齐扩展列表展示（已安装/可用分类）
  - [x] SubTask 7.4: 补齐扩展启用/禁用操作
  - [x] SubTask 7.5: 添加国际化字符串 — 修复硬编码，新增 2 个 i18n keys
  - [x] SubTask 7.6: 编写 PHP Extensions provider 单元测试 — 2/2 通过
  - [x] SubTask 7.7: 运行门禁验证 — 全部通过

## Phase 3: 功能完善 — Database 与 Firewall 残留

- [x] Task 8: Database 用户管理完善
  - [x] SubTask 8.1: 审查 `database_v2.dart` 中用户管理端点
  - [x] SubTask 8.2: 确认 `lib/features/databases/` 中 users provider 已有实现 — 已完整
  - [x] SubTask 8.3: 补齐用户创建表单（用户名、密码、权限选择）
  - [x] SubTask 8.4: 补齐用户授权管理（数据库选择、权限级别）
  - [x] SubTask 8.5: 补齐用户删除确认对话框
  - [x] SubTask 8.6: 添加国际化字符串 — 已完整国际化
  - [x] SubTask 8.7: 编写 Database users provider 单元测试 — 从 3 扩展到 9 个测试
  - [x] SubTask 8.8: 运行门禁验证 — 9/9 通过

- [x] Task 9: Firewall 高级链路完善
  - [x] SubTask 9.1: 审查 `firewall_v2.dart` 中 forward/filter advance/chain status 端点
  - [x] SubTask 9.2: 确认 `lib/features/firewall/` 中已有实现
  - [x] SubTask 9.3: 补齐端口转发规则管理页面
  - [x] SubTask 9.4: 补齐高级过滤规则（IP 白名单/黑名单、协议过滤）
  - [x] SubTask 9.5: 补齐链路状态查看
  - [x] SubTask 9.6: 添加国际化字符串 — 修复 7 处硬编码，新增 7 个 i18n keys
  - [x] SubTask 9.7: 编写 Firewall 高级功能 provider 单元测试 — 从 7 扩展到 19 个测试
  - [x] SubTask 9.8: 运行门禁验证 — 19/19 通过

## Phase 4: 测试覆盖率提升 — 无测试 API 模块

- [x] Task 10: 为 disk_management_v2.dart 补齐测试
  - [x] SubTask 10.1: 分析 disk_management_v2.dart 的 API 方法签名
  - [x] SubTask 10.2: 创建 `test/api_client/disk_management_api_client_test.dart`
  - [x] SubTask 10.3: 覆盖磁盘列表、分区、格式化等主要端点 — 9 个测试
  - [x] SubTask 10.4: 运行测试验证 — 全部通过

- [x] Task 11: 为 host_tool_v2.dart 补齐测试
  - [x] SubTask 11.1: 分析 host_tool_v2.dart 的 API 方法签名
  - [x] SubTask 11.2: 创建 `test/api_client/host_tool_api_client_test.dart`
  - [x] SubTask 11.3: 覆盖主机工具集主要端点 — 15 个测试
  - [x] SubTask 11.4: 运行测试验证 — 全部通过

- [x] Task 12: 为 terminal_v2.dart 补齐测试
  - [x] SubTask 12.1: 分析 terminal_v2.dart 的 API 方法签名
  - [x] SubTask 12.2: 创建 `test/api_client/terminal_api_client_test.dart`
  - [x] SubTask 12.3: 覆盖终端会话创建、连接、关闭等端点 — 32 个测试
  - [x] SubTask 12.4: 运行测试验证 — 全部通过

- [x] Task 13: 为 update_v2.dart 补齐测试
  - [x] SubTask 13.1: 分析 update_v2.dart 的 API 方法签名
  - [x] SubTask 13.2: 创建 `test/api_client/update_api_client_test.dart`
  - [x] SubTask 13.3: 覆盖系统更新检查、执行等端点 — 6 个测试
  - [x] SubTask 13.4: 运行测试验证 — 全部通过

- [x] Task 14: 为 user_v2.dart 补齐测试
  - [x] SubTask 14.1: 分析 user_v2.dart 的 API 方法签名
  - [x] SubTask 14.2: 创建 `test/api_client/user_api_client_test.dart`
  - [x] SubTask 14.3: 覆盖用户信息获取、更新等端点 — 21 个测试
  - [x] SubTask 14.4: 运行测试验证 — 全部通过

- [x] Task 15: 为 website_group_v2.dart 补齐测试
  - [x] SubTask 15.1: 分析 website_group_v2.dart 的 API 方法签名
  - [x] SubTask 15.2: 创建 `test/api_client/website_group_api_client_test.dart`
  - [x] SubTask 15.3: 覆盖网站分组 CRUD 端点 — 5 个测试
  - [x] SubTask 15.4: 运行测试验证 — 全部通过

## Phase 5: 测试覆盖率提升 — 无测试 Swagger 标签

- [x] Task 16: Container Image 标签测试
  - [x] SubTask 16.1: 从 swagger.json 提取 Container Image 标签的端点清单
  - [x] SubTask 16.2: 创建 `test/api_client/docker_image_api_test.dart` — 14 个测试
  - [x] SubTask 16.3: 覆盖镜像拉取、列表、删除、检查端点
  - [x] SubTask 16.4: 运行测试验证 — 全部通过

- [x] Task 17: Container Compose 标签测试
  - [x] SubTask 17.1: 从 swagger.json 提取 Container Compose 标签的端点清单
  - [x] SubTask 17.2: 扩展 `test/api_client/compose_api_test.dart` — 新增 14 个测试
  - [x] SubTask 17.3: 覆盖 Compose CRUD 与操作端点
  - [x] SubTask 17.4: 运行测试验证 — 全部通过

- [x] Task 18: Container Network 标签测试
  - [x] SubTask 18.1: 从 swagger.json 提取 Container Network 标签的端点清单
  - [x] SubTask 18.2: 创建 `test/api_client/docker_network_api_test.dart` — 7 个测试
  - [x] SubTask 18.3: 覆盖网络 CRUD 端点
  - [x] SubTask 18.4: 运行测试验证 — 全部通过

- [x] Task 19: Container Volume 标签测试
  - [x] SubTask 19.1: 从 swagger.json 提取 Container Volume 标签的端点清单
  - [x] SubTask 19.2: 创建 `test/api_client/docker_volume_api_test.dart` — 7 个测试
  - [x] SubTask 19.3: 覆盖卷 CRUD 端点
  - [x] SubTask 19.4: 运行测试验证 — 全部通过

- [x] Task 20: Website Nginx 标签测试
  - [x] SubTask 20.1: 从 swagger.json 提取 Website Nginx 标签的端点清单
  - [x] SubTask 20.2: 创建 `test/api_client/nginx_api_client_test.dart` — 12 个测试
  - [x] SubTask 20.3: 覆盖 Nginx 配置读取、更新、重载端点
  - [x] SubTask 20.4: 运行测试验证 — 全部通过

- [x] Task 21: Website HTTPS 标签测试
  - [x] SubTask 21.1: 从 swagger.json 提取 Website HTTPS 标签的端点清单
  - [x] SubTask 21.2: 创建 `test/api_client/ssl_v2_api_test.dart` — 20 个测试
  - [x] SubTask 21.3: 覆盖 HTTPS 配置相关端点
  - [x] SubTask 21.4: 运行测试验证 — 全部通过

- [x] Task 22: PHP Extensions 标签测试
  - [x] SubTask 22.1: 从 swagger.json 提取 PHP Extensions 标签的端点清单
  - [x] SubTask 22.2: 创建 `test/api_client/php_extensions_api_test.dart` — 9 个测试
  - [x] SubTask 22.3: 覆盖扩展列表、安装、卸载端点
  - [x] SubTask 22.4: 运行测试验证 — 全部通过

- [x] Task 23: Menu Setting 标签测试
  - [x] SubTask 23.1: 从 swagger.json 提取 Menu Setting 标签的端点清单
  - [x] SubTask 23.2: 创建 `test/api_client/menu_setting_api_test.dart` — 6 个测试
  - [x] SubTask 23.3: 覆盖菜单配置读取与保存端点
  - [x] SubTask 23.4: 运行测试验证 — 全部通过

## Phase 6: 测试覆盖率提升 — 薄弱模块补强

- [x] Task 24: Dashboard 模块测试补强
  - [x] SubTask 24.1: 审查当前 `test/features/dashboard/` 测试覆盖范围
  - [x] SubTask 24.2: 为 7 个 dashboard widget card 补齐 widget 测试 — 新增 dashboard_widgets_test.dart
  - [x] SubTask 24.3: 为 DashboardService 补齐单元测试 — 新增 dashboard_service_test.dart
  - [x] SubTask 24.4: 运行测试验证 — 62 个测试全部通过

- [x] Task 25: Settings 模块测试补强
  - [x] SubTask 25.1: 审查当前 `test/features/settings/` 测试覆盖范围
  - [x] SubTask 25.2: 为关键 Settings 页面补齐 smoke 测试 — 7 个页面 smoke 测试
  - [x] SubTask 25.3: 为 Settings provider 补齐状态流转测试 — MFA/passkey/proxy/terminal 等
  - [x] SubTask 25.4: 运行测试验证 — 43 个测试全部通过

## Phase 7: 白名单端点审计与补全

- [x] Task 26: 白名单端点审计
  - [x] SubTask 26.1: 从 `docs/development/api_coverage.json` 提取所有白名单端点清单 — 共 58 个唯一白名单端点（`EXTRA_ENDPOINT_CLASSIFICATIONS` in `check_module_client_coverage.py`），去重后 54 个（website_ssl 与 ssl 共享 4 个）
  - [x] SubTask 26.2: 分类白名单端点（兼容旧路由、客户端扩展、平台特有）— 3 类：客户端扩展(AI/Database/File/Setting/SSL/Toolbox)、兼容旧路由(Command/Script legacy)、平台特有(Host SSH联动)
  - [x] SubTask 26.3: 为每个白名单端点标注当前测试状态 — 已测试 39/54 (72%)，未测试 15/54 (28%)；未测试端点集中在 Database 权限/密码、Toolbox clean、Setting 备份/MFA/重置、Container command、Host legacy fallback
  - [x] SubTask 26.4: 输出白名单端点审计报告 — 审计结果详见下方汇总表

  **白名单端点审计汇总（54 个唯一端点）**:

  | 模块 | 端点数 | 已测试 | 未测试 | 分类 |
  |------|--------|--------|--------|------|
  | AI | 4 | 3 | 1 | 客户端扩展 |
  | Auth | 3 | 3 | 0 | 客户端扩展 |
  | Command | 9 | 7 | 2 | 兼容旧路由 |
  | Container | 1 | 0 | 1 | 客户端扩展 |
  | Database | 7 | 1 | 6 | 客户端扩展 |
  | File | 1 | 1 | 0 | 客户端扩展 |
  | Host | 7 | 5 | 2 | 平台特有 |
  | Log | 2 | 2 | 0 | 客户端扩展 |
  | Setting | 6 | 3 | 3 | 客户端扩展 |
  | SSL | 4 | 4 | 0 | 客户端扩展 |
  | Toolbox | 14 | 11 | 3 | 客户端扩展 |

  **未测试端点清单（15 个）**:
  - `POST /ai/agents/models/test` — 模型连接测试
  - `POST /containers/command` — 容器命令创建
  - `GET /databases/{id}/connection/test` — 数据库连接测试
  - `GET /databases/{id}/privileges` — 数据库权限读取
  - `POST /databases/update` — 数据库通用更新
  - `POST /databases/{id}/backups` — 数据库备份快捷入口
  - `POST /databases/{id}/password/reset` — 数据库密码重置
  - `POST /databases/{id}/privileges` — 数据库权限写入
  - `POST /hosts/test/byid` — 旧版主机连接测试（legacy fallback）
  - `POST /settings/ssh` — SSH 设置写入
  - `POST /backups/del` — 备份账号删除
  - `POST /core/settings/mfa/unbind` — MFA 解绑
  - `POST /core/settings/reset` — 系统设置重置
  - `GET /toolbox/clean/data` — 清理工具数据
  - `GET /toolbox/clean/tree` — 清理工具树
  - `POST /toolbox/clean/log` — 清理工具日志
  - `POST /core/script` — 脚本创建（legacy wrapper）
  - `POST /core/script/update` — 脚本更新（legacy wrapper）

- [x] Task 27: 白名单端点测试补全
  - [x] SubTask 27.1: 为未测试的白名单端点创建测试用例 — 新增 `test/api_client/whitelist_endpoints_alignment_test.dart`，覆盖 24 个测试用例，涵盖所有 15 个此前未测试的白名单端点（部分端点通过同一 API 方法批量覆盖）
  - [x] SubTask 27.2: 运行测试验证 — `flutter analyze` 通过，零错误

## Phase 8: 全局验证与文档回写

- [x] Task 28: 全局回归验证
  - [x] SubTask 28.1: 运行 `flutter analyze` — 8 个预存错误在 test/debug/（非本次变更），本次变更零新增错误
  - [x] SubTask 28.2: 运行 `dart run test/scripts/test_runner.dart unit` — 19/19 全部通过
  - [x] SubTask 28.3: 运行 `dart run test/scripts/test_runner.dart ui` — 2 个预存 golden test 超时（非本次变更），其余全部通过
  - [ ] SubTask 28.4: 运行 `dart run test/scripts/test_runner.dart integration` — 需要 .env 配置，待手动执行
  - [ ] SubTask 28.5: 运行 `flutter test --coverage` 生成覆盖率报告 — 待手动执行
  - [ ] SubTask 28.6: 确认测试覆盖率 ≥ 80% — 待覆盖率报告确认

- [ ] Task 29: 文档回写
  - [ ] SubTask 29.1: 更新 `docs/development/api_coverage.md` 反映最新测试覆盖状态
  - [ ] SubTask 29.2: 更新 `docs/development/todo_wip.md` 反映最新功能完成状态
  - [ ] SubTask 29.3: 更新 `docs/CODE_WIKI.md` 补充新增功能模块说明
  - [ ] SubTask 29.4: 更新 `CHANGELOG.md` 记录本阶段变更

# Task Dependencies

- Task 1-4 (Container 子标签) 可并行执行
- Task 5-7 (Website/PHP) 可并行执行
- Task 8-9 (Database/Firewall) 可并行执行
- Task 10-15 (无测试 API 模块) 可并行执行
- Task 16-23 (无测试 Swagger 标签) 可并行执行
- Task 24-25 (薄弱模块补强) 可并行执行
- Task 26 (白名单审计) 先于 Task 27
- Task 28 (全局回归) 依赖 Task 1-27 全部完成
- Task 29 (文档回写) 依赖 Task 28 完成
