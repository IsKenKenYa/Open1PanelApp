// 计划任务 / 快捷命令 / 分组 端到端夹具集成测试（真服务器联调）。
//
// 用途：对三类轻量资源各自执行 创建 → 按名称搜索确认 → 删除 的完整闭环。
//
// 危险面边界：本文件只创建、搜索、删除名称带 `onepanel-e2e-` 前缀 + 6位随机后缀的
// 自有夹具（cronjob、command、group 各一个），不修改任何现有任务/命令/分组，
// 不触发任务执行（不调用 handle/stop），不调用任何面板基础配置修改接口。
import 'package:flutter_test/flutter_test.dart';
import '../test_helper.dart';
import 'package:onepanel_client/api/v2/cronjob_v2.dart';
import 'package:onepanel_client/api/v2/command_v2.dart';
import 'package:onepanel_client/api/v2/system_group_v2.dart';
import 'package:onepanel_client/data/models/command_models.dart';
import 'package:onepanel_client/data/models/common_models.dart'
    hide GroupCreate, GroupSearch;
import 'package:onepanel_client/data/models/cronjob_form_request_models.dart';
import 'package:onepanel_client/data/models/cronjob_list_models.dart';
import 'package:onepanel_client/data/models/system_group_models.dart';

Future<void> main() async {
  // 注意：真服务器集成测试禁止使用 TestWidgetsFlutterBinding（会劫持 HttpClient，
  // 所有请求返回假 400）。TestConfig.initialize() 仅读取 .env，无需绑定层。
  await TestConfig.initialize();

  late final TestApiClient apiClient;
  late final CronjobV2Api cronjobApi;
  late final CommandV2Api commandApi;
  late final SystemGroupV2Api groupApi;

  final hasApiKey = SkipConditions.skipNoApiKey() == null;
  if (hasApiKey) {
    apiClient = TestApiClient(
      baseUrl: TestConfig.baseUrl,
      apiKey: TestConfig.apiKey,
    );
    cronjobApi = CronjobV2Api(apiClient.client);
    commandApi = CommandV2Api(apiClient.client);
    groupApi = SystemGroupV2Api(apiClient.client);
  }

  tearDownAll(() async {
    if (hasApiKey) apiClient.dispose();
    await teardownTestEnvironment();
  });

  group('计划任务 E2E 夹具测试', () {
    test(
      '应该能够创建-搜索-删除shell类型计划任务',
      skip: SkipConditions.skipIntegration() ?? SkipConditions.skipNoApiKey(),
      () async {
        final cronName = 'onepanel-e2e-cron-${TestDataGenerator.randomString(6)}';

        Future<void> cleanup() async {
          try {
            final search = await cronjobApi.searchCronjobs(
              CronjobListQuery(page: 1, pageSize: 50, info: cronName),
            );
            final ids = search.data!.items
                .where((item) => item.name == cronName)
                .map((item) => item.id)
                .toList();
            if (ids.isEmpty) return;
            await cronjobApi.deleteCronjob(
              CronjobBatchDeleteRequest(ids: ids),
            );
          } catch (e) {
            // ignore: avoid_print
            print('清理计划任务失败（忽略）: $cronName -> $e');
          }
        }

        try {
          final createResponse = await cronjobApi.createCronjob(
            CronjobOperateRequest(
              name: cronName,
              groupID: 0,
              type: 'shell',
              specCustom: false,
              spec: '0 0 * * *',
              executor: 'root',
              scriptMode: 'input',
              script: 'echo onepanel-e2e-integration',
            ),
          );
          expect(createResponse.statusCode, 200);

          final searchResponse = await cronjobApi.searchCronjobs(
            CronjobListQuery(page: 1, pageSize: 20, info: cronName),
          );
          expect(searchResponse.statusCode, 200);
          expect(searchResponse.data, isA<PageResult<CronjobSummary>>());
          expect(
            searchResponse.data!.items.any((item) => item.name == cronName),
            isTrue,
            reason: '创建的计划任务 $cronName 应出现在搜索结果中',
          );
        } finally {
          await cleanup();
        }
      },
    );
  });

  group('快捷命令 E2E 夹具测试', () {
    test(
      '应该能够创建-搜索-删除快捷命令',
      skip: SkipConditions.skipIntegration() ?? SkipConditions.skipNoApiKey(),
      () async {
        final cmdName = 'onepanel-e2e-cmd-${TestDataGenerator.randomString(6)}';

        Future<void> cleanup() async {
          try {
            final search = await commandApi.searchCommands(
              CommandSearchRequest(page: 1, pageSize: 50, info: cmdName),
            );
            final ids = search.data!.items
                .where((item) => item.name == cmdName)
                .map((item) => item.id)
                .whereType<int>()
                .toList();
            if (ids.isEmpty) return;
            await commandApi.deleteCommand(OperateByIDs(ids: ids));
          } catch (e) {
            // ignore: avoid_print
            print('清理快捷命令失败（忽略）: $cmdName -> $e');
          }
        }

        try {
          final createResponse = await commandApi.createCommand(
            CommandOperate(
              name: cmdName,
              command: 'echo onepanel-e2e-integration',
              groupID: 0,
              groupBelong: '',
              type: 'command',
            ),
          );
          expect(createResponse.statusCode, 200);

          final searchResponse = await commandApi.searchCommands(
            CommandSearchRequest(page: 1, pageSize: 20, info: cmdName),
          );
          expect(searchResponse.statusCode, 200);
          expect(searchResponse.data, isA<PageResult<CommandInfo>>());
          expect(
            searchResponse.data!.items.any((item) => item.name == cmdName),
            isTrue,
            reason: '创建的快捷命令 $cmdName 应出现在搜索结果中',
          );
        } finally {
          await cleanup();
        }
      },
    );
  });

  group('系统分组 E2E 夹具测试', () {
    test(
      '应该能够创建-搜索-删除分组',
      skip: SkipConditions.skipIntegration() ?? SkipConditions.skipNoApiKey(),
      () async {
        final groupName =
            'onepanel-e2e-group-${TestDataGenerator.randomString(6)}';

        Future<void> cleanup() async {
          try {
            final search = await groupApi.searchCoreGroups(
              const GroupSearch(type: 'cronjob'),
            );
            final ids = search.data!
                .where((item) => item.name == groupName)
                .map((item) => item.id)
                .whereType<int>()
                .toList();
            if (ids.isEmpty) return;
            for (final id in ids) {
              await groupApi.deleteCoreGroup(OperateByID(id: id));
            }
          } catch (e) {
            // ignore: avoid_print
            print('清理分组失败（忽略）: $groupName -> $e');
          }
        }

        try {
          final createResponse = await groupApi.createCoreGroup(
            GroupCreate(name: groupName, type: 'cronjob'),
          );
          expect(createResponse.statusCode, 200);

          final searchResponse = await groupApi.searchCoreGroups(
            const GroupSearch(type: 'cronjob'),
          );
          expect(searchResponse.statusCode, 200);
          expect(searchResponse.data, isA<List<GroupInfo>>());
          expect(
            searchResponse.data!.any((item) => item.name == groupName),
            isTrue,
            reason: '创建的分组 $groupName 应出现在搜索结果中',
          );
        } finally {
          await cleanup();
        }
      },
    );
  });
}
