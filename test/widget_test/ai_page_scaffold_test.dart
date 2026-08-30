import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onepanel_client/features/ai/ai_page.dart';
import 'package:onepanel_client/features/ai/ai_provider.dart';
import 'package:onepanel_client/features/ai/agents/agents_provider.dart';
import 'package:onepanel_client/features/ai/ai_repository.dart';
import 'package:onepanel_client/features/ai/mcp_server_provider.dart';
import 'package:onepanel_client/features/ai/mcp_server_service.dart';
import 'package:onepanel_client/data/models/common_models.dart';
import 'package:onepanel_client/data/models/ai_models.dart';
import 'package:onepanel_client/data/models/mcp_models.dart';
import 'package:onepanel_client/core/i18n/l10n_x.dart';
import 'package:onepanel_client/l10n/generated/app_localizations.dart';
import 'package:onepanel_client/features/shell/controllers/current_server_controller.dart';
import 'package:onepanel_client/features/shell/widgets/shell_drawer_scope.dart';
import 'package:provider/provider.dart';

class _MockAIRepository extends Mock implements AIRepository {}

class _MockMcpServerService extends Mock implements McpServerService {}

/// 阶段1-类1/3 回归守卫：AI 页作为 shell 嵌入 Tab，必须与其它 Tab 模块一致——
/// AppBar 提供汉堡 leading（shell scope 内）、Scaffold 背景显式 surface。
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildHarness() {
    final aiRepo = _MockAIRepository();
    final mcpService = _MockMcpServerService();
    // Tab 页懒加载会触发这两条读取；mock 成空态避免网络。
    when(() => aiRepo.searchOllamaModels(
          page: any(named: 'page'),
          pageSize: any(named: 'pageSize'),
          info: any(named: 'info'),
        )).thenAnswer((_) async =>
            PageResult<OllamaModel>(total: 0, items: const <OllamaModel>[]));
    when(() => mcpService.loadSnapshot(keyword: any(named: 'keyword')))
        .thenAnswer((_) async => McpServerSnapshot(
              servers: const <McpServerDTO>[],
              binding: McpBindDomainRes(),
            ));

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CurrentServerController()),
        ChangeNotifierProvider(create: (_) => AIProvider(repository: aiRepo)),
        ChangeNotifierProvider(create: (_) => AgentsProvider()),
        ChangeNotifierProvider(
            create: (_) => McpServerProvider(service: mcpService)),
      ],
      child: ShellDrawerScope(
        openDrawer: () {},
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const AIPage(),
        ),
      ),
    );
  }

  testWidgets('AI 页嵌入 shell 时 AppBar 显示汉堡 leading（类1）', (tester) async {
    await tester.pumpWidget(buildHarness());
    await tester.pump();
    // postFrame 触发的懒加载允许在网络 mock 抛出后稳定。
    await tester.pump(const Duration(milliseconds: 100));

    expect(
      find.byKey(const Key('shell-drawer-menu-button')),
      findsOneWidget,
      reason: 'AI 页是 shell 嵌入 Tab，AppBar 左上角必须提供汉堡菜单入口',
    );
  });

  testWidgets('AI 页 Scaffold 背景显式 surface（类3）', (tester) async {
    await tester.pumpWidget(buildHarness());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    final context = tester.element(find.byType(Scaffold).first);
    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold).first);
    expect(
      scaffold.backgroundColor,
      equals(Theme.of(context).colorScheme.surface),
      reason: 'AGENTS.md：桌面/移动 Scaffold 背景必须显式 surface',
    );
  });

  testWidgets('AI 页保留 5 个功能 Tab（结构守卫）', (tester) async {
    await tester.pumpWidget(buildHarness());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    final l10n = tester.element(find.byType(AIPage).first).l10n;
    expect(find.text(l10n.aiTabModels), findsOneWidget);
    expect(find.text(l10n.aiTabGpu), findsOneWidget);
    expect(find.text(l10n.aiTabDomain), findsOneWidget);
    expect(find.text(l10n.aiTabAgents), findsOneWidget);
    expect(find.text(l10n.aiTabMcp), findsOneWidget);
  });
}
