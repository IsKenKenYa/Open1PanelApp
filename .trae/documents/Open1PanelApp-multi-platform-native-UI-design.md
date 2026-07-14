# Open1PanelApp 全平台原生 UI 设计方案

## 概述

为 1Panel Client（Flutter 跨平台服务器管理客户端）创建覆盖 5 个平台原生设计系统的完整 UI 设计。以 MDUI3 为基线，同时规划 Apple Liquid Glass、Windows WinUI3/Fluent、HarmonyOS 光场设计，以及 Android Material 3 Expressive。

设计产出为 `.design` 画布项目群，共 **4 个 `.design` 项目 x 15 个页面 = 60 个 HTML 设计稿**，覆盖手机/平板/桌面全屏幕尺寸。

## 现状分析

### 已有资产
- `design/open1panel-mdui3/` — 10 页 MDUI3 设计（已验证通过）
- 品牌色 `#0C9B4B`，设计 Token 体系完整（`app_design_tokens.dart`）
- 33 个功能模块代码实现
- 4 个原生轨道已有代码基础（macOS/iOS/Windows/HarmonyOS）
- 跨平台治理文档 `cross_platform_ui_governance.md`

### 缺口
- MDUI3 基线缺少 5 页（防火墙/备份/进程/日志/AI）
- 无 Apple Liquid Glass 设计稿
- 无 Windows Fluent 设计稿
- 无 HarmonyOS 光场设计稿
- 无跨平台交互规范对照表
- 无统一图标映射表

## 设计目录结构

```
design/
├── open1panel-mdui3/                    # Phase 1: 补充 5 页 (15 页总计)
├── open1panel-apple-liquidglass/        # Phase 2: Apple 设计 (15 页)
├── open1panel-windows-fluent/           # Phase 3: Windows 设计 (15 页)
├── open1panel-harmonyos-lightfield/     # Phase 4: HarmonyOS 设计 (15 页)
└── _shared/                             # Phase 5: 共享规范
    ├── interaction_patterns.md
    ├── icon_mapping_table.md
    └── screen_content_spec.md
```

## 15 页内容规范（平台无关）

每个平台的 HTML 页面包含相同的业务信息，仅布局/样式/交互因平台而异。

| 页面 | 核心内容 | 关键交互 |
|------|---------|---------|
| 导航壳 | Logo/服务器名/模块入口/主题切换/渲染模式切换 | 各平台导航模式不同 |
| 仪表板 | 服务器状态/CPU内存磁盘网络/快速操作/活动日志/Top进程 | 数据刷新、快速操作触发 |
| 服务器列表 | 服务器卡片(名称/地址/OS/状态)/分组筛选/添加 | 长按操作/右键菜单/hover |
| 容器管理 | 容器列表(状态/镜像/资源占用)/子导航/批量操作 | Swipe/Context Menu |
| 文件管理器 | 面包屑/文件列表/视图切换/上传/多选 | 拖拽/多选/Swipe/右键 |
| 数据库管理 | TabBar(MySQL/PG/Mongo/Redis)/DB卡片/操作 | 右键/长按备份删除 |
| 网站管理 | 网站列表(域名/SSL/类型/状态)/操作 | SSL状态指示 |
| 设置 | 分组列表(通用/安全/服务器/终端/关于)/Switch/Dropdown | 平台特有导航 |
| 登录引导 | 引导轮播/服务器添加/认证 | Passkey/MFA |
| 终端SSH | 全屏终端/语法高亮/会话管理/多标签 | 快捷键/字体缩放 |
| 防火墙 | 开关/端口规则/IP规则/服务标签 | 批量开关/添加规则 |
| 备份管理 | 账户列表/备份记录/恢复/新建 | 拖拽恢复 |
| 进程管理 | 进程列表(PID/CPU/内存)/排序筛选/详情 | 排序/终止进程 |
| 日志查看 | 分类Tab/日志列表/搜索筛选/导出 | 级别筛选/时间范围 |
| AI管理 | Ollama模型/GPU监控/MCP配置/域名代理 | 拉取模型/启停 |

## 各平台设计系统规格

### Android MDUI3 Expressive
- **导航**: Bottom NavigationBar (5项) + Drawer (更多)
- **材质**: 16dp卡片圆角, outlineVariant边框, elevation 0 (border-only)
- **动画**: Spring curves (`cubic-bezier(0.2, 0, 0, 1)`)
- **交互**: 48dp触摸目标, 下拉刷新, Swipe-to-dismiss, Bottom Sheet
- **Token**: 沿用现有 `--op1-*` 变量 + Expressive 新增 (radius-xl: 28px, motion-spring)

### Apple Liquid Glass
- **导航**: macOS NavigationSplitView (260px sidebar); iOS TabView (底部5项)
- **材质**: `backdrop-filter: blur(40px) saturate(180%)`, 半透明背景 0.65 alpha
- **字体**: SF Pro / SF Mono (HTML fallback: system-ui)
- **交互**: macOS trackpad手势/右键/键盘快捷键; iOS edge swipe/长按peek
- **Token**: `--apple-glass-bg`, `--apple-glass-blur`, `--apple-brand: rgba(12,155,75,0.85)`

### Windows WinUI3/Fluent
- **导航**: NavigationView Left模式 (展开320px/折叠48px) + CommandBar
- **材质**: Acrylic (blur+noise), Mica (壁纸采样), Reveal highlight
- **字体**: Segoe UI Variable / Cascadia Code
- **交互**: 右键MenuFlyout, 键盘快捷键(Ctrl+N/F5), 拖放, Reveal hover
- **Token**: `--fluent-acrylic-bg`, `--fluent-navview-compact-width: 48px`

### HarmonyOS 光场设计
- **导航**: 底部 TabBar (5项) + 状态栏 + 侧滑面板
- **材质**: 光晕边缘 `box-shadow: 0 0 20px rgba(12,155,75,0.08)`, 层级阴影
- **字体**: HarmonyOS Sans (HTML fallback: Noto Sans SC)
- **交互**: 侧滑返回, 下拉刷新(光效反馈), 长按菜单, ripple水波纹
- **Token**: `--harmony-light-field-soft`, `--harmony-glow-color`, `--harmony-tabbar-height: 56px`

## 交互模式对照表

| 场景 | Android | iOS | macOS | Windows | HarmonyOS |
|------|---------|-----|-------|---------|-----------|
| 主导航 | BottomBar+Drawer | TabView | NavSplitView | NavView | TabBar+侧滑 |
| 二级导航 | ModuleSubnav Tab | Tab Bar | Sidebar section | Pane tabs | TabBar/侧滑面板 |
| 列表操作 | 长按菜单 | Swipe actions | 右键+hover | 右键MenuFlyout | 长按菜单 |
| 多选 | 长按进入 | Select模式 | Cmd+Click | Ctrl+Click | 长按进入 |
| 快捷操作 | FAB | FAB/BarButton | Toolbar | CommandBar | FAB |
| 刷新 | Pull-to-refresh | Pull-to-refresh | Cmd+R | F5 | 下拉刷新 |
| 返回 | System back | Edge swipe | Cmd+[ | Backspace | 侧滑返回 |
| 搜索 | TopBar | NavSearch | Cmd+F | AutoSuggestBox | 顶部搜索栏 |
| 详情 | Push页面 | Push+Navigate | Push in column | Navigate pane | Push页面 |
| 确认弹窗 | AlertDialog | ActionSheet | Sheet | ContentDialog | 底部弹窗优先 |
| 终端 | 全屏+折叠工具栏 | 全屏 | 多标签分屏 | 多标签分屏 | 全屏+会话管理 |
| 文件操作 | 上下文菜单 | UIActivity | Drag+Drop | Drag+Drop | 上下文菜单 |

## 分阶段实施计划

### Phase 1: 补充 MDUI3 基线 (5页)

在 `design/open1panel-mdui3/` 中新增 5 个 HTML 页面:
- `firewall.html` — 防火墙管理 (开关/端口规则列表/IP规则列表)
- `backup-management.html` — 备份管理 (账户列表/备份记录/恢复)
- `process-monitor.html` — 进程管理 (进程列表/排序/CPU&内存占用)
- `log-viewer.html` — 日志查看 (分类Tab/日志列表/搜索筛选)
- `ai-management.html` — AI管理 (Ollama模型列表/GPU监控/MCP配置)

更新 `open1panel-mdui3.design` JSON 注册 5 个新页面节点。
沿用现有页面结构: Tailwind CSS + Lucide Icons + `--op1-*` CSS变量 + 3断点 + dark mode。

### Phase 2: Apple Liquid Glass (15页)

创建 `design/open1panel-apple-liquidglass/`:
- `tokens/apple_design_tokens.css` — Glass/Vibrancy/SF Pro Token
- 15 个 HTML 页面，每个页面包含:
  - macOS布局 (>=768px): NavigationSplitView sidebar 260px + 内容区
  - iOS布局 (<768px): 底部 TabView 5项 + 内容区
  - Liquid Glass 材质模拟 (backdrop-filter blur + 半透明 + 光泽gradient)
- `.design` 文件注册所有页面节点

### Phase 3: Windows Fluent (15页)

创建 `design/open1panel-windows-fluent/`:
- `tokens/fluent_design_tokens.css` — Acrylic/Mica/Segoe UI Token
- 15 个 HTML 页面，每个页面包含:
  - NavigationView Left模式 (展开320px/折叠48px)
  - CommandBar 顶部操作栏
  - 右键 MenuFlyout 菜单模拟
  - Acrylic/Mica 材质 (backdrop-filter + noise texture)
- `.design` 文件注册所有页面节点

### Phase 4: HarmonyOS 光场设计 (15页)

创建 `design/open1panel-harmonyos-lightfield/`:
- `tokens/harmonyos_design_tokens.css` — 光场/HMSymbol/HarmonyOS Sans Token
- 15 个 HTML 页面，每个页面包含:
  - 状态栏 (时间/信号/电量模拟)
  - 底部 TabBar (5项)
  - 光晕卡片效果 (box-shadow glow)
  - harmony-list 风格列表 + ripple 水波纹
- `.design` 文件注册所有页面节点

### Phase 5: 共享规范文档

创建 `design/_shared/`:
- `interaction_patterns.md` — 跨平台交互模式对照表
- `icon_mapping_table.md` — Material/SF Symbols/Fluent/HMSymbol 图标映射
- `screen_content_spec.md` — 15 页功能内容规范

## 关键设计决策

1. **品牌色跨平台适配**: #0C9B4B 直接用于 Android/Windows/HarmonyOS; Apple Liquid Glass 中使用 rgba(12,155,75,0.85) 适配半透明材质
2. **HTML 近似 vs 原生实现**: HTML 设计稿仅作为视觉参考和交互规范，标注"近似效果"提示; 实际实现使用各平台原生 API
3. **图标占位**: 所有平台使用 Lucide Icons 作为通用占位, 映射表标注各平台应替换为的图标名称
4. **Token 体系独立**: 每个平台的 CSS Token 独立定义, 不互相引用; 共享语义通过品牌色统一
5. **断点统一**: 所有平台共用 3 断点 (Compact 360px / Medium 768px / Expanded 1280px)
6. **暗色模式全覆盖**: 每个页面必须支持 light/dark 切换

## 验证标准

- [ ] MDUI3 15 页全部可渲染
- [ ] Apple 15 页通过 scan-design-directory 验证
- [ ] Windows 15 页通过验证
- [ ] HarmonyOS 15 页通过验证
- [ ] 每个页面包含 3 断点响应式布局
- [ ] 每个页面支持 light/dark 模式
- [ ] 所有 UI 文案为中文
- [ ] 品牌色 #0C9B4B 正确应用
- [ ] 交互模式对照表覆盖 12 种常见场景 x 5 平台
- [ ] 图标映射表覆盖 15 个功能模块 x 4 平台
