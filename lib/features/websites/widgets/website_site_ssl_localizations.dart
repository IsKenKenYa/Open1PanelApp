import 'package:flutter/material.dart';
import 'package:onepanel_client/core/i18n/l10n_x.dart';
import 'package:onepanel_client/shared/security_gateway/models/security_gateway_models.dart';

List<RiskNotice> localizeWebsiteSiteSslRiskNotices(
  BuildContext context,
  List<RiskNotice> notices,
) {
  final l10n = context.l10n;
  return notices.map((notice) {
    // NOTE: switch keys are canonical English titles from the provider.
    // If the provider changes these strings, the default branch will
    // return the original (unlocalized) notice. Update both sides together.
    switch (notice.title) {
      case 'HTTPS enabled without certificate':
        return RiskNotice(
          level: notice.level,
          title: l10n.websiteSiteSslRiskNoCertTitle,
          message: l10n.websiteSiteSslRiskNoCertMessage,
        );
      case 'Domain mismatch':
        return RiskNotice(
          level: notice.level,
          title: l10n.websiteSiteSslRiskDomainMismatchTitle,
          message: l10n.websiteSiteSslRiskDomainMismatchMessage,
        );
      case 'Expired certificate':
        return RiskNotice(
          level: notice.level,
          title: l10n.websiteSiteSslRiskExpiredCertTitle,
          message: l10n.websiteSiteSslRiskExpiredCertMessage,
        );
      case 'Certificate expiring soon':
        return RiskNotice(
          level: notice.level,
          title: l10n.websiteSiteSslRiskExpiringSoonTitle,
          message: l10n.websiteSiteSslRiskExpiringSoonMessage,
        );
      default:
        return notice;
    }
  }).toList(growable: false);
}

List<ConfigDiffItem> localizeWebsiteSiteSslDiffItems(
  BuildContext context,
  List<ConfigDiffItem> items,
) {
  final l10n = context.l10n;
  return items.map((item) {
    return ConfigDiffItem(
      field: item.field,
      label: _localizeDiffLabel(l10n, item.label),
      currentValue: _localizeDiffValue(l10n, item.currentValue),
      nextValue: _localizeDiffValue(l10n, item.nextValue),
    );
  }).toList(growable: false);
}

String _localizeDiffLabel(AppLocalizations l10n, String label) {
  switch (label) {
    case 'HTTPS':
      return l10n.websiteSiteSslDiffLabelHttps;
    case 'HTTP Mode':
      return l10n.websiteSiteSslDiffLabelHttpMode;
    case 'Certificate':
      return l10n.websiteSiteSslDiffLabelCertificate;
    case 'Expiration':
      return l10n.websiteSiteSslDiffLabelExpiration;
    case 'Provider':
      return l10n.websiteSiteSslDiffLabelProvider;
    default:
      return label;
  }
}

String _localizeDiffValue(dynamic l10n, String value) {
  switch (value) {
    case 'true':
      return l10n.systemSettingsEnabled;
    case 'false':
      return l10n.systemSettingsDisabled;
    default:
      return value;
  }
}
