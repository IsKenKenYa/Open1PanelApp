# 功能完善与测试覆盖提升 Spec

## Why

30天全链路超级任务清单已完成，API 覆盖率 100%（27 模块全部 aligned）。但功能完善度、测试覆盖率和白名单端点仍有缺口需要收口。当前测试覆盖率为 54%（28/52 标签有测试），多个 P0/P1 模块的功能实现仅达到"API 对齐"但未达到"功能可用"状态。用户明确优先级为：**功能完善 > 测试覆盖率提升 > 白名单端点补全**。

## What Changes

### 功能完善（优先级最高）
- 补齐 Container 子标签功能：Image、Compose、Network、Volume 的 UI 页面与交互流程
- 补齐 Website 子标签功能：Nginx 配置管理、HTTPS 重定向设置
- 补齐 PHP Extensions 管理功能
- 补齐 Menu Setting 功能的测试覆盖
- 完善 Database 模块的用户管理与写操作表单（Phase 2 已批准残留）
- 完善 Firewall 模块的高级链路（forward/filter advance/chain status）

### 测试覆盖率提升
- 为 6 个无测试的 API 模块补齐测试：disk_management_v2、host_tool_v2、terminal_v2、update_v2、user_v2、website_group_v2
- 为 8 个无测试的 Swagger 标签补齐测试：Container Image、Container Compose、Container Network、Container Volume、Website Nginx、Website HTTPS、PHP Extensions、Menu Setting
- 为已有测试但覆盖不足的模块补充用例：Dashboard（7 widget cards 仅 1 provider test）、Settings（17+ pages 仅 5 test files）

### 白名单端点补全
- 审计并记录所有白名单扩展端点（约 53 个）的功能覆盖状态
- 为未测试的白名单端点补充测试

## Impact

- Affected specs: API 覆盖度追踪、模块适配专属工作流、30天全链路超级任务清单后续阶段
- Affected code:
  - `lib/api/v2/` — 6 个未测试 API 模块
  - `lib/features/containers/` — Image/Compose/Network/Volume 子功能
  - `lib/features/websites/` — Nginx/HTTPS 子功能
  - `lib/features/runtimes/` — PHP Extensions 管理
  - `lib/features/settings/` — Menu Setting
  - `lib/features/databases/` — 用户管理与写操作
  - `lib/features/firewall/` — 高级链路
  - `test/` — 测试目录全面扩展

## ADDED Requirements

### Requirement: Container 子标签功能完善

系统 SHALL 提供 Container Image、Compose、Network、Volume 的完整管理功能。

#### Scenario: Container Image 管理
- **WHEN** 用户进入容器管理页面并切换到"镜像"标签
- **THEN** 显示镜像列表，支持拉取、删除、查看详情操作

#### Scenario: Container Compose 管理
- **WHEN** 用户进入容器管理页面并切换到"编排"标签
- **THEN** 显示 Compose 列表，支持创建、启动、停止、删除、查看日志操作

#### Scenario: Container Network 管理
- **WHEN** 用户进入容器管理页面并切换到"网络"标签
- **THEN** 显示网络列表，支持创建、删除、查看详情操作

#### Scenario: Container Volume 管理
- **WHEN** 用户进入容器管理页面并切换到"卷"标签
- **THEN** 显示卷列表，支持创建、删除、查看详情操作

### Requirement: Website 子标签功能完善

系统 SHALL 提供 Nginx 配置管理与 HTTPS 重定向设置功能。

#### Scenario: Nginx 配置管理
- **WHEN** 用户进入网站管理并选择"OpenResty/Nginx"配置入口
- **THEN** 显示 Nginx 配置文件列表，支持查看、编辑、重载操作

#### Scenario: HTTPS 重定向设置
- **WHEN** 用户在网站 SSL 设置中启用 HTTPS 重定向
- **THEN** 配置生效，HTTP 请求自动重定向到 HTTPS

### Requirement: PHP Extensions 管理

系统 SHALL 提供 PHP 扩展的查看与管理功能。

#### Scenario: 查看 PHP 扩展列表
- **WHEN** 用户进入运行时管理并选择 PHP 环境
- **THEN** 显示已安装扩展列表及可用扩展，支持启用/禁用操作

### Requirement: 无测试 API 模块补齐

系统 SHALL 为以下 6 个 API 模块提供完整的单元测试覆盖：
- `disk_management_v2.dart`
- `host_tool_v2.dart`
- `terminal_v2.dart`
- `update_v2.dart`
- `user_v2.dart`
- `website_group_v2.dart`

#### Scenario: API 模块测试通过
- **WHEN** 运行 `flutter test test/api_client/{module}_api_test.dart`
- **THEN** 所有用例通过，覆盖主要请求路径与边界条件

### Requirement: 无测试 Swagger 标签补齐

系统 SHALL 为以下 8 个 Swagger 标签提供测试覆盖：
- Container Image、Container Compose、Container Network、Container Volume
- Website Nginx、Website HTTPS
- PHP Extensions、Menu Setting

#### Scenario: Swagger 标签测试通过
- **WHEN** 运行对应标签的测试文件
- **THEN** 所有用例通过，覆盖 CRUD 主链路与错误路径

### Requirement: Database 用户管理完善

系统 SHALL 提供数据库用户的完整 CRUD 功能。

#### Scenario: MySQL 用户管理
- **WHEN** 用户进入 MySQL 数据库详情并切换到"用户"标签
- **THEN** 显示用户列表，支持创建、授权、删除用户操作

### Requirement: Firewall 高级链路完善

系统 SHALL 提供防火墙高级规则管理功能。

#### Scenario: 端口转发规则
- **WHEN** 用户进入防火墙管理并选择"端口转发"
- **THEN** 显示转发规则列表，支持创建、编辑、删除、启用/禁用操作

## MODIFIED Requirements

### Requirement: API 覆盖率目标
- 当前状态：API 客户端实现 98%（51/52 标签），测试覆盖 54%（28/52 标签）
- 目标状态：测试覆盖 ≥ 80%（≥ 42/52 标签有测试）

### Requirement: 功能完成度目标
- 当前状态：P0 模块 100% API 对齐但 UI 完成度参差不齐
- 目标状态：P0 模块 UI 完成度 ≥ 90%，P1 模块 UI 完成度 ≥ 70%

## REMOVED Requirements

无
