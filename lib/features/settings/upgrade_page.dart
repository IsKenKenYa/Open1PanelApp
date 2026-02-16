import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:onepanelapp_app/core/theme/app_design_tokens.dart';
import 'package:onepanelapp_app/core/i18n/l10n_x.dart';
import 'package:onepanelapp_app/features/settings/settings_provider.dart';

class UpgradePage extends StatefulWidget {
  const UpgradePage({super.key});

  @override
  State<UpgradePage> createState() => _UpgradePageState();
}

class _UpgradePageState extends State<UpgradePage> {
  Future<dynamic>? _upgradeInfoFuture;
  Future<List<dynamic>?>? _releasesFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final provider = context.read<SettingsProvider>();
    _upgradeInfoFuture = provider.loadUpgradeInfo();
    _releasesFuture = provider.getUpgradeReleases();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final provider = context.watch<SettingsProvider>();
    final currentVersion = provider.data.systemSettings?.systemVersion ?? '-';

    return Scaffold(
      appBar: AppBar(title: Text(l10n.upgradeTitle)),
      body: FutureBuilder(
        future: _upgradeInfoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(l10n.commonLoadFailedTitle),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () {
                      setState(() {
                        _loadData();
                      });
                    },
                    child: Text(l10n.commonRetry),
                  ),
                ],
              ),
            );
          }

          return ListView(
            padding: AppDesignTokens.pagePadding,
            children: [
              _buildSectionTitle(context, l10n.upgradeCurrentVersion, theme),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text(l10n.upgradeCurrentVersionLabel),
                  trailing: Text(currentVersion, style: const TextStyle(color: Colors.grey)),
                ),
              ),
              const SizedBox(height: AppDesignTokens.spacingMd),
              _buildSectionTitle(context, l10n.upgradeAvailableVersions, theme),
              Card(
                child: FutureBuilder<List<dynamic>?>(
                  future: _releasesFuture,
                  builder: (context, releasesSnapshot) {
                    if (releasesSnapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (releasesSnapshot.hasError) {
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: Center(
                          child: Column(
                            children: [
                              const Icon(Icons.error_outline, color: Colors.red, size: 48),
                              const SizedBox(height: 8),
                              Text(l10n.commonLoadFailedTitle),
                            ],
                          ),
                        ),
                      );
                    }

                    final releases = releasesSnapshot.data;
                    if (releases == null || releases.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: Center(
                          child: Column(
                            children: [
                              const Icon(Icons.check_circle, color: Colors.green, size: 48),
                              const SizedBox(height: 8),
                              Text(l10n.upgradeNoUpdates),
                            ],
                          ),
                        ),
                      );
                    }

                    return Column(
                      children: releases.map((release) {
                        final version = release['version'] as String? ?? 'Unknown';
                        final description = release['description'] as String? ?? '';
                        final isLatest = release['isLatest'] == true;

                        return ListTile(
                          leading: Icon(
                            isLatest ? Icons.new_releases : Icons.update_outlined,
                            color: isLatest ? Colors.green : null,
                          ),
                          title: Text(version),
                          subtitle: description.isNotEmpty ? Text(description, maxLines: 2) : null,
                          trailing: isLatest 
                              ? Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    l10n.upgradeLatest,
                                    style: const TextStyle(fontSize: 12, color: Colors.green),
                                  ),
                                )
                              : null,
                          onTap: () => _showUpgradeDialog(context, provider, l10n, version),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          );
        },
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

  void _showUpgradeDialog(BuildContext context, SettingsProvider provider, AppLocalizations l10n, String version) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.upgradeConfirm),
        content: Text(l10n.upgradeConfirmMessage(version)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await provider.upgrade(version: version);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(success ? l10n.upgradeStarted : l10n.commonSaveFailed)),
                );
              }
            },
            child: Text(l10n.upgradeButton),
          ),
        ],
      ),
    );
  }
}
