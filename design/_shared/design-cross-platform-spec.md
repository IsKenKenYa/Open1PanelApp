# 1Panel 客户端 跨平台设计规范

## 1. 技术栈要求
- HTML5 文档格式: `<html lang="zh-CN" class="light">`
- Tailwind CSS 4.x CDN: `@tailwindcss/browser@4`
- Lucide Icons: `unpkg.com/lucide@latest` + `lucide.createIcons()`
- 内联 CSS Token 变量定义 (每个 HTML 页面自包含)
- 3 个响应式断点:
  - Compact: 360px (手机竖屏)
  - Medium: 768px (平板/小桌面)
  - Expanded: 1280px (桌面)
- light/dark 模式: 通过 `.light`/`.dark` class 在 `<html>` 标签上切换

## 2. HTML 页面骨架
每个 HTML 文件必须包含:
1. `<!DOCTYPE html>`
2. `<html lang="zh-CN" class="light">`
3. `<meta charset="UTF-8">` + `<meta name="viewport" content="width=device-width, initial-scale=1.0">`
4. `<style id="theme-vars">` 内联所有 CSS Token 变量
5. `<script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>`
6. `@theme inline { }` 将 Token 桥接到 Tailwind
7. `<script src="https://unpkg.com/lucide@latest"></script>` + 末尾 `lucide.createIcons()`

## 3. 品牌色体系
四平台共享，任何平台不得覆盖:
- Primary: `#0C9B4B`
- Brand light: `#4DB87A`
- Brand dark: `#087A3A`
- Brand 50: `#E8F5EE`
- Brand 100: `#C8E8D4`
- Brand 500: `#0C9B4B`
- Brand 700: `#087A3A`
- Brand 900: `#055A2B`

## 4. 各平台设计系统
### 4.1 Android MDUI3 Expressive
- 圆角: sm=12px, md=16px, lg=20px, card=22px, button=9999px(胶囊)
- 动效: spring cubic-bezier(0.175, 0.885, 0.32, 1.275), fast=200ms, normal=350ms
- 导航: BottomBar (360px) → NavigationRail (768px/1280px)
- 材质: border-only elevation, 动态色彩

### 4.2 Apple Liquid Glass
- 圆角: sm=12px, md=16px, lg=20px, card=22px, button=9999px
- 动效: iOS spring, fast=200ms, normal=350ms
- 导航: TabView (360px) → NavigationSplitView 260px (768px/1280px)
- 材质: `backdrop-filter blur(40px) saturate(180%)`, 半透明 0.65 alpha
- 字体: `system-ui`, `-apple-system`, `'SF Pro Display'`

### 4.3 Windows WinUI3 Fluent
- 圆角: sm=4px, md=8px, lg=8px, card=8px
- 动效: decelerate cubic-bezier(0,0,0,1), fast=167ms, normal=250ms
- 导航: NavigationView 48px compact → 320px expanded
- 材质: Acrylic (blur+noise), Mica (壁纸采样), Reveal highlight
- 字体: `'Segoe UI Variable'`, `'Segoe UI'`, `system-ui`

### 4.4 HarmonyOS 光场设计
- 圆角: sm=8px, md=16px, lg=24px, card=24px
- 动效: spring cubic-bezier(0.34, 1.56, 0.64, 1), ripple 400ms
- 导航: TabBar 56px + 侧滑面板 280px
- 材质: 光晕 box-shadow glow, ripple 水波纹, 下拉刷新光效
- 字体: `'HarmonyOS Sans'`, `'Noto Sans SC'`, `system-ui`

## 5. 字体回退链
| 平台 | 主字体 | 等宽字体 |
|------|--------|---------|
| Android | `system-ui`, `'Noto Sans SC'` | `ui-monospace`, `monospace` |
| Apple | `system-ui`, `-apple-system`, `'SF Pro Display'` | `'SF Mono'`, `ui-monospace`, `Menlo` |
| Windows | `'Segoe UI Variable'`, `'Segoe UI'`, `system-ui` | `'Cascadia Code'`, `'Consolas'` |
| HarmonyOS | `'HarmonyOS Sans'`, `'Noto Sans SC'`, `system-ui` | `'HarmonyOS Sans Mono'`, `'Noto Sans Mono'` |

## 6. 验证流程
### 自动化验证
- `fill-html-head.mjs --replace-head`: 注入标准 HTML 骨架
- `scan-design-directory.mjs`: 验证目录完整性 (15 pages + 1 CSS + 1 .design)

### 手动验证清单
- [ ] 15 个页面全部存在
- [ ] 每个页面包含 `<html lang="zh-CN" class="light">`
- [ ] 每个页面包含 `<style id="theme-vars">` 块
- [ ] 每个页面包含 Tailwind CDN script
- [ ] 每个页面包含 Lucide CDN script + `lucide.createIcons()`
- [ ] 每个页面支持 3 断点 (360/768/1280)
- [ ] 每个页面支持 light/dark 模式
- [ ] 所有 UI 文案为中文 (品牌名 1Panel 除外)
- [ ] 品牌色 `#0C9B4B` 正确应用
