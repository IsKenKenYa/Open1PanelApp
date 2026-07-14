# Open1PanelApp 多平台原生 UI 设计 — 实施计划

## 概述

在已完成 MDUI3 基线 (15 页) 的基础上，创建 Apple Liquid Glass、Windows WinUI3 Fluent、HarmonyOS 光场设计三个平台各 15 个 HTML 设计稿，加上共享规范文档和 MDUI3 Expressive 升级。总计 **新建 68 文件 + 修改 16 文件 = 84 次文件操作**。

## 现状

| 项目 | 状态 | 文件数 |
|------|------|--------|
| MDUI3 | 已完成 (15 HTML + 1 CSS + 1 .design) | 17 |
| Apple Liquid Glass | `.design` 已创建，无页面 | 1 |
| Windows Fluent | 未创建 | 0 |
| HarmonyOS 光场 | 未创建 | 0 |
| 共享规范 | 未创建 | 0 |

## 目标结构

```
design/
├── open1panel-mdui3/                  [已完成，Phase 5B 升级]
├── open1panel-apple-liquidglass/      [Phase 2-3，15 HTML + 1 CSS + 1 .design]
├── open1panel-windows-fluent/         [Phase 3-4，15 HTML + 1 CSS + 1 .design]
├── open1panel-harmonyos-guangchang/   [Phase 4-5，15 HTML + 1 CSS + 1 .design]
└── _shared/                           [Phase 2A，5 个规范文档]
```

## Phase 2: 基础设施 + Apple Liquid Glass

### 2A: 共享规范文档 (5 文件)

创建 `design/_shared/` 下的 5 个规范文档:

| 文件 | 内容 |
|------|------|
| `design-cross-platform-spec.md` | 总纲: 技术栈要求 (Tailwind 4.x + Lucide)、HTML 骨架规范、品牌色 #0C9B4B 不可覆盖、3 断点 (360/768/1280)、light/dark 切换、验证流程 |
| `interaction-matrix.md` | 12 种交互场景 x 5 平台对照矩阵 (主导航/列表操作/多选/刷新/返回/搜索/详情/确认弹窗/终端/文件操作/快捷操作/二级导航)，含 CSS 实现方式 |
| `page-content-spec.md` | 15 个页面的数据字段、组件类型、操作按钮、空状态/错误状态规范 |
| `component-library-spec.md` | 卡片/按钮/输入框/导航/对话框/列表项在各平台的对应组件名和视觉差异 |
| `token-naming-convention.md` | `--op1-{category}-{property}[-{variant}]` 命名规范，品牌色共享规则，平台专属分类 (glass/acrylic/glow) |

### 2B: Apple Token CSS + 导航壳 (2 文件)

1. **`design/open1panel-apple-liquidglass/colors_and_type.css`** — 约 110 个 CSS 变量:

```css
:root {
  /* 品牌色 (与 MDUI3 共享，不可覆盖) */
  --op1-brand: #0C9B4B;
  /* ... 其他 brand 系列 */

  /* Glass 材质 */
  --op1-glass-blur: 40px;
  --op1-glass-saturate: 180%;
  --op1-glass-alpha: 0.65;
  --op1-glass-alpha-elevated: 0.85;
  --op1-glass-border-alpha: 0.20;
  --op1-glass-highlight-inset: 0 1px 2px rgba(255,255,255,0.6);
  --op1-glass-shadow-outer: 0 8px 32px rgba(31,38,135,0.15);

  /* Surface (glass-based) */
  --op1-surface: rgba(255,255,255,0.15);
  --op1-surface-elevated: rgba(255,255,255,0.40);
  --op1-surface-card: rgba(255,255,255,0.20);
  --op1-surface-nav: rgba(255,255,255,0.65);
  --op1-surface-popover: rgba(255,255,255,0.50);

  /* Navigation */
  --op1-nav-sidebar-width: 260px;
  --op1-nav-tab-height: 49px;

  /* Typography (SF Pro) */
  --op1-font-family: system-ui, -apple-system, 'SF Pro Display', sans-serif;
  --op1-font-family-mono: 'SF Mono', ui-monospace, Menlo, monospace;

  /* Radius (iOS 26 胶囊趋势) */
  --op1-radius-sm: 12px;
  --op1-radius-md: 16px;
  --op1-radius-lg: 20px;
  --op1-radius-card: 22px;
  --op1-radius-button: 9999px;

  /* Motion (iOS 弹性) */
  --op1-motion-fast: 200ms;
  --op1-motion-normal: 350ms;
  --op1-easing-spring: cubic-bezier(0.175, 0.885, 0.32, 1.275);
}
.dark {
  --op1-surface: rgba(30,30,30,0.65);
  --op1-surface-elevated: rgba(50,50,50,0.75);
  --op1-surface-card: rgba(40,40,40,0.70);
  --op1-surface-nav: rgba(30,30,30,0.75);
  /* ... */
}
```

2. **`design/open1panel-apple-liquidglass/pages/shell-navigation.html`** — 导航壳:
- macOS (>=768px): NavigationSplitView sidebar 260px, `backdrop-filter: blur(40px) saturate(180%)`, 浮动在内容上方
- iOS (<768px): 底部 TabView 5 项, `tabBarMinimizeBehavior` 滚动折叠
- 品牌色 tint: `rgba(12,155,75,0.85)`
- 侧边栏/TabBar 5 项: 仪表板/容器/网站/数据库/设置
- 深色模式 sidebar 使用 `rgba(30,30,30,0.75)`

### 2C: Apple 剩余 14 页 (并行 3 批)

| 批次 | 页面 |
|------|------|
| Batch 1 | dashboard, server-list, container-management, file-manager, database-management |
| Batch 2 | website-management, settings, login-onboarding, terminal, firewall |
| Batch 3 | backup-management, process-monitor, log-viewer, ai-management |

**每批执行流程**: 读取对应 MDUI3 页面参考 → 应用 Apple Liquid Glass Token → 创建 HTML → `fill-html-head.mjs --replace-head` → 验证

**Apple 页面特殊要求**:
- Dashboard: 数据卡片 glass (blur 20px, alpha 0.20), 图表区避免 glass 保证可读性
- Terminal: 全屏, 顶部 glass 工具栏, macOS 多标签分屏
- File Manager: macOS Drag & Drop, iOS swipe actions
- Login: 全屏玻璃背景, glass icon, 输入框 glass (blur 16px, alpha 0.40)
- Settings: macOS Inspector 面板, iOS Grouped List

## Phase 3: Windows Fluent Token + 导航壳 + 项目创建

### 3A: Windows 项目初始化 (3 文件)

1. **`design/open1panel-windows-fluent/open1panel-windows-fluent.design`** — 15 个 page node

2. **`design/open1panel-windows-fluent/colors_and_type.css`** — 约 120 个 CSS 变量:

```css
:root {
  /* Acrylic 材质 */
  --op1-acrylic-blur: 30px;
  --op1-acrylic-noise-opacity: 0.03;
  --op1-acrylic-tint-opacity: 0.80;

  /* Mica 材质 */
  --op1-mica-opacity: 0.85;
  --op1-mica-blur: 60px;

  /* Reveal Highlight */
  --op1-reveal-hover: rgba(255,255,255,0.08);

  /* Surface */
  --op1-surface: #F3F3F3;
  --op1-surface-card: #FFFFFF;
  --op1-surface-nav: rgba(243,243,243,0.80);

  /* Navigation */
  --op1-nav-pane-expanded: 320px;
  --op1-nav-pane-compact: 48px;

  /* Typography (Segoe UI Variable) */
  --op1-font-family: 'Segoe UI Variable', 'Segoe UI', system-ui, sans-serif;
  --op1-font-family-mono: 'Cascadia Code', 'Consolas', monospace;

  /* Radius (WinUI3 偏小) */
  --op1-radius-sm: 4px;
  --op1-radius-md: 8px;
  --op1-radius-card: 8px;

  /* Motion (Fluent 减弱动效) */
  --op1-motion-fast: 167ms;
  --op1-motion-normal: 250ms;
  --op1-easing-decelerate: cubic-bezier(0, 0, 0, 1);
}
```

3. **`design/open1panel-windows-fluent/pages/shell-navigation.html`** — NavigationView:
- Expanded (1280px): 320px pane, Mica 背景, 品牌色左边框 3px 选中态
- Compact (768px): 48px icon-only, Acrylic 背景, hover tooltip
- 360px: 48px 不变
- CommandBar 顶部操作栏
- Reveal highlight hover 效果
- 右键 MenuFlyout (Acrylic, 8px 圆角)
- Acrylic noise 纹理 (`::before` 伪元素 + SVG noise)

### 3B: Windows 剩余 14 页 (并行 3 批)

| 批次 | 页面 |
|------|------|
| Batch 1 | dashboard, server-list, container-management, file-manager, database-management |
| Batch 2 | website-management, settings, login-onboarding, terminal, firewall |
| Batch 3 | backup-management, process-monitor, log-viewer, ai-management |

**Windows 页面特殊要求**:
- Dashboard: DataGrid/ListView, 8px 圆角, Mica 背景
- Terminal: 多标签分屏, `Cascadia Code` 字体, TabView 控件样式
- File Manager: Drag & Drop + 右键 MenuFlyout, Breadcrumb 导航
- Settings: SettingsCard 分组布局
- 确认弹窗: ContentDialog (居中模态)
- 列表操作: 右键 MenuFlyout, Ctrl+Click 多选

## Phase 4: HarmonyOS 光场 Token + 导航壳 + 项目创建

### 4A: HarmonyOS 项目初始化 (3 文件)

1. **`design/open1panel-harmonyos-guangchang/open1panel-harmonyos-guangchang.design`** — 15 个 page node

2. **`design/open1panel-harmonyos-guangchang/colors_and_type.css`** — 约 100 个 CSS 变量:

```css
:root {
  /* 光场材质 */
  --op1-glow-color: rgba(12,155,75,0.08);
  --op1-glow-color-intense: rgba(12,155,75,0.16);
  --op1-glow-spread: 20px;

  /* Surface (光场融合) */
  --op1-surface: #F1F3F5;
  --op1-surface-card: #FFFFFF;
  --op1-surface-nav: rgba(241,243,245,0.92);

  /* Navigation */
  --op1-nav-tab-height: 56px;
  --op1-nav-sidebar-width: 280px;

  /* Ripple */
  --op1-ripple-color: rgba(12,155,75,0.12);
  --op1-ripple-duration: 400ms;

  /* Typography (HarmonyOS Sans) */
  --op1-font-family: 'HarmonyOS Sans', 'Noto Sans SC', system-ui, sans-serif;
  --op1-font-family-mono: 'HarmonyOS Sans Mono', 'Noto Sans Mono', monospace;

  /* Radius (和谐美学大圆角) */
  --op1-radius-sm: 8px;
  --op1-radius-md: 16px;
  --op1-radius-lg: 24px;
  --op1-radius-card: 24px;

  /* 引力动效 */
  --op1-motion-spring: cubic-bezier(0.34, 1.56, 0.64, 1);
}
```

3. **`design/open1panel-harmonyos-guangchang/pages/shell-navigation.html`** — 导航壳:
- 底部 TabBar (56px), 5 项, spring 弹性切换动效
- 侧滑面板 (280px, `backdrop-filter: blur(20px)`)
- 光晕边缘: `box-shadow: 0 -1px 20px rgba(12,155,75,0.08)`
- 下拉刷新光效: `radial-gradient(circle, rgba(12,155,75,0.15) 0%, transparent 70%)`
- Ripple 水波纹: 所有可点击元素

### 4B: HarmonyOS 剩余 14 页 (并行 3 批)

| 批次 | 页面 |
|------|------|
| Batch 1 | dashboard, server-list, container-management, file-manager, database-management |
| Batch 2 | website-management, settings, login-onboarding, terminal, firewall |
| Batch 3 | backup-management, process-monitor, log-viewer, ai-management |

**HarmonyOS 页面特殊要求**:
- Dashboard: 光晕卡片 (`box-shadow: 0 0 20px rgba(12,155,75,0.08)`)
- Login: 中轴对称布局, 光场融合效果
- Terminal: 全屏, 顶部会话管理栏, 快捷命令面板
- 确认弹窗: 底部弹窗优先, 24px 顶部大圆角
- 列表操作: 长按菜单, swipe actions
- 下拉刷新: 所有列表页, 光效反馈

## Phase 5: MDUI3 Expressive 升级 + 最终验证

### 5A: MDUI3 Expressive 升级 (修改 16 文件)

在 `design/open1panel-mdui3/` 中升级:

| 改动项 | 值变更 |
|--------|--------|
| `--op1-radius-sm` | 10px → 12px |
| `--op1-radius-lg` | 16px → 20px |
| `--op1-radius-card` | 16px → 22px |
| `--op1-radius-button` | 新增 9999px (胶囊按钮) |
| `--op1-motion-fast` | 150ms → 200ms |
| `--op1-easing-spring` | 新增 `cubic-bezier(0.175, 0.885, 0.32, 1.275)` |
| 按钮样式 | 主操作改为胶囊形状 |
| Toast/Snackbar | 弹出动效改弹性过渡 |

修改文件: `colors_and_type.css` + 15 个 HTML 页面。

### 5B: 最终验证

```
scan-design-directory.mjs --all    # 4 x 17 文件 = 68 文件检查
fill-html-head.mjs --validate-all   # HTML 骨架合规检查
```

检查项:
- 4 个平台各 15 pages + 1 CSS + 1 .design
- 每页包含 `<html lang="zh-CN" class="light">`
- 每页包含 `<style id="theme-vars">` + Tailwind CDN + Lucide CDN
- 每页 3 断点响应式 (360/768/1280)
- 每页 light/dark 模式
- 所有 UI 文案为中文
- 品牌色 `#0C9B4B` 正确应用 (未覆盖)

## 交互模式矩阵 (核心 12 场景 x 5 平台)

| 场景 | Android MDUI3 | Apple Liquid Glass | Windows Fluent | HarmonyOS 光场 |
|------|---------------|-------------------|----------------|----------------|
| 主导航 | BottomBar+Drawer | Sidebar/TabView | NavView 320/48px | TabBar+侧滑 |
| 列表操作 | 长按菜单 | Swipe/右键peek | 右键MenuFlyout | 长按/swipe |
| 多选 | 长按进入 | Select模式/Cmd+Click | Ctrl+Click | 长按进入 |
| 刷新 | Pull-to-refresh | Pull/Cmd+R | F5 | 下拉光效 |
| 返回 | System back | Edge swipe/Cmd+[ | Backspace | 侧滑返回 |
| 搜索 | TopBar | NavSearch/Cmd+F | AutoSuggestBox | 顶部搜索栏 |
| 确认弹窗 | AlertDialog | Sheet/ActionSheet | ContentDialog | 底部弹窗优先 |
| 终端 | 全屏+折叠工具栏 | 全屏/多标签 | 多标签分屏 | 全屏+会话管理 |
| 文件操作 | 上下文菜单 | UIActivity/Drag | Drag+MenuFlyout | 上下文菜单 |
| 快捷操作 | FAB | BarButton/Toolbar | CommandBar | FAB |
| 详情页 | Push页面 | Push+Navigate | Navigate pane | Push页面 |
| 二级导航 | ModuleSubnav Tab | Tab Bar/Sidebar section | Pane tabs | TabBar/侧滑面板 |

## 关键设计决策

1. **品牌色跨平台**: 四平台共享 `#0C9B4B`，通过不同 alpha/blend 适配材质
2. **Token CSS 内联**: 每个 HTML 自包含，便于独立渲染 (与 MDUI3 一致)
3. **交互不强行统一**: 各平台遵循原生交互范式 (弹窗/手势/菜单各有不同)
4. **断点统一但布局不同**: 360/768/1280 三断点硬性要求，布局策略按平台差异
5. **图标统一用 Lucide**: 占位图标，映射表标注各平台应替换为的图标名

## Sub-Agent 并行策略总览

| 阶段 | 批次 | 内容 | 并行度 |
|------|------|------|--------|
| 2A | 1 | 5 个共享文档 | 串行 |
| 2B | 1 | Apple Token + 导航壳 | 2 |
| 2C | 3 | Apple 5+5+4 页面 | 5/5/4 |
| 3A | 1 | Windows 项目+Token+导航壳 | 2 |
| 3B | 3 | Windows 5+5+4 页面 | 5/5/4 |
| 4A | 1 | HarmonyOS 项目+Token+导航壳 | 2 |
| 4B | 3 | HarmonyOS 5+5+4 页面 | 5/5/4 |
| 5A | 1 | MDUI3 升级 16 文件 | 5 |
| 5B | 1 | 全量验证 | 串行 |
