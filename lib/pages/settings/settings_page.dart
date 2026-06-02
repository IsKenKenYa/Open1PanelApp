import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:onepanel_client/config/app_router.dart';
import 'package:onepanel_client/core/i18n/l10n_x.dart';
import 'package:onepanel_client/core/layout/adaptive_layout.dart';
import 'package:onepanel_client/core/services/app_settings_controller.dart';
import 'package:onepanel_client/core/services/onboarding_service.dart';
import 'package:onepanel_client/core/theme/app_design_tokens.dart';
import 'package:onepanel_client/core/theme/ui_render_mode.dart';
import 'package:onepanel_client/core/theme/ui_render_policy.dart';
import 'package:onepanel_client/features/settings/about_page.dart';
import 'package:onepanel_client/features/settings/app_lock_settings_page.dart';
import 'package:onepanel_client/features/settings/screens/theme_settings_page.dart';
import 'package:onepanel_client/features/shell/shell_navigation.dart';
import 'package:onepanel_client/features/shell/widgets/shell_drawer_scope.dart';
import 'package:onepanel_client/pages/settings/cache_settings_page.dart';

import '../../core/utils/snackbar_utils.dart';
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final spec = AdaptiveLayoutSpec.of(context);
    if (spec.isDesktop) {
      return const _SettingsPageDesktop();
    }
    if (spec.isTablet) {
      return const _SettingsPageTablet();
    }
    return const _SettingsPageMobile();
  }
}

class _SettingsPageMobile extends StatelessWidget {
  const _SettingsPageMobile();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    // When embedded in a shell, canPop is false and we show the drawer button;
    // when pushed standalone (e.g. from onboarding), show a back arrow.
    final canPop = Navigator.of(context).canPop();

    return Scaffold(
      appBar: AppBar(
        leading: canPop
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).maybePop(),
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              )
            : buildShellDrawerLeading(
                context,
                key: const Key('shell-drawer-menu-button'),
              ),
        title: Text(l10n.settingsPageTitle),
      ),
      body: const _SettingsBody(),
    );
  }
}

class _SettingsPageDesktop extends StatelessWidget {
  const _SettingsPageDesktop();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.surface,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: AdaptiveLayoutSpec.of(context).settingsBodyMaxWidth,
          ),
          child: ColoredBox(
            color: scheme.surface,
            child: const _SettingsBody(),
          ),
        ),
      ),
    );
  }
}

class _SettingsPageTablet extends StatelessWidget {
  const _SettingsPageTablet();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final spec = AdaptiveLayoutSpec.of(context);
    return Scaffold(
      backgroundColor: scheme.surface,
      body: AdaptiveWidthContainer(
        maxWidth: spec.settingsBodyMaxWidth,
        child: ColoredBox(
          color: scheme.surface,
          child: const _SettingsBody(),
        ),
      ),
    );
  }
}

class _SettingsBody extends StatelessWidget {
  const _SettingsBody();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ListView(
      padding: AdaptiveLayoutSpec.of(context).pagePadding,
      children: [
        Text(l10n.settingsGeneral,
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppDesignTokens.spacingSm),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.color_lens_outlined),
                title: Text(l10n.settingsTheme),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ThemeSettingsPage(),
                    ),
                  );
                },
              ),
              const Divider(height: 1),
              Consumer<AppSettingsController>(
                builder: (context, settings, _) {
                  return ListTile(
                    leading: const Icon(Icons.language_outlined),
                    title: Text(l10n.settingsLanguage),
                    subtitle: Text(
                      _languageLabel(context, settings.locale),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    // openRouteRespectingShell handles navigation both inside
                    // the shell (module switch) and standalone (push).
                    onTap: () => openRouteRespectingShell(
                      context,
                      AppRoutes.settingsLanguage,
                    ),
                  );
                },
              ),
              const Divider(height: 1),
              Consumer<AppSettingsController>(
                builder: (context, settings, _) {
                  return ListTile(
                    leading: const Icon(Icons.design_services_outlined),
                    title: Text(l10n.settingsUIRenderMode),
                    subtitle: Text(
                      settings.uiRenderMode == UIRenderMode.native
                          ? l10n.settingsUIRenderModeNative
                          : l10n.settingsUIRenderModeMD3,
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(l10n.settingsUIRenderMode),
                            content: RadioGroup<UIRenderMode>(
                              groupValue: settings.uiRenderMode,
                              onChanged: (value) {
                                if (value == null) {
                                  return;
                                }
                                settings.updateUIRenderMode(value);
                                Navigator.pop(context);
                                SnackBarUtils.showSuccess(context, l10n
                                          .settingsUIRenderModeRestartHint);
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (UIRenderPolicy.canSelectNativeMode())
                                    RadioListTile<UIRenderMode>(
                                      title:
                                          Text(l10n.settingsUIRenderModeNative),
                                      value: UIRenderMode.native,
                                    ),
                                  RadioListTile<UIRenderMode>(
                                    title: Text(l10n.settingsUIRenderModeMD3),
                                    value: UIRenderMode.md3,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.lock_person_outlined),
                title: Text(l10n.settingsAppLock),
                subtitle: Text(l10n.settingsAppLockDesc),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AppLockSettingsPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDesignTokens.spacingLg),
        Text(l10n.settingsStorage,
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppDesignTokens.spacingSm),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.cached_outlined),
                title: Text(l10n.settingsCacheTitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CacheSettingsPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDesignTokens.spacingLg),
        Text(l10n.settingsSupport,
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppDesignTokens.spacingSm),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.feedback_outlined),
                title: Text(l10n.settingsFeedbackCenterTitle),
                subtitle: Text(l10n.settingsFeedbackCenterSubtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => openRouteRespectingShell(
                  context,
                  AppRoutes.settingsFeedbackCenter,
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.policy_outlined),
                title: Text(l10n.settingsLegalCenterTitle),
                subtitle: Text(l10n.settingsLegalCenterSubtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => openRouteRespectingShell(
                  context,
                  AppRoutes.settingsLegalCenter,
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: Text(l10n.settingsAbout),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AboutPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDesignTokens.spacingLg),
        Text(l10n.settingsAppSectionTitle,
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppDesignTokens.spacingSm),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.dns_outlined),
                title: Text(l10n.settingsServerManagement),
                subtitle: Text(l10n.settingsServerManagementSubtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () =>
                    openRouteRespectingShell(context, AppRoutes.server),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.slideshow_outlined),
                title: Text(l10n.settingsResetOnboarding),
                onTap: () async {
                  await OnboardingService().resetAll();
                  if (!context.mounted) {
                    return;
                  }
                  SnackBarUtils.showSuccess(context, l10n.settingsResetOnboardingDone);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

String _languageLabel(BuildContext context, Locale? locale) {
  final l10n = context.l10n;
  switch (locale?.languageCode) {
    case 'zh':
      return l10n.languageZh;
    case 'en':
      return l10n.languageEn;
    default:
      return l10n.languageSystem;
  }
}
