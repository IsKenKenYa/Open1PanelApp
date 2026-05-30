import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onepanel_client/core/utils/snackbar_utils.dart';
import 'package:onepanel_client/l10n/generated/app_localizations.dart';

void main() {
  testWidgets('SnackBarUtils.showErrorWithRetry shows snackbar with retry action',
      (tester) async {
    var retried = false;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  SnackBarUtils.showErrorWithRetry(
                    context,
                    '加载失败: 网络错误',
                    () => retried = true,
                    retryLabel: '重试',
                  );
                },
                child: const Text('show'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('show'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('重试'), findsOneWidget);

    final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
    snackBar.action!.onPressed();

    expect(retried, isTrue);
  });

  testWidgets('SnackBarUtils.showError truncates long messages', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  SnackBarUtils.showError(context, 'x' * 200);
                },
                child: const Text('show'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('show'));
    await tester.pump();

    final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
    final content = snackBar.content as Row;
    final text = content.children.whereType<Expanded>().first.child as Text;
    expect(text.data!.length, lessThanOrEqualTo(120));
  });
}
