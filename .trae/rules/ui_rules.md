# UI设计规范

## Material Design 3 (MDUI3) 规范

### 核心原则
- **一致性**: 所有UI组件必须遵循Material Design 3设计语言
- **动态色彩**: 使用MDUI3的动态色彩系统(Material You)
- **圆角设计**: 卡片16dp，按钮全圆角
- **阴影层级**: 使用MDUI3的elevation系统

### 组件规范

| 组件类型 | 规范要求 |
|---------|---------|
| 卡片 | `Card` 或 `Card.filled`，圆角 16dp |
| 按钮 | `FilledButton`、`OutlinedButton`、`TextButton` |
| 输入框 | `TextField` + `OutlineInputBorder` |
| 导航 | `NavigationBar`(底部) / `NavigationRail`(侧边) |
| 对话框 | `AlertDialog` 配合 MDUI3 样式 |

### 主题配置
```dart
MaterialApp(
  theme: ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.light,
    ),
  ),
  darkTheme: ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    ),
  ),
);
```

## 平台适配

### iOS平台
- 液态玻璃组件使用原生Swift实现
- 遵循iOS Human Interface Guidelines
- 支持iOS原生滑动手势

### Android平台
- 完全遵循Material Design 3规范
- 支持动态取色(Dynamic Colors)
- 适配Android 12+视觉特性

## 设计资源
- [Material Design 3 官方文档](https://m3.material.io/)
- [Flutter Material 3 指南](https://docs.flutter.dev/ui/design/material)
- [Material 3 Expressive (2025)](https://material.io/blog/material-3-expressive)
