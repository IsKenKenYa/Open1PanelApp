import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onepanel_client/features/shell/models/client_module.dart';
import 'package:onepanel_client/features/shell/module_registry.dart';

void main() {
  group('ModuleRegistry', () {
    test('every ClientModule has a registration', () {
      for (final module in ClientModule.values) {
        final reg = ModuleRegistry.registrationFor(module);
        expect(reg, isNotNull, reason: '$module should be registered');
        expect(reg!.module, module);
      }
    });

    testWidgets('buildShellPage returns a widget for every module',
        (tester) async {
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            for (final module in ClientModule.values) {
              final page = ModuleRegistry.buildShellPage(
                context,
                module,
                serverId: module.requiresServer ? 'server-1' : null,
              );
              expect(page, isA<Widget>(),
                  reason: '$module should build a widget');
            }
            return const SizedBox.shrink();
          },
        ),
      );
    });

    testWidgets(
        'buildStandalonePage returns null for non-standalone modules',
        (tester) async {
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            // servers and settings do not support standalone push
            expect(
              ModuleRegistry.buildStandalonePage(
                  ClientModule.servers, context),
              isNull,
            );
            expect(
              ModuleRegistry.buildStandalonePage(
                  ClientModule.settings, context),
              isNull,
            );
            // apps/websites/ai/verification do support standalone
            expect(
              ModuleRegistry.buildStandalonePage(ClientModule.apps, context),
              isNotNull,
            );
            expect(
              ModuleRegistry.buildStandalonePage(
                  ClientModule.websites, context),
              isNotNull,
            );
            return const SizedBox.shrink();
          },
        ),
      );
    });
  });
}
