# Open1PanelApp MDUI3 多屏幕尺寸 UI 设计项目

## 概述

为 1Panel Client (Flutter 跨平台服务器管理客户端) 创建完整的 UI 设计项目。基于 Material Design 3 设计语言，覆盖手机(360-414px)、平板(768-1024px)、桌面(1280-1440px+) 三种屏幕尺寸，支持触控、鼠标、触控板多种交互方式。

设计产出为 `.design` 画布项目，包含 10 个核心页面的 HTML 设计稿，每个页面展示三种断点的响应式布局。

## 现状分析

### 已有设计基础

**品牌色与设计令牌** (`lib/core/theme/app_design_tokens.dart`):
- 品牌色 `#0C9B4B` (绿色)
- 圆角: radiusSm=10, radiusMd=14, radiusLg=20
- 间距: spacingXs=4, spacingSm=8, spacingMd=12, spacingLg=16, spacingXl=24
- 动效: motionFast=150ms, motionNormal=240ms
- 语义色: success=#16A34A, warning=#F59E0B, danger=#DC2626

**主题系统** (`lib/core/theme/app_theme.dart`):
- `useMaterial3: true`，`ColorScheme.fromSeed(seedColor: brand)`
- 桌面端 Card elevation=0，移动端 elevation=1
- NavigationBar/NavigationRail 使用 primaryContainer 指示器
- 按钮统一 radiusMd=14 + minHeight=44

**自适应壳** (`lib/features/shell/app_shell_page.dart`):
- `<600px`: 底部 NavigationBar (4 slot: servers + 2置顶 + settings)
- `600-1023px`: 左侧 NavigationRail
- `>=1024px`: 左侧 Sidebar (264px)

**模块体系**: 8个一级模块 (servers, files, containers, apps, websites, ai, settings, verification)，6个可置顶模块

### 需要设计的核心页面 (10个)

1. Shell/导航壳 — 三断点自适应导航
2. Dashboard — 系统监控概览 (CPU/内存/磁盘/网络)
3. 服务器列表 — 多服务器管理与状态
4. 容器管理 — Docker 容器列表与操作
5. 文件管理器 — 文件浏览与操作
6. 数据库管理 — 多类型数据库列表
7. 网站管理 — 网站列表与 SSL 状态
8. 设置 — 系统配置分组列表
9. 登录/引导 — 服务器连接设置
10. 终端 — SSH 终端界面

## 设计方案

### 设计项目结构

在 `/Volumes/FanXiangMac/MyOpenSource/Open1PanelApp/design/` 下创建 `.design` 画布项目，包含 HTML 页面设计稿。

### 设计令牌 (直接对应 Dart 代码)

| 令牌 | 值 | 对应代码 |
|------|-----|---------|
| 品牌色 | #0C9B4B | AppDesignTokens.brand |
| 卡片圆角 | 16dp | CardTheme borderRadius |
| 按钮圆角 | 14dp | radiusMd |
| 按钮最小高度 | 44px | FilledButtonTheme |
| 卡片内边距 | 16px | pagePadding |
| 导航侧边栏宽 | 264px | ShellSidebarNavigation |
| 卡片边框 | outlineVariant 1px | CardTheme shape |

### 三断点布局策略

| 页面 | Mobile (<600px) | Tablet (600-1023px) | Desktop (>=1024px) |
|------|-----------------|---------------------|---------------------|
| 导航壳 | 底部 NavigationBar | 左侧 NavigationRail | 左侧 Sidebar 264px |
| Dashboard | 单列滚动 | 两列 5:3 | 两列 2:1，max1280 |
| 服务器列表 | 垂直列表 | 双列网格 | 三列网格 |
| 容器管理 | 单列+子导航 | 双列网格 | 三列网格 |
| 文件管理器 | 单列列表 | 双列/列表切换 | 列表+右键菜单 |
| 数据库管理 | TabBar+单列 | TabBar+单列 | 双列网格 |
| 网站管理 | 单列列表 | 双列网格 | 三列网格 |
| 设置 | 分组列表 | 左导航+右内容 | 双栏 max900 |
| 登录 | 居中表单 | 居中表单 Card | 居中表单 Card |
| 终端 | 全屏+折叠工具栏 | 左会话+右终端 | 多标签分屏 |

### 深色模式策略

- 依赖 `ColorScheme.fromSeed(brightness: dark)` 自动生成
- 桌面端 Card 使用半透明 surface (alpha 0.8)
- 终端固定深色背景 #1E1E1E
- 进度条/状态色保持语义一致，增加对比度

## 实施步骤

### Step 1: 创建 .design 项目骨架

创建 `.design` 配置文件和 `colors_and_type.css` 设计令牌文件。

**文件**:
- `design/open1panel-mdui3.design` — 项目元数据
- `design/open1panel-mdui3.design/colors_and_type.css` — 颜色和排版令牌

**内容要点**:
- 颜色令牌: 品牌色 #0C9B4B，MDUI3 ColorScheme 完整色板 (primary, onPrimary, primaryContainer, secondary, surface, surfaceContainerLow, outlineVariant 等)
- 排版: headlineSmall/Medium/Large, titleMedium/Large, bodyMedium/Large, labelMedium/Large
- 间距令牌: 4/8/12/16/24 五级
- 圆角令牌: 10/14/16/20 四级
- 动效令牌: 150ms/240ms

### Step 2: 生成页面设计稿 (并行)

使用 Sub-Agent 并行创建 HTML 页面设计稿。每个页面包含三种断点的响应式布局，使用 CSS media queries 切换。

**页面设计优先级**:

1. `shell-navigation.html` — 自适应导航壳 (三种导航模式演示)
2. `dashboard.html` — 系统监控仪表板 (资源卡片+进度条+快速操作)
3. `server-list.html` — 服务器列表 (状态指示+卡片网格)
4. `container-management.html` — 容器管理 (子导航+状态标签+操作菜单)
5. `file-manager.html` — 文件管理器 (面包屑+文件列表+工具栏)
6. `database-management.html` — 数据库管理 (TabBar+类型图标)
7. `website-management.html` — 网站管理 (SSL状态+域名信息)
8. `settings.html` — 设置页面 (分组列表+开关)
9. `login-onboarding.html` — 登录/引导 (表单+Logo)
10. `terminal.html` — SSH 终端 (全屏终端+会话管理)

**每个页面的 HTML 要求**:
- 使用 `fill-html-head.mjs` 生成 HTML 骨架
- 内联 CSS 或引用 `colors_and_type.css` 令牌
- 三断点响应式: `@media (max-width: 599px)` / `(min-width: 600px) and (max-width: 1023px)` / `(min-width: 1024px)`
- 包含状态变体: 正常态 / 加载态 / 空态 / 错误态
- 中文 UI 文案
- MDUI3 组件: Card (16dp圆角, outlineVariant边框), FilledButton/OutlinedButton, NavigationBar/NavigationRail/Sidebar, Chip, ListTile, ProgressBar

### Step 3: 生成辅助图片资产

为设计稿生成必要的图片资产:
- Dashboard 资源图表占位图 (CPU/内存/磁盘/网络)
- 服务器状态图标 (在线/离线/超时)
- 数据库类型图标 (MySQL/PostgreSQL/MongoDB/Redis)
- SSL 状态图标 (有效/过期/无)
- 终端界面截图占位

### Step 4: 注册 .design 节点

在 `.design` 文件中注册所有页面节点和图片节点:
- 10 个 `type: "page"` 节点，每个指向对应 HTML 文件
- 生成的图片注册为 `type: "image"` 节点

### Step 5: 验证

运行 `scan-design-directory.mjs` 验证:
- `.design` 文件 JSON 格式正确
- 所有页面 HTML 文件存在
- 所有图片资产存在且有对应节点
- 节点 ID 唯一
- devMetadata 完整

## 关键设计决策

1. **以代码令牌为单一事实来源**: 设计稿中的颜色、间距、圆角值严格对应 `app_design_tokens.dart` 中的常量
2. **断点值与代码一致**: 严格使用 `<600` / `600-1023` / `>=1024` 三档
3. **中文为主**: UI 文案使用中文，与 `app_zh.arb` 中的文案对应
4. **MDUI3 优先**: 所有组件遵循 Material Design 3 规范，不引入非标准组件
5. **交互模式按设备分化**: 移动端触控优先 (44px触控区)，桌面端鼠标优先 (hover状态、右键菜单)

## 验证标准

- [ ] `.design` 文件通过 `scan-design-directory.mjs` 验证
- [ ] 10 个页面 HTML 全部可渲染，无白屏
- [ ] 每个页面包含三断点响应式布局
- [ ] 设计令牌与 `app_design_tokens.dart` 值一致
- [ ] 导航壳三种模式 (NavigationBar/NavigationRail/Sidebar) 均有展示
- [ ] 所有页面使用中文 UI 文案
