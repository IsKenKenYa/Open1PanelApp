# 网站SSL证书模块架构设计

## 模块目标

- 适配 Open1PanelApp 作为 1Panel Linux 运维面板社区版的定位
- 提供完整的SSL证书管理能力
- 支持证书申请、续期、删除等操作
- 提供CA证书管理和ACME配置
- 统一证书管理与错误反馈

## 功能完整性清单

基于 1PanelV2OpenAPI.json，网站SSL证书模块共包含 24 个端点:

### SSL证书管理 (11端点)
1. GET /website/ssl - 获取SSL证书列表
2. POST /website/ssl - 申请SSL证书
3. POST /website/ssl/update - 更新SSL证书
4. POST /website/ssl/del - 删除SSL证书
5. GET /website/ssl/{id} - 获取证书详情
6. POST /website/ssl/renew - 续期SSL证书
7. POST /website/ssl/verify - 验证SSL证书
8. GET /website/ssl/providers - 获取证书提供商
9. POST /website/ssl/provider - 配置证书提供商
10. GET /website/ssl/auto-renew - 获取自动续期配置
11. POST /website/ssl/auto-renew/update - 更新自动续期配置

### CA证书管理 (7端点)
1. GET /website/ssl/ca - 获取CA证书列表
2. POST /website/ssl/ca - 导入CA证书
3. POST /website/ssl/ca/update - 更新CA证书
4. POST /website/ssl/ca/del - 删除CA证书
5. GET /website/ssl/ca/{id} - 获取CA证书详情
6. POST /website/ssl/ca/trust - 信任CA证书
7. POST /website/ssl/ca/export - 导出CA证书

### ACME配置 (4端点)
1. GET /website/ssl/acme - 获取ACME配置
2. POST /website/ssl/acme - 更新ACME配置
3. GET /website/ssl/acme/accounts - 获取ACME账户
4. POST /website/ssl/acme/account - 添加ACME账户

### HTTPS配置 (2端点)
1. GET /website/ssl/https - 获取HTTPS配置
2. POST /website/ssl/https/update - 更新HTTPS配置

## 业务流程与交互验证

### 证书申请流程
- 进入SSL证书管理页面
- 点击"申请证书"按钮
- 选择证书类型（免费/商业）
- 填写域名和邮箱
- 选择验证方式
- 提交申请
- 等待签发
- 安装证书

### 证书续期流程
- 从证书列表找到即将过期的证书
- 点击"续期"按钮
- 确认续期信息
- 执行续期操作
- 验证证书有效性

### CA证书管理流程
- 进入CA证书管理页面
- 导入CA证书文件
- 配置证书信任状态
- 导出CA证书

### ACME配置流程
- 进入ACME配置页面
- 配置ACME账户
- 设置ACME服务器
- 测试ACME连接

## 关键边界与异常

### 证书申请异常
- 域名验证失败的诊断
- 证书签发超时的处理
- DNS配置错误的提示
- 邮箱验证失败的处理

### 证书续期异常
- 续期失败的处理
- 证书已过期的处理
- 续期冲突的处理

### CA证书异常
- 证书格式错误的处理
- 证书导入失败
- 信任设置失败

## 模块分层与职责

### 前端
- UI页面: 证书列表、证书详情、申请表单、CA管理、ACME配置
- 状态管理: 证书列表缓存、申请状态、续期提醒

### 服务层
- API适配: SslV2Api
- 数据模型: SSLCertificate, CACertificate, ACMEConfig等

## 数据流

1. 用户操作 -> 参数验证 -> API请求
2. API响应 -> 证书状态更新 -> UI刷新
3. 证书申请 -> 签发流程 -> 证书安装 -> 状态确认
4. 证书续期 -> 续期请求 -> 证书更新 -> 用户通知

## 与现有实现的差距

- SSL证书列表页面缺失
- 证书申请流程缺失
- CA证书管理页面缺失
- ACME配置页面缺失

## 评审记录

| 日期 | 评审人 | 结论 | 备注 |
| --- | --- | --- | --- |
| 待定 | 评审人A | 待评审 | |
| 待定 | 评审人B | 待评审 | |

---

**文档版本**: 1.0
**最后更新**: 2026-02-14
