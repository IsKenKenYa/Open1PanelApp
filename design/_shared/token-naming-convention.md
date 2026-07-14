# 1Panel 客户端 Token 命名规范

## 1. 命名格式

```
--op1-{category}-{property}[-{variant}]
```

### Category 分类
| Category | 说明 | 示例 |
|----------|------|------|
| brand | 品牌色 (所有平台共享，禁止覆盖) | --op1-brand, --op1-brand-light |
| semantic | 语义色 (成功/警告/危险/信息) | --op1-success, --op1-danger |
| surface | 表面色 (平台差异化) | --op1-surface, --op1-surface-card |
| material | 材质参数 (平台专属) | --op1-glass-blur, --op1-acrylic-noise-opacity |
| nav | 导航组件尺寸 (平台专属) | --op1-nav-sidebar-width, --op1-nav-tab-height |
| radius | 圆角 (平台差异化) | --op1-radius-sm, --op1-radius-card |
| motion | 动效参数 (平台差异化) | --op1-motion-fast, --op1-easing-spring |
| type | 字体 (平台专属) | --op1-font-family, --op1-font-family-mono |
| glow | 光效 (HarmonyOS 专属) | --op1-glow-color, --op1-glow-spread |
| acrylic | 亚克力 (Windows 专属) | --op1-acrylic-blur, --op1-acrylic-tint-opacity |
| glass | 玻璃 (Apple 专属) | --op1-glass-alpha, --op1-glass-border-alpha |
| reveal | 高亮 (Windows 专属) | --op1-reveal-hover, --op1-reveal-pressed |
| ripple | 水波纹 (HarmonyOS 专属) | --op1-ripple-color, --op1-ripple-duration |

## 2. 共享变量 (不可覆盖)

以下变量在所有平台中保持一致，任何平台的 Token CSS 不得覆盖:

```css
/* 品牌色 */
--op1-brand: #0C9B4B;
--op1-brand-light: #4DB87A;
--op1-brand-dark: #087A3A;
--op1-brand-50: #E8F5EE;
--op1-brand-100: #C8E8D4;
--op1-brand-500: #0C9B4B;
--op1-brand-700: #087A3A;
--op1-brand-900: #055A2B;

/* 语义色 */
--op1-success: #16A34A;
--op1-warning: #F59E0B;
--op1-danger: #DC2626;
--op1-info: #0EA5E9;
```

## 3. 平台专属变量

### Apple Liquid Glass 额外变量
- --op1-glass-* 系列 (blur, saturate, alpha, border-alpha, highlight, shadow)
- --op1-nav-sidebar-width: 260px
- --op1-nav-tab-height: 49px
- --op1-radius-button: 9999px
- --op1-easing-spring

### Windows Fluent 额外变量
- --op1-acrylic-* 系列 (blur, noise-opacity, tint-opacity, luminosity)
- --op1-mica-* 系列 (opacity, blur)
- --op1-reveal-* 系列 (hover, pressed, border)
- --op1-nav-pane-expanded: 320px
- --op1-nav-pane-compact: 48px
- --op1-easing-decelerate / --op1-easing-accelerate / --op1-easing-standard

### HarmonyOS 光场额外变量
- --op1-glow-* 系列 (color, color-intense, spread, blur)
- --op1-ripple-* 系列 (color, duration)
- --op1-nav-tab-height: 56px
- --op1-nav-sidebar-width: 280px
- --op1-nav-statusbar-height: 44px
- --op1-motion-spring
- --op1-refresh-glow

## 4. Variant 后缀规则

| 后缀 | 说明 | 示例 |
|------|------|------|
| -low | 最低层级 | --op1-surface-container-low |
| -high | 最高层级 | --op1-surface-container-high |
| -elevated | 提升层级 | --op1-surface-elevated |
| -intense | 增强版 | --op1-glow-color-intense |
| -foreground | 前景色 | --op1-surface-card-foreground |
| -container | 容器色 | --op1-primary-container |
| -outline | 边框色 | --op1-outline-variant |
| -hover | hover 状态 | --op1-reveal-hover |
| -pressed | pressed 状态 | --op1-reveal-pressed |

## 5. 暗色模式

所有平台必须定义 `.dark {}` 块，覆盖与浅色模式不同的变量:

```css
.dark {
  --op1-surface: /* 平台特有暗色值 */;
  --op1-surface-card: /* ... */;
  --op1-on-surface: /* ... */;
  /* ... 其他需要暗色覆盖的变量 */
}
```

暗色模式不覆盖 brand 系列和 semantic 系列 (这些颜色在两个模式下保持一致)。
