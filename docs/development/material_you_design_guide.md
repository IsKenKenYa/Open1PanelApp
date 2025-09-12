# 1Panel 移动端APP - Material You Design 3 设计指南

## 1. Material You Design 3 概述

### 1.1 什么是Material You Design 3
Material You Design 3是Google推出的新一代设计系统，它建立在Material Design的基础上，更加注重个性化、动态性和适应性。Material You Design 3允许用户根据自己的壁纸、主题和偏好自定义应用程序的外观和感觉，提供更加个性化和一致的用户体验。

### 1.2 Material You Design 3 的核心原则
- **个性化**：允许用户根据自己的喜好自定义应用外观
- **动态性**：应用外观可以随系统主题和壁纸动态变化
- **适应性**：适应不同设备、屏幕尺寸和用户需求
- **可访问性**：确保所有用户都能使用应用，包括有特殊需求的用户
- **一致性**：在整个应用中保持一致的设计语言和交互模式

### 1.3 为什么选择Material You Design 3
- 提供现代化的用户界面
- 支持动态主题，可以根据用户壁纸自动调整颜色
- 提供更好的可访问性支持
- 与Android系统原生体验保持一致
- 丰富的组件和动画效果

## 2. 色彩系统

### 2.1 动态色彩
Material You Design 3的核心是动态色彩系统，它可以从用户的壁纸中提取主色调，并生成一套协调的色彩方案。在1Panel移动端APP中，我们将利用这一特性，使应用外观与用户设备主题保持一致。

#### 2.1.1 色彩角色
- **Primary**：应用的主要品牌色，用于按钮、选中等状态
- **OnPrimary**：在Primary色彩上显示的文字和图标颜色
- **PrimaryContainer**：主要色彩的容器，用于卡片、对话框等
- **OnPrimaryContainer**：在PrimaryContainer上显示的文字和图标颜色
- **Secondary**：次要色彩，用于辅助按钮、标签等
- **OnSecondary**：在Secondary色彩上显示的文字和图标颜色
- **SecondaryContainer**：次要色彩的容器
- **OnSecondaryContainer**：在SecondaryContainer上显示的文字和图标颜色
- **Tertiary**：第三色彩，用于强调和对比
- **OnTertiary**：在Tertiary色彩上显示的文字和图标颜色
- **TertiaryContainer**：第三色彩的容器
- **OnTertiaryContainer**：在TertiaryContainer上显示的文字和图标颜色
- **Error**：错误色彩，用于错误提示和警告
- **OnError**：在Error色彩上显示的文字和图标颜色
- **ErrorContainer**：错误色彩的容器
- **OnErrorContainer**：在ErrorContainer上显示的文字和图标颜色
- **Background**：背景色彩
- **OnBackground**：在背景上显示的文字和图标颜色
- **Surface**：表面色彩，用于卡片、对话框等
- **OnSurface**：在表面上显示的文字和图标颜色
- **SurfaceVariant**：表面变体色彩
- **OnSurfaceVariant**：在表面变体上显示的文字和图标颜色
- **Outline**：边框和分隔线色彩
- **OutlineVariant**：边框和分隔线变体色彩
- **Shadow**：阴影色彩
- **Scrim**：遮罩色彩
- **InverseSurface**：反转表面色彩
- **InverseOnSurface**：在反转表面上显示的文字和图标颜色
- **InversePrimary**：反转主要色彩

#### 2.1.2 色彩方案实现
在Flutter中，我们可以使用`Material3`和`dynamic_color`包来实现动态色彩：

```dart
import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        return MaterialApp(
          theme: ThemeData(
            colorScheme: lightDynamic ?? ThemeData().colorScheme,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: darkDynamic ?? ThemeData.dark().colorScheme,
            useMaterial3: true,
          ),
          themeMode: ThemeMode.system,
          home: const HomePage(),
        );
      },
    );
  }
}
```

### 2.2 静态色彩
除了动态色彩，我们还需要定义一些静态色彩，用于品牌标识和特定功能：

- **品牌色**：1Panel的品牌色，用于Logo和重要元素
- **状态色**：
  - 成功色：绿色，表示操作成功
  - 警告色：黄色，表示需要注意
  - 错误色：红色，表示错误或失败
  - 信息色：蓝色，表示信息提示

## 3. 排版系统

### 3.1 字体族
Material You Design 3推荐使用Roboto字体作为Android平台的主要字体，iOS平台使用San Francisco字体。在1Panel移动端APP中，我们将遵循这一推荐：

```dart
TextTheme(
  displayLarge: TextStyle(
    fontFamily: 'Roboto',
    fontSize: 57,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
  ),
  displayMedium: TextStyle(
    fontFamily: 'Roboto',
    fontSize: 45,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  ),
  displaySmall: TextStyle(
    fontFamily: 'Roboto',
    fontSize: 36,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  ),
  headlineLarge: TextStyle(
    fontFamily: 'Roboto',
    fontSize: 32,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  ),
  headlineMedium: TextStyle(
    fontFamily: 'Roboto',
    fontSize: 28,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  ),
  headlineSmall: TextStyle(
    fontFamily: 'Roboto',
    fontSize: 24,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  ),
  titleLarge: TextStyle(
    fontFamily: 'Roboto',
    fontSize: 22,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  ),
  titleMedium: TextStyle(
    fontFamily: 'Roboto',
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
  ),
  titleSmall: TextStyle(
    fontFamily: 'Roboto',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  ),
  bodyLarge: TextStyle(
    fontFamily: 'Roboto',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
  ),
  bodyMedium: TextStyle(
    fontFamily: 'Roboto',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
  ),
  bodySmall: TextStyle(
    fontFamily: 'Roboto',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
  ),
  labelLarge: TextStyle(
    fontFamily: 'Roboto',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  ),
  labelMedium: TextStyle(
    fontFamily: 'Roboto',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  ),
  labelSmall: TextStyle(
    fontFamily: 'Roboto',
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  ),
)
```

### 3.2 文字样式使用指南
- **Display**：用于大标题，如欢迎页面、大标题
- **Headline**：用于页面标题、章节标题
- **Title**：用于卡片标题、列表项标题
- **Body**：用于正文内容
- **Label**：用于按钮、标签、表单字段

## 4. 形状系统

### 4.1 形状主题
Material You Design 3引入了形状主题，允许我们为应用定义一套一致的形状语言：

```dart
ShapeTheme(
  small: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(4.0),
  ),
  medium: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8.0),
  ),
  large: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12.0),
  ),
  extraLarge: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16.0),
  ),
)
```

### 4.2 形状使用指南
- **Small**：用于按钮、标签、小卡片
- **Medium**：用于卡片、对话框、列表项
- **Large**：用于大卡片、底部导航栏
- **ExtraLarge**：用于模态对话框、特殊卡片

## 5. 组件设计

### 5.1 导航组件
#### 5.1.1 底部导航栏
底部导航栏是1Panel移动端APP的主要导航方式，我们将使用Material You Design 3的底部导航栏组件：

```dart
BottomNavigationBar(
  items: const [
    BottomNavigationBarItem(
      icon: Icon(Icons.dashboard),
      label: '仪表盘',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.apps),
      label: '应用',
    ),
    BottomNavigationBarItem(
      icon: Icons.storage),
      label: '容器',
    ),
    BottomNavigationBarItem(
      icon: Icons.language),
      label: '网站',
    ),
    BottomNavigationBarItem(
      icon: Icons.more_horiz),
      label: '更多',
    ),
  ],
  currentIndex: _selectedIndex,
  selectedItemColor: Theme.of(context).colorScheme.primary,
  unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
  onTap: _onItemTapped,
)
```

#### 5.1.2 导航抽屉
导航抽屉用于访问次要功能：

```dart
Drawer(
  child: ListView(
    padding: EdgeInsets.zero,
    children: [
      DrawerHeader(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        child: Text(
          '1Panel',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            fontSize: 24,
          ),
        ),
      ),
      ListTile(
        leading: const Icon(Icons.database),
        title: const Text('数据库'),
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/database');
        },
      ),
      ListTile(
        leading: const Icon(Icons.folder),
        title: const Text('文件管理'),
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/files');
        },
      ),
      ListTile(
        leading: const Icon(Icons.backup),
        title: const Text('备份管理'),
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/backup');
        },
      ),
      ListTile(
        leading: const Icon(Icons.settings),
        title: const Text('设置'),
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/settings');
        },
      ),
    ],
  ),
)
```

### 5.2 卡片组件
卡片是Material You Design 3中的重要组件，用于显示相关信息：

```dart
Card(
  elevation: 1,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CPU使用率',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: 0.7,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '70%',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    ),
  ),
)
```

### 5.3 按钮组件
Material You Design 3提供了多种按钮样式，我们将根据使用场景选择合适的按钮：

#### 5.3.1 填充按钮
用于主要操作：

```dart
FilledButton(
  onPressed: () {
    // 处理按钮点击
  },
  child: const Text('安装应用'),
)
```

#### 5.3.2 轮廓按钮
用于次要操作：

```dart
OutlinedButton(
  onPressed: () {
    // 处理按钮点击
  },
  child: const Text('查看详情'),
)
```

#### 5.3.3 文本按钮
用于低优先级操作：

```dart
TextButton(
  onPressed: () {
    // 处理按钮点击
  },
  child: const Text('取消'),
)
```

#### 5.3.4 浮动操作按钮
用于主要操作：

```dart
FloatingActionButton(
  onPressed: () {
    // 处理按钮点击
  },
  child: const Icon(Icons.add),
)
```

### 5.4 列表组件
列表用于显示多个相似项：

```dart
ListView.builder(
  itemCount: apps.length,
  itemBuilder: (context, index) {
    final app = apps[index];
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(app.icon),
      ),
      title: Text(app.name),
      subtitle: Text(app.description),
      trailing: Icon(
        app.status == 'running' ? Icons.check_circle : Icons.error,
        color: app.status == 'running' 
          ? Theme.of(context).colorScheme.primary 
          : Theme.of(context).colorScheme.error,
      ),
      onTap: () {
        // 处理列表项点击
      },
    );
  },
)
```

### 5.5 对话框组件
对话框用于显示重要信息或需要用户确认的操作：

```dart
ElevatedButton(
  onPressed: () {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('确认删除'),
          content: const Text('确定要删除这个应用吗？此操作不可撤销。'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('删除'),
            ),
          ],
        );
      },
    );
  },
  child: const Text('删除应用'),
)
```

### 5.6 标签组件
标签用于显示状态或分类：

```dart
InputChip(
  label: const Text('运行中'),
  selected: true,
  onSelected: (bool value) {},
  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
  selectedColor: Theme.of(context).colorScheme.primaryContainer,
  checkmarkColor: Theme.of(context).colorScheme.onPrimaryContainer,
)
```

### 5.7 进度指示器
进度指示器用于显示操作进度：

```dart
// 线性进度指示器
LinearProgressIndicator(
  value: 0.7,
  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
  valueColor: AlwaysStoppedAnimation<Color>(
    Theme.of(context).colorScheme.primary,
  ),
)

// 圆形进度指示器
CircularProgressIndicator(
  value: 0.7,
  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
  valueColor: AlwaysStoppedAnimation<Color>(
    Theme.of(context).colorScheme.primary,
  ),
)
```

## 6. 动画和过渡效果

### 6.1 页面过渡
Material You Design 3提供了多种页面过渡效果，我们将使用以下过渡效果：

```dart
// 淡入淡出过渡
Navigator.push(
  context,
  PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
    pageBuilder: (context, animation, secondaryAnimation) {
      return const SecondPage();
    },
  ),
);

// 滑动过渡
Navigator.push(
  context,
  PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(
        CurveTween(curve: curve),
      );

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
    pageBuilder: (context, animation, secondaryAnimation) {
      return const SecondPage();
    },
  ),
);
```

### 6.2 共享元素过渡
共享元素过渡可以在两个页面之间创建平滑的视觉连接：

```dart
// 第一页
Hero(
  tag: 'app-icon',
  child: CircleAvatar(
    backgroundImage: NetworkImage(app.icon),
  ),
)

// 第二页
Hero(
  tag: 'app-icon',
  child: CircleAvatar(
    backgroundImage: NetworkImage(app.icon),
    radius: 40,
  ),
)
```

### 6.3 微交互动画
微交互动画可以增强用户体验：

```dart
// 按钮点击动画
ElevatedButton(
  onPressed: () {
    // 处理按钮点击
  },
  style: ElevatedButton.styleFrom(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  child: const Text('点击我'),
)

// 卡片悬停效果
MouseRegion(
  cursor: SystemMouseCursors.click,
  child: AnimatedContainer(
    duration: const Duration(milliseconds: 200),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: const Card(
      child: ListTile(
        title: Text('悬停我'),
      ),
    ),
  ),
)
```

## 7. 适配性和可访问性

### 7.1 响应式设计
1Panel移动端APP需要适应不同屏幕尺寸和方向：

```dart
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth > 600) {
      // 平板布局
      return _buildTabletLayout();
    } else {
      // 手机布局
      return _buildPhoneLayout();
    }
  },
)
```

### 7.2 深色模式
支持深色模式，提供更好的用户体验：

```dart
ThemeModeSwitcher(
  onThemeModeChanged: (ThemeMode mode) {
    // 处理主题模式变化
  },
)

// 在MaterialApp中设置
MaterialApp(
  theme: ThemeData(
    colorScheme: lightColorScheme,
    useMaterial3: true,
  ),
  darkTheme: ThemeData(
    colorScheme: darkColorScheme,
    useMaterial3: true,
  ),
  themeMode: ThemeMode.system,
)
```

### 7.3 可访问性
确保应用对所有用户都可访问：

```dart
// 为图像提供替代文本
Image.network(
  'https://example.com/image.png',
  semanticLabel: '应用图标',
)

// 确保足够的对比度
Text(
  '重要文本',
  style: TextStyle(
    color: Theme.of(context).colorScheme.onPrimary,
  ),
)

// 提供足够的触摸目标大小
GestureDetector(
  onTap: () {
    // 处理点击
  },
  child: Container(
    width: 48,
    height: 48,
    child: const Icon(Icons.add),
  ),
)
```

## 8. 实现指南

### 8.1 设置Material You Design 3
在Flutter项目中启用Material You Design 3：

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
  themeMode: ThemeMode.system,
)
```

### 8.2 使用动态色彩
使用`dynamic_color`包实现动态色彩：

```dart
import 'package:dynamic_color/dynamic_color.dart';

DynamicColorBuilder(
  builder: (lightDynamic, darkDynamic) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: lightDynamic ?? ThemeData().colorScheme,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: darkDynamic ?? ThemeData.dark().colorScheme,
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  },
)
```

### 8.3 自定义组件
基于Material You Design 3创建自定义组件：

```dart
class AppCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? child;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (child != null) ...[
                const SizedBox(height: 16),
                child!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
```

## 9. 设计资源

### 9.1 图标
使用Material Icons作为主要图标集：

```dart
import 'package:flutter/material.dart';

// 使用Material Icons
Icon(Icons.dashboard)
Icon(Icons.apps)
Icon(Icons.storage)
Icon(Icons.language)
Icon(Icons.settings)
```

### 9.2 图片和插图
使用一致的图片风格和插图：

- 使用矢量图形（SVG）作为图标和简单插图
- 使用高分辨率的位图作为复杂插图
- 保持一致的视觉风格和色彩方案

### 9.3 字体
使用Roboto字体作为主要字体：

```yaml
# pubspec.yaml
flutter:
  fonts:
    - family: Roboto
      fonts:
        - asset: fonts/Roboto-Regular.ttf
        - asset: fonts/Roboto-Bold.ttf
          weight: 700
        - asset: fonts/Roboto-Italic.ttf
          style: italic
```

## 10. 最佳实践

### 10.1 设计一致性
- 在整个应用中保持一致的设计语言
- 使用统一的颜色、形状、字体和间距
- 遵循Material You Design 3的设计原则

### 10.2 性能优化
- 使用`const`构造函数创建不变的小部件
- 避免不必要的重建和重绘
- 使用`ListView.builder`等懒加载组件
- 优化图像和动画性能

### 10.3 用户体验
- 提供清晰的视觉反馈
- 使用适当的动画和过渡效果
- 确保应用响应迅速
- 提供直观的导航和操作流程

### 10.4 测试和验证
- 在不同设备和屏幕尺寸上测试应用
- 验证深色模式和浅色模式的外观
- 测试动态色彩方案的效果
- 确保应用符合可访问性标准

通过遵循本设计指南，我们可以创建一个美观、一致且符合Material You Design 3标准的1Panel移动端APP，为用户提供优秀的用户体验。