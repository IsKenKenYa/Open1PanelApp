// 面板设置只读防护集成测试（危险面防护）。
//
// 用途：验证面板设置类的只读端点在真实服务器上可达；并通过一个"静态守卫"测试
// 读取本文件源码，断言文件中不存在任何设置修改类方法的调用。
//
// 危险面边界：本文件不包含任何对设置修改端点的 POST/PUT/DELETE 调用——
// 仅调用 SettingV2Api 的只读方法（search/terminal search/interface/memo GET/
// base dir/website dir/auth setting），绝不修改面板端口、监听地址、安全入口、
// 未认证设置、授权IP、域名绑定、面板SSL等任何基础配置。
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import '../test_helper.dart';
import 'package:onepanel_client/api/v2/setting_v2.dart';

Future<void> main() async {
  // 注意：真服务器集成测试禁止使用 TestWidgetsFlutterBinding（会劫持 HttpClient，
  // 所有请求返回假 400）。TestConfig.initialize() 仅读取 .env，无需绑定层。
  await TestConfig.initialize();

  late final TestApiClient apiClient;
  late final SettingV2Api settingApi;

  final hasApiKey = SkipConditions.skipNoApiKey() == null;
  if (hasApiKey) {
    apiClient = TestApiClient(
      baseUrl: TestConfig.baseUrl,
      apiKey: TestConfig.apiKey,
    );
    settingApi = SettingV2Api(apiClient.client);
  }

  tearDownAll(() async {
    if (hasApiKey) apiClient.dispose();
    await teardownTestEnvironment();
  });

  group('面板设置只读路径集成测试', () {
    test(
      '应该能够读取系统设置',
      skip: SkipConditions.skipIntegration() ?? SkipConditions.skipNoApiKey(),
      () async {
        final response = await settingApi.getSystemSettings();

        expect(response.statusCode, 200);
      },
    );

    test(
      '应该能够读取终端设置',
      skip: SkipConditions.skipIntegration() ?? SkipConditions.skipNoApiKey(),
      () async {
        final response = await settingApi.getTerminalSettings();

        expect(response.statusCode, 200);
      },
    );

    test(
      '应该能够读取网络接口列表',
      skip: SkipConditions.skipIntegration() ?? SkipConditions.skipNoApiKey(),
      () async {
        final response = await settingApi.getNetworkInterfaces();

        expect(response.statusCode, 200);
        expect(response.data, isA<List<String>>());
      },
    );

    test(
      '应该能够读取仪表盘备忘',
      skip: SkipConditions.skipIntegration() ?? SkipConditions.skipNoApiKey(),
      () async {
        final response = await settingApi.getDashboardMemo();

        expect(response.statusCode, 200);
      },
    );

    test(
      '应该能够读取基础设置与目录配置',
      skip: SkipConditions.skipIntegration() ?? SkipConditions.skipNoApiKey(),
      () async {
        final baseSettings = await settingApi.searchBaseSettings();
        expect(baseSettings.statusCode, 200);

        final baseDir = await settingApi.getBaseDir();
        expect(baseDir.statusCode, 200);

        final websiteDir = await settingApi.getWebsiteDir();
        expect(websiteDir.statusCode, 200);
      },
    );

    test(
      '应该能够读取认证设置',
      skip: SkipConditions.skipIntegration() ?? SkipConditions.skipNoApiKey(),
      () async {
        final response = await settingApi.getAuthSetting();

        expect(response.statusCode, 200);
      },
    );
  });

  group('危险面静态守卫', () {
    test(
      '本文件源码不得包含任何设置修改类方法的调用',
      skip: SkipConditions.skipIntegration() ?? SkipConditions.skipNoApiKey(),
      () async {
        final guardFile = File(
          '${Directory.current.path}/test/integration/panel_settings_readonly_test.dart',
        );
        expect(guardFile.existsSync(), isTrue,
            reason: '静态守卫必须能读取本文件源码');
        final source = await guardFile.readAsString();

        // 关键字以相邻字符串字面量拼接构造，避免守卫源码自身包含完整关键字。
        final forbiddenCalls = <String>[
          'update' 'SystemSetting',
          'update' 'TerminalSettings',
          'update' 'DashboardMemo',
          'update' 'PasswordSettings',
          'update' 'PortSettings',
          'update' 'ProxySettings',
          'update' 'BindSettings',
          'update' 'MenuSettings',
          'update' 'ApiConfig',
          'update' 'AppStoreConfig',
          'update' 'SSL',
          'update' 'MonitorSetting',
          'update' 'SnapshotDescription',
          'update' 'DefaultSSHConnection',
          'update' 'FileHistory',
          'update' 'FilesAi',
          'update' 'TerminalAi',
          'save' 'Description',
          'save' 'SSHConnection',
          'reset' 'SystemSetting',
          'delete' 'Passkey',
          'delete' 'BackupAccount',
          'delete' 'Snapshot',
          'bind' 'Mfa',
          'unbind' 'Mfa',
          'import' 'Snapshot',
          'recover' 'Snapshot',
          'recreate' 'Snapshot',
          'rollback' 'Snapshot',
          'create' 'Snapshot',
          'generate' 'ApiKey',
          'upgrade' '(',
        ];
        for (final call in forbiddenCalls) {
          expect(source.contains(call), isFalse,
              reason: '本文件禁止出现设置修改类调用: $call');
        }
      },
    );
  });
}
