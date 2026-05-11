# 主机管理模块索引

## 模块定位

主机管理在 Phase 1 被拆成主机资产、SSH、Process 三段推进。Week 2 仅交付主机资产主链路，SSH 与 Process 保留到后续周。

## 子模块结构

| 子模块 | 端点 | 数据结构 | 说明 |
|--------|------|----------|------|
| 主机列表 | `POST /core/hosts/search` | `HostSearchRequest` / `HostInfo[]` | `HostAssetsProvider` 维护搜索、分组、选择态、四态 |
| 主机详情 | `POST /core/hosts/info` | `HostInfo` | `HostAssetService.fromHostInfo` 回填表单 |
| 主机操作 | `POST /core/hosts`, `POST /core/hosts/update`, `POST /core/hosts/del` | `HostOperate` / `ids` | 创建、编辑、删除 |
| 连接测试 | `POST /core/hosts/test/byinfo`, `POST /core/hosts/test/byid/:id` | `HostConnTest` / `bool` | 表单即时测试与保存后测试 |
| 分组移动 | `POST /core/hosts/update/group` | `HostGroupChange` | 列表卡片移动分组 |
| 树形数据 | `POST /core/hosts/tree` | `HostTreeNode[]` | 为后续联动链路保留 |

## 已有落地

- `HostAssetsPage`
  - 搜索框、分组筛选、刷新
  - 卡片式列表，支持 `edit / test / delete / move group`
  - 批量删除与二次确认
- `HostAssetFormPage`
  - 基础信息、认证方式、连接验证三段结构
  - 测试成功后才允许保存
- `HostAssetsProvider`
  - 维护 `HostSearchRequest`
  - 维护会话内 `last test status`
- `HostAssetService`
  - 封装 Base64 编码前的业务调用与 `HostInfo -> HostOperate` 映射

## 接口对齐说明

1. `POST /core/hosts`：创建主机
2. `POST /core/hosts/update`：更新主机
3. `POST /core/hosts/del`：删除主机
4. `POST /core/hosts/search`：Week 2 主列表真值
5. `POST /core/hosts/info`：详情回填
6. `POST /core/hosts/tree`：保留能力，当前 UI 不依赖其渲染列表
7. `POST /core/hosts/test/byid/:id`：按 ID 测试连接
8. `POST /core/hosts/test/byinfo`：按表单信息测试连接
9. `POST /core/hosts/update/group`：更新分组

## Swagger-客户端覆盖状态

- 覆盖状态: aligned（含白名单）
- 测试覆盖: API 测试通过
- 双轨状态: N/A

### 额外端点白名单（7 个）

| 端点 | 原因分类 | 保留原因 |
|------|---------|---------|
| `GET /settings/ssh/conn` | SSH 设置共用 | SSH 连接配置读取，当前由主机/SSH 设置共用；归属后续收口到 ssh/setting |
| `POST /settings/ssh` | SSH 设置共用 | SSH 设置写入，当前由主机/SSH 设置共用；归属后续收口到 ssh/setting |
| `POST /settings/ssh/check/info` | SSH 设置共用 | SSH 表单即时校验；归属后续收口到 ssh/setting |
| `POST /settings/ssh/conn/default` | SSH 设置共用 | SSH 默认连接配置写入；归属后续收口到 ssh/setting |
| `POST /core/hosts/test/byid/{var}` | 双路由测试 | 真实主机连接测试路由；当前 OpenAPI 归一化结果未命中，客户端以真实 API 为准 |
| `POST /hosts/test/byid` | 双路由测试 | 旧版主机连接测试兼容回退；真实 core 路径失败时才使用 |
| `POST /toolbox/fail2ban/operate/sshd` | fail2ban 联动 | SSH 安全联动 fail2ban；归属后续收口到 toolbox/ssh 安全子模块 |

### 双路由回退策略

主机连接测试存在双路由共存：
- 主路由: `POST /core/hosts/test/byid/{id}` - 真实 API 路径
- 回退路由: `POST /hosts/test/byid` - 旧版兼容路径

客户端优先使用主路由，主路由失败时回退到旧版路径。退出窗口为 6-12 个月，届时服务端完成路由归一化后移除回退路由。

## 后续计划

1. Week 3 在当前主机资产基座上继续补 SSH 与 Process
2. 后续再评估是否复用 `/core/hosts/tree` 承接更多 host 选择场景
3. 6-12 个月内完成双路由归一化，移除 `/hosts/test/byid` 回退

---
**文档版本**: 3.0
**最后更新**: 2026-05-08
