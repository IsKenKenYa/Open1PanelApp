# 网站配置管理模块架构设计

## 模块目标

- 适配 Open1PanelApp 作为 1Panel Linux 运维面板社区版的定位
- 提供完整的Nginx配置管理能力
- 支持PHP扩展安装和管理
- 提供配置备份和恢复功能
- 统一配置管理与错误反馈

## 功能完整性清单

基于 1PanelV2OpenAPI.json，网站配置管理模块共包含 9 个端点:

### Nginx配置 (4端点)
1. GET /website/nginx/config - 获取Nginx配置
2. POST /website/nginx/config/update - 更新Nginx配置
3. POST /website/nginx/config/validate - 验证Nginx配置
4. POST /website/nginx/config/backup - 备份Nginx配置

### PHP扩展 (4端点)
1. GET /php/extensions - 获取PHP扩展列表
2. POST /php/extensions/install - 安装PHP扩展
3. POST /php/extensions/uninstall - 卸载PHP扩展
4. GET /php/extensions/status - 获取扩展状态

### PHP版本 (1端点)
1. POST /website/php/version - 切换PHP版本

## 业务流程与交互验证

### Nginx配置流程
- 进入Nginx配置页面
- 查看当前配置
- 编辑配置内容
- 验证配置语法
- 保存并重载配置

### PHP扩展管理流程
- 进入PHP扩展页面
- 查看已安装扩展列表
- 选择需要安装的扩展
- 执行安装操作
- 验证安装结果

### PHP版本切换流程
- 进入网站配置页面
- 选择PHP版本
- 确认切换操作
- 验证网站运行状态

## 关键边界与异常

### Nginx配置异常
- 配置语法错误的处理
- 配置重载失败的处理
- 配置冲突的处理

### PHP扩展异常
- 扩展安装失败
- 扩展依赖缺失
- 扩展版本冲突

### PHP版本异常
- 版本切换失败
- 网站不兼容
- 服务重启失败

## 模块分层与职责

### 前端
- UI页面: Nginx配置编辑器、PHP扩展列表、版本选择器
- 状态管理: 配置缓存、扩展状态

### 服务层
- API适配: OpenrestyV2Api
- 数据模型: NginxConfig, PHPExtension等

## 数据流

1. 用户编辑 -> 配置验证 -> API请求
2. API响应 -> 配置更新 -> 服务重载
3. 重载结果 -> 状态确认 -> 用户反馈
4. 扩展安装 -> 进度监控 -> 安装完成

## 与现有实现的差距

- Nginx配置编辑器缺失
- PHP扩展管理页面缺失
- 配置验证功能缺失

## 评审记录

| 日期 | 评审人 | 结论 | 备注 |
| --- | --- | --- | --- |
| 待定 | 评审人A | 待评审 | |
| 待定 | 评审人B | 待评审 | |

---

**文档版本**: 1.0
**最后更新**: 2026-02-14
