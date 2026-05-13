import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:onepanel_client/config/app_router.dart';
import 'package:onepanel_client/l10n/generated/app_localizations.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    PackageInfo.setMockInitialValues(
      appName: '1Panel Client',
      packageName: 'com.iskenkenya.onepanel',
      version: '0.5.0-alpha.1',
      buildNumber: '42',
      buildSignature: '',
    );
  });

  testWidgets('testing warning dialog uses tablet-friendly width',
      (tester) async {
    tester.view.physicalSize = const Size(1024, 1366);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const SplashPage(),
      ),
    );

    await tester.pump(const Duration(milliseconds: 350));
    await tester.pump(const Duration(milliseconds: 100));

    final dialog = find.byKey(const Key('testing-warning-dialog'));
    expect(dialog, findsOneWidget);
    expect(tester.getRect(dialog).width, greaterThan(500));
  });
}
