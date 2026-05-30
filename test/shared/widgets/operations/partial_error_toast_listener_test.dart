import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onepanel_client/l10n/generated/app_localizations.dart';
import 'package:onepanel_client/shared/widgets/operations/partial_error_toast_listener.dart';

void main() {
  testWidgets('PartialErrorToastListener shows toast when cached data exists',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('zh'),
        home: Scaffold(
          body: PartialErrorToastListener(
            errorMessage: 'refresh failed',
            hasCachedData: true,
            onRetry: () {},
            child: const Text('content'),
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('content'), findsOneWidget);
  });

  testWidgets('PartialErrorToastListener skips toast without cached data',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('zh'),
        home: Scaffold(
          body: PartialErrorToastListener(
            errorMessage: 'load failed',
            hasCachedData: false,
            onRetry: () {},
            child: const Text('content'),
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('PartialErrorToastListener does not repeat same error toast',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('zh'),
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return PartialErrorToastListener(
                errorMessage: 'same error',
                hasCachedData: true,
                onRetry: () {},
                child: ElevatedButton(
                  onPressed: () => setState(() {}),
                  child: const Text('rebuild'),
                ),
              );
            },
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byType(SnackBar), findsOneWidget);

    await tester.tap(find.text('rebuild'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byType(SnackBar), findsOneWidget);
  });
}
