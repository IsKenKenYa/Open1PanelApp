import 'package:flutter/material.dart';
import 'package:onepanel_client/core/i18n/l10n_x.dart';
import 'package:onepanel_client/features/security_gateway/providers/security_gateway_center_provider.dart';
import 'package:onepanel_client/shared/security_gateway/models/security_gateway_models.dart';

List<RiskNotice> localizeSecurityGatewayRiskNotices(
  BuildContext context,
  List<RiskNotice> notices,
) {
  final l10n = context.l10n;
  return notices.map((notice) {
    switch (notice.title) {
      case 'Panel TLS expired':
        return RiskNotice(
          level: notice.level,
          title: l10n.securityGatewayRiskPanelTlsExpiredTitle,
          message: l10n.securityGatewayRiskPanelTlsExpiredMessage,
        );
      case 'Website certificates expiring':
        return RiskNotice(
          level: notice.level,
          title: l10n.securityGatewayRiskWebsiteCertsExpiringTitle,
          message: l10n.securityGatewayRiskWebsiteCertsExpiringMessage(
            _extractCount(notice.message),
          ),
        );
      case 'OpenResty status unavailable':
        return RiskNotice(
          level: notice.level,
          title: l10n.securityGatewayRiskOpenRestyUnavailableTitle,
          message: l10n.securityGatewayRiskOpenRestyUnavailableMessage,
        );
      default:
        return notice;
    }
  }).toList(growable: false);
}

String localizeSecurityGatewayLatestApply(
  BuildContext context,
  SecurityGatewayCenterProvider provider,
) {
  final l10n = context.l10n;
  if (provider.recentSnapshots.isEmpty) {
    return l10n.securityGatewayNoRecentSnapshot;
  }
  return provider.recentSnapshots.first.title;
}

String localizeSecurityGatewayRecentSummary(
  BuildContext context,
  SecurityGatewayCenterProvider provider,
  String scopePrefix,
) {
  final l10n = context.l10n;
  for (final snapshot in provider.recentSnapshots) {
    if (snapshot.scope.startsWith(scopePrefix)) {
      return snapshot.summary;
    }
  }
  return l10n.securityGatewayNoRecentSnapshot;
}

int _extractCount(String message) {
  final match = RegExp(r'^(\d+)').firstMatch(message.trim());
  return match != null ? int.parse(match.group(1)!) : 0;
}
