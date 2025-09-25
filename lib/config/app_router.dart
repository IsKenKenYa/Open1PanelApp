/// 应用路由配置
/// 
/// 此文件定义应用的所有路由和导航配置。

import 'package:flutter/material.dart';
import '../features/ai/ai_page.dart';
import '../features/dashboard/dashboard_page.dart';
import '../features/apps/apps_page.dart';
import '../features/containers/containers_page.dart';
import '../features/websites/websites_page.dart';
import '../features/files/files_page.dart';
import '../pages/settings/settings_page.dart';

/// 路由名称常量
class AppRoutes {
  static const String home = '/';
  static const String dashboard = '/dashboard';
  static const String apps = '/apps';
  static const String containers = '/containers';
  static const String websites = '/websites';
  static const String files = '/files';
  static const String ai = '/ai';
  static const String settings = '/settings';
}

/// 路由生成器
class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => const DashboardPage(),
        );
      case AppRoutes.dashboard:
        return MaterialPageRoute(
          builder: (_) => const DashboardPage(),
        );
      case AppRoutes.apps:
        return MaterialPageRoute(
          builder: (_) => const AppsPage(),
        );
      case AppRoutes.containers:
        return MaterialPageRoute(
          builder: (_) => const ContainersPage(),
        );
      case AppRoutes.websites:
        return MaterialPageRoute(
          builder: (_) => const WebsitesPage(),
        );
      case AppRoutes.files:
        return MaterialPageRoute(
          builder: (_) => const FilesPage(),
        );
      case AppRoutes.ai:
        return MaterialPageRoute(
          builder: (_) => const AIPage(),
        );
      case AppRoutes.settings:
        return MaterialPageRoute(
          builder: (_) => const SettingsPage(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const NotFoundPage(),
        );
    }
  }
}

/// 主页面
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('1Panel Open'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '欢迎使用 1Panel Open',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.ai);
              },
              child: const Text('AI管理'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.settings);
              },
              child: const Text('设置'),
            ),
          ],
        ),
      ),
    );
  }
}

/// 404页面
class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('页面未找到'),
      ),
      body: const Center(
        child: Text('404 - 页面未找到'),
      ),
    );
  }
}