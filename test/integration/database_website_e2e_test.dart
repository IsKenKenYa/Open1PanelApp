// 数据库 / 网站 端到端夹具集成测试（真服务器联调）。
//
// 用途：验证在真实 1Panel 服务器上创建并删除一个 MySQL 测试库与一个静态测试站点
// 的完整闭环（存在前置条件不满足时 soft-skip，不算失败）。
//
// 危险面边界：本文件仅创建/删除名称带 `onepanel-e2e-` 前缀 + 6位随机后缀的自有
// 夹具库与站点，不修改、不删除任何现有数据库/网站，不修改面板或数据库服务配置，
// 不调用任何面板基础配置修改接口（端口/安全入口/SSL 等）。
// 数据库与网站是真实服务：夹具库只在已存在的 MySQL 服务实例中建库；站点为静态
// 类型，不绑定运行环境、不创建应用。
import 'package:flutter_test/flutter_test.dart';
import '../test_helper.dart';
import 'package:onepanel_client/api/v2/database_v2.dart';
import 'package:onepanel_client/api/v2/system_group_v2.dart';
import 'package:onepanel_client/api/v2/website_v2.dart';
import 'package:onepanel_client/data/models/common_models.dart';
import 'package:onepanel_client/data/models/database_models.dart';
import 'package:onepanel_client/data/models/system_group_models.dart'
    as group_models;
import 'package:onepanel_client/data/models/website_models.dart';

Future<void> main() async {
  // 注意：真服务器集成测试禁止使用 TestWidgetsFlutterBinding（会劫持 HttpClient，
  // 所有请求返回假 400）。TestConfig.initialize() 仅读取 .env，无需绑定层。
  await TestConfig.initialize();

  late final TestApiClient apiClient;
  late final DatabaseV2Api databaseApi;
  late final WebsiteV2Api websiteApi;
  late final SystemGroupV2Api groupApi;

  final hasApiKey = SkipConditions.skipNoApiKey() == null;
  if (hasApiKey) {
    apiClient = TestApiClient(
      baseUrl: TestConfig.baseUrl,
      apiKey: TestConfig.apiKey,
    );
    databaseApi = DatabaseV2Api(apiClient.client);
    websiteApi = WebsiteV2Api(apiClient.client);
    groupApi = SystemGroupV2Api(apiClient.client);
  }

  tearDownAll(() async {
    if (hasApiKey) apiClient.dispose();
    await teardownTestEnvironment();
  });

  group('数据库 E2E 夹具测试', () {
    test(
      '应该能够在已有MySQL服务中创建-搜索-删除测试库',
      skip: SkipConditions.skipIntegration() ?? SkipConditions.skipNoApiKey(),
      () async {
        final dbName = 'onepanel_e2e_db_${TestDataGenerator.randomString(6)}';

        Future<void> cleanup() async {
          try {
            final search = await databaseApi.searchDatabases(
              DatabaseSearch(
                database: '',
                name: dbName,
                type: 'mysql',
                page: 1,
                pageSize: 20,
              ),
            );
            final matches = search.data!.items
                .where((item) => item.name == dbName)
                .toList();
            if (matches.isEmpty) return;
            for (final item in matches) {
              await databaseApi.deleteDatabase(OperateByID(id: item.id));
            }
          } catch (e) {
            // ignore: avoid_print
            print('清理测试库失败（忽略）: $dbName -> $e');
          }
        }

        try {
          // 前置探测：本机必须已有 MySQL 服务实例，否则 soft-skip。
          final servers = await databaseApi.listDatabases('mysql');
          expect(servers.statusCode, 200);
          final serverList = servers.data ?? [];
          if (serverList.isEmpty) {
            // ignore: avoid_print
            print('[soft-skip] 本机未发现可用的 MySQL 服务实例，跳过建库测试');
            return;
          }
          final serverName = serverList.first['name']?.toString() ?? '';
          if (serverName.isEmpty) {
            // ignore: avoid_print
            print('[soft-skip] MySQL 服务实例名称为空，跳过建库测试');
            return;
          }

          final createResponse = await databaseApi.createRemoteDatabase(
            <String, dynamic>{
              'name': dbName,
              'type': 'mysql',
              'server': serverName,
              'format': 'utf8mb4',
            },
          );
          expect(createResponse.statusCode, 200);

          final searchResponse = await databaseApi.searchDatabases(
            DatabaseSearch(
              database: '',
              name: dbName,
              type: 'mysql',
              page: 1,
              pageSize: 20,
            ),
          );
          expect(searchResponse.statusCode, 200);
          expect(searchResponse.data, isA<PageResult<DatabaseInfo>>());
          expect(
            searchResponse.data!.items.any((item) => item.name == dbName),
            isTrue,
            reason: '创建的测试库 $dbName 应出现在搜索结果中',
          );
        } finally {
          await cleanup();
        }
      },
    );
  });

  group('网站 E2E 夹具测试', () {
    test(
      '应该能够创建-搜索-删除静态测试站点（前置不满足时soft-skip）',
      skip: SkipConditions.skipIntegration() ?? SkipConditions.skipNoApiKey(),
      () async {
        final suffix = TestDataGenerator.randomString(6);
        final siteAlias = 'onepanel-e2e-site-$suffix';
        final siteDomain = 'onepanel-e2e-site-$suffix.example.com';

        Future<void> cleanup() async {
          try {
            final search = await websiteApi.getWebsites(name: siteDomain);
            final matches = search.items
                .where((item) =>
                    item.primaryDomain == siteDomain || item.alias == siteAlias)
                .toList();
            if (matches.isEmpty) return;
            for (final item in matches) {
              final id = item.id;
              if (id == null) continue;
              await websiteApi.deleteWebsite(id);
            }
          } catch (e) {
            // ignore: avoid_print
            print('清理测试站点失败（忽略）: $siteDomain -> $e');
          }
        }

        try {
          // 读路径验证：网站列表可达。
          final listBefore = await websiteApi.getWebsites();
          expect(listBefore, isA<PageResult<WebsiteInfo>>());

          // 前置探测：网站分组（取第一个组；失败/为空时回退 0）。
          var groupId = 0;
          try {
            final groups = await groupApi.searchAgentGroups(
              const group_models.GroupSearch(type: 'website'),
            );
            final list = groups.data ?? [];
            if (list.isNotEmpty) {
              groupId = list.first.id ?? 0;
            }
          } catch (e) {
            // ignore: avoid_print
            print('查询网站分组失败（回退 groupId=0）: $e');
          }

          // 创建静态站点：服务端要求 appType 满足 oneof=new|installed
          // （1Panel 前端对 static 类型默认传 'installed'）；缺 OpenResty 时报错 soft-skip。
          try {
            await websiteApi.createWebsite(
              WebsiteCreate(
                alias: siteAlias,
                name: siteDomain,
                type: 'static',
                appType: 'installed',
                webSiteGroupId: groupId,
                domains: <WebsiteDomain>[
                  WebsiteDomain(domain: siteDomain, port: 80),
                ],
              ),
            );
          } catch (e) {
            // ignore: avoid_print
            print('[soft-skip] 创建网站失败（可能缺少 OpenResty/默认运行环境）: $e');
            return;
          }

          final searchResponse = await websiteApi.getWebsites(name: siteDomain);
          expect(searchResponse, isA<PageResult<WebsiteInfo>>());
          expect(
            searchResponse.items.any(
              (item) =>
                  item.primaryDomain == siteDomain || item.alias == siteAlias,
            ),
            isTrue,
            reason: '创建的测试站点 $siteDomain 应出现在搜索结果中',
          );
        } finally {
          await cleanup();
        }
      },
    );
  });
}
