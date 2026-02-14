# 应用管理模块架构设计

## 模块目标

- 适配 Open1PanelApp 作为 1Panel Linux 运维面板社区版的定位
- 提供完整的应用商店浏览、安装、配置、管理能力
- 支持应用生命周期管理（安装、启动、停止、重启、卸载、更新）
- 提供应用详情查看、日志查看、配置编辑功能
- 统一应用状态管理与错误反馈

## 功能完整性清单

基于 1PanelV2OpenAPI.json 的 App 标签共 30 个端点:

### 应用商店
1. GET /apps - 获取应用列表
2. GET /apps/{id} - 获取应用详情
3. POST /apps/search - 搜索应用
4. GET /apps/categories - 获取应用分类
5. GET /apps/recommend - 获取推荐应用

### 应用安装
6. POST /apps/install - 安装应用
7. POST /apps/install/check - 检查安装条件
8. GET /apps/install/params - 获取安装参数
9. POST /apps/install/params/check - 检查安装参数

### 已安装应用管理
10. GET /apps/installed - 获取已安装应用列表
11. GET /apps/installed/{id} - 获取已安装应用详情
12. POST /apps/installed/search - 搜索已安装应用
13. POST /apps/installed/sync - 同步已安装应用

### 应用操作
14. POST /apps/operate - 应用操作（启动/停止/重启）
15. POST /apps/start - 启动应用
16. POST /apps/stop - 停止应用
17. POST /apps/restart - 重启应用
18. POST /apps/reload - 重载应用

### 应用更新
19. POST /apps/update - 更新应用
20. POST /apps/update/check - 检查更新
21. POST /apps/upgrade - 升级应用

### 应用卸载
22. POST /apps/uninstall - 卸载应用
23. POST /apps/uninstall/check - 检查卸载条件

### 应用配置
24. GET /apps/config - 获取应用配置
25. POST /apps/config/update - 更新应用配置
26. POST /apps/config/check - 检查配置

### 应用日志
27. GET /apps/logs - 获取应用日志
28. POST /apps/logs/clean - 清理应用日志

### 其他
29. POST /apps/backup - 备份应用
30. POST /apps/restore - 恢复应用

## 业务流程与交互验证

### 应用商店浏览流程
- 进入应用商店页面
- 显示应用分类和推荐应用
- 支持按分类筛选应用
- 支持搜索应用名称
- 点击应用查看详情

### 应用安装流程
- 在应用详情页点击安装
- 显示安装参数配置页面
- 用户配置安装参数
- 检查安装条件
- 开始安装并显示进度
- 安装完成后跳转到已安装应用列表

### 应用管理流程
- 进入已安装应用列表
- 显示应用状态（运行中/已停止）
- 点击应用查看详情
- 提供启动/停止/重启/卸载操作
- 操作完成后更新状态

### 应用更新流程
- 检查应用是否有更新
- 显示更新日志
- 用户确认更新
- 执行更新并显示进度
- 更新完成后刷新应用信息

### 应用配置流程
- 进入应用详情页
- 点击配置管理
- 显示当前配置
- 用户编辑配置
- 检查配置有效性
- 保存配置并重启应用

## 关键边界与异常

### 安装失败
- 依赖条件不满足时的提示
- 端口冲突的处理
- 磁盘空间不足的提示
- 网络问题导致的下载失败

### 操作失败
- 应用启动失败的诊断
- 应用停止超时的处理
- 配置错误导致的异常
- 权限不足的提示

### 更新问题
- 版本不兼容的提示
- 更新失败的回滚
- 数据迁移的风险提示

### 卸载风险
- 数据丢失的警告
- 依赖应用的检查
- 卸载失败的清理

## 模块分层与职责

### 前端
- UI页面: 应用商店、已安装应用、应用详情、安装向导、配置管理
- 状态管理: 应用列表缓存、安装状态、操作状态

### 服务层
- API适配: AppV2Api
- 数据模型: App、AppInstall、AppConfig、AppStatus等

## 数据流

1. UI触发 -> Provider/Service -> API客户端请求
2. API响应解析 -> 模型映射 -> 状态更新
3. 状态更新 -> UI刷新 -> 用户反馈
4. 长时间操作 -> 进度轮询 -> 状态更新

## 与现有实现的差距

- 应用商店浏览页面缺失
- 应用安装向导未实现
- 应用详情页面不完整
- 应用配置管理功能缺失
- 应用日志查看功能缺失

## 评审记录

| 日期 | 评审人 | 结论 | 备注 |
| --- | --- | --- | --- |
| 待定 | 评审人A | 待评审 | |
| 待定 | 评审人B | 待评审 | |
