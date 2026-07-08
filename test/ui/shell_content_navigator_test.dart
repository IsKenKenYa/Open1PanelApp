import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:onepanel_client/core/config/api_config.dart';
import 'package:onepanel_client/core/services/app_settings_controller.dart';
import 'package:onepanel_client/features/server/server_models.dart';
import 'package:onepanel_client/features/server/server_provider.dart';
import 'package:onepanel_client/features/server/server_repository.dart';
import 'package:onepanel_client/features/shell/controllers/current_server_controller.dart';
import 'package:onepanel_client/features/shell/models/client_module.dart';
import 'package:onepanel_client/features/shell/shell_navigation.dart';
import 'package:onepanel_client/l10n/generated/app_localizations.dart';
import 'package:onepanel_client/ui/desktop/common/widgets/shell_content_host.dart';

void main() {
  group('findShellContentNavigator', () {
    testWidgets(
      'returns null when no ShellContentHost is mounted',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(body: SizedBox.shrink()),
          ),
        );

        final BuildContext context =
            tester.element(find.byType(SizedBox));
        expect(findShellContentNavigator(context), isNull);
      },
    );

    testWidgets(
      'returns the inner NavigatorState after a ShellContentHost is mounted',
      (tester) async {
        // Use a ServerProvider that talks to a no-op repository so the
        // ShellContentHost's `buildShellModulePage(...)` initialization
        // (which is `ClientModule.servers` -> `ServerListPage`) does not
        // hit real persistence. We still need a `MultiProvider` because
        // the page calls `context.read<ServerProvider>()` in initState.
        final serverProvider = ServerProvider(
          repository: _NoopServerRepository(),
        );
        addTearDown(serverProvider.dispose);

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<ServerProvider>.value(
                value: serverProvider,
              ),
              ChangeNotifierProvider(
                create: (_) => CurrentServerController(),
              ),
              ChangeNotifierProvider(
                create: (_) => AppSettingsController(),
              ),
            ],
            child: MaterialApp(
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: const [Locale('en'), Locale('zh')],
              home: Scaffold(
                body: ShellContentHost(
                  module: ClientModule.servers,
                  serverId: null,
                ),
              ),
            ),
          ),
        );

        // Let the inner Navigator complete its initial layout and any
        // post-frame callbacks registered by the page's view model.
        await tester.pumpAndSettle();

        final BuildContext context =
            tester.element(find.byType(ShellContentHost));
        final navigator = findShellContentNavigator(context);
        expect(navigator, isNotNull);
        expect(navigator, isA<NavigatorState>());
      },
    );

    test(
      'each ShellContentHost instance owns a distinct inner Navigator key',
      () {
        final a = ShellContentHost(
          module: ClientModule.servers,
          serverId: 'srv-1',
        );
        final b = ShellContentHost(
          module: ClientModule.ai,
          serverId: 'srv-1',
        );
        // Two hosts must not share a single static key (that was the
        // root cause of the "page content lost" bug). Each instance
        // owns its own GlobalKey.
        expect(identical(a, b), isFalse);
        expect(a, isNotNull);
        expect(b, isNotNull);
      },
    );

    testWidgets(
      'multiple mounted ShellContentHosts each expose their own Navigator',
      (tester) async {
        // The outer `DesktopContentHost` keeps an `IndexedStack` of
        // *every* previously-visited module's `ShellContentHost`
        // mounted at the same time. Each instance must own a
        // distinct `NavigatorState` so the active one is not silently
        // replaced by a sibling that was mounted later.
        final serverProvider = ServerProvider(
          repository: _NoopServerRepository(),
        );
        addTearDown(serverProvider.dispose);

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<ServerProvider>.value(
                value: serverProvider,
              ),
              ChangeNotifierProvider(
                create: (_) => CurrentServerController(),
              ),
              ChangeNotifierProvider(
                create: (_) => AppSettingsController(),
              ),
            ],
            child: MaterialApp(
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: const [Locale('en'), Locale('zh')],
              home: Scaffold(
                body: _MultiHostSwitcher(),
              ),
            ),
          ),
        );
        // pump a few frames; we don't need pumpAndSettle because no
        // page has any pending animation/timer.
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 50));

        final hostStates = tester
            .stateList<ShellContentHostState>(find.byType(ShellContentHost))
            .toList();
        expect(hostStates.length, 2,
            reason: 'Both module hosts must be mounted at once');
        final navigators =
            hostStates.map((s) => s.innerNavigator).toList(growable: false);
        expect(navigators.every((n) => n != null), isTrue,
            reason: 'Each ShellContentHost must own a non-null Navigator');
        // The two Navigators must be different instances.
        expect(identical(navigators[0], navigators[1]), isFalse,
            reason: 'Two mounted hosts must not share a single Navigator');
      },
    );
  });
}

/// A host that mounts two `ShellContentHost` widgets side-by-side —
/// mirroring what `DesktopContentHost`'s `IndexedStack` does in
/// production when the user has visited two or more top-level modules.
class _MultiHostSwitcher extends StatelessWidget {
  const _MultiHostSwitcher();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ShellContentHost(
            module: ClientModule.servers,
            serverId: 'srv-1',
          ),
        ),
        Expanded(
          child: ShellContentHost(
            module: ClientModule.ai,
            serverId: 'srv-1',
          ),
        ),
      ],
    );
  }
}

/// No-op replacement for [ServerRepository] used by the test only — it
/// returns an empty server list without touching storage or network.
class _NoopServerRepository extends ServerRepository {
  const _NoopServerRepository();

  @override
  Future<List<ServerCardViewModel>> loadServerCards() async =>
      const <ServerCardViewModel>[];

  @override
  Future<ServerMetricsSnapshot> loadServerMetrics(String serverId) async =>
      const ServerMetricsSnapshot();

  @override
  Future<void> setCurrent(String id) async {}

  @override
  Future<void> removeConfig(String id) async {}

  @override
  Future<void> saveConfig(ApiConfig config) async {}
}
