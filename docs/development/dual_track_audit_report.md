# 双轨模块审计报告

> 审计日期：Day 20 里程碑
> 审计范围：7 个核心模块 × 3 条 UI 轨道（Dart MDUI3 / Apple SwiftUI / Windows WinUI 3）

---

## 1. Servers（服务器管理）

### 入口语义

| 轨道 | 入口方式 |
|------|---------|
| MDUI3 | 底部导航栏 / 侧边栏第一个 Tab（`ClientModule.servers`），`AppShellPage` 默认首页 |
| iOS | Tab 栏或侧边栏 "Servers" 项，`NavigationView` 导航 |
| macOS | 侧边栏 "Servers" 项，`Table` 视图，工具栏含刷新和添加按钮 |
| Windows | `NavigationView` 左侧 "Servers" 项（Globe 图标），`Frame.Navigate` 跳转 |

**对齐状态：** ✅ 对齐 — 所有轨道均通过侧边栏/Tab 栏进入，入口一致。

### 主流程

| 轨道 | 主流程 |
|------|--------|
| MDUI3 | 服务器列表 → 点击服务器卡片 → `CurrentServerController` 切换当前服务器 → 各模块自动刷新；支持添加/编辑/删除服务器 |
| iOS | 服务器列表（`List` + `InsetGroupedListStyle`）→ 点击切换；无添加/删除入口 |
| macOS | 服务器表格（`Table` + `inset` 样式）→ 右键菜单 Connect/Delete → `confirmationDialog` 确认删除 → `AddServerSheet` 添加服务器；错误通过 `alert` 弹出 |
| Windows | 服务器列表（`ListView`）→ 点击触发 `ConfirmDialog` 确认切换 → `SwitchServerAsync` 执行 → 失败时 `ErrorToast` 提示 |

**对齐状态：** ⚠️ 部分对齐

- iOS 缺少添加/删除服务器功能
- macOS 有完整的 CRUD，但切换服务器无确认对话框
- Windows 有切换确认但无添加/删除

### 错误反馈

| 轨道 | 错误反馈方式 |
|------|-------------|
| MDUI3 | `SnackBar` + 状态栏错误提示 + `ErrorState` 组件 |
| iOS | 无明确错误反馈机制（ViewModel 无 errorMessage 处理） |
| macOS | `alert` 弹窗显示 `viewModel.errorMessage` |
| Windows | `ErrorToast`（`InfoBar` 自动消失 5 秒）+ `ModulePageBase` 的 Error 状态页 |

**对齐状态：** ⚠️ 部分对齐 — iOS 缺少错误反馈。

### 差异与修复项

| 差异 | 优先级 | 说明 |
|------|--------|------|
| iOS 缺少添加/删除服务器 | High | macOS 已实现，iOS 需补齐 |
| iOS 缺少错误反馈 | High | 需增加 `errorMessage` 监听和 `alert` 展示 |
| macOS 切换服务器无确认对话框 | Medium | Windows 已实现 `ConfirmDialog`，macOS 应对齐 |
| Windows 缺少添加/删除服务器 | Medium | 需实现 `AddServerDialog` 和删除确认 |

---

## 2. Files（文件管理）

### 入口语义

| 轨道 | 入口方式 |
|------|---------|
| MDUI3 | 底部导航栏 / 侧边栏 "Files" 项（`ClientModule.files`） |
| iOS | Tab 栏或侧边栏 "Files" 项 |
| macOS | 侧边栏 "Files" 项，`Table` 视图 |
| Windows | `NavigationView` 左侧 "Files" 项（Folder 图标） |

**对齐状态：** ✅ 对齐

### 主流程

| 轨道 | 主流程 |
|------|--------|
| MDUI3 | 文件列表 → 双击/点击目录进入 → `PathBreadcrumb` 面包屑导航 → 上传/下载/新建/删除/重命名/压缩/解压/搜索/排序/权限/属性等完整操作 → 收藏夹/回收站/挂载点/传输管理子页面 |
| iOS | 文件列表（`List`）→ 仅展示文件名/大小/日期，无目录导航交互 |
| macOS | 文件表格（`Table`）→ 右键菜单 Open/Delete → 工具栏 Up/NewFolder/Refresh 按钮 → `sheet` 新建文件夹 |
| Windows | 文件列表（`ListView`）→ 双击目录导航 → 面包屑栏（可点击分段）→ Up 按钮返回上级 |

**对齐状态：** ⚠️ 部分对齐

- iOS 仅有只读列表，无任何导航或操作能力
- macOS 有基本导航和新建文件夹，但缺少上传/下载/重命名/压缩等
- Windows 有导航和面包屑，但缺少文件操作（上传/下载/删除/重命名等）

### 错误反馈

| 轨道 | 错误反馈方式 |
|------|-------------|
| MDUI3 | `SnackBar` + 对话框错误提示 + `ErrorState` 组件 |
| iOS | 无错误反馈 |
| macOS | `alert` 弹窗（ViewModel errorMessage） |
| Windows | `ErrorToast` + `ModulePageBase` Error 状态页 |

**对齐状态：** ⚠️ 部分对齐 — iOS 缺少错误反馈。

### 差异与修复项

| 差异 | 优先级 | 说明 |
|------|--------|------|
| iOS 缺少目录导航交互 | High | 双击/点击目录应触发导航 |
| iOS 缺少所有文件操作 | High | 至少需支持删除、重命名 |
| macOS 缺少上传/下载 | High | 文件管理核心功能缺失 |
| macOS 缺少面包屑导航 | Medium | 当前仅通过工具栏 Up 按钮，缺少路径面包屑 |
| Windows 缺少文件操作 | High | 需实现右键菜单（删除/重命名/压缩等） |
| Windows 缺少上传/下载 | High | 文件管理核心功能缺失 |

---

## 3. Containers（容器管理）

### 入口语义

| 轨道 | 入口方式 |
|------|---------|
| MDUI3 | 侧边栏 "Containers" 项（`ClientModule.containers`），含子导航 Tabs（containers/images/networks/volumes/compose/repos/templates/config） |
| iOS | Tab 栏或侧边栏 "Containers" 项 |
| macOS | 侧边栏 "Containers" 项，`Table` 视图 |
| Windows | `NavigationView` 左侧 "Containers" 项（AllApps 图标） |

**对齐状态：** ✅ 对齐

### 主流程

| 轨道 | 主流程 |
|------|--------|
| MDUI3 | 容器列表 → `ModuleSubnav` 切换子模块 → 容器卡片（状态/操作）→ 创建容器 → 容器详情（日志/统计/配置）→ 镜像/网络/存储卷/Compose 管理 |
| iOS | 容器列表（`List`）→ 仅展示名称/镜像/状态/CPU/内存，无操作交互 |
| macOS | 容器表格（`Table`）→ 右键菜单 Start/Stop/Restart/Delete → `confirmationDialog` 确认删除 → `alert` 错误提示 |
| Windows | 占位页面，仅显示 "Containers" 文本 |

**对齐状态：** ❌ 不对齐

- Windows 完全是占位页面，无任何功能
- iOS 仅有只读列表，无操作能力
- macOS 有基本 CRUD 但缺少子模块切换（images/networks/volumes 等）

### 错误反馈

| 轨道 | 错误反馈方式 |
|------|-------------|
| MDUI3 | `SnackBar` + `ContainersErrorWidget` + 对话框 |
| iOS | 无错误反馈 |
| macOS | `alert` 弹窗（ViewModel errorMessage） |
| Windows | `ModulePageBase` Error 状态页（无实际数据加载） |

**对齐状态：** ⚠️ 部分对齐

### 差异与修复项

| 差异 | 优先级 | 说明 |
|------|--------|------|
| Windows 容器页面为占位 | High | 需实现完整的容器列表和操作 |
| iOS 缺少容器操作 | High | 需增加 Start/Stop/Restart/Delete |
| iOS 缺少错误反馈 | High | 需增加 errorMessage 处理 |
| macOS 缺少子模块导航 | Medium | 需增加 images/networks/volumes/compose 等 Tab |
| macOS 缺少容器创建 | Medium | 需实现创建容器对话框 |
| 所有原生轨道缺少容器详情页 | Medium | 日志/统计/配置等详情页 |

---

## 4. Apps（应用商店）

### 入口语义

| 轨道 | 入口方式 |
|------|---------|
| MDUI3 | 侧边栏 "Apps" 项（`ClientModule.apps`），含子导航（已安装/商店） |
| iOS | Tab 栏或侧边栏 "Apps" 项 |
| macOS | 侧边栏 "Apps" 项，`Table` 视图 |
| Windows | `NavigationView` 左侧 "Apps" 项（Library 图标） |

**对齐状态：** ✅ 对齐

### 主流程

| 轨道 | 主流程 |
|------|--------|
| MDUI3 | `ModuleSubnav` 切换已安装/商店 → 已安装应用列表 → 应用详情/配置 → 应用商店浏览/安装/卸载 |
| iOS | 应用列表（`List`）→ 仅展示名称/版本/状态，无操作交互 |
| macOS | 应用表格（`Table`）→ 右键菜单 Start/Stop/Uninstall → `confirmationDialog` 确认卸载 → `alert` 错误提示 |
| Windows | 占位页面，仅显示 "Apps" 文本 |

**对齐状态：** ❌ 不对齐

- Windows 完全是占位页面
- iOS 仅有只读列表
- macOS 有基本操作但缺少应用商店视图

### 错误反馈

| 轨道 | 错误反馈方式 |
|------|-------------|
| MDUI3 | `SnackBar` + `NoServerSelectedState` + 对话框 |
| iOS | 无错误反馈 |
| macOS | `alert` 弹窗 |
| Windows | `ModulePageBase` Error 状态页（无实际数据加载） |

**对齐状态：** ⚠️ 部分对齐

### 差异与修复项

| 差异 | 优先级 | 说明 |
|------|--------|------|
| Windows 应用页面为占位 | High | 需实现应用列表和操作 |
| iOS 缺少应用操作 | High | 需增加 Start/Stop/Uninstall |
| iOS 缺少应用商店视图 | Medium | 需增加已安装/商店 Tab 切换 |
| macOS 缺少应用商店视图 | Medium | 需增加商店浏览和安装功能 |
| 所有原生轨道缺少应用详情页 | Medium | 配置编辑/日志查看等 |

---

## 5. Websites（网站管理）

### 入口语义

| 轨道 | 入口方式 |
|------|---------|
| MDUI3 | 侧边栏 "Websites" 项（`ClientModule.websites`） |
| iOS | Tab 栏或侧边栏 "Websites" 项 |
| macOS | 侧边栏 "Websites" 项，`Table` 视图 |
| Windows | `NavigationView` 左侧 "Websites" 项（World 图标） |

**对齐状态：** ✅ 对齐

### 主流程

| 轨道 | 主流程 |
|------|--------|
| MDUI3 | 网站列表 → 创建网站流程 → 网站详情（基本配置/域名/路由规则/SSL/安全访问）→ SSL 证书中心 → 配置中心 |
| iOS | 网站列表（`List`）→ 仅展示域名/备注/状态，无操作交互 |
| macOS | 网站表格（`Table`）→ 右键菜单 Start/Stop/Delete → `confirmationDialog` 确认删除 → `alert` 错误提示 |
| Windows | 占位页面，仅显示 "Websites" 文本 |

**对齐状态：** ❌ 不对齐

- Windows 完全是占位页面
- iOS 仅有只读列表
- macOS 有基本 CRUD 但缺少网站详情/配置/SSL 等子页面

### 错误反馈

| 轨道 | 错误反馈方式 |
|------|-------------|
| MDUI3 | `SnackBar` + `WebsiteAsyncStateView` + 对话框 |
| iOS | 无错误反馈 |
| macOS | `alert` 弹窗 |
| Windows | `ModulePageBase` Error 状态页（无实际数据加载） |

**对齐状态：** ⚠️ 部分对齐

### 差异与修复项

| 差异 | 优先级 | 说明 |
|------|--------|------|
| Windows 网站页面为占位 | High | 需实现网站列表和操作 |
| iOS 缺少网站操作 | High | 需增加 Start/Stop/Delete |
| iOS 缺少错误反馈 | High | 需增加 errorMessage 处理 |
| macOS 缺少网站详情页 | Medium | 基本配置/域名/SSL 等子页面 |
| macOS 缺少创建网站流程 | Medium | 需实现网站创建向导 |
| 所有原生轨道缺少 SSL 管理 | Low | 证书中心/SSL 账户等高级功能 |

---

## 6. Monitoring（监控）

### 入口语义

| 轨道 | 入口方式 |
|------|---------|
| MDUI3 | 侧边栏 "Monitoring" 项，`Scaffold` + `AppBar` |
| iOS | Tab 栏或侧边栏 "Monitoring" 项 |
| macOS | 侧边栏 "Monitoring" 项，`GroupBox` + `ResourceRow` |
| Windows | 无独立监控页面（未在 `MainWindow._pageMap` 中注册） |

**对齐状态：** ⚠️ 部分对齐 — Windows 缺少监控入口。

### 主流程

| 轨道 | 主流程 |
|------|--------|
| MDUI3 | 实时指标卡片（CPU/内存/磁盘/负载）→ 时序图表（可展开/折叠）→ IO/网络选择器 → GPU 监控 → 自动刷新 → 设置对话框（刷新间隔/时间范围/数据点/保留期/清理） |
| iOS | 系统使用率列表（CPU/内存/磁盘）→ 负载平均值列表（1/5/15 分钟）→ 自动刷新 |
| macOS | 资源仪表（CPU/内存/磁盘进度条）→ 系统负载（1/5/15 分钟）→ 自动刷新 → 工具栏刷新按钮 |
| Windows | 无 |

**对齐状态：** ❌ 不对齐

- Windows 完全缺失
- iOS 和 macOS 仅有基础指标展示，缺少时序图表和设置
- 所有原生轨道缺少 GPU 监控

### 错误反馈

| 轨道 | 错误反馈方式 |
|------|-------------|
| MDUI3 | `_ErrorView`（图标 + 错误信息 + 重试按钮）+ `SnackBar` |
| iOS | 无错误反馈 |
| macOS | 无错误反馈 |
| Windows | 无 |

**对齐状态：** ❌ 不对齐 — 原生轨道均缺少错误反馈。

### 差异与修复项

| 差异 | 优先级 | 说明 |
|------|--------|------|
| Windows 缺少监控模块 | High | 需新增 MonitoringPage 并注册到导航 |
| iOS 缺少时序图表 | Medium | 需增加 `SwiftUI Charts` 图表展示 |
| macOS 缺少时序图表 | Medium | 需增加 `SwiftUI Charts` 图表展示 |
| iOS/macOS 缺少监控设置 | Medium | 刷新间隔/时间范围/数据点等配置 |
| iOS/macOS 缺少错误反馈 | High | 需增加加载失败提示和重试 |
| 所有原生轨道缺少 GPU 监控 | Low | GPU 利用率/显存/温度 |

---

## 7. Settings（设置）

### 入口语义

| 轨道 | 入口方式 |
|------|---------|
| MDUI3 | 底部导航栏 / 侧边栏 "Settings" 项（`ClientModule.settings`），多级子页面（面板设置/主题/语言/安全/备份/SSL 等） |
| iOS | Tab 栏或侧边栏 "Settings" 项，`Form` + `NavigationView` |
| macOS | 侧边栏 "Settings" 项，`ScrollView` + 分组卡片 |
| Windows | `NavigationView` 左侧 "Settings" 项（Setting 图标） |

**对齐状态：** ✅ 对齐

### 主流程

| 轨道 | 主流程 |
|------|--------|
| MDUI3 | 设置列表 → 面板设置（基本信息/高级选项）→ 主题设置 → 语言设置 → 安全设置 → 备份账户 → SSL 证书 → API Key → 快照 → 升级 → 关于 等 20+ 子页面 |
| iOS | `Form` 分组 → 显示设置（UI 渲染模式 Picker）→ 存储设置（清除缓存）→ 关于（版本/GitHub） |
| macOS | 分组卡片 → 通用（主题/语言/UI 渲染模式/应用锁 Toggle）→ 存储（清除缓存 + 确认对话框）→ 支持反馈（反馈中心/法律/关于 Sheet）→ 应用（服务器管理/GitHub） |
| Windows | 设置列表（分类：Appearance/About/General）→ 布尔设置 `ToggleSwitch` → 非布尔设置文本展示 → `UpdateSettingAsync` 保存 |

**对齐状态：** ⚠️ 部分对齐

- iOS 设置项极少，缺少主题/语言/应用锁等
- macOS 较完整但缺少面板设置/安全/备份/SSL 等
- Windows 仅有基础设置展示和布尔切换

### 错误反馈

| 轨道 | 错误反馈方式 |
|------|-------------|
| MDUI3 | `SnackBar` + 对话框 |
| iOS | 缓存清除结果内联展示（✓/✗ 前缀） |
| macOS | 缓存清除结果内联展示 + `confirmationDialog` 确认 |
| Windows | `ErrorToast`（设置切换失败时）+ Toggle 自动回退 |

**对齐状态：** ✅ 对齐 — 各轨道均有适合平台的错误反馈方式。

### 差异与修复项

| 差异 | 优先级 | 说明 |
|------|--------|------|
| iOS 缺少主题/语言设置 | High | macOS 已实现，iOS 需对齐 |
| iOS 缺少应用锁 | Medium | macOS 已实现 Toggle，iOS 需增加 |
| macOS 缺少面板设置子页面 | Medium | 面板名称/端口/IPv6 等基础配置 |
| Windows 缺少主题/语言设置 | Medium | 需增加 Picker 或下拉选择 |
| Windows 缺少缓存清除 | Medium | 需增加清除缓存按钮和确认对话框 |
| 所有原生轨道缺少安全设置 | Low | API Key/备份/SSL 等高级设置 |

---

## 汇总统计

### 模块对齐总览

| 模块 | 入口语义 | 主流程 | 错误反馈 | 综合评级 |
|------|---------|--------|---------|---------|
| Servers | ✅ | ⚠️ | ⚠️ | ⚠️ 部分对齐 |
| Files | ✅ | ⚠️ | ⚠️ | ⚠️ 部分对齐 |
| Containers | ✅ | ❌ | ⚠️ | ❌ 不对齐 |
| Apps | ✅ | ❌ | ⚠️ | ❌ 不对齐 |
| Websites | ✅ | ❌ | ⚠️ | ❌ 不对齐 |
| Monitoring | ⚠️ | ❌ | ❌ | ❌ 不对齐 |
| Settings | ✅ | ⚠️ | ✅ | ⚠️ 部分对齐 |

### 按优先级排列的修复项

#### High 优先级（功能缺失）

1. **Windows Containers/Apps/Websites 页面为占位** — 需实现完整列表和 CRUD 操作
2. **Windows 缺少 Monitoring 模块** — 需新增页面并注册导航
3. **iOS 所有模块缺少操作交互** — Servers/Files/Containers/Apps/Websites 均为只读列表
4. **iOS 缺少错误反馈机制** — 所有模块均无 errorMessage 处理
5. **iOS Files 缺少目录导航** — 双击/点击目录应触发导航
6. **macOS/iOS Files 缺少上传/下载** — 文件管理核心功能缺失

#### Medium 优先级（功能不完整）

7. **macOS Servers 缺少切换确认对话框** — Windows 已实现，需对齐
8. **macOS/iOS 缺少监控时序图表** — 需增加 Charts 展示
9. **macOS/iOS 缺少监控设置** — 刷新间隔/时间范围等配置
10. **macOS Containers 缺少子模块导航** — images/networks/volumes/compose 等 Tab
11. **macOS/iOS Apps 缺少应用商店视图** — 已安装/商店 Tab 切换
12. **macOS/iOS Websites 缺少详情页** — 基本配置/域名/SSL 子页面
13. **Windows Settings 缺少主题/语言/缓存清除** — 需增加 Picker 和操作按钮

#### Low 优先级（增强功能）

14. **所有原生轨道缺少 GPU 监控** — GPU 利用率/显存/温度
15. **所有原生轨道缺少 SSL 证书管理** — 证书中心/SSL 账户
16. **所有原生轨道缺少安全设置** — API Key/备份等高级设置

### 各轨道完成度评估

| 轨道 | 完成度 | 说明 |
|------|--------|------|
| Dart MDUI3 | ★★★★★ | 全模块完整实现，含 20+ 子页面、对话框、图表 |
| macOS SwiftUI | ★★★☆☆ | 基础 CRUD 已实现，缺少子模块和高级功能 |
| iOS SwiftUI | ★★☆☆☆ | 仅只读列表，缺少操作和错误反馈 |
| Windows WinUI 3 | ★★☆☆☆ | Servers/Files/Settings 有基础实现，其余为占位 |
