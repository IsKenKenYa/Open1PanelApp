# 1Panel 客户端 交互模式矩阵

> 12 种常见交互场景 x 5 平台的对照表，含 CSS 实现方式和设计规范。

## 1. 主导航
| 平台 | 模式 | 360px | 768px | 1280px | CSS 关键属性 |
|------|------|-------|-------|--------|-------------|
| Android MDUI3 | BottomBar+Rail+Drawer | BottomBar 5项 | NavigationRail 80px | NavigationRail+展开 | position:fixed bottom-0 |
| Apple Liquid Glass | TabView+NavSplitView | TabView 5项 49px | NavigationSplitView 260px | NavigationSplitView 260px | backdrop-filter:blur(40px) |
| Windows Fluent | NavigationView | 48px icon-only | 48px compact | 320px expanded | left:0; width:var(--nav-width) |
| HarmonyOS 光场 | TabBar+侧滑面板 | TabBar 5项 56px | TabBar+侧滑280px | TabBar+侧滑280px | box-shadow:光晕边缘 |

### 导航切换动效
| 平台 | easing | duration | 说明 |
|------|--------|----------|------|
| Android | cubic-bezier(0.2,0,0,1) | 300ms | M3 标准动画 |
| Apple | cubic-bezier(0.175,0.885,0.32,1.275) | 350ms | iOS 弹性 spring |
| Windows | cubic-bezier(0.8,0,0.2,1) | 250ms | Fluent 标准过渡 |
| HarmonyOS | cubic-bezier(0.34,1.56,0.64,1) | 400ms | 引力弹性 |

## 2. 列表操作
| 平台 | 触发方式 | 呈现形式 | 选中态 |
|------|---------|---------|--------|
| Android | 长按弹出菜单 | 垂直 DropdownMenu | rgba(12,155,75,0.12) 背景 |
| Apple iOS | 左滑 Swipe Action | 底部操作按钮 (操作色/删除色) | 系统蓝/品牌绿 |
| Apple macOS | 右键 Context Menu | NSMenu 风格浮动菜单 | 品牌色左侧指示 |
| Windows | 右键 MenuFlyout | Acrylic 背景 8px 圆角 | 品牌色左边框 3px |
| HarmonyOS | 长按弹出菜单 | 底部弹窗 24px 圆角 | ripple 反馈 |

## 3. 多选
| 平台 | 进入方式 | 选中视觉 | 批量操作位置 |
|------|---------|---------|------------|
| Android | 长按任一列表项 | Checkbox + 品牌色背景 | BottomAppBar |
| Apple iOS | Select 模式 (长按触发) | 蓝色 Checkmark | NavigationBar 右侧 |
| Apple macOS | Cmd+Click | 品牌色背景 + Checkmark | Toolbar |
| Windows | Ctrl+Click | 品牌色半透明背景 | CommandBar |
| HarmonyOS | 长按任一列表项 | Checkbox + ripple | 顶部操作栏 |

## 4. 刷新
| 平台 | 触发方式 | 指示器位置 | 动效特征 |
|------|---------|-----------|---------|
| Android | Pull-to-refresh | 顶部圆形 Spinner | M3 拉伸指示器 |
| Apple | Pull-to-refresh (iOS) / Cmd+R (macOS) | 顶部圆形 Spinner | 系统原生弹性 |
| Windows | F5 键盘 | 顶部进度条 (细线) | Reveal 高亮 |
| HarmonyOS | 下拉刷新 | 顶部光效圆环 | radial-gradient 光圈扩散 |

## 5. 返回
| 平台 | 手势/操作 | 视觉反馈 | CSS 实现 |
|------|----------|---------|---------|
| Android | System back button/gesture | 页面右滑推出 | transform:translateX(100%) |
| Apple iOS | Edge swipe from left | 页面右滑推出 | interactive-pop gesture |
| Apple macOS | Cmd+[ / Back button | navigate back | 页面 fade |
| Windows | Backspace / Alt+Left | navigate back | 页面 slide |
| HarmonyOS | 侧滑返回 (从左边缘) | 页面右滑推出 | transform:translateX(100%) + opacity |

## 6. 搜索
| 平台 | 入口位置 | 交互方式 | 键盘快捷键 |
|------|---------|---------|-----------|
| Android | TopBar 搜索图标 | 全屏 SearchBar | 无 |
| Apple iOS | NavigationBar 搜索图标 | SearchBar 覆盖式 | 无 |
| Apple macOS | Sidebar 顶部 / Cmd+F | 聚焦 SearchField | Cmd+F |
| Windows | NavigationView 顶部 / Ctrl+F | AutoSuggestBox | Ctrl+F |
| HarmonyOS | 顶部搜索栏 | 展开式 SearchBar | 无 |

## 7. 详情页
| 平台 | 导航方式 | 过渡动效 | 层级关系 |
|------|---------|---------|---------|
| Android | push 新页面 | 右滑推入 | Stack navigation |
| Apple iOS | push + NavigationLink | 右滑推入 | UINavigationController |
| Apple macOS | Navigate 在同一列 | fade/侧滑 | NavigationSplitView column |
| Windows | Navigate 新 pane | 滑入 | Frame navigation |
| HarmonyOS | push 新页面 | 右滑推入 | Stack navigation |

## 8. 确认弹窗
| 平台 | 组件名 | 位置 | 圆角 | 按钮排列 |
|------|--------|------|------|---------|
| Android | AlertDialog | 居中 | 28px | 水平 (取消/确认) |
| Apple iOS | ActionSheet / Alert | 底部/居中 | 自动 | 垂直 |
| Apple macOS | Sheet / Alert | 居中 | 自动 | 水平 |
| Windows | ContentDialog | 居中 | 8px | 水平 |
| HarmonyOS | 底部弹窗 (Bottom Sheet) | 底部 | 24px (顶部) | 垂直 |

## 9. 终端
| 平台 | 布局模式 | 工具栏 | 字体 | 分屏 |
|------|---------|--------|------|------|
| Android | 全屏 | 折叠式 BottomBar | 等宽 14px | 不支持 |
| Apple iOS | 全屏 | 顶部 Bar | SF Mono 13px | 不支持 |
| Apple macOS | 窗口/多标签 | 顶部 Toolbar | SF Mono 13px | 水平/垂直分屏 |
| Windows | 窗口/多标签 | TabView + CommandBar | Cascadia Code 14px | 水平/垂直分屏 |
| HarmonyOS | 全屏 | 顶部会话管理栏 | 等宽 14px | 不支持 |

## 10. 文件操作
| 平台 | 上传方式 | 下载方式 | 批量操作 | 分享 |
|------|---------|---------|---------|------|
| Android | FAB/菜单 | 长按菜单下载 | 长按多选 | Android ShareSheet |
| Apple iOS | Share/菜单 | 长按菜单下载 | Select多选 | UIActivityViewController |
| Apple macOS | Drag&Drop/菜单 | Drag&Drop/菜单 | Cmd+Click | Share Menu |
| Windows | Drag&Drop/CommandBar | 右键保存 | Ctrl+Click | Share 弹窗 |
| HarmonyOS | 菜单/FAB | 长按菜单下载 | 长按多选 | 系统分享 |

## 11. 快捷操作 (FAB/BarButton/CommandBar)
| 平台 | 组件 | 位置 | 样式 |
|------|------|------|------|
| Android | FAB (FloatingActionButton) | 右下角 | 56px 圆形, elevation 3, 品牌色 |
| Apple iOS | FAB/BarButton | 右下角/导航栏 | 品牌色胶囊 |
| Apple macOS | Toolbar Button | 窗口 Toolbar | 品牌色圆形 |
| Windows | CommandBar 按钮 | 窗口顶部 | 扁平, Reveal hover |
| HarmonyOS | FAB | 右下角 | 56px 圆形, 光晕阴影 |

## 12. 二级导航
| 平台 | 组件 | 位置 | 切换动效 |
|------|------|------|---------|
| Android | Tab/SegmentedButton | 内容区顶部 | 下划线滑动 |
| Apple iOS | Segmented Control | NavigationBar 下方 | 胶囊滑动 |
| Apple macOS | Segmented Control | Sidebar section / 内容区顶部 | 胶囊滑动 |
| Windows | Pivot/Tab | 内容区顶部 | 下划线滑动 |
| HarmonyOS | Tab | 内容区顶部 | 背景色渐变切换 |

## 附录: 通用交互状态 CSS
所有平台共享以下基础状态定义 (各平台通过 Token 变量覆盖具体值):

### Hover (桌面平台适用)
```css
.interactive:hover {
  background: var(--op1-hover-bg);
  cursor: pointer;
}
```

### Focus (键盘可访问性)
```css
.interactive:focus-visible {
  outline: 2px solid var(--op1-brand);
  outline-offset: 2px;
  border-radius: var(--op1-radius-sm);
}
```

### Active/Pressed
```css
.interactive:active {
  transform: scale(0.98);
  opacity: 0.9;
}
```

### Disabled
```css
.interactive:disabled {
  opacity: 0.38;
  cursor: not-allowed;
}
```
