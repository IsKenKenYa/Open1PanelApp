import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onepanel_client/features/orchestration/widgets/orchestration_resource_page_body.dart';
import 'package:onepanel_client/l10n/generated/app_localizations.dart';
import 'package:onepanel_client/shared/widgets/operations/module_error_state_widget.dart';

void main() {
  testWidgets('OrchestrationResourcePageBody shows blocking error when empty',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('zh'),
        home: Scaffold(
          body: OrchestrationResourcePageBody<String>(
          items: const [],
          error: 'network error',
          isLoading: false,
          onRefresh: () async {},
          itemBuilder: (item) => ListTile(title: Text(item)),
        ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(ModuleErrorStateWidget), findsOneWidget);
    expect(find.text('network error'), findsOneWidget);
    expect(find.text('加载失败'), findsOneWidget);
  });

  testWidgets('OrchestrationResourcePageBody shows toast not inline banner',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('zh'),
        home: Scaffold(
          body: OrchestrationResourcePageBody<String>(
          items: const ['item-a'],
          error: 'refresh failed',
          isLoading: false,
          onRefresh: () async {},
          itemBuilder: (item) => ListTile(title: Text(item)),
        ),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('item-a'), findsOneWidget);
    expect(find.byType(SnackBar), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(ListView),
        matching: find.text('refresh failed'),
      ),
      findsNothing,
    );
  });
}
