import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onepanel_client/features/server/server_provider.dart';
import 'package:onepanel_client/features/shell/controllers/current_server_controller.dart';
import 'package:onepanel_client/features/shell/controllers/pinned_modules_controller.dart';
import 'package:onepanel_client/features/shell/app_shell_page.dart';
import 'package:onepanel_client/l10n/generated/app_localizations.dart';
import 'package:onepanel_client/ui/mobile/app/mobile_shell_page.dart';
import 'package:onepanel_client/ui/tablet/app/tablet_shell_page.dart';
import 'package:onepanel_client/ui/routing/ui_target.dart';
import 'package:onepanel_client/ui/routing/ui_route_host.dart';
import 'package:provider/provider.dart';

Widget _buildHostUnderTest(
  RouteSettings settings, {
  Size size = const Size(390, 844),
  UiTarget? targetOverride,
}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ServerProvider()),
      ChangeNotifierProvider(create: (_) => CurrentServerController()),
      ChangeNotifierProvider(create: (_) => PinnedModulesController()),
    ],
    child: MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(size: size),
        child: UiRouteHost(
          settings: settings,
          debugTargetOverride: targetOverride,
        ),
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('zh')],
    ),
  );
}

void main() {
  group('UiRouteHost', () {
    testWidgets('home on Android builds MobileShellPage', (tester) async {
      await tester.pumpWidget(
        _buildHostUnderTest(RouteSettings(name: '/home')),
      );

      expect(find.byType(MobileShellPage), findsOneWidget);
      expect(find.byType(AppShellPage), findsOneWidget);
    },
        variant: const TargetPlatformVariant(<TargetPlatform>{
          TargetPlatform.android,
        }));

    testWidgets('tablet home builds TabletShellPage for harmony tablet',
        (tester) async {
      await tester.pumpWidget(
        _buildHostUnderTest(
          const RouteSettings(name: '/home'),
          size: const Size(1200, 900),
          targetOverride: const UiTarget(
            platformKind: UiPlatformKind.harmony,
            formFactor: UiFormFactor.tablet,
            tabletKind: TabletKind.harmonyPad,
          ),
        ),
      );

      expect(find.byType(TabletShellPage), findsOneWidget);
      expect(find.byType(AppShellPage), findsNothing);
    });

    testWidgets('unknown route shows not-found scaffold', (tester) async {
      await tester.pumpWidget(
        _buildHostUnderTest(RouteSettings(name: '/__unknown__')),
      );

      expect(find.byType(Scaffold), findsOneWidget);
    },
        variant: const TargetPlatformVariant(<TargetPlatform>{
          TargetPlatform.android,
        }));
  });
}
