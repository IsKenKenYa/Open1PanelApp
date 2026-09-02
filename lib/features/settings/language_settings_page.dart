import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:onepanel_client/core/i18n/l10n_x.dart';
import 'package:onepanel_client/core/services/app_settings_controller.dart';
import 'package:onepanel_client/core/theme/app_design_tokens.dart';
import 'package:onepanel_client/shared/widgets/section_card.dart';

class LanguageSettingsPage extends StatelessWidget {
  const LanguageSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(l10n.settingsLanguage),
      ),
      body: Consumer<AppSettingsController>(
        builder: (context, settings, _) {
          final value = settings.locale?.languageCode ?? 'system';
          final colorScheme = Theme.of(context).colorScheme;
          Widget optionTrailing(bool selected) => selected
              ? Icon(Icons.check_circle, color: colorScheme.primary)
              : const Icon(Icons.chevron_right);
          return ListView(
            padding: AppDesignTokens.pagePadding,
            children: [
              Text(
                l10n.settingsLanguageHint,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppDesignTokens.spacingSm),
              SectionEntryList(
                items: [
                  SectionEntryItem(
                    icon: Icons.phone_android_outlined,
                    title: l10n.languageSystem,
                    trailing: optionTrailing(value == 'system'),
                    onTap: () => settings.updateLocale(null),
                  ),
                  SectionEntryItem(
                    icon: Icons.translate_outlined,
                    title: l10n.languageZh,
                    trailing: optionTrailing(value == 'zh'),
                    onTap: () => settings.updateLocale(const Locale('zh')),
                  ),
                  SectionEntryItem(
                    icon: Icons.language_outlined,
                    title: l10n.languageEn,
                    trailing: optionTrailing(value == 'en'),
                    onTap: () => settings.updateLocale(const Locale('en')),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
