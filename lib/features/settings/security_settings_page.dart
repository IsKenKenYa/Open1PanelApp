import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:onepanelapp_app/core/theme/app_design_tokens.dart';
import 'package:onepanelapp_app/core/i18n/l10n_x.dart';
import 'package:onepanelapp_app/features/settings/settings_provider.dart';

class SecuritySettingsPage extends StatelessWidget {
  const SecuritySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final provider = context.watch<SettingsProvider>();
    final settings = provider.data.systemSettings;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.securitySettingsTitle)),
      body: ListView(
        padding: AppDesignTokens.pagePadding,
        children: [
          _buildSectionTitle(context, l10n.securitySettingsMfaSection, theme),
          Card(
            child: Column(
              children: [
                _buildInfoListTile(
                  title: l10n.securitySettingsMfaStatus,
                  value: _isEnabled(settings?.mfaStatus) ? l10n.systemSettingsEnabled : l10n.systemSettingsDisabled,
                  icon: Icons.security_outlined,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDesignTokens.spacingMd),
          _buildSectionTitle(context, l10n.securitySettingsAccessControl, theme),
          Card(
            child: Column(
              children: [
                _buildInfoListTile(
                  title: l10n.securitySettingsSecurityEntrance,
                  value: settings?.securityEntrance ?? '-',
                  icon: Icons.login_outlined,
                ),
                _buildInfoListTile(
                  title: l10n.securitySettingsBindDomain,
                  value: settings?.bindDomain ?? '-',
                  icon: Icons.domain_outlined,
                ),
                _buildInfoListTile(
                  title: l10n.securitySettingsAllowIPs,
                  value: settings?.allowIPs ?? '-',
                  icon: Icons.list_alt_outlined,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDesignTokens.spacingMd),
          _buildSectionTitle(context, l10n.securitySettingsPasswordPolicy, theme),
          Card(
            child: Column(
              children: [
                _buildInfoListTile(
                  title: l10n.securitySettingsComplexityVerification,
                  value: _isEnabled(settings?.complexityVerification) ? l10n.systemSettingsEnabled : l10n.systemSettingsDisabled,
                  icon: Icons.password_outlined,
                ),
                _buildInfoListTile(
                  title: l10n.securitySettingsExpirationDays,
                  value: settings?.expirationDays ?? '-',
                  icon: Icons.calendar_today_outlined,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDesignTokens.spacingSm),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildInfoListTile({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Text(value, style: const TextStyle(color: Colors.grey)),
    );
  }

  bool _isEnabled(String? value) {
    if (value == null) return false;
    return value.toLowerCase() == 'enable' || value.toLowerCase() == 'true';
  }
}
