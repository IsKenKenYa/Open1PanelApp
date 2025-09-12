# 1Panel 移动端APP - 开发指南

## 1. 概述

本文档是1Panel移动端APP的开发指南，旨在为开发团队提供全面的开发指导，包括开发环境搭建、项目结构、代码规范、开发流程、测试策略、调试技巧和部署流程等内容。遵循本指南可以确保代码质量、提高开发效率并保持团队协作的一致性。

## 2. 开发环境搭建

### 2.1 前置要求

#### 2.1.1 硬件要求

- **操作系统**：Windows 10/11、macOS 10.14+ 或 Linux (Ubuntu 18.04+)
- **内存**：至少8GB RAM，推荐16GB
- **存储**：至少10GB可用空间
- **处理器**：支持64位的x86或ARM处理器

#### 2.1.2 软件要求

- **Flutter SDK**：3.16.0或更高版本
- **Dart SDK**：3.2.0或更高版本
- **Android Studio**：2022.1或更高版本（用于Android开发）
- **Xcode**：14.0或更高版本（用于iOS开发，仅macOS）
- **Visual Studio Code**：1.70或更高版本（推荐）
- **Git**：2.30或更高版本

### 2.2 Flutter SDK安装

#### 2.2.1 Windows安装

1. 下载Flutter SDK：https://flutter.dev/docs/get-started/install/windows
2. 解压到目标目录（例如：`C:\flutter`）
3. 将Flutter添加到PATH环境变量：
   ```bash
   C:\flutter\bin
   ```
4. 运行`flutter doctor`检查安装状态

#### 2.2.2 macOS安装

1. 下载Flutter SDK：https://flutter.dev/docs/get-started/install/macos
2. 解压到目标目录（例如：`~/flutter`）
3. 将Flutter添加到PATH环境变量（在`~/.zshrc`或`~/.bash_profile`中）：
   ```bash
   export PATH="$PATH:`pwd`/flutter/bin"
   ```
4. 运行`flutter doctor`检查安装状态

#### 2.2.3 Linux安装

1. 下载Flutter SDK：https://flutter.dev/docs/get-started/install/linux
2. 解压到目标目录（例如：`~/flutter`）
3. 将Flutter添加到PATH环境变量（在`~/.bashrc`中）：
   ```bash
   export PATH="$PATH:`pwd`/flutter/bin"
   ```
4. 运行`flutter doctor`检查安装状态

### 2.3 IDE配置

#### 2.3.1 Visual Studio Code配置

1. 安装VS Code：https://code.visualstudio.com/
2. 安装Flutter和Dart扩展：
   - Flutter扩展
   - Dart扩展
3. 配置VS Code设置（`.vscode/settings.json`）：
   ```json
   {
     "dart.flutterSdkPath": "flutter安装路径",
     "dart.debugExternalLibraries": false,
     "dart.debugSdkLibraries": false,
     "files.associations": {
       "*.dart": "dart"
     }
   }
   ```

#### 2.3.2 Android Studio配置

1. 安装Android Studio：https://developer.android.com/studio
2. 安装Flutter和Dart插件：
   - File > Settings > Plugins
   - 搜索并安装Flutter插件（会自动安装Dart插件）
3. 配置Android SDK：
   - File > Settings > Appearance & Behavior > System Settings > Android SDK
   - 确保已安装Android SDK Platform-Tools
4. 配置Flutter SDK路径：
   - File > Settings > Languages & Frameworks > Flutter
   - 设置Flutter SDK路径

### 2.4 模拟器和设备配置

#### 2.4.1 Android模拟器配置

1. 在Android Studio中打开AVD Manager：
   - Tools > AVD Manager
2. 创建虚拟设备：
   - 点击"Create Virtual Device"
   - 选择设备型号
   - 选择系统镜像
   - 完成配置
3. 启动模拟器

#### 2.4.2 iOS模拟器配置（仅macOS）

1. 在Xcode中打开模拟器：
   - Open Developer Tool > Simulator
2. 选择设备型号：
   - Hardware > Device > 选择设备型号
3. 启动模拟器

#### 2.4.3 物理设备配置

**Android设备配置**：

1. 在设备上启用开发者选项：
   - 设置 > 关于手机 > 连续点击版本号7次
2. 启用USB调试：
   - 设置 > 开发者选项 > USB调试
3. 连接设备并授权调试

**iOS设备配置**（仅macOS）：

1. 在Xcode中配置设备：
   - 连接设备到Mac
   - 在Xcode中信任设备
2. 配置开发者证书：
   - 在Apple Developer Portal注册设备
   - 创建开发者证书

### 2.5 项目依赖安装

1. 克隆项目：
   ```bash
   git clone https://github.com/yourusername/1panel-mobile-app.git
   cd 1panel-mobile-app
   ```

2. 安装Flutter依赖：
   ```bash
   flutter pub get
   ```

3. 安装iOS依赖（仅macOS）：
   ```bash
   cd ios
   pod install
   cd ..
   ```

4. 运行项目：
   ```bash
   flutter run
   ```

## 3. 项目结构

### 3.1 目录结构

```
1panel-mobile-app/
├── android/                # Android原生代码
├── ios/                    # iOS原生代码
├── lib/                    # Flutter源代码
│   ├── config/             # 配置文件
│   ├── core/               # 核心功能
│   │   ├── auth/           # 认证模块
│   │   ├── network/        # 网络模块
│   │   ├── theme/          # 主题模块
│   │   └── utils/          # 工具类
│   ├── data/               # 数据层
│   │   ├── models/         # 数据模型
│   │   ├── repositories/   # 数据仓库
│   │   └── services/       # 数据服务
│   ├── features/           # 功能模块
│   │   ├── dashboard/      # 仪表盘
│   │   ├── apps/           # 应用管理
│   │   ├── containers/     # 容器管理
│   │   ├── websites/       # 网站管理
│   │   ├── files/          # 文件管理
│   │   └── backups/        # 备份管理
│   ├── shared/             # 共享组件
│   │   ├── widgets/        # 通用组件
│   │   └── constants/      # 常量定义
│   └── main.dart           # 应用入口
├── assets/                 # 资源文件
│   ├── images/             # 图片资源
│   ├── fonts/              # 字体资源
│   └── data/               # 数据资源
├── test/                   # 测试代码
│   ├── unit/               # 单元测试
│   ├── widget/             # 组件测试
│   └── integration/        # 集成测试
├── docs/                   # 文档
│   ├── api/                # API文档
│   ├── development/        # 开发文档
│   └── uml/                # UML图
├── pubspec.yaml            # 项目配置
└── README.md               # 项目说明
```

### 3.2 模块职责

#### 3.2.1 核心模块（core）

- **auth**：处理用户认证和授权
- **network**：处理网络请求和响应
- **theme**：管理应用主题和样式
- **utils**：提供通用工具类和函数

#### 3.2.2 数据层（data）

- **models**：定义数据模型和实体类
- **repositories**：实现数据访问抽象
- **services**：提供数据服务和API调用

#### 3.2.3 功能模块（features）

- **dashboard**：仪表盘功能
- **apps**：应用管理功能
- **containers**：容器管理功能
- **websites**：网站管理功能
- **files**：文件管理功能
- **backups**：备份管理功能

#### 3.2.4 共享模块（shared）

- **widgets**：提供通用UI组件
- **constants**：定义应用常量

### 3.3 文件命名规范

#### 3.3.1 Dart文件命名

- 使用小写字母和下划线
- 文件名应反映其主要内容
- 示例：`auth_service.dart`, `user_model.dart`, `dashboard_page.dart`

#### 3.3.2 资源文件命名

- 图片资源：使用小写字母和下划线，以类型为前缀
  - 示例：`ic_launcher.png`, `bg_home.jpg`, `btn_login.png`
- 字体资源：使用小写字母和下划线
  - 示例：`source_han_sans_regular.ttf`
- 数据资源：使用小写字母和下划线
  - 示例：`app_config.json`, `localization_en.json`

## 4. 代码规范

### 4.1 Dart语言规范

#### 4.1.1 命名规范

- **类名**：使用PascalCase（首字母大写的驼峰命名法）
  ```dart
  class AuthService {}
  class UserModel {}
  ```

- **方法名**：使用camelCase（首字母小写的驼峰命名法）
  ```dart
  void login() {}
  String getUserName() {}
  ```

- **变量名**：使用camelCase
  ```dart
  String userName = '';
  bool isLoggedIn = false;
  ```

- **常量名**：使用大写字母和下划线
  ```dart
  const String API_BASE_URL = 'https://api.1panel.com';
  const int MAX_RETRY_COUNT = 3;
  ```

- **文件名**：使用小写字母和下划线
  ```dart
  // 文件名: auth_service.dart
  class AuthService {}
  ```

#### 4.1.2 代码格式

- **缩进**：使用2个空格，不使用制表符
- **行长度**：每行最多80个字符
- **大括号**：左大括号不换行，右大括号换行
  ```dart
  if (condition) {
    // 代码
  } else {
    // 代码
  }
  ```

- **空行**：在类、方法和逻辑块之间使用空行分隔
  ```dart
  class MyClass {
    void method1() {
      // 代码
    }

    void method2() {
      // 代码
    }
  }
  ```

#### 4.1.3 注释规范

- **文档注释**：使用`///`，用于类、方法和公共属性的说明
  ```dart
  /// 用户认证服务
  class AuthService {
    /// 用户登录
    /// 
    /// [username] 用户名
    /// [password] 密码
    /// 返回登录结果
    Future<bool> login(String username, String password) async {
      // 实现
    }
  }
  ```

- **行内注释**：使用`//`，用于代码行的说明
  ```dart
  // 检查网络连接
  if (await _checkNetworkConnection()) {
    // 执行网络请求
  }
  ```

- **多行注释**：使用`/* */`，用于大段代码的注释
  ```dart
  /*
   * 这是一个多行注释
   * 用于解释复杂的逻辑
   */
  void complexMethod() {
    // 实现
  }
  ```

### 4.2 Flutter规范

#### 4.2.1 Widget规范

- **Widget命名**：使用PascalCase
  ```dart
  class CustomButton extends StatelessWidget {
    // 实现
  }
  ```

- **Widget构建**：使用`const`构造函数，提高性能
  ```dart
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBar(
        title: Text('1Panel'),
      ),
      body: Center(
        child: Text('Hello World'),
      ),
    );
  }
  ```

- **Widget拆分**：将复杂的Widget拆分为更小的Widget
  ```dart
  class DashboardPage extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text('仪表盘')),
        body: Column(
          children: [
            const SystemInfoCard(),
            const ResourceUsageCard(),
            const RecentActivitiesList(),
          ],
        ),
      );
    }
  }
  ```

#### 4.2.2 状态管理规范

- **Provider使用**：使用Provider进行状态管理
  ```dart
  class AuthProvider with ChangeNotifier {
    bool _isLoggedIn = false;
    
    bool get isLoggedIn => _isLoggedIn;
    
    Future<void> login(String username, String password) async {
      // 登录逻辑
      _isLoggedIn = true;
      notifyListeners();
    }
    
    void logout() {
      _isLoggedIn = false;
      notifyListeners();
    }
  }
  ```

- **状态访问**：使用`Consumer`或`context.watch`访问状态
  ```dart
  Consumer<AuthProvider>(
    builder: (context, authProvider, child) {
      return authProvider.isLoggedIn
          ? const HomePage()
          : const LoginPage();
    },
  )
  ```

#### 4.2.3 路由规范

- **路由定义**：使用命名路由
  ```dart
  class AppRouter {
    static const String login = '/login';
    static const String dashboard = '/dashboard';
    static const String apps = '/apps';
    static const String containers = '/containers';
    static const String websites = '/websites';
    static const String files = '/files';
    static const String backups = '/backups';
  }
  ```

- **路由配置**：在MaterialApp中配置路由
  ```dart
  MaterialApp(
    routes: {
      AppRouter.login: (context) => const LoginPage(),
      AppRouter.dashboard: (context) => const DashboardPage(),
      AppRouter.apps: (context) => const AppsPage(),
      AppRouter.containers: (context) => const ContainersPage(),
      AppRouter.websites: (context) => const WebsitesPage(),
      AppRouter.files: (context) => const FilesPage(),
      AppRouter.backups: (context) => const BackupsPage(),
    },
    initialRoute: AppRouter.login,
  )
  ```

- **路由导航**：使用`Navigator.pushNamed`进行导航
  ```dart
  ElevatedButton(
    onPressed: () {
      Navigator.pushNamed(context, AppRouter.apps);
    },
    child: const Text('查看应用'),
  )
  ```

### 4.3 项目特定规范

#### 4.3.1 API调用规范

- **API服务类**：每个功能模块对应一个API服务类
  ```dart
  class AppsApiService {
    final Dio _dio = Dio();
    
    Future<List<AppModel>> getApps() async {
      try {
        final response = await _dio.get('/api/apps');
        return (response.data['data'] as List)
            .map((json) => AppModel.fromJson(json))
            .toList();
      } catch (e) {
        throw Exception('Failed to load apps: $e');
      }
    }
    
    Future<bool> installApp(String appName) async {
      try {
        final response = await _dio.post('/api/apps/install', data: {
          'name': appName,
        });
        return response.data['success'];
      } catch (e) {
        throw Exception('Failed to install app: $e');
      }
    }
  }
  ```

- **错误处理**：统一处理API错误
  ```dart
  class ApiErrorHandler {
    static dynamic handleError(DioException error) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          throw Exception('连接超时，请检查网络连接');
        case DioExceptionType.sendTimeout:
          throw Exception('发送超时，请重试');
        case DioExceptionType.receiveTimeout:
          throw Exception('接收超时，请重试');
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          if (statusCode == 401) {
            throw Exception('未授权，请重新登录');
          } else if (statusCode == 403) {
            throw Exception('权限不足');
          } else if (statusCode == 404) {
            throw Exception('资源不存在');
          } else if (statusCode >= 500) {
            throw Exception('服务器错误，请稍后重试');
          } else {
            throw Exception('请求失败: ${error.response?.data['message']}');
          }
        case DioExceptionType.cancel:
          throw Exception('请求已取消');
        case DioExceptionType.unknown:
          throw Exception('网络错误，请检查网络连接');
        default:
          throw Exception('未知错误');
      }
    }
  }
  ```

#### 4.3.2 数据模型规范

- **模型类**：使用`json_serializable`进行序列化
  ```dart
  part 'app_model.g.dart';
  
  @JsonSerializable()
  class AppModel {
    final String id;
    final String name;
    final String version;
    final String status;
    final DateTime createdAt;
    final DateTime updatedAt;
    
    AppModel({
      required this.id,
      required this.name,
      required this.version,
      required this.status,
      required this.createdAt,
      required this.updatedAt,
    });
    
    factory AppModel.fromJson(Map<String, dynamic> json) =>
        _$AppModelFromJson(json);
    
    Map<String, dynamic> toJson() => _$AppModelToJson(this);
  }
  ```

- **模型枚举**：使用枚举表示固定值
  ```dart
  enum AppStatus {
    running,
    stopped,
    error,
    installing,
    updating,
  }
  
  extension AppStatusExtension on AppStatus {
    String get displayName {
      switch (this) {
        case AppStatus.running:
          return '运行中';
        case AppStatus.stopped:
          return '已停止';
        case AppStatus.error:
          return '错误';
        case AppStatus.installing:
          return '安装中';
        case AppStatus.updating:
          return '更新中';
      }
    }
    
    Color get color {
      switch (this) {
        case AppStatus.running:
          return Colors.green;
        case AppStatus.stopped:
          return Colors.grey;
        case AppStatus.error:
          return Colors.red;
        case AppStatus.installing:
        case AppStatus.updating:
          return Colors.blue;
      }
    }
  }
  ```

#### 4.3.3 UI组件规范

- **组件封装**：封装常用UI组件
  ```dart
  class AppCard extends StatelessWidget {
    final Widget child;
    final EdgeInsetsGeometry? padding;
    final Color? color;
    final VoidCallback? onTap;
    
    const AppCard({
      super.key,
      required this.child,
      this.padding,
      this.color,
      this.onTap,
    });
    
    @override
    Widget build(BuildContext context) {
      return Card(
        color: color ?? Theme.of(context).colorScheme.surfaceVariant,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: padding ?? const EdgeInsets.all(16),
            child: child,
          ),
        ),
      );
    }
  }
  ```

- **主题使用**：使用主题颜色和样式
  ```dart
  class AppButton extends StatelessWidget {
    final String text;
    final VoidCallback? onPressed;
    final bool isLoading;
    
    const AppButton({
      super.key,
      required this.text,
      this.onPressed,
      this.isLoading = false,
    });
    
    @override
    Widget build(BuildContext context) {
      return ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(text),
      );
    }
  }
  ```

## 5. 开发流程

### 5.1 Git工作流

#### 5.1.1 分支策略

- **main**：主分支，用于生产环境
- **develop**：开发分支，用于集成开发
- **feature/***：功能分支，用于开发新功能
- **hotfix/***：修复分支，用于紧急修复
- **release/***：发布分支，用于准备发布

#### 5.1.2 分支操作

- **创建功能分支**：
  ```bash
  git checkout develop
  git pull origin develop
  git checkout -b feature/feature-name
  ```

- **提交更改**：
  ```bash
  git add .
  git commit -m "feat: add new feature"
  git push origin feature/feature-name
  ```

- **创建合并请求**：
  - 在Git平台（如GitHub、GitLab）上创建从功能分支到develop分支的合并请求
  - 请求代码审查
  - 解决冲突
  - 合并到develop分支

- **创建发布分支**：
  ```bash
  git checkout develop
  git pull origin develop
  git checkout -b release/v1.0.0
  ```

- **合并到主分支**：
  ```bash
  git checkout main
  git pull origin main
  git merge --no-ff release/v1.0.0
  git push origin main
  ```

#### 5.1.3 提交信息规范

使用[Conventional Commits](https://www.conventionalcommits.org/)规范：

- **feat**：新功能
- **fix**：修复bug
- **docs**：文档更新
- **style**：代码格式（不影响代码运行的变动）
- **refactor**：重构（既不是新增功能，也不是修改bug的代码变动）
- **perf**：性能优化
- **test**：增加测试
- **chore**：构建过程或辅助工具的变动

示例：
```bash
git commit -m "feat: add user authentication"
git commit -m "fix: resolve login issue on Android"
git commit -m "docs: update API documentation"
git commit -m "style: format code according to linting rules"
git commit -m "refactor: simplify authentication logic"
git commit -m "perf: improve app startup time"
git commit -m "test: add unit tests for auth service"
git commit -m "chore: update dependencies"
```

### 5.2 代码审查流程

#### 5.2.1 代码审查清单

- **功能正确性**：代码是否实现了预期功能
- **代码质量**：代码是否清晰、简洁、易于理解
- **性能考虑**：代码是否考虑了性能影响
- **安全性**：代码是否存在安全风险
- **测试覆盖**：代码是否有足够的测试覆盖
- **文档完整性**：代码是否有适当的文档和注释
- **代码规范**：代码是否符合项目编码规范

#### 5.2.2 审查流程

1. 开发者完成功能开发并提交代码
2. 创建合并请求，指派至少一名审查者
3. 审查者检查代码并提供反馈
4. 开发者根据反馈修改代码
5. 审查者确认修改后批准合并请求
6. 合并请求被合并到目标分支

### 5.3 持续集成/持续部署

#### 5.3.1 CI/CD配置

使用GitHub Actions进行CI/CD：

```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Set up Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.16.0'
        channel: 'stable'
    
    - name: Get dependencies
      run: flutter pub get
    
    - name: Analyze code
      run: flutter analyze
    
    - name: Run tests
      run: flutter test
    
    - name: Build Android APK
      run: flutter build apk --release
    
    - name: Build iOS app
      run: flutter build ios --release --no-codesign
      if: false # 仅在macOS上运行

  build-and-deploy:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Set up Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.16.0'
        channel: 'stable'
    
    - name: Get dependencies
      run: flutter pub get
    
    - name: Build Android APK
      run: flutter build apk --release
    
    - name: Build Android AAB
      run: flutter build appbundle --release
    
    - name: Upload artifacts
      uses: actions/upload-artifact@v3
      with:
        name: release-builds
        path: |
          build/app/outputs/flutter-apk/app-release.apk
          build/app/outputs/bundle/release/app-release.aab
```

#### 5.3.2 自动化测试

- **单元测试**：测试单个函数或方法
- **组件测试**：测试UI组件
- **集成测试**：测试多个组件或模块的交互
- **端到端测试**：测试完整用户流程

### 5.4 版本管理

#### 5.4.1 版本号规范

使用[语义化版本](https://semver.org/)规范：

- **主版本号**：不兼容的API修改
- **次版本号**：向下兼容的功能性新增
- **修订号**：向下兼容的问题修正

示例：`1.0.0`, `1.0.1`, `1.1.0`, `2.0.0`

#### 5.4.2 版本发布流程

1. 更新版本号（在`pubspec.yaml`中）
2. 更新变更日志
3. 创建发布分支
4. 构建应用
5. 测试应用
6. 合并到主分支
7. 创建标签
8. 发布到应用商店

## 6. 测试策略

### 6.1 测试类型

#### 6.1.1 单元测试

测试单个函数或方法，不依赖外部资源。

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/auth/auth_service.dart';

void main() {
  group('AuthService', () {
    late AuthService authService;
    
    setUp(() {
      authService = AuthService();
    });
    
    test('login with valid credentials returns true', () async {
      // Arrange
      const username = 'admin';
      const password = 'password';
      
      // Act
      final result = await authService.login(username, password);
      
      // Assert
      expect(result, isTrue);
    });
    
    test('login with invalid credentials returns false', () async {
      // Arrange
      const username = 'invalid';
      const password = 'invalid';
      
      // Act
      final result = await authService.login(username, password);
      
      // Assert
      expect(result, isFalse);
    });
  });
}
```

#### 6.1.2 组件测试

测试UI组件，验证其渲染和交互。

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/widgets/app_button.dart';

void main() {
  group('AppButton', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      // Arrange
      const buttonText = 'Test Button';
      
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              text: buttonText,
              onPressed: () {},
            ),
          ),
        ),
      );
      
      // Assert
      expect(find.text(buttonText), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
    
    testWidgets('calls onPressed when tapped', (WidgetTester tester) async {
      // Arrange
      var pressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              text: 'Test Button',
              onPressed: () {
                pressed = true;
              },
            ),
          ),
        ),
      );
      
      // Act
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      
      // Assert
      expect(pressed, isTrue);
    });
  });
}
```

#### 6.1.3 集成测试

测试多个组件或模块的交互，验证它们是否正确协作。

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/features/apps/apps_page.dart';
import 'package:my_app/features/apps/apps_service.dart';
import 'package:provider/provider.dart';
import 'package:mocktail/mocktail.dart';

class MockAppsService extends Mock implements AppsService {}

void main() {
  group('AppsPage Integration Test', () {
    late MockAppsService mockAppsService;
    
    setUp(() {
      mockAppsService = MockAppsService();
    });
    
    testWidgets('displays list of apps', (WidgetTester tester) async {
      // Arrange
      when(() => mockAppsService.getApps()).thenAnswer((_) async => [
        AppModel(id: '1', name: 'App 1', version: '1.0.0', status: 'running'),
        AppModel(id: '2', name: 'App 2', version: '2.0.0', status: 'stopped'),
      ]);
      
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => AppsProvider(mockAppsService),
          child: const MaterialApp(
            home: AppsPage(),
          ),
        ),
      );
      
      // Act
      await tester.pumpAndSettle();
      
      // Assert
      expect(find.text('App 1'), findsOneWidget);
      expect(find.text('App 2'), findsOneWidget);
      expect(find.text('1.0.0'), findsOneWidget);
      expect(find.text('2.0.0'), findsOneWidget);
    });
  });
}
```

#### 6.1.4 端到端测试

测试完整用户流程，验证应用是否按预期工作。

```dart
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('1Panel App E2E Test', () {
    late FlutterDriver driver;
    
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });
    
    tearDownAll(() async {
      if (driver != null) {
        await driver.close();
      }
    });
    
    test('login and view dashboard', () async {
      // Find UI elements
      final usernameField = find.byValueKey('username_field');
      final passwordField = find.byValueKey('password_field');
      final loginButton = find.byValueKey('login_button');
      final dashboardTitle = find.byValueKey('dashboard_title');
      
      // Enter credentials
      await driver.enterText(usernameField, 'admin');
      await driver.enterText(passwordField, 'password');
      
      // Tap login button
      await driver.tap(loginButton);
      
      // Wait for dashboard to load
      await driver.waitFor(dashboardTitle);
      
      // Verify dashboard is displayed
      expect(await driver.getText(dashboardTitle), '仪表盘');
    });
  });
}
```

### 6.2 测试覆盖率

#### 6.2.1 覆盖率目标

- **单元测试覆盖率**：≥80%
- **组件测试覆盖率**：≥80%
- **集成测试覆盖率**：≥60%
- **端到端测试覆盖率**：关键流程100%

#### 6.2.2 覆盖率工具

使用`flutter test --coverage`生成覆盖率报告：

```bash
flutter test --coverage
```

然后使用`lcov`工具生成HTML报告：

```bash
lcov --remove coverage/lcov.info 'lib/*/*.g.dart' 'lib/*/*.freezed.dart' -o coverage/lcov.info
genhtml coverage/lcov.info -o coverage/html
```

### 6.3 测试自动化

#### 6.3.1 本地测试

在开发过程中运行测试：

```bash
# 运行所有测试
flutter test

# 运行特定测试文件
flutter test test/auth_service_test.dart

# 运行特定测试
flutter test --plain-name "login with valid credentials"
```

#### 6.3.2 CI测试

在CI/CD流程中自动运行测试：

```yaml
- name: Run tests
  run: flutter test --coverage

- name: Upload coverage to Codecov
  uses: codecov/codecov-action@v3
  with:
    file: coverage/lcov.info
```

## 7. 调试技巧

### 7.1 Flutter调试工具

#### 7.1.1 Flutter DevTools

Flutter DevTools是一套强大的调试和性能分析工具，包括：

- **Widget Inspector**：检查Widget树和属性
- **Performance Overlay**：性能分析
- **Memory View**：内存使用情况
- **Network Profiler**：网络请求分析
- **Logging**：日志查看

启动DevTools：

```bash
flutter pub global activate devtools
flutter pub global run devtools
```

或在VS Code中，使用命令面板（Ctrl+Shift+P）运行"Flutter: Open Flutter DevTools"。

#### 7.1.2 热重载和热重启

- **热重载**：在不重启应用的情况下更新代码
  ```bash
  flutter run
  # 修改代码后按 'r'
  ```

- **热重启**：重启应用但保留状态
  ```bash
  flutter run
  # 修改代码后按 'R'
  ```

### 7.2 日志记录

#### 7.2.1 使用`print`和`debugPrint`

```dart
print('Simple log message');
debugPrint('Debug log message');
```

#### 7.2.2 使用`logger`包

添加依赖：

```yaml
dependencies:
  logger: ^2.0.2+1
```

使用示例：

```dart
import 'package:logger/logger.dart';

var logger = Logger();

void main() {
  logger.d('Debug message');
  logger.i('Info message');
  logger.w('Warning message');
  logger.e('Error message');
}
```

#### 7.2.3 自定义日志记录器

```dart
class AppLogger {
  static const String _tag = '1Panel';
  
  static void d(String message) {
    debugPrint('[$_tag] DEBUG: $message');
  }
  
  static void i(String message) {
    debugPrint('[$_tag] INFO: $message');
  }
  
  static void w(String message) {
    debugPrint('[$_tag] WARNING: $message');
  }
  
  static void e(String message, {StackTrace? stackTrace}) {
    debugPrint('[$_tag] ERROR: $message');
    if (stackTrace != null) {
      debugPrint('[$_tag] STACK TRACE: $stackTrace');
    }
  }
}
```

### 7.3 断点调试

#### 7.3.1 在VS Code中设置断点

1. 在代码行号左侧单击设置断点
2. 按F5启动调试
3. 使用调试控制面板控制执行流程

#### 7.3.2 条件断点

右键单击断点，选择"编辑断点"，然后设置条件：

```dart
if (user.id == '123') {
  // 断点将在此处停止
}
```

#### 7.3.3 日志断点

右键单击断点，选择"编辑断点"，然后设置日志消息：

```dart
// 断点将在此处记录消息但不停止执行
print('User ID: ${user.id}');
```

### 7.4 性能分析

#### 7.4.1 使用Flutter Performance Overlay

在应用中启用性能覆盖层：

```dart
MaterialApp(
  showPerformanceOverlay: true,
  // 其他配置
)
```

#### 7.4.2 使用Flutter DevTools性能分析

1. 打开Flutter DevTools
2. 选择"Performance"选项卡
3. 点击"Record"开始记录
4. 执行要分析的操作
5. 点击"Stop"停止记录
6. 分析性能数据

#### 7.4.3 使用Dart DevTools内存分析

1. 打开Flutter DevTools
2. 选择"Memory"选项卡
3. 点击"Record"开始记录
4. 执行要分析的操作
5. 点击"Stop"停止记录
6. 分析内存使用情况

## 8. 部署流程

### 8.1 构建配置

#### 8.1.1 Android构建配置

在`android/app/build.gradle`中配置：

```gradle
android {
    compileSdkVersion 34
    
    defaultConfig {
        applicationId "com.example.1panel"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
    }
    
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }
}
```

#### 8.1.2 iOS构建配置

在`ios/Runner.xcodeproj/project.pbxproj`中配置：

```xml
buildSettings = {
    PRODUCT_NAME = 1Panel;
    ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
    CURRENT_PROJECT_VERSION = 1;
    DEVELOPMENT_TEAM = YOUR_TEAM_ID;
    MARKETING_VERSION = 1.0.0;
};
```

### 8.2 构建命令

#### 8.2.1 Android构建

```bash
# 构建Debug APK
flutter build apk --debug

# 构建Release APK
flutter build apk --release

# 构建App Bundle (用于Google Play)
flutter build appbundle --release

# 构建特定架构的APK
flutter build apk --release --split-per-abi
```

#### 8.2.2 iOS构建

```bash
# 构建iOS应用 (仅macOS)
flutter build ios --release

# 构建iOS应用 (不签名)
flutter build ios --release --no-codesign
```

### 8.3 应用商店发布

#### 8.3.1 Google Play Store发布

1. 登录[Google Play Console](https://play.google.com/console)
2. 创建应用
3. 上传App Bundle (`build/app/outputs/bundle/release/app-release.aab`)
4. 填写应用信息
5. 设置内容分级
6. 设置定价和分发范围
7. 发布应用

#### 8.3.2 Apple App Store发布

1. 登录[App Store Connect](https://appstoreconnect.apple.com)
2. 创建应用
3. 使用Xcode上传应用 (`flutter build ios`)
4. 填写应用信息
5. 设置定价和可用性
6. 提交审核
7. 发布应用

### 8.4 版本更新

#### 8.4.1 版本号更新

在`pubspec.yaml`中更新版本号：

```yaml
version: 1.0.0+1
```

格式：`version: 主版本号.次版本号.修订号+构建号`

#### 8.4.2 变更日志

在`CHANGELOG.md`中记录变更：

```markdown
## [1.0.0] - 2023-12-01

### Added
- 用户认证功能
- 仪表盘功能
- 应用管理功能
- 容器管理功能
- 网站管理功能
- 文件管理功能
- 备份管理功能

### Changed
- 初始版本发布

### Fixed
- 初始版本，无已知问题
```

## 9. 最佳实践

### 9.1 代码组织

#### 9.1.1 模块化设计

将应用拆分为独立的模块，每个模块负责特定的功能：

```dart
// 模块结构
lib/
├── core/           # 核心功能
├── data/           # 数据层
├── features/       # 功能模块
│   ├── auth/       # 认证模块
│   ├── dashboard/  # 仪表盘模块
│   ├── apps/       # 应用管理模块
│   └── ...         # 其他模块
├── shared/         # 共享组件
└── main.dart       # 应用入口
```

#### 9.1.2 依赖注入

使用依赖注入模式管理依赖关系：

```dart
// 服务定位器
class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  
  factory ServiceLocator() {
    return _instance;
  }
  
  ServiceLocator._internal();
  
  late final Dio dio = Dio();
  late final AuthService authService = AuthService(dio);
  late final AppsService appsService = AppsService(dio);
  // 其他服务
}

// 在main.dart中初始化
void main() {
  final serviceLocator = ServiceLocator();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(serviceLocator.authService),
        ),
        ChangeNotifierProvider(
          create: (context) => AppsProvider(serviceLocator.appsService),
        ),
        // 其他提供者
      ],
      child: const MyApp(),
    ),
  );
}
```

### 9.2 性能优化

#### 9.2.1 列表优化

使用`ListView.builder`和`const`构造函数优化列表性能：

```dart
@override
Widget build(BuildContext context) {
  return ListView.builder(
    itemCount: items.length,
    itemBuilder: (context, index) {
      return const AppListItem(
        // 使用const构造函数
        title: 'Item Title',
        subtitle: 'Item Subtitle',
      );
    },
  );
}
```

#### 9.2.2 图片优化

使用缓存和压缩优化图片加载：

```dart
// 使用cached_network_image包
CachedNetworkImage(
  imageUrl: 'https://example.com/image.jpg',
  placeholder: (context, url) => const CircularProgressIndicator(),
  errorWidget: (context, url, error) => const Icon(Icons.error),
  fit: BoxFit.cover,
  width: 100,
  height: 100,
)
```

#### 9.2.3 状态管理优化

使用`Provider`和`Selector`优化状态管理：

```dart
// 使用Selector只重建需要的部分
Selector<AuthProvider, bool>(
  selector: (context, authProvider) => authProvider.isLoggedIn,
  builder: (context, isLoggedIn, child) {
    return isLoggedIn ? const HomePage() : const LoginPage();
  },
)
```

### 9.3 错误处理

#### 9.3.1 全局错误处理

使用`ErrorWidget`和`FlutterError`处理全局错误：

```dart
// 在main.dart中设置全局错误处理
void main() {
  FlutterError.onError = (details) {
    // 记录错误
    AppLogger.e('Flutter Error: ${details.exception}', stackTrace: details.stack);
    // 显示友好的错误页面
    runApp(ErrorApp(details.exception.toString()));
  };
  
  runApp(const MyApp());
}

class ErrorApp extends StatelessWidget {
  final String errorMessage;
  
  const ErrorApp(this.errorMessage, {super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                '发生错误',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 8),
              Text(errorMessage),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // 重启应用
                  main();
                },
                child: const Text('重启应用'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

#### 9.3.2 网络错误处理

使用`try-catch`处理网络错误：

```dart
Future<List<AppModel>> getApps() async {
  try {
    final response = await _dio.get('/api/apps');
    return (response.data['data'] as List)
        .map((json) => AppModel.fromJson(json))
        .toList();
  } on DioException catch (e) {
    // 处理Dio异常
    throw ApiErrorHandler.handleError(e);
  } catch (e) {
    // 处理其他异常
    throw Exception('Failed to load apps: $e');
  }
}
```

### 9.4 安全性

#### 9.4.1 敏感数据存储

使用平台安全存储存储敏感数据：

```dart
// 使用flutter_secure_storage包
final storage = FlutterSecureStorage();

// 存储数据
await storage.write(key: 'auth_token', value: 'token_value');

// 读取数据
final token = await storage.read(key: 'auth_token');

// 删除数据
await storage.delete(key: 'auth_token');
```

#### 9.4.2 HTTPS和证书固定

使用HTTPS和证书固定确保网络安全：

```dart
// 配置Dio客户端
final dio = Dio();
(dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    (client) {
  // 证书固定
  client.badCertificateCallback = (X509Certificate cert, String host, int port) {
    // 验证证书
    return cert.pem == _trustedCertificate;
  };
  return client;
};
```

### 9.5 可访问性

#### 9.5.1 语义化标签

使用语义化标签提高可访问性：

```dart
Semantics(
  label: '登录按钮',
  hint: '点击此按钮登录系统',
  button: true,
  child: ElevatedButton(
    onPressed: () {},
    child: const Text('登录'),
  ),
)
```

#### 9.5.2 屏幕阅读器支持

确保所有交互元素都支持屏幕阅读器：

```dart
TextField(
  decoration: const InputDecoration(
    labelText: '用户名',
    hintText: '请输入用户名',
  ),
  onChanged: (value) {
    // 处理输入
  },
)
```

## 10. 总结

1Panel移动端APP的开发指南提供了全面的开发指导，包括开发环境搭建、项目结构、代码规范、开发流程、测试策略、调试技巧和部署流程等内容。遵循本指南可以确保代码质量、提高开发效率并保持团队协作的一致性。

通过模块化设计、依赖注入、性能优化、错误处理、安全性和可访问性等最佳实践，我们可以构建一个高质量、高性能、安全且易于维护的移动应用。

希望本指南能够帮助开发团队更好地理解项目结构和开发流程，提高开发效率，确保代码质量，最终交付一个优秀的1Panel移动端APP。