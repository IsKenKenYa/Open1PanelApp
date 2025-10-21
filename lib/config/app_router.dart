/// 应用路由配置
/// 
/// 此文件定义应用的所有路由和导航配置。

import 'package:flutter/material.dart';
import '../features/ai/ai_page.dart';
import '../pages/server/server_config_page.dart';
import '../pages/server/server_selection_page.dart';
import '../core/config/api_config.dart';

/// 路由名称常量
class AppRoutes {
  static const String splash = '/';
  static const String serverConfig = '/server-config';
  static const String serverSelection = '/server-selection';
  static const String home = '/home';
  static const String ai = '/ai';
}

/// 路由生成器
class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(
          builder: (_) => const SplashPage(),
        );
      case AppRoutes.serverConfig:
        return MaterialPageRoute(
          builder: (_) => const ServerConfigPage(),
        );
      case AppRoutes.serverSelection:
        return MaterialPageRoute(
          builder: (_) => const ServerSelectionPage(),
        );
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
        );
      case AppRoutes.ai:
        return MaterialPageRoute(
          builder: (_) => const AIPage(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const NotFoundPage(),
        );
    }
  }
}

/// 启动页面
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkConfig();
  }

  Future<void> _checkConfig() async {
    // 延迟一下，让启动页面显示
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (!mounted) return;
    
    try {
      final configs = await ApiConfigManager.getConfigs();
      
      if (configs.isEmpty) {
        // 没有配置，跳转到服务器配置页面
        Navigator.pushReplacementNamed(context, AppRoutes.serverConfig);
      } else {
        // 有配置，跳转到主页
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      }
    } catch (e) {
      // 出错，跳转到服务器配置页面
      Navigator.pushReplacementNamed(context, AppRoutes.serverConfig);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 可以添加应用Logo
            const Icon(
              Icons.dashboard,
              size: 80,
              color: Colors.blue,
            ),
            const SizedBox(height: 24),
            const Text(
              '1Panel Open',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            const SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(),
            ),
            const SizedBox(height: 16),
            const Text(
              '正在初始化...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 主页面
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ApiConfig? _currentConfig;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentConfig();
  }

  Future<void> _loadCurrentConfig() async {
    try {
      final config = await ApiConfigManager.getCurrentConfig();
      setState(() {
        _currentConfig = config;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('1Panel Open'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.serverSelection).then((_) {
                _loadCurrentConfig();
              });
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadCurrentConfig,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_currentConfig != null) ...[
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '当前服务器',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  const Icon(Icons.dns, size: 24),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _currentConfig!.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  if (_currentConfig!.isDefault)
                                    const Icon(Icons.star, color: Colors.amber),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.link, size: 24),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _currentConfig!.url,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                    const Text(
                      '功能模块',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        _buildFeatureCard(
                          context,
                          title: 'AI管理',
                          icon: Icons.smart_toy,
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.ai);
                          },
                        ),
                        _buildFeatureCard(
                          context,
                          title: '应用管理',
                          icon: Icons.apps,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('功能开发中')),
                            );
                          },
                        ),
                        _buildFeatureCard(
                          context,
                          title: '容器管理',
                          icon: Icons.inventory_2,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('功能开发中')),
                            );
                          },
                        ),
                        _buildFeatureCard(
                          context,
                          title: '网站管理',
                          icon: Icons.language,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('功能开发中')),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
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