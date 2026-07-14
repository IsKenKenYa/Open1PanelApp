# 1Panel 客户端 页面内容规范

> 15 个页面的数据字段、组件类型、操作按钮、空状态/错误状态规范。
> 每个平台使用相同的业务数据，仅布局/样式/交互因平台而异。

## 1. 导航壳 (shell-navigation)
### 核心组件
- 应用 Logo + 名称 "1Panel"
- 当前服务器名称 + 在线状态指示灯 (绿色圆点=在线, 红色=离线, 灰色=未知)
- 导航菜单项 (5 个主模块):
  - 仪表板 (dashboard icon)
  - 容器 (container icon)
  - 文件 (folder icon)
  - 网站 (globe icon)
  - 设置 (settings icon)
- 服务器切换下拉菜单
- 主题切换 (light/dark)
- 渲染模式切换 (原生/MDUI3, 仅桌面平台)

### 数据字段
- 服务器名称: string
- 在线状态: online | offline | unknown
- 当前用户: string
- 版本号: string

## 2. 仪表板 (dashboard)
### 核心组件
- 4 个统计卡片: CPU 使用率、内存使用率、磁盘使用率、网络流量
- 容器运行状态概览 (运行中/已停止/总计)
- 快速操作区: 终端、文件管理、容器管理
- 最近活动日志 (最近 5 条)
- Top 进程列表 (CPU 占用前 5)

### 数据字段
- cpuPercent: number (0-100)
- memPercent: number (0-100)
- diskPercent: number (0-100)
- networkIn: string (如 "12.5 MB/s")
- networkOut: string (如 "3.2 MB/s")
- containerRunning: number
- containerStopped: number
- recentLogs: Array<{time, level, message}>
- topProcesses: Array<{pid, name, cpu, mem}>

### 空状态
- 服务器离线时: 大图标 + "服务器离线" + "请检查网络连接后重试" + 重试按钮

## 3. 服务器列表 (server-list)
### 核心组件
- 搜索栏 (按名称/IP 搜索)
- 分组筛选 (全部/在线/离线)
- 服务器卡片列表:
  - 服务器名称
  - IP 地址 + 端口
  - 操作系统 (Ubuntu 22.04 等)
  - 在线状态指示灯
  - 在线时长
- 添加服务器按钮 (FAB)

### 数据字段
- id: string
- name: string
- host: string
- port: number
- os: string
- status: online | offline
- uptime: string
- lastSync: datetime

### 操作
- 添加服务器 (跳转登录页)
- 编辑服务器信息
- 删除服务器 (确认弹窗)
- 设为默认服务器

## 4. 容器管理 (container-management)
### 核心组件
- 子导航: 全部/运行中/已停止/镜像
- 搜索/筛选栏
- 容器列表/网格视图:
  - 容器名称
  - 镜像名称 (截断)
  - 状态标签 (running=绿色, exited=灰色, error=红色)
  - 端口映射
  - CPU/内存占用
- 批量操作栏 (多选后显示): 启动/停止/重启/删除

### 数据字段
- id: string
- name: string
- image: string
- status: running | exited | error
- ports: Array<string>
- cpu: number
- mem: string
- createdAt: datetime

### 操作
- 启动/停止/重启容器
- 删除容器 (确认弹窗)
- 查看容器日志
- 进入容器终端

## 5. 文件管理器 (file-manager)
### 核心组件
- 面包屑导航路径
- 视图切换 (列表/网格)
- 文件列表:
  - 文件名
  - 大小
  - 修改时间
  - 权限
  - 类型图标 (文件夹/文件/图片/代码等)
- 排序 (名称/大小/时间)
- 上传按钮 (FAB)

### 数据字段
- path: string
- name: string
- size: number
- modifiedAt: datetime
- permissions: string (如 "drwxr-xr-x")
- type: directory | file
- mimeType: string

### 操作
- 上传文件
- 下载文件
- 新建文件夹
- 重命名
- 删除 (确认弹窗)
- 复制/移动
- 搜索文件

## 6. 数据库管理 (database-management)
### 核心组件
- TabBar 分类: MySQL / PostgreSQL / MongoDB / Redis
- 数据库列表:
  - 数据库名称
  - 类型标签
  - 大小
  - 字符集
  - 状态指示灯
- 创建数据库按钮

### 数据字段
- name: string
- type: mysql | postgresql | mongodb | redis
- size: string
- charset: string
- status: online | offline
- connectionCount: number

### 操作
- 创建数据库
- 备份数据库
- 删除数据库 (确认弹窗)
- 连接管理

## 7. 网站管理 (website-management)
### 核心组件
- 搜索/筛选栏
- 网站列表:
  - 域名 (主域名)
  - 网站类型 (WordPress/静态/PHP 等)
  - SSL 状态 (已认证=绿色锁, 未配置=灰色)
  - 运行状态
  - 访问量
- 创建网站按钮

### 数据字段
- id: string
- domain: string
- type: string
- sslStatus: active | inactive
- status: running | stopped
- visits: number
- createdAt: datetime

### 操作
- 创建网站
- 编辑配置
- SSL 证书配置
- 删除网站 (确认弹窗)
- 查看日志

## 8. 设置 (settings)
### 核心组件
- 分组列表:
  - 通用设置: 主题 (light/dark/auto), 语言, 渲染模式
  - 安全设置: MFA 开关, API Key 管理, 自动锁定
  - 服务器设置: 连接超时, 自动重连, 通知设置
  - 终端设置: 字体大小, 主题, 快捷键
  - 关于: 版本信息, 开源许可, 检查更新

### 数据字段
- theme: light | dark | auto
- language: zh-CN | en-US
- renderMode: native | mdui3
- mfaEnabled: boolean
- autoLock: boolean
- connectionTimeout: number (秒)
- terminalFontSize: number
- version: string

### 交互类型
- Toggle Switch (开关)
- Dropdown/Picker (选择)
- Slider (数值)
- 导航跳转 (详情页)

## 9. 登录与引导 (login-onboarding)
### 核心组件
- 引导页 (首次打开):
  - 品牌动画/Logo
  - 功能介绍轮播 (3 页)
  - "开始使用" 按钮
- 登录页:
  - 服务器地址输入框
  - API Key 输入框 (密码模式)
  - "记住密码" 开关
  - "连接" 主按钮
  - 连接测试状态指示
- 添加服务器页:
  - 与登录页相同表单
  - 返回按钮

### 数据字段
- serverUrl: string
- apiKey: string
- rememberPassword: boolean
- connectionStatus: idle | testing | success | failed
- errorMessage: string

### 空状态
- 无服务器: "添加你的第一台服务器" + 添加按钮
- 连接失败: 错误信息 + "重试" + "检查设置"

## 10. 终端 (terminal)
### 核心组件
- 终端模拟器区域 (全屏/大面积)
- 工具栏:
  - 会话标签栏 (多标签)
  - 新建会话按钮
  - 字体大小调节 (+/-)
  - 全屏切换
- 命令输入区
- 输出流显示区 (语法高亮)

### 数据字段
- sessionId: string
- serverId: string
- commandHistory: Array<string>
- output: string
- cursorPosition: {line, col}

### 操作
- 新建会话
- 关闭会话
- 复制文本
- 粘贴文本
- 清屏
- 字体缩放
- 分屏 (macOS/Windows)

## 11. 防火墙管理 (firewall)
### 核心组件
- 总开关 (启用/禁用防火墙)
- TabBar: 端口规则 / IP 规则 / 服务标签
- 规则列表:
  - 端口/协议/来源/动作(允许/拒绝)/备注
- 添加规则按钮

### 数据字段
- enabled: boolean
- rules: Array<{id, port, protocol, source, action, note}>
- services: Array<{name, ports, enabled}>

### 操作
- 开关防火墙
- 添加/编辑/删除规则
- 启用/禁用规则
- 批量操作

## 12. 备份管理 (backup-management)
### 核心组件
- 备份账户列表
- 备份记录列表:
  - 备份名称
  - 备份时间
  - 备份大小
  - 类型 (数据库/文件/系统)
  - 状态 (成功/失败/进行中)
- 新建备份按钮

### 数据字段
- accountName: string
- backupName: string
- backupTime: datetime
- size: string
- type: database | file | system
- status: success | failed | in_progress
- path: string

### 操作
- 新建备份
- 恢复备份 (确认弹窗)
- 删除备份 (确认弹窗)
- 下载备份
- 查看日志

## 13. 进程管理 (process-monitor)
### 核心组件
- 排序/筛选栏 (按 CPU/内存/名称)
- 进程列表:
  - PID
  - 进程名
  - CPU 占用 (百分比条)
  - 内存占用 (MB)
  - 状态
- 排序指示器

### 数据字段
- pid: number
- name: string
- cpu: number (0-100)
- mem: number (MB)
- status: running | sleeping | stopped
- user: string

### 操作
- 排序 (CPU↑/CPU↓/Mem↑/Mem↓/Name)
- 筛选 (按名称搜索)
- 结束进程 (确认弹窗)
- 查看进程详情

## 14. 日志查看 (log-viewer)
### 核心组件
- 分类 Tab: 系统 / 应用 / 安全 / 自定义
- 时间范围筛选器
- 日志列表:
  - 时间戳
  - 级别标签 (INFO=蓝, WARN=黄, ERROR=红, DEBUG=灰)
  - 来源
  - 日志内容
- 搜索栏
- 实时跟踪开关

### 数据字段
- timestamp: datetime
- level: info | warn | error | debug
- source: string
- content: string
- tags: Array<string>

### 操作
- 搜索 (全文搜索)
- 级别筛选
- 时间范围筛选
- 导出日志
- 实时跟踪 (自动刷新)

## 15. AI 管理 (ai-management)
### 核心组件
- Ollama 模型列表:
  - 模型名称
  - 状态 (已安装/可安装)
  - 大小
  - GPU 使用率
- GPU 监控面板:
  - GPU 温度
  - 显存使用率
  - 计算利用率
- MCP 配置列表
- 域名代理配置

### 数据字段
- modelName: string
- installed: boolean
- size: string
- gpuUsage: number
- gpuTemp: number
- vramUsage: number
- computeUsage: number
- mcpServers: Array<{name, url, enabled}>
- proxyDomains: Array<{domain, target}>

### 操作
- 拉取/安装模型
- 卸载模型
- 启动/停止模型
- 配置 MCP 服务器
- 绑定域名代理
