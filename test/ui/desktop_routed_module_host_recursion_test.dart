import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onepanel_client/config/app_router.dart';
import 'package:onepanel_client/core/platform/platform_capabilities.dart';
import 'package:onepanel_client/ui/routing/route_registry.dart';
import 'package:onepanel_client/ui/routing/ui_target.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppRouter.generateEmbeddedRoute', () {
    setUp(() {
      AppRouter.resetRouteRegistryForTest();
      // The Flutter test framework checks foundation debug variables
      // are unset at the start of each test, so any prior test's
      // override must be cleared here too.
      debugDefaultTargetPlatformOverride = null;
      PlatformCapabilities.setTargetPlatformForTest(null);
    });

    tearDown(() {
      AppRouter.resetRouteRegistryForTest();
      debugDefaultTargetPlatformOverride = null;
      PlatformCapabilities.setTargetPlatformForTest(null);
    });

    testWidgets(
      'uses defaultBuilder and bypasses the platform override',
      (tester) async {
        // Register a route with both a defaultBuilder and a desktop
        // platform override. The override mirrors the recursion-prone
        // pattern used for `settingsFeedbackCenter`.
        const defaultMarker = Key('default-builder');
        const overrideMarker = Key('desktop-override-builder');

        AppRouter.registerRouteForTest(
          '/__test_recursive_route__',
          RouteEntry(
            defaultBuilder: (_, __) => const SizedBox(key: defaultMarker),
            platformOverrides: {
              UiPlatformKind.desktopMacos:
                  (_, __) => const SizedBox(key: overrideMarker),
              UiPlatformKind.desktopWindows:
                  (_, __) => const SizedBox(key: overrideMarker),
              UiPlatformKind.desktopLinux:
                  (_, __) => const SizedBox(key: overrideMarker),
            },
          ),
        );

        // Force desktop target so the platform override would be
        // picked by the regular `generateRoute` on macOS. We must
        // also override `defaultTargetPlatform` (used by
        // `UiTargetResolver.resolve`) — `PlatformCapabilities` alone
        // is not enough.
        debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
        PlatformCapabilities.setTargetPlatformForTest(TargetPlatform.macOS);

        const settings = RouteSettings(name: '/__test_recursive_route__');
        final regularRoute =
            AppRouter.generateRoute(settings) as MaterialPageRoute;
        final embeddedRoute =
            AppRouter.generateEmbeddedRoute(settings) as MaterialPageRoute;

        // Use a real widget tree so `UiTargetResolver.resolve` can
        // inspect the MediaQuery and report desktop macOS.
        late Widget regularChild;
        late Widget embeddedChild;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                // Capture the route outputs from inside a real
                // BuildContext that has a real MediaQuery.
                regularChild = regularRoute.builder(context);
                embeddedChild = embeddedRoute.builder(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        // On macOS the regular route picks the platform override.
        expect(regularChild, isA<SizedBox>());
        expect((regularChild as SizedBox).key, overrideMarker);
        // The embedded route always picks the default builder.
        expect(embeddedChild, isA<SizedBox>());
        expect((embeddedChild as SizedBox).key, defaultMarker);

        // Reset foundation debug variable before the test framework
        // checks invariants.
        debugDefaultTargetPlatformOverride = null;
      },
    );

    testWidgets(
      'embedded route returns defaultBuilder even on a non-desktop platform',
      (tester) async {
        const defaultMarker = Key('default-builder');
        const overrideMarker = Key('desktop-override-builder');

        AppRouter.registerRouteForTest(
          '/__test_recursive_route__',
          RouteEntry(
            defaultBuilder: (_, __) => const SizedBox(key: defaultMarker),
            platformOverrides: {
              UiPlatformKind.desktopMacos:
                  (_, __) => const SizedBox(key: overrideMarker),
            },
          ),
        );

        // Force a non-desktop target. Regular route picks default
        // (no override for android). Embedded route also picks
        // default.
        debugDefaultTargetPlatformOverride = TargetPlatform.android;
        PlatformCapabilities.setTargetPlatformForTest(TargetPlatform.android);

        const settings = RouteSettings(name: '/__test_recursive_route__');
        final regularRoute =
            AppRouter.generateRoute(settings) as MaterialPageRoute;
        final embeddedRoute =
            AppRouter.generateEmbeddedRoute(settings) as MaterialPageRoute;

        late Widget regularChild;
        late Widget embeddedChild;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                regularChild = regularRoute.builder(context);
                embeddedChild = embeddedRoute.builder(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect((regularChild as SizedBox).key, defaultMarker);
        expect((embeddedChild as SizedBox).key, defaultMarker);

        // Reset foundation debug variable before the test framework
        // checks invariants.
        debugDefaultTargetPlatformOverride = null;
      },
    );
  });
}
