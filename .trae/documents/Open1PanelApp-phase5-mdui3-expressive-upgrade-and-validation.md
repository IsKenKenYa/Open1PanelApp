# Phase 5: MDUI3 Expressive 升级 + 全平台最终验证

## 概述

多平台原生 UI 设计系统的前 4 个阶段（共享规范 5 文档 + Apple 17 文件 + Windows 17 文件 + HarmonyOS 17 文件 = 56 新文件）已全部完成。本计划覆盖最后两个阶段：

- **Phase 5A**: MDUI3 基线升级为 Material Design 3 Expressive 风格（修改 16 文件）
- **Phase 5B**: 4 平台 × 17 文件 = 68 文件的全量结构验证

## 现状

| 平台 | 文件数 | 状态 |
|------|--------|------|
| `_shared/` | 5 份规范文档 | 已完成 |
| `open1panel-mdui3/` | 1 CSS + 15 HTML + 1 .design = 17 | 已完成，待 Expressive 升级 |
| `open1panel-apple-liquidglass/` | 1 CSS + 15 HTML + 1 .design = 17 | 已完成 |
| `open1panel-windows-fluent/` | 1 CSS + 15 HTML + 1 .design = 17 | 已完成 |
| `open1panel-harmonyos-guangchang/` | 1 CSS + 15 HTML + 1 .design = 17 | 已完成 |

**MDUI3 当前 Token 值（需升级）**:

```css
--op1-radius-sm: 10px;     /* → 12px */
--op1-radius-md: 14px;     /* 保持不变 */
--op1-radius-lg: 16px;     /* → 20px */
--op1-radius-card: 16px;   /* → 22px */
--op1-radius-full: 9999px; /* 保持不变 */
/* --op1-radius-button: 9999px; ← 新增（胶囊按钮专用） */
--op1-motion-fast: 150ms;  /* → 200ms */
--op1-motion-normal: 240ms; /* → 300ms */
/* --op1-easing-spring: cubic-bezier(0.175, 0.885, 0.32, 1.275); ← 新增 */
/* --op1-easing-emphasized: cubic-bezier(0.2, 0, 0, 1); ← 新增（减速曲线） */
```

## Phase 5A: MDUI3 Expressive 升级

### 5A-1: 更新 `colors_and_type.css`（1 文件）

**文件**: `design/open1panel-mdui3/colors_and_type.css`

**改动清单**:

```css
/* Radius System — Expressive 升级 */
--op1-radius-sm: 12px;          /* 10px → 12px */
--op1-radius-md: 14px;          /* 不变 */
--op1-radius-lg: 20px;          /* 16px → 20px */
--op1-radius-card: 22px;         /* 16px → 22px */
--op1-radius-full: 9999px;       /* 不变 */
--op1-radius-button: 9999px;     /* 新增：胶囊按钮专用 Token */

/* Motion — Expressive 升级 */
--op1-motion-fast: 200ms;        /* 150ms → 200ms */
--op1-motion-normal: 300ms;      /* 240ms → 300ms */
--op1-motion-slow: 400ms;        /* 新增 */
--op1-easing-spring: cubic-bezier(0.175, 0.885, 0.32, 1.275);  /* 新增 */
--op1-easing-emphasized: cubic-bezier(0.2, 0, 0, 1);           /* 新增 */
```

### 5A-2: 批量更新 15 个 HTML 页面的内联 Token（15 文件）

每个 HTML 页面都包含 `<style id="theme-vars">` 块，其中内联了完整的 CSS 变量集。需要对每个页面做同样的 6 项值变更 + 3 项新增。

**受影响页面列表**:

1. `shell-navigation.html`
2. `dashboard.html`
3. `server-list.html`
4. `container-management.html`
5. `file-manager.html`
6. `database-management.html`
7. `website-management.html`
8. `settings.html`
9. `login-onboarding.html`
10. `terminal.html`
11. `firewall.html`
12. `backup-management.html`
13. `process-monitor.html`
14. `log-viewer.html`
15. `ai-management.html`

**每个页面的改动方式**: 使用 `SearchReplace` 逐一替换 6 个旧值为新值，并在 Motion 区块后新增 3 行。

**具体替换**:
1. `--op1-radius-sm: 10px;` → `--op1-radius-sm: 12px;`
2. `--op1-radius-lg: 16px;` → `--op1-radius-lg: 20px;`
3. `--op1-radius-card: 16px;` → `--op1-radius-card: 22px;`
4. 在 `--op1-radius-full: 9999px;` 后新增一行 `--op1-radius-button: 9999px;`
5. `--op1-motion-fast: 150ms;` → `--op1-motion-fast: 200ms;`
6. `--op1-motion-normal: 240ms;` → `--op1-motion-normal: 300ms;`
7. 在 `--op1-motion-normal` 后新增:
   ```
   --op1-motion-slow: 400ms;
   --op1-easing-spring: cubic-bezier(0.175, 0.885, 0.32, 1.275);
   --op1-easing-emphasized: cubic-bezier(0.2, 0, 0, 1);
   ```

### 5A-3: 按钮样式升级 — 胶囊形状（15 文件页面级）

在完成 Token 值更新后，需检查每个 HTML 页面中的主操作按钮（FilledButton / primary action button），确保:

- 主操作按钮使用 `border-radius: var(--op1-radius-button)` 或直接 `border-radius: 9999px`
- 次要操作按钮保持圆角 `var(--op1-radius-lg)` (20px)
- 危险操作按钮保持红色 + 圆角

由于各页面的按钮 HTML 结构不完全相同，需要逐页检查。使用 Sub-Agent 并行处理。

### 5A-4: 弹性动效升级（15 文件）

为以下交互元素添加 Expressive 弹性动效:

- Toast / Snackbar 出入场: `transition: transform var(--op1-motion-normal) var(--op1-easing-spring)`
- 卡片 hover: `transition: box-shadow var(--op1-motion-fast) var(--op1-easing-emphasized)`
- FAB / 浮动按钮: `transition: transform var(--op1-motion-normal) var(--op1-easing-spring)`
- 模态框/对话框: `transition: opacity var(--op1-motion-normal) var(--op1-easing-emphasized)`

### 5A 执行策略

使用 **5 个并行 Sub-Agent**，每个处理 3 个页面:

| Sub-Agent | 页面 |
|-----------|------|
| Batch 1 | shell-navigation, dashboard, server-list |
| Batch 2 | container-management, file-manager, database-management |
| Batch 3 | website-management, settings, login-onboarding |
| Batch 4 | terminal, firewall, backup-management |
| Batch 5 | process-monitor, log-viewer, ai-management |

每个 Sub-Agent 的任务:
1. 读取目标页面的完整 HTML
2. 执行 6 项 SearchReplace + 3 项新增（Token 升级）
3. 检查主操作按钮并更新为胶囊形状
4. 检查 Toast/Snackbar/Cards 并添加弹性动效
5. 写回文件

`colors_and_type.css` 的升级由主 Agent 直接执行。

## Phase 5B: 全量验证

### 5B-1: 文件数量验证

检查 4 个平台目录，确认各 17 文件:

```
open1panel-mdui3/            → 1 CSS + 15 HTML + 1 .design = 17
open1panel-apple-liquidglass/ → 1 CSS + 15 HTML + 1 .design = 17
open1panel-windows-fluent/    → 1 CSS + 15 HTML + 1 .design = 17
open1panel-harmonyos-guangchang/ → 1 CSS + 15 HTML + 1 .design = 17
_shared/                     → 5 规范文档
总计: 73 文件
```

### 5B-2: HTML 骨架合规检查

对每个 HTML 页面（共 60 个）检查:

| 检查项 | 期望值 |
|--------|--------|
| `<html lang>` | `zh-CN` |
| `<html class>` | `light` |
| `<style id="theme-vars">` | 存在且包含品牌色 `#0C9B4B` |
| Tailwind CDN | `tailwindcss/browser@4` |
| Lucide CDN | `lucide` |
| 3 断点 | 360px / 768px / 1280px (通过 `@media` 或内联 class) |
| light/dark 模式 | `.dark` CSS 规则块存在 |
| 中文文案 | UI 文本为中文 |

### 5B-3: Token 一致性验证

确认每个平台的 CSS 和 HTML 页面中的 Token 值一致:

- MDUI3: `--op1-radius-card: 22px`（升级后）
- Apple: `--op1-glass-blur: 40px`
- Windows: `--op1-acrylic-blur: 30px`
- HarmonyOS: `--op1-glow-color: rgba(12, 155, 75, 0.08)`

### 5B-4: 品牌色验证

确认所有 4 个平台的品牌色一致:
- `--op1-brand: #0C9B4B`
- `--op1-brand-dark: #087A3A`
- `--op1-brand-light: #4DB87A`

### 5B 执行策略

主 Agent 使用 `Grep` 跨目录批量检查关键标记，不使用 Sub-Agent。

## 实施顺序

1. 主 Agent 直接修改 `colors_and_type.css`
2. 并行派发 5 个 Sub-Agent 处理 15 个 HTML 页面
3. 主 Agent 执行 Phase 5B 验证（Grep + Glob 检查）
4. 汇总验证结果并输出最终报告
