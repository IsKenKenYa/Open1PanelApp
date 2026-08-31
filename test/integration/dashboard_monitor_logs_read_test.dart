// Dashboard / Monitor / Logs 只读集成测试（真服务器联调）。
//
// 用途：验证仪表盘、监控、日志三类纯读端点在真实 1Panel 服务上可达且返回结构正确。
//
// 危险面边界：本文件只包含只读请求（dashboard 读取、monitor search/setting/options、
// 日志搜索与系统日志文件列表），不创建、不修改、不删除任何服务器资源，
// 不触碰面板基础配置（端口/监听地址/安全入口/未认证设置/授权IP/域名绑定/面板SSL）。
import 'package:flutter_test/flutter_test.dart';
import '../test_helper.dart';
import 'package:onepanel_client/api/v2/dashboard_v2.dart';
import 'package:onepanel_client/api/v2/monitor_v2.dart';
import 'package:onepanel_client/api/v2/logs_v2.dart';
import 'package:onepanel_client/data/models/common_models.dart';
import 'package:onepanel_client/data/models/logs_models.dart';
import 'package:onepanel_client/data/models/monitoring_models.dart';

Future<void> main() async {
  // 注意：真服务器集成测试禁止使用 TestWidgetsFlutterBinding（会劫持 HttpClient，
  // 所有请求返回假 400）。TestConfig.initialize() 仅读取 .env，无需绑定层。
  await TestConfig.initialize();

  late final TestApiClient apiClient;
  late final DashboardV2Api dashboardApi;
  late final MonitorV2Api monitorApi;
  late final LogsV2Api logsApi;

  final hasApiKey = SkipConditions.skipNoApiKey() == null;
  if (hasApiKey) {
    apiClient = TestApiClient(
      baseUrl: TestConfig.baseUrl,
      apiKey: TestConfig.apiKey,
    );
    dashboardApi = DashboardV2Api(apiClient.client);
    monitorApi = MonitorV2Api(apiClient.client);
    logsApi = LogsV2Api(apiClient.client);
  }

  tearDownAll(() async {
    if (hasApiKey) apiClient.dispose();
    await teardownTestEnvironment();
  });

  group('Dashboard 只读集成测试', () {
    test(
      '应该能够获取仪表盘基础信息',
      skip: SkipConditions.skipIntegration() ?? SkipConditions.skipNoApiKey(),
      () async {
        final response = await dashboardApi.getDashboardBase();

        expect(response.statusCode, 200);
        expect(response.data, isA<Map<String, dynamic>>());
        expect(response.data, isNotEmpty);
      },
    );

    test(
      '应该能够获取操作系统信息',
      skip: SkipConditions.skipIntegration() ?? SkipConditions.skipNoApiKey(),
      () async {
        final response = await dashboardApi.getOperatingSystemInfo();

        expect(response.statusCode, 200);
        expect(response.data, isNotNull);
      },
    );

    test(
      '应该能够获取当前实时指标',
      skip: SkipConditions.skipIntegration() ?? SkipConditions.skipNoApiKey(),
      () async {
        final response = await dashboardApi.getCurrentMetrics();

        expect(response.statusCode, 200);
        expect(response.data, isA<SystemMetrics>());
      },
    );

    test(
      '应该能够获取当前节点信息',
      skip: SkipConditions.skipIntegration() ?? SkipConditions.skipNoApiKey(),
      () async {
        final response = await dashboardApi.getCurrentNode();

        expect(response.statusCode, 200);
        expect(response.data, isA<Map<String, dynamic>>());
        expect(response.data, isNotEmpty);
      },
    );

    test(
      '应该能够获取CPU占用Top进程列表',
      skip: SkipConditions.skipIntegration() ?? SkipConditions.skipNoApiKey(),
      () async {
        final response = await dashboardApi.getTopCPUProcesses();

        expect(response.statusCode, 200);
        expect(response.data, isA<List>());
      },
    );

    test(
      '应该能够获取内存占用Top进程列表',
      skip: SkipConditions.skipIntegration() ?? SkipConditions.skipNoApiKey(),
      () async {
        final response = await dashboardApi.getTopMemoryProcesses();

        expect(response.statusCode, 200);
        expect(response.data, isA<List>());
      },
    );
  });

  group('Monitor 只读集成测试', () {
    test(
      '应该能够搜索近1小时监控数据',
      skip: SkipConditions.skipIntegration() ?? SkipConditions.skipNoApiKey(),
      () async {
        final endTime = DateTime.now().toUtc();
        final startTime = endTime.subtract(const Duration(hours: 1));
        final request = MonitorSearch(
          param: 'all',
          startTime: startTime.toIso8601String(),
          endTime: endTime.toIso8601String(),
        );
        final response = await monitorApi.search(request);

        expect(response.statusCode, 200);
        expect(response.data, isA<MonitorSearchResponse>());
      },
    );

    test(
      '应该能够获取监控设置',
      skip: SkipConditions.skipIntegration() ?? SkipConditions.skipNoApiKey(),
      () async {
        final response = await monitorApi.getSetting();

        expect(response.statusCode, 200);
        expect(response.data, isA<MonitorSetting>());
      },
    );

    test(
      '应该能够获取IO设备选项',
      skip: SkipConditions.skipIntegration() ?? SkipConditions.skipNoApiKey(),
      () async {
        final response = await monitorApi.getIoOptions();

        expect(response.statusCode, 200);
        expect(response.data, isA<List<String>>());
      },
    );

    test(
      '应该能够获取网络接口选项',
      skip: SkipConditions.skipIntegration() ?? SkipConditions.skipNoApiKey(),
      () async {
        final response = await monitorApi.getNetworkOptions();

        expect(response.statusCode, 200);
        expect(response.data, isA<List<String>>());
      },
    );
  });

  group('Logs 只读集成测试', () {
    test(
      '应该能够搜索登录日志',
      skip: SkipConditions.skipIntegration() ?? SkipConditions.skipNoApiKey(),
      () async {
        final request = const LoginLogSearchRequest(page: 1, pageSize: 10);
        final response = await logsApi.searchLoginLogs(request);

        expect(response.statusCode, 200);
        expect(response.data, isA<PageResult<LoginLogEntry>>());
      },
    );

    test(
      '应该能够搜索操作日志',
      skip: SkipConditions.skipIntegration() ?? SkipConditions.skipNoApiKey(),
      () async {
        final request = const OperationLogSearchRequest(page: 1, pageSize: 10);
        final response = await logsApi.searchOperationLogs(request);

        expect(response.statusCode, 200);
        expect(response.data, isA<PageResult<OperationLogEntry>>());
      },
    );

    test(
      '应该能够获取系统日志文件列表',
      skip: SkipConditions.skipIntegration() ?? SkipConditions.skipNoApiKey(),
      () async {
        final response = await logsApi.getSystemLogFiles();

        expect(response.statusCode, 200);
        expect(response.data, isA<List<String>>());
      },
    );
  });
}
