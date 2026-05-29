import 'package:flutter/material.dart';
import 'package:onepanel_client/core/i18n/l10n_x.dart';
import 'package:onepanel_client/core/theme/app_design_tokens.dart';
import 'package:onepanel_client/features/openresty/openresty_page.dart';
import 'package:onepanel_client/features/security_gateway/providers/security_gateway_center_provider.dart';
import 'package:onepanel_client/features/security_gateway/widgets/security_gateway_localizations.dart';
import 'package:onepanel_client/features/settings/panel_ssl/pages/panel_ssl_page.dart';
import 'package:onepanel_client/features/websites/pages/website_site_ssl_page.dart';
import 'package:onepanel_client/features/websites/pages/website_ssl_center_page.dart';
import 'package:onepanel_client/shared/security_gateway/widgets/risk_notice_banner.dart';
import 'package:provider/provider.dart';

class SecurityGatewayCenterPage extends StatelessWidget {
  const SecurityGatewayCenterPage({
    super.key,
    this.initialSection = SecurityGatewaySection.panelTls,
    this.initialWebsiteId,
    this.displayName,
    this.provider,
  });

  final SecurityGatewaySection initialSection;
  final int? initialWebsiteId;
  final String? displayName;
  final SecurityGatewayCenterProvider? provider;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SecurityGatewayCenterProvider>(
      create: (_) => provider ??
          SecurityGatewayCenterProvider(
            initialWebsiteId: initialWebsiteId,
          )
        ..load(),
      child: _SecurityGatewayCenterBody(
        initialSection: initialSection,
        initialWebsiteId: initialWebsiteId,
        displayName: displayName,
      ),
    );
  }
}

class _SecurityGatewayCenterBody extends StatelessWidget {
  const _SecurityGatewayCenterBody({
    required this.initialSection,
    this.initialWebsiteId,
    this.displayName,
  });

  final SecurityGatewaySection initialSection;
  final int? initialWebsiteId;
  final String? displayName;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Consumer<SecurityGatewayCenterProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.securityGatewayPageTitle),
            actions: [
              IconButton(
                onPressed: provider.load,
                icon: const Icon(Icons.refresh),
                tooltip: l10n.commonRefresh,
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(AppDesignTokens.spacingLg),
            children: [
              if (provider.isLoading) const LinearProgressIndicator(),
              RiskNoticeBanner(
                  notices: localizeSecurityGatewayRiskNotices(
                      context, provider.riskNotices),
                  title: l10n.securityGatewayUnifiedSummaryTitle),
              const SizedBox(height: AppDesignTokens.spacingMd),
              _SectionCard(
                title: l10n.securityGatewaySummarySection,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _MetricRow(
                        label: l10n.securityGatewayEntryFocusLabel,
                        value: _entryLabel(context, initialSection)),
                    _MetricRow(
                        label: l10n.securityGatewayPanelTlsSection,
                        value: provider.panelTlsEnabled
                            ? l10n.securityGatewayAvailable
                            : l10n.securityGatewayUnavailable),
                    _MetricRow(
                      label: l10n.securityGatewayWebsiteExpiringLabel,
                      value: l10n.securityGatewayCertificateCount(
                          provider.expiringCertificateCount),
                    ),
                    _MetricRow(
                      label: l10n.securityGatewayOpenRestyLabel,
                      value: provider.openRestyRunning
                          ? l10n.securityGatewayRunning
                          : l10n.securityGatewayInactive,
                    ),
                    _MetricRow(
                        label: l10n.securityGatewayLatestApplyLabel,
                        value: localizeSecurityGatewayLatestApply(
                            context, provider)),
                  ],
                ),
              ),
              const SizedBox(height: AppDesignTokens.spacingMd),
              _SectionCard(
                title: l10n.securityGatewayQuickActionsSection,
                child: Wrap(
                  spacing: AppDesignTokens.spacingSm,
                  runSpacing: AppDesignTokens.spacingSm,
                  children: [
                    FilledButton.icon(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const PanelSslPage()),
                      ),
                      icon: const Icon(Icons.download_outlined),
                      label: Text(l10n.securityGatewayPanelTlsSection),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => WebsiteSslCenterPage(
                              initialWebsiteId: initialWebsiteId),
                        ),
                      ),
                      icon: const Icon(Icons.workspace_premium_outlined),
                      label: Text(l10n.securityGatewayCertificateCenterAction),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => const OpenRestyPage()),
                      ),
                      icon: const Icon(Icons.hub_outlined),
                      label: Text(l10n.securityGatewayOpenRestyHttpsAction),
                    ),
                    OutlinedButton.icon(
                      key: const Key('security-gateway-rollback-action'),
                      onPressed: () async {
                        final success = await provider.rollbackLatest();
                        if (!context.mounted) {
                          return;
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              success
                                  ? l10n.securityGatewayRollbackSuccess
                                  : l10n.securityGatewayRollbackEmpty,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.history),
                      label: Text(l10n.securityGatewayRollbackLatestAction),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDesignTokens.spacingMd),
              _SectionCard(
                title: l10n.securityGatewayPanelTlsSection,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _MetricRow(
                        label: l10n.securityGatewayStatusLabel,
                        value: provider.panelTlsEnabled
                            ? l10n.securityGatewayLoaded
                            : l10n.securityGatewayUnavailable),
                    _MetricRow(
                      label: l10n.securityGatewayRiskLabel,
                      value: provider.riskNotices
                              .where((notice) =>
                                  notice.title == 'Panel TLS expired')
                              .isEmpty
                          ? l10n.securityGatewayNoPanelTlsRisk
                          : localizeSecurityGatewayRiskNotices(
                              context, provider.riskNotices)
                              .firstWhere(
                                  (notice) =>
                                      notice.title ==
                                      l10n
                                          .securityGatewayRiskPanelTlsExpiredTitle)
                              .message,
                    ),
                    _MetricRow(
                      label: l10n.securityGatewayRecentLabel,
                      value: localizeSecurityGatewayRecentSummary(
                          context, provider, 'panel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const PanelSslPage()),
                      ),
                      child: Text(l10n.securityGatewayOpenPanelTlsAction),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDesignTokens.spacingMd),
              _SectionCard(
                title: l10n.securityGatewayWebsiteCertsSection,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _MetricRow(
                        label: l10n.securityGatewaySummaryLabel,
                        value: l10n.securityGatewayCertsLoadedCount(
                            provider.certificates.length)),
                    _MetricRow(
                        label: l10n.securityGatewayRiskLabel,
                        value: l10n.securityGatewayExpiringSoonCount(
                            provider.expiringCertificateCount)),
                    _MetricRow(
                      label: l10n.securityGatewayRecentLabel,
                      value: localizeSecurityGatewayRecentSummary(
                          context, provider, 'website_https'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => WebsiteSslCenterPage(
                              initialWebsiteId: initialWebsiteId),
                        ),
                      ),
                      child: Text(l10n.securityGatewayOpenCertCenterAction),
                    ),
                    if (initialWebsiteId != null)
                      TextButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => WebsiteSiteSslPage(
                              websiteId: initialWebsiteId!,
                              displayName: displayName,
                            ),
                          ),
                        ),
                        child: Text(
                            l10n.securityGatewayOpenWebsiteStrategyAction),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppDesignTokens.spacingMd),
              _SectionCard(
                title: l10n.securityGatewayOpenRestyGatewaySection,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _MetricRow(
                        label: l10n.securityGatewayStatusLabel,
                        value: provider.openRestyRunning
                            ? l10n.securityGatewayRunning
                            : l10n.securityGatewayInactive),
                    _MetricRow(
                      label: l10n.openrestyTabHttps,
                      value: provider.openRestySnapshot.https['https'] == true
                          ? l10n.securityGatewayEnabled
                          : l10n.securityGatewayDisabled,
                    ),
                    _MetricRow(
                      label: l10n.securityGatewayRecentLabel,
                      value: localizeSecurityGatewayRecentSummary(
                          context, provider, 'openresty_'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => const OpenRestyPage()),
                      ),
                      child: Text(l10n.securityGatewayOpenOpenRestyAction),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _entryLabel(
      BuildContext context, SecurityGatewaySection section) {
    final l10n = context.l10n;
    switch (section) {
      case SecurityGatewaySection.panelTls:
        return l10n.securityGatewayEntryPanelTls;
      case SecurityGatewaySection.websiteCertificates:
        return l10n.securityGatewayEntryWebsiteCerts;
      case SecurityGatewaySection.openresty:
        return l10n.securityGatewayEntryOpenResty;
    }
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDesignTokens.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: AppDesignTokens.spacingMd),
            child,
          ],
        ),
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDesignTokens.spacingSm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 136,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
