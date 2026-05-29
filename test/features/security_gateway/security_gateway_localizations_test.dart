import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onepanel_client/features/security_gateway/widgets/security_gateway_localizations.dart';
import 'package:onepanel_client/features/websites/widgets/website_site_ssl_localizations.dart';
import 'package:onepanel_client/l10n/generated/app_localizations.dart';
import 'package:onepanel_client/shared/security_gateway/models/security_gateway_models.dart';

Widget _buildL10nApp(Locale locale, {required WidgetBuilder builder}) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: locale,
    home: Builder(builder: builder),
  );
}

Future<BuildContext> _pumpContext(
  WidgetTester tester,
  Locale locale,
) async {
  late BuildContext ctx;
  await tester.pumpWidget(_buildL10nApp(
    locale,
    builder: (context) {
      ctx = context;
      return const Placeholder();
    },
  ));
  return ctx;
}

void main() {
  group('localizeSecurityGatewayRiskNotices', () {
    testWidgets('maps "Panel TLS expired" to localized strings',
        (tester) async {
      final ctx = await _pumpContext(tester, const Locale('en'));
      final l10n = AppLocalizations.of(ctx);

      final input = [
        const RiskNotice(
          level: RiskLevel.high,
          title: 'Panel TLS expired',
          message: 'original message',
        ),
      ];

      final result = localizeSecurityGatewayRiskNotices(ctx, input);

      expect(result, hasLength(1));
      expect(result.first.title, l10n.securityGatewayRiskPanelTlsExpiredTitle);
      expect(result.first.message,
          l10n.securityGatewayRiskPanelTlsExpiredMessage);
      expect(result.first.level, RiskLevel.high);
    });

    testWidgets('maps "OpenResty status unavailable" to localized strings',
        (tester) async {
      final ctx = await _pumpContext(tester, const Locale('en'));
      final l10n = AppLocalizations.of(ctx);

      final input = [
        const RiskNotice(
          level: RiskLevel.medium,
          title: 'OpenResty status unavailable',
          message: 'original message',
        ),
      ];

      final result = localizeSecurityGatewayRiskNotices(ctx, input);

      expect(result, hasLength(1));
      expect(result.first.title,
          l10n.securityGatewayRiskOpenRestyUnavailableTitle);
      expect(result.first.message,
          l10n.securityGatewayRiskOpenRestyUnavailableMessage);
      expect(result.first.level, RiskLevel.medium);
    });

    testWidgets('maps "Website certificates expiring" and extracts count',
        (tester) async {
      final ctx = await _pumpContext(tester, const Locale('en'));
      final l10n = AppLocalizations.of(ctx);

      final input = [
        const RiskNotice(
          level: RiskLevel.low,
          title: 'Website certificates expiring',
          message: '5 website certificate(s) expire within 30 days.',
        ),
      ];

      final result = localizeSecurityGatewayRiskNotices(ctx, input);

      expect(result, hasLength(1));
      expect(result.first.title,
          l10n.securityGatewayRiskWebsiteCertsExpiringTitle);
      expect(result.first.message,
          l10n.securityGatewayRiskWebsiteCertsExpiringMessage(5));
      expect(result.first.level, RiskLevel.low);
    });

    testWidgets('extracts count of 0 when message has no leading number',
        (tester) async {
      final ctx = await _pumpContext(tester, const Locale('en'));
      final l10n = AppLocalizations.of(ctx);

      final input = [
        const RiskNotice(
          level: RiskLevel.low,
          title: 'Website certificates expiring',
          message: 'no leading number here',
        ),
      ];

      final result = localizeSecurityGatewayRiskNotices(ctx, input);

      expect(result.first.message,
          l10n.securityGatewayRiskWebsiteCertsExpiringMessage(0));
    });

    testWidgets('extracts count from message with leading whitespace',
        (tester) async {
      final ctx = await _pumpContext(tester, const Locale('en'));
      final l10n = AppLocalizations.of(ctx);

      final input = [
        const RiskNotice(
          level: RiskLevel.low,
          title: 'Website certificates expiring',
          message: '  12 certificates expiring soon',
        ),
      ];

      final result = localizeSecurityGatewayRiskNotices(ctx, input);

      expect(result.first.message,
          l10n.securityGatewayRiskWebsiteCertsExpiringMessage(12));
    });

    testWidgets('passes through unknown titles unchanged', (tester) async {
      final ctx = await _pumpContext(tester, const Locale('en'));

      const original = RiskNotice(
        level: RiskLevel.high,
        title: 'Some unknown risk',
        message: 'unknown message',
      );

      final result = localizeSecurityGatewayRiskNotices(ctx, [original]);

      expect(result, hasLength(1));
      expect(result.first.title, original.title);
      expect(result.first.message, original.message);
      expect(result.first.level, original.level);
    });

    testWidgets('localizes multiple notices in a single list', (tester) async {
      final ctx = await _pumpContext(tester, const Locale('en'));
      final l10n = AppLocalizations.of(ctx);

      final input = [
        const RiskNotice(
          level: RiskLevel.high,
          title: 'Panel TLS expired',
          message: 'msg1',
        ),
        const RiskNotice(
          level: RiskLevel.medium,
          title: 'OpenResty status unavailable',
          message: 'msg2',
        ),
        const RiskNotice(
          level: RiskLevel.low,
          title: 'Website certificates expiring',
          message: '3 certs',
        ),
      ];

      final result = localizeSecurityGatewayRiskNotices(ctx, input);

      expect(result, hasLength(3));
      expect(result[0].title, l10n.securityGatewayRiskPanelTlsExpiredTitle);
      expect(result[1].title,
          l10n.securityGatewayRiskOpenRestyUnavailableTitle);
      expect(result[2].title,
          l10n.securityGatewayRiskWebsiteCertsExpiringTitle);
      expect(result[2].message,
          l10n.securityGatewayRiskWebsiteCertsExpiringMessage(3));
    });

    testWidgets('returns non-growable list', (tester) async {
      final ctx = await _pumpContext(tester, const Locale('en'));

      final result = localizeSecurityGatewayRiskNotices(ctx, [
        const RiskNotice(
          level: RiskLevel.low,
          title: 'Panel TLS expired',
          message: 'msg',
        ),
      ]);

      expect(() => result.add(
            const RiskNotice(
              level: RiskLevel.low,
              title: 'x',
              message: 'y',
            ),
          ), throwsA(isA<UnsupportedError>()));
    });
  });

  group('localizeWebsiteSiteSslRiskNotices', () {
    testWidgets('maps "HTTPS enabled without certificate"', (tester) async {
      final ctx = await _pumpContext(tester, const Locale('en'));
      final l10n = AppLocalizations.of(ctx);

      final input = [
        const RiskNotice(
          level: RiskLevel.high,
          title: 'HTTPS enabled without certificate',
          message: 'original',
        ),
      ];

      final result = localizeWebsiteSiteSslRiskNotices(ctx, input);

      expect(result, hasLength(1));
      expect(result.first.title, l10n.websiteSiteSslRiskNoCertTitle);
      expect(result.first.message, l10n.websiteSiteSslRiskNoCertMessage);
    });

    testWidgets('maps "Domain mismatch"', (tester) async {
      final ctx = await _pumpContext(tester, const Locale('en'));
      final l10n = AppLocalizations.of(ctx);

      final input = [
        const RiskNotice(
          level: RiskLevel.medium,
          title: 'Domain mismatch',
          message: 'original',
        ),
      ];

      final result = localizeWebsiteSiteSslRiskNotices(ctx, input);

      expect(result.first.title, l10n.websiteSiteSslRiskDomainMismatchTitle);
      expect(
          result.first.message, l10n.websiteSiteSslRiskDomainMismatchMessage);
    });

    testWidgets('maps "Expired certificate"', (tester) async {
      final ctx = await _pumpContext(tester, const Locale('en'));
      final l10n = AppLocalizations.of(ctx);

      final input = [
        const RiskNotice(
          level: RiskLevel.high,
          title: 'Expired certificate',
          message: 'original',
        ),
      ];

      final result = localizeWebsiteSiteSslRiskNotices(ctx, input);

      expect(result.first.title, l10n.websiteSiteSslRiskExpiredCertTitle);
      expect(result.first.message, l10n.websiteSiteSslRiskExpiredCertMessage);
    });

    testWidgets('maps "Certificate expiring soon"', (tester) async {
      final ctx = await _pumpContext(tester, const Locale('en'));
      final l10n = AppLocalizations.of(ctx);

      final input = [
        const RiskNotice(
          level: RiskLevel.low,
          title: 'Certificate expiring soon',
          message: 'original',
        ),
      ];

      final result = localizeWebsiteSiteSslRiskNotices(ctx, input);

      expect(result.first.title, l10n.websiteSiteSslRiskExpiringSoonTitle);
      expect(
          result.first.message, l10n.websiteSiteSslRiskExpiringSoonMessage);
    });

    testWidgets('passes through unknown titles unchanged', (tester) async {
      final ctx = await _pumpContext(tester, const Locale('en'));

      const original = RiskNotice(
        level: RiskLevel.medium,
        title: 'Unknown SSL risk',
        message: 'some message',
      );

      final result = localizeWebsiteSiteSslRiskNotices(ctx, [original]);

      expect(result, hasLength(1));
      expect(result.first.title, original.title);
      expect(result.first.message, original.message);
    });

    testWidgets('returns non-growable list', (tester) async {
      final ctx = await _pumpContext(tester, const Locale('en'));

      final result = localizeWebsiteSiteSslRiskNotices(ctx, [
        const RiskNotice(
          level: RiskLevel.low,
          title: 'Domain mismatch',
          message: 'msg',
        ),
      ]);

      expect(() => result.add(
            const RiskNotice(
              level: RiskLevel.low,
              title: 'x',
              message: 'y',
            ),
          ), throwsA(isA<UnsupportedError>()));
    });
  });

  group('localizeWebsiteSiteSslDiffItems', () {
    testWidgets('localizes known diff labels', (tester) async {
      final ctx = await _pumpContext(tester, const Locale('en'));
      final l10n = AppLocalizations.of(ctx);

      final input = [
        const ConfigDiffItem(
          field: 'https',
          label: 'HTTPS',
          currentValue: 'on',
          nextValue: 'off',
        ),
        const ConfigDiffItem(
          field: 'httpMode',
          label: 'HTTP Mode',
          currentValue: 'redirect',
          nextValue: 'force',
        ),
        const ConfigDiffItem(
          field: 'cert',
          label: 'Certificate',
          currentValue: 'cert-a',
          nextValue: 'cert-b',
        ),
        const ConfigDiffItem(
          field: 'exp',
          label: 'Expiration',
          currentValue: '2024-01-01',
          nextValue: '2025-01-01',
        ),
        const ConfigDiffItem(
          field: 'provider',
          label: 'Provider',
          currentValue: 'letsencrypt',
          nextValue: 'zerossl',
        ),
      ];

      final result = localizeWebsiteSiteSslDiffItems(ctx, input);

      expect(result, hasLength(5));
      expect(result[0].label, l10n.websiteSiteSslDiffLabelHttps);
      expect(result[1].label, l10n.websiteSiteSslDiffLabelHttpMode);
      expect(result[2].label, l10n.websiteSiteSslDiffLabelCertificate);
      expect(result[3].label, l10n.websiteSiteSslDiffLabelExpiration);
      expect(result[4].label, l10n.websiteSiteSslDiffLabelProvider);
    });

    testWidgets('localizes "true"/"false" values to enabled/disabled',
        (tester) async {
      final ctx = await _pumpContext(tester, const Locale('en'));
      final l10n = AppLocalizations.of(ctx);

      final input = [
        const ConfigDiffItem(
          field: 'https',
          label: 'HTTPS',
          currentValue: 'false',
          nextValue: 'true',
        ),
      ];

      final result = localizeWebsiteSiteSslDiffItems(ctx, input);

      expect(result, hasLength(1));
      expect(result.first.currentValue, l10n.systemSettingsDisabled);
      expect(result.first.nextValue, l10n.systemSettingsEnabled);
    });

    testWidgets('preserves field name and unknown labels/values',
        (tester) async {
      final ctx = await _pumpContext(tester, const Locale('en'));

      final input = [
        const ConfigDiffItem(
          field: 'customField',
          label: 'Custom Label',
          currentValue: 'some-value',
          nextValue: 'other-value',
        ),
      ];

      final result = localizeWebsiteSiteSslDiffItems(ctx, input);

      expect(result, hasLength(1));
      expect(result.first.field, 'customField');
      expect(result.first.label, 'Custom Label');
      expect(result.first.currentValue, 'some-value');
      expect(result.first.nextValue, 'other-value');
    });

    testWidgets('returns non-growable list', (tester) async {
      final ctx = await _pumpContext(tester, const Locale('en'));

      final result = localizeWebsiteSiteSslDiffItems(ctx, [
        const ConfigDiffItem(
          field: 'f',
          label: 'HTTPS',
          currentValue: 'a',
          nextValue: 'b',
        ),
      ]);

      expect(() => result.add(
            const ConfigDiffItem(
              field: 'x',
              label: 'y',
              currentValue: 'a',
              nextValue: 'b',
            ),
          ), throwsA(isA<UnsupportedError>()));
    });
  });

  group('localization differs by locale', () {
    testWidgets('Chinese locale produces different strings than English',
        (tester) async {
      final enCtx = await _pumpContext(tester, const Locale('en'));
      final enL10n = AppLocalizations.of(enCtx);

      final zhCtx = await _pumpContext(tester, const Locale('zh'));
      final zhL10n = AppLocalizations.of(zhCtx);

      expect(
        enL10n.securityGatewayRiskPanelTlsExpiredTitle,
        isNot(zhL10n.securityGatewayRiskPanelTlsExpiredTitle),
      );
      expect(
        enL10n.websiteSiteSslRiskDomainMismatchTitle,
        isNot(zhL10n.websiteSiteSslRiskDomainMismatchTitle),
      );
      expect(
        enL10n.systemSettingsEnabled,
        isNot(zhL10n.systemSettingsEnabled),
      );
    });

    testWidgets('security gateway notices use Chinese strings for zh locale',
        (tester) async {
      final ctx = await _pumpContext(tester, const Locale('zh'));
      final l10n = AppLocalizations.of(ctx);

      final input = [
        const RiskNotice(
          level: RiskLevel.high,
          title: 'Panel TLS expired',
          message: 'msg',
        ),
      ];

      final result = localizeSecurityGatewayRiskNotices(ctx, input);

      expect(result.first.title, l10n.securityGatewayRiskPanelTlsExpiredTitle);
      expect(result.first.title, isNot('Panel TLS expired'));
    });

    testWidgets('SSL diff values use Chinese strings for zh locale',
        (tester) async {
      final ctx = await _pumpContext(tester, const Locale('zh'));
      final l10n = AppLocalizations.of(ctx);

      final input = [
        const ConfigDiffItem(
          field: 'https',
          label: 'HTTPS',
          currentValue: 'true',
          nextValue: 'false',
        ),
      ];

      final result = localizeWebsiteSiteSslDiffItems(ctx, input);

      expect(result.first.currentValue, l10n.systemSettingsEnabled);
      expect(result.first.nextValue, l10n.systemSettingsDisabled);
      expect(result.first.currentValue, isNot('Enabled'));
    });
  });
}
