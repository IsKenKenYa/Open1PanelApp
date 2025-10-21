import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'config/app_router.dart';
import 'core/config/api_config.dart';
import 'core/i18n/app_localizations.dart';
import 'core/services/logger/logger_service.dart';
import 'core/network/api_client.dart';
import 'features/ai/ai_provider.dart';
import 'api/v2/ai_v2.dart';

void main() {
  // 初始化日志服务
  appLogger.init();
  
  // 记录应用启动日志
  appLogger.i('App 启动');
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeProviders(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return snapshot.data!;
          } else {
            return MaterialApp(
              title: '1Panel Open',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en'), // English
                Locale('zh'), // Chinese
              ],
              home: Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(AppLocalizations.of(context)?.configLoadError ?? '无法加载配置'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          // 重新加载应用
                          runApp(const MyApp());
                        },
                        child: Text(AppLocalizations.of(context)?.retry ?? '重试'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        } else {
          return MaterialApp(
          title: '1Panel Open',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'), // English
            Locale('zh'), // Chinese
          ],
          home: Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(AppLocalizations.of(context)?.loading ?? '正在初始化...'),
                ],
              ),
            ),
          ),
        );
        }
      },
    );
  }

  Future<Widget> _initializeProviders() async {
    try {
      // 获取当前配置
      final config = await ApiConfigManager.getCurrentConfig();
      
      if (config == null) {
        // 如果没有配置，返回一个不包含AIProvider的应用
        return MaterialApp(
          title: AppLocalizations.of(context)?.appName ?? '1Panel Open',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'), // English
            Locale('zh'), // Chinese
          ],
          initialRoute: '/',
          onGenerateRoute: AppRouter.generateRoute,
        );
      }
      
      // 创建API客户端
      final apiClient = ApiClient(
        baseUrl: config.url,
        apiKey: config.apiKey,
      );
      
      // 创建AIV2Api实例
      final aiV2Api = AIV2Api(apiClient);
      
      // 创建包含Provider的应用
      return MultiProvider(
        providers: [
          // 创建AIProvider实例
          ChangeNotifierProvider(
            create: (context) => AIProvider(aiV2Api),
          ),
        ],
        child: MaterialApp(
          title: AppLocalizations.of(context)?.appName ?? '1Panel Open',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'), // English
            Locale('zh'), // Chinese
          ],
          initialRoute: '/',
          onGenerateRoute: AppRouter.generateRoute,
        ),
      );
    } catch (e) {
      appLogger.e('初始化Provider失败: $e');
      rethrow;
    }
  }
}
