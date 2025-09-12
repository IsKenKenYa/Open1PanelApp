# 1Panel 移动端APP - 代码规范文档

## 1. 概述

本文档规定了1Panel移动端APP项目的代码规范，旨在确保所有团队成员编写一致、可读、可维护的代码。遵循这些规范将有助于提高代码质量，减少错误，加快开发速度，并促进团队协作。

## 2. Dart语言规范

### 2.1 代码风格

- **使用2个空格进行缩进**（不要使用制表符）
- **每行不超过80个字符**（长字符串和导入语句除外）
- **运算符前后添加空格**：`a + b` 而不是 `a+b`
- **逗号后面添加空格**：`[1, 2, 3]` 而不是 `[1,2,3]`
- **花括号使用与K&R风格**：左花括号放在行尾，不另起一行
- **方法和构造函数的参数**：每行一个参数，当参数过长时

```dart
// 好的例子
void myFunction({
  required String parameter1,
  required int parameter2,
  bool parameter3 = false,
}) {
  // 函数体
}
```

### 2.2 命名规范

- **类名、枚举名**：使用大驼峰命名法（PascalCase），例如 `MyClass`
- **变量名、方法名、参数名**：使用小驼峰命名法（camelCase），例如 `myVariable`
- **常量名**：使用全大写字母，下划线分隔，例如 `MAX_COUNT`
- **私有成员**：以下划线（`_`）开头，例如 `_privateField`
- **文件名**：使用小驼峰或下划线分隔，与类名对应，例如 `my_class.dart` 或 `myClass.dart`
- **包名**：使用小写字母，下划线分隔，例如 `my_package`

### 2.3 导入语句

- **排序导入语句**：首先是Dart SDK导入，然后是Flutter包导入，最后是项目文件导入
- **使用相对路径导入项目文件**：`import '../widgets/my_widget.dart';`
- **避免导入不必要的文件**：只导入需要的类和函数
- **使用`as`关键字为长导入路径指定别名**：`import 'package:some_long_package_name/some_long_module_name.dart' as long_module;`

```dart
// 好的例子
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../services/auth_service.dart';
import '../utils/logger.dart';
```

### 2.4 注释

- **使用文档注释**（三斜杠 `///`）为公共API编写文档
- **使用单行注释**（双斜杠 `//`）为代码添加解释性注释
- **避免冗余注释**：代码本身应该是自解释的
- **注释应该清晰、简洁，并说明"为什么"而不是"是什么"**

```dart
/// 用户认证服务
/// 处理登录、注销和令牌管理等功能
class AuthService {
  /// 登录方法
  /// [username]：用户名
  /// [password]：密码
  /// 返回登录响应对象
  Future<LoginResponse> login(String username, String password) async {
    // 使用超时避免请求无限等待
    return await _apiService.post('/api/auth/login', data: {
      'username': username,
      'password': password,
    }).timeout(const Duration(seconds: 30));
  }
}
```

## 3. Flutter规范

### 3.1 小部件（Widget）设计

- **使用不可变小部件**（`const`构造函数）尽可能使用`const`构造函数
- **拆分复杂小部件**：将复杂UI拆分为多个小的、可重用的小部件
- **使用`StatelessWidget`**：当小部件不需要管理状态时
- **使用`StatefulWidget`**：当小部件需要管理状态时
- **避免在`build`方法中执行复杂计算**：将计算移到`initState`或`didChangeDependencies`

```dart
// 好的例子
class ProfileHeader extends StatelessWidget {
  final User user;
  
  const ProfileHeader({super.key, required this.user});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          AvatarWidget(url: user.avatarUrl),
          const SizedBox(width: 12),
          UserInfoWidget(name: user.name, email: user.email),
        ],
      ),
    );
  }
}
```

### 3.2 状态管理

- **使用Provider进行状态管理**：符合项目架构设计
- **避免过度使用`setState`**：优先使用Provider
- **创建清晰的数据模型**：使用`freezed`或`equatable`帮助实现不可变数据模型
- **分离业务逻辑和UI**：将业务逻辑移到服务类中

### 3.3 布局和约束

- **使用Flex布局**：优先使用`Row`、`Column`和`Flex`进行布局
- **使用`Expanded`和`Flexible`**：控制子小部件的尺寸
- **使用`Padding`和`Margin`**：控制间距，避免使用固定像素值
- **使用`LayoutBuilder`**：根据父容器的约束调整布局
- **使用`MediaQuery`**：获取设备信息和屏幕尺寸

```dart
// 好的例子
class DashboardLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SectionTitle(title: 'System Overview'),
                const SizedBox(height: 16),
                // 使用Flexible和Expanded创建响应式布局
                Row(
                  children: [
                    Expanded(child: CpuWidget()),
                    const SizedBox(width: 12),
                    Expanded(child: MemoryWidget()),
                  ],
                ),
                // 更多组件...
              ],
            ),
          );
        },
      ),
    );
  }
}
```

### 3.4 资源和本地化

- **使用`AssetImage`加载图像**：`Image.asset('assets/images/logo.png')`
- **使用`intl`包进行国际化**：遵循Flutter的国际化最佳实践
- **将字符串、颜色和尺寸定义为常量**：便于维护和更新

## 4. 项目特定规范

### 4.1 目录结构

遵循项目的目录结构，将代码组织到适当的目录中：

- `lib/api/`：API接口定义和实现
- `lib/core/`：核心功能和服务
- `lib/models/`：数据模型
- `lib/providers/`：状态管理提供者
- `lib/screens/`：应用屏幕和页面
- `lib/services/`：业务逻辑服务
- `lib/utils/`：工具函数和辅助类
- `lib/widgets/`：可重用的UI组件

### 4.2 文件结构

- **每个文件包含一个主要类**：避免在一个文件中放置多个不相关的类
- **文件命名与类名对应**：例如 `user_service.dart` 包含 `UserService` 类
- **组织文件内容**：按以下顺序组织文件内容
  1. 导入语句
  2. 常量定义
  3. 枚举定义
  4. 类定义
  5. 扩展和混合定义

### 4.3 错误处理

- **使用`try-catch`处理预期异常**：特别是网络请求和异步操作
- **抛出有意义的异常**：提供清晰的错误信息
- **避免空值**：使用`null`安全特性，避免空指针异常
- **使用`Result`模式**：处理可能失败的操作

```dart
// 好的例子
Future<Result<User>> fetchUser(String userId) async {
  try {
    final response = await _apiService.get('/users/$userId');
    return Success(User.fromJson(response.data));
  } catch (e) {
    _logger.e('Failed to fetch user: $e');
    return Error('获取用户信息失败，请稍后重试');
  }
}
```

### 4.4 日志记录

- **使用项目提供的`Logger`工具类**：统一日志记录方式
- **分级日志**：使用不同级别的日志（debug、info、warning、error）
- **避免在生产环境记录敏感信息**：如密码、令牌等
- **在异常处理中记录错误信息**：便于调试和问题排查

```dart
// 好的例子
class ApiService {
  final Logger _logger = Logger('ApiService');
  
  Future<Response> get(String path) async {
    _logger.d('GET request to: $path');
    try {
      final response = await _dio.get(path);
      _logger.d('GET response from $path: ${response.statusCode}');
      return response;
    } catch (e) {
      _logger.e('GET request to $path failed: $e');
      rethrow;
    }
  }
}
```

### 4.5 测试

- **编写单元测试**：测试独立的函数和类
- **编写小部件测试**：测试UI组件的渲染和交互
- **编写集成测试**：测试多个组件的协作
- **测试覆盖率目标**：争取达到80%以上的代码覆盖率
- **使用`mockito`模拟依赖**：隔离测试对象

```dart
// 好的例子
void main() {
  group('AuthService', () {
    late AuthService authService;
    late MockApiClient mockApiClient;
    
    setUp(() {
      mockApiClient = MockApiClient();
      authService = AuthService(apiClient: mockApiClient);
    });
    
    test('login should return success when credentials are valid', () async {
      // 模拟API响应
      when(mockApiClient.post('/api/auth/login', data: anyNamed('data')))
          .thenAnswer((_) async => Response(
                statusCode: 200,
                data: {'token': 'test_token', 'user': {'id': '1', 'name': 'Test User'}},
                requestOptions: RequestOptions(path: '/api/auth/login'),
              ));
      
      // 执行测试
      final result = await authService.login('username', 'password');
      
      // 验证结果
      expect(result, isA<Success>());
      expect((result as Success).value.token, 'test_token');
    });
  });
}
```

## 5. 性能优化规范

### 5.1 渲染性能

- **避免不必要的重建**：使用`const`构造函数和`const`小部件
- **使用`ListView.builder`**：对于长列表，避免一次性加载所有项
- **使用`CachedNetworkImage`**：缓存网络图像
- **使用`RepaintBoundary`**：隔离频繁重绘的小部件

### 5.2 内存管理

- **及时释放资源**：在`dispose`方法中清理定时器、监听器等
- **避免内存泄漏**：正确管理订阅和引用
- **使用`WeakReference`**：对于非必要的强引用
- **优化大对象**：避免创建过大的对象

```dart
// 好的例子
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});
  
  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  late StreamSubscription _subscription;
  
  @override
  void initState() {
    super.initState();
    _subscription = someStream.listen((data) {
      // 处理数据
    });
  }
  
  @override
  void dispose() {
    // 释放资源，避免内存泄漏
    _subscription.cancel();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    // 构建UI
  }
}
```

### 5.3 网络性能

- **使用请求缓存**：避免重复请求相同数据
- **批量请求**：合并多个小请求为一个大请求
- **压缩数据**：在网络传输中使用数据压缩
- **设置合理的超时时间**：避免请求无限等待

## 6. 安全规范

- **不要硬编码敏感信息**：使用环境变量或安全存储
- **使用`flutter_secure_storage`存储敏感数据**：如令牌、密码等
- **验证用户输入**：防止注入攻击
- **使用HTTPS**：确保网络通信安全
- **限制权限**：仅请求应用需要的权限

## 7. 代码审查规范

### 7.1 审查流程

- **创建Pull Request**：完成功能或修复后创建PR
- **添加描述**：详细描述PR的目的、更改内容和测试情况
- **请求审查**：指定至少一位审查者
- **响应反馈**：及时处理审查者的评论和建议
- **合并代码**：审查通过后合并到主分支

### 7.2 审查关注点

- **代码质量**：遵循编码规范，代码是否清晰、简洁
- **功能正确性**：是否实现了预期功能，是否有bug
- **性能影响**：是否有性能问题，是否有优化空间
- **安全性**：是否有安全隐患
- **测试覆盖**：是否有足够的测试覆盖

## 8. 版本控制规范

- **使用Git进行版本控制**
- **遵循分支命名约定**：`feature/feature-name`、`fix/bug-description`、`hotfix/critical-issue`
- **编写有意义的提交消息**：清晰描述更改内容和原因
- **定期拉取最新代码**：避免合并冲突
- **保持提交历史整洁**：避免不必要的提交

```bash
# 好的提交消息例子
feat: add user profile page

Add user profile page with avatar, personal information and settings options.
Include responsive design for different screen sizes.

Closes #123
```

## 9. 文档规范

- **更新API文档**：当修改或添加API时
- **更新README**：当项目结构或使用方式改变时
- **编写注释**：为复杂代码和公共API添加注释
- **使用DartDoc**：为公共API生成文档
- **保持文档同步**：确保文档与代码一致

## 10. 总结

遵循这些代码规范将有助于提高1Panel移动端APP项目的代码质量和可维护性，促进团队协作，减少错误，并加快开发速度。所有团队成员都应该熟悉并遵守这些规范。

---

本规范文档会根据项目进展和最佳实践的演变定期更新。如有任何建议或问题，请联系项目负责人。