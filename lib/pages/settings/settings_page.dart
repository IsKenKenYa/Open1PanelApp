import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:onepanelapp_app/core/i18n/l10n_x.dart';
import 'package:onepanelapp_app/core/services/app_settings_controller.dart';
import 'package:onepanelapp_app/core/services/app_preferences_service.dart';
import 'package:onepanelapp_app/core/services/onboarding_service.dart';
import 'package:onepanelapp_app/core/services/cache/file_preview_cache_manager.dart';
import 'package:onepanelapp_app/core/theme/app_design_tokens.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsPageTitle)),
      body: ListView(
        padding: AppDesignTokens.pagePadding,
        children: [
          Text(l10n.settingsGeneral,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppDesignTokens.spacingSm),
          Card(
            child: Padding(
              padding: AppDesignTokens.pagePadding,
              child: Consumer<AppSettingsController>(
                builder: (context, settings, _) {
                  return Column(
                    children: [
                      _ThemeSelector(settings: settings),
                      const Divider(height: 24),
                      _LanguageSelector(settings: settings),
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: AppDesignTokens.spacingLg),
          Text(l10n.settingsCacheTitle,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppDesignTokens.spacingSm),
          Card(
            child: Padding(
              padding: AppDesignTokens.pagePadding,
              child: Consumer<AppSettingsController>(
                builder: (context, settings, _) {
                  return Column(
                    children: [
                      _CacheStrategySelector(settings: settings),
                      const Divider(height: 24),
                      _CacheSizeSelector(settings: settings),
                      const Divider(height: 24),
                      _CacheStatsDisplay(),
                      const Divider(height: 24),
                      _ClearCacheButton(),
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: AppDesignTokens.spacingLg),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.dns_outlined),
                  title: Text(l10n.settingsServerManagement),
                  onTap: () => Navigator.pushNamed(context, '/server'),
                ),
                ListTile(
                  leading: const Icon(Icons.slideshow_outlined),
                  title: Text(l10n.settingsResetOnboarding),
                  onTap: () async {
                    await OnboardingService().resetAll();
                    if (!context.mounted) {
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.settingsResetOnboardingDone)),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text(l10n.settingsAbout),
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: l10n.appName,
                      applicationVersion: '1.0.0',
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeSelector extends StatelessWidget {
  const _ThemeSelector({required this.settings});

  final AppSettingsController settings;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      children: [
        Expanded(child: Text(l10n.settingsTheme)),
        DropdownButton<ThemeMode>(
          value: settings.themeMode,
          onChanged: (value) {
            if (value != null) {
              settings.updateThemeMode(value);
            }
          },
          items: [
            DropdownMenuItem(
                value: ThemeMode.system, child: Text(l10n.themeSystem)),
            DropdownMenuItem(
                value: ThemeMode.light, child: Text(l10n.themeLight)),
            DropdownMenuItem(
                value: ThemeMode.dark, child: Text(l10n.themeDark)),
          ],
        ),
      ],
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  const _LanguageSelector({required this.settings});

  final AppSettingsController settings;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final value = settings.locale?.languageCode ?? 'system';

    return Row(
      children: [
        Expanded(child: Text(l10n.settingsLanguage)),
        DropdownButton<String>(
          value: value,
          onChanged: (next) {
            switch (next) {
              case 'zh':
                settings.updateLocale(const Locale('zh'));
                break;
              case 'en':
                settings.updateLocale(const Locale('en'));
                break;
              default:
                settings.updateLocale(null);
            }
          },
          items: [
            DropdownMenuItem(value: 'system', child: Text(l10n.languageSystem)),
            DropdownMenuItem(value: 'zh', child: Text(l10n.languageZh)),
            DropdownMenuItem(value: 'en', child: Text(l10n.languageEn)),
          ],
        ),
      ],
    );
  }
}

class _CacheStrategySelector extends StatelessWidget {
  const _CacheStrategySelector({required this.settings});

  final AppSettingsController settings;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    
    return Row(
      children: [
        Expanded(child: Text(l10n.settingsCacheStrategy)),
        DropdownButton<CacheStrategy>(
          value: settings.cacheStrategy,
          onChanged: (value) {
            if (value != null) {
              settings.updateCacheStrategy(value);
            }
          },
          items: [
            DropdownMenuItem(
              value: CacheStrategy.hybrid,
              child: Text(l10n.settingsCacheStrategyHybrid),
            ),
            DropdownMenuItem(
              value: CacheStrategy.memoryOnly,
              child: Text(l10n.settingsCacheStrategyMemoryOnly),
            ),
            DropdownMenuItem(
              value: CacheStrategy.diskOnly,
              child: Text(l10n.settingsCacheStrategyDiskOnly),
            ),
          ],
        ),
      ],
    );
  }
}

class _CacheSizeSelector extends StatelessWidget {
  const _CacheSizeSelector({required this.settings});

  final AppSettingsController settings;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    
    return Row(
      children: [
        Expanded(child: Text(l10n.settingsCacheMaxSize)),
        DropdownButton<int>(
          value: settings.cacheMaxSizeMB,
          onChanged: (value) {
            if (value != null) {
              settings.updateCacheMaxSizeMB(value);
              FilePreviewCacheManager().initialize(
                strategy: settings.cacheStrategy,
                maxSizeMB: value,
              );
            }
          },
          items: [50, 100, 200, 500].map((size) {
            return DropdownMenuItem(
              value: size,
              child: Text('${size}MB'),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _CacheStatsDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final stats = FilePreviewCacheManager().getMemoryCacheStats();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.settingsCacheStats,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        Text(
          '${l10n.settingsCacheItemCount}: ${stats['itemCount']}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text(
          '${l10n.settingsCacheCurrentSize}: ${stats['currentSizeMB']}MB / ${stats['maxSizeMB']}MB',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _ClearCacheButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    
    return ElevatedButton.icon(
      onPressed: () async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(l10n.settingsCacheClearConfirm),
            content: Text(l10n.settingsCacheClearConfirmMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.commonCancel),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(l10n.commonConfirm),
              ),
            ],
          ),
        );
        
        if (confirmed == true && context.mounted) {
          await FilePreviewCacheManager().clearAllCache();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.settingsCacheCleared)),
            );
          }
        }
      },
      icon: const Icon(Icons.delete_outline),
      label: Text(l10n.settingsCacheClear),
    );
  }
}
