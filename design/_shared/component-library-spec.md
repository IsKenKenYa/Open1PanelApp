# 1Panel 客户端 跨平台组件库规范

> 卡片、按钮、输入框、导航、对话框、列表项在各平台的对应组件名和视觉差异。

## 1. 卡片 (Card)

| 平台 | 组件名 | 圆角 | 阴影 | 边框 | 背景 |
|------|--------|------|------|------|------|
| Android MDUI3 | Card / Card.filled | 22px | elevation 0 (border-only) | outlineVariant 1px | surfaceContainerLow |
| Apple Liquid Glass | Glass Card | 22px | 外阴影 0 8px 32px rgba(31,38,135,0.15) | highlight-inset | rgba(255,255,255,0.20) |
| Windows Fluent | Card / Expander | 8px | elevation 2 (subtle) | 1px solid cardStroke | #FFFFFF (Mica layer) |
| HarmonyOS 光场 | 光晕卡片 | 24px | glow box-shadow 0 0 20px | 无 | #FFFFFF |

### 卡片交互状态
| 状态 | Android | Apple | Windows | HarmonyOS |
|------|---------|-------|---------|-----------|
| Hover | 无 (触摸设备) | 微微提升阴影 | Reveal highlight | 光晕扩散 |
| Pressed | ripple + 缩小 | 缩小 0.98 | Reveal pressed | ripple |
| Disabled | opacity 0.38 | opacity 0.4 | opacity 0.4 | opacity 0.4 |

## 2. 按钮 (Button)

| 类型 | Android | Apple | Windows | HarmonyOS |
|------|---------|-------|---------|-----------|
| Primary (主操作) | FilledButton 胶囊 | 品牌色填充胶囊 | AccentButton 扁平 | 品牌色填充胶囊 |
| Secondary (次操作) | FilledTonalButton 胶囊 | Gray 填充胶囊 | DefaultButton | 灰色填充胶囊 |
| Outlined (边框) | OutlinedButton 胶囊 | 系统边框按钮 | OutlineButton | 边框胶囊 |
| Text (文本) | TextButton | 系统文本按钮 | HyperlinkButton | 文本按钮 |
| FAB | 56px 圆形 | 50px 圆形 | 无 (用 CommandBar) | 56px 圆形 |

### 按钮尺寸
| 平台 | Small | Medium | Large |
|------|-------|--------|-------|
| Android | h=32px, font=14 | h=40px, font=14 | h=56px, font=16 |
| Apple | h=30px, font=13 | h=36px, font=15 | h=44px, font=17 |
| Windows | h=28px, font=12 | h=36px, font=14 | h=44px, font=14 |
| HarmonyOS | h=32px, font=14 | h=40px, font=14 | h=52px, font=16 |

### 按钮圆角
| 平台 | 全部按钮 |
|------|---------|
| Android | 9999px (胶囊) |
| Apple | 9999px (胶囊, iOS 26 趋势) |
| Windows | 4px (WinUI3 标准) |
| HarmonyOS | 9999px (胶囊) |

## 3. 输入框 (TextField)

| 平台 | 组件名 | 圆角 | 边框 | 样式 |
|------|--------|------|------|------|
| Android | TextField (Outlined) | 16px | outlineVariant 1px | Material outlined |
| Apple | 系统输入框 | 10px | 无 (glass blur bg) | Liquid Glass 输入框 |
| Windows | TextBox | 4px | 1px solid textStroke | Fluent 标准输入 |
| HarmonyOS | 系统输入框 | 16px | 1px solid | 光场输入框 |

### 输入框状态
| 状态 | 所有平台通用 |
|------|------------|
| Default | border/outline 默认色 |
| Focused | 品牌色 #0C9B4B 边框/光环 |
| Error | #DC2626 红色边框 + 错误提示文字 |
| Disabled | opacity 0.38, cursor: not-allowed |

## 4. 导航 (Navigation)

| 组件 | Android | Apple | Windows | HarmonyOS |
|------|---------|-------|---------|-----------|
| 主导航 | NavigationBar / NavigationRail | TabView / NavigationSplitView | NavigationView | TabBar + 侧滑面板 |
| 次级导航 | Tab / SegmentedButton | Segmented Control | Pivot / Tabs | Tab |
| 面包屑 | Breadcrumb (桌面) | 无 (push 导航) | BreadcrumbBar | 面包屑 |
| 返回 | System back | Cmd+[ / Edge swipe | Backspace | 侧滑返回 |

## 5. 对话框 (Dialog)

| 平台 | 组件名 | 位置 | 圆角 | 按钮排列 | 破坏性操作 |
|------|--------|------|------|---------|-----------|
| Android | AlertDialog | 居中 | 28px | 水平 (取消/确认) | 确认按钮红色 |
| Apple iOS | ActionSheet (底部) / Alert (居中) | 底部/居中 | 自动 | 垂直 | 红色文字 |
| Apple macOS | Sheet / Alert | 居中 | 自动 | 水平 | 红色文字 |
| Windows | ContentDialog | 居中 | 8px | 水平 (关闭/确认) | 确认按钮红色 |
| HarmonyOS | 底部弹窗 (Bottom Sheet) | 底部 | 24px (顶部) | 垂直 | 红色文字 |

## 6. 列表项 (List Item)

| 平台 | 样式 | 高度 | 图标 | 操作 |
|------|------|------|------|------|
| Android | ListTile | 56px | 左侧 40px | 右侧 trailing |
| Apple | List Row | 44px | 左侧 SF Symbol | 右侧 chevron |
| Windows | ListViewItem | 40px | 左侧 24px | 右侧操作 |
| HarmonyOS | ListItem | 56px | 左侧 24px | 右侧操作 |

### 列表分隔线
| 平台 | 样式 |
|------|------|
| Android | Divider (inset 16px) |
| Apple | 行间分割 (系统默认) |
| Windows | Separator (全宽) |
| HarmonyOS | 分割线 (左侧缩进 16px) |

## 7. 状态指示器

| 类型 | Android | Apple | Windows | HarmonyOS |
|------|---------|-------|---------|-----------|
| 在线 | 绿色圆点 8px | SF Symbol checkmark.circle.fill 绿色 | 绿色小圆点 | 绿色圆点 |
| 离线 | 灰色圆点 | SF Symbol xmark.circle 灰色 | 灰色小圆点 | 灰色圆点 |
| 错误 | 红色圆点 | SF Symbol exclamationmark.triangle 红色 | 红色信息栏 | 红色圆点 |
| 加载中 | CircularProgressIndicator | UIActivityIndicatorView | ProgressRing | LoadingProgress |
| 成功 | Green checkmark | SF Symbol checkmark | 绿色 checkmark | 绿色 checkmark |
| 警告 | 黄色/橙色 | SF Symbol exclamationmark.triangle 黄色 | 黄色信息栏 | 橙色提示 |

## 8. Toast/Snackbar

| 平台 | 组件名 | 位置 | 样式 | 持续时间 |
|------|--------|------|------|---------|
| Android | SnackBar | 底部 | 表面容器 + 品牌色操作 | 4s (可滑动关闭) |
| Apple | none (原生无 Toast) | - | 使用 Banner/in-line | - |
| Windows | InfoBar | 顶部/底部 | 表面色 + 关闭按钮 | 可配置 |
| HarmonyOS | Toast | 底部居中 | 半透明 + 光晕 | 2-3s |
