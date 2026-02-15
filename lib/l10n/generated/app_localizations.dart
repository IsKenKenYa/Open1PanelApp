import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'1Panel Open'**
  String get appName;

  /// No description provided for @commonLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get commonLoading;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get commonConfirm;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get commonRefresh;

  /// No description provided for @commonComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get commonComingSoon;

  /// No description provided for @commonEmpty.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get commonEmpty;

  /// No description provided for @commonLoadFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Failed to load'**
  String get commonLoadFailedTitle;

  /// No description provided for @monitorNetworkLabel.
  ///
  /// In en, this message translates to:
  /// **'Network'**
  String get monitorNetworkLabel;

  /// No description provided for @monitorMetricCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get monitorMetricCurrent;

  /// No description provided for @monitorMetricMin.
  ///
  /// In en, this message translates to:
  /// **'Min'**
  String get monitorMetricMin;

  /// No description provided for @monitorMetricAvg.
  ///
  /// In en, this message translates to:
  /// **'Avg'**
  String get monitorMetricAvg;

  /// No description provided for @monitorMetricMax.
  ///
  /// In en, this message translates to:
  /// **'Max'**
  String get monitorMetricMax;

  /// No description provided for @navServer.
  ///
  /// In en, this message translates to:
  /// **'Servers'**
  String get navServer;

  /// No description provided for @navFiles.
  ///
  /// In en, this message translates to:
  /// **'Files'**
  String get navFiles;

  /// No description provided for @navSecurity.
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get navSecurity;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @serverPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Servers'**
  String get serverPageTitle;

  /// No description provided for @serverSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search server name or IP'**
  String get serverSearchHint;

  /// No description provided for @serverAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get serverAdd;

  /// No description provided for @serverListEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No servers yet'**
  String get serverListEmptyTitle;

  /// No description provided for @serverListEmptyDesc.
  ///
  /// In en, this message translates to:
  /// **'Add your first 1Panel server to get started.'**
  String get serverListEmptyDesc;

  /// No description provided for @serverOnline.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get serverOnline;

  /// No description provided for @serverOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get serverOffline;

  /// No description provided for @serverCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get serverCurrent;

  /// No description provided for @serverDefault.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get serverDefault;

  /// No description provided for @serverIpLabel.
  ///
  /// In en, this message translates to:
  /// **'IP'**
  String get serverIpLabel;

  /// No description provided for @serverCpuLabel.
  ///
  /// In en, this message translates to:
  /// **'CPU'**
  String get serverCpuLabel;

  /// No description provided for @serverMemoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Memory'**
  String get serverMemoryLabel;

  /// No description provided for @serverLoadLabel.
  ///
  /// In en, this message translates to:
  /// **'Load'**
  String get serverLoadLabel;

  /// No description provided for @serverDiskLabel.
  ///
  /// In en, this message translates to:
  /// **'Disk'**
  String get serverDiskLabel;

  /// No description provided for @serverMetricsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Metrics unavailable'**
  String get serverMetricsUnavailable;

  /// No description provided for @serverOpenDetail.
  ///
  /// In en, this message translates to:
  /// **'Open details'**
  String get serverOpenDetail;

  /// No description provided for @serverDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Server Details'**
  String get serverDetailTitle;

  /// No description provided for @serverModulesTitle.
  ///
  /// In en, this message translates to:
  /// **'Modules'**
  String get serverModulesTitle;

  /// No description provided for @serverModuleApps.
  ///
  /// In en, this message translates to:
  /// **'Apps'**
  String get serverModuleApps;

  /// No description provided for @serverModuleContainers.
  ///
  /// In en, this message translates to:
  /// **'Containers'**
  String get serverModuleContainers;

  /// No description provided for @serverModuleWebsites.
  ///
  /// In en, this message translates to:
  /// **'Websites'**
  String get serverModuleWebsites;

  /// No description provided for @serverModuleDatabases.
  ///
  /// In en, this message translates to:
  /// **'Databases'**
  String get serverModuleDatabases;

  /// No description provided for @serverModuleFirewall.
  ///
  /// In en, this message translates to:
  /// **'Firewall'**
  String get serverModuleFirewall;

  /// No description provided for @serverModuleTerminal.
  ///
  /// In en, this message translates to:
  /// **'Terminal'**
  String get serverModuleTerminal;

  /// No description provided for @serverModuleMonitoring.
  ///
  /// In en, this message translates to:
  /// **'Monitoring'**
  String get serverModuleMonitoring;

  /// No description provided for @serverModuleFiles.
  ///
  /// In en, this message translates to:
  /// **'File Manager'**
  String get serverModuleFiles;

  /// No description provided for @serverInsightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get serverInsightsTitle;

  /// No description provided for @serverActionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get serverActionsTitle;

  /// No description provided for @serverActionRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get serverActionRefresh;

  /// No description provided for @serverActionSwitch.
  ///
  /// In en, this message translates to:
  /// **'Switch server'**
  String get serverActionSwitch;

  /// No description provided for @serverActionSecurity.
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get serverActionSecurity;

  /// No description provided for @serverFormTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Server'**
  String get serverFormTitle;

  /// No description provided for @serverFormName.
  ///
  /// In en, this message translates to:
  /// **'Server name'**
  String get serverFormName;

  /// No description provided for @serverFormNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Production'**
  String get serverFormNameHint;

  /// No description provided for @serverFormUrl.
  ///
  /// In en, this message translates to:
  /// **'Server URL'**
  String get serverFormUrl;

  /// No description provided for @serverFormUrlHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. https://panel.example.com'**
  String get serverFormUrlHint;

  /// No description provided for @serverFormApiKey.
  ///
  /// In en, this message translates to:
  /// **'API key'**
  String get serverFormApiKey;

  /// No description provided for @serverFormApiKeyHint.
  ///
  /// In en, this message translates to:
  /// **'Enter API key'**
  String get serverFormApiKeyHint;

  /// No description provided for @serverFormSaveConnect.
  ///
  /// In en, this message translates to:
  /// **'Save and continue'**
  String get serverFormSaveConnect;

  /// No description provided for @serverFormTest.
  ///
  /// In en, this message translates to:
  /// **'Test connection'**
  String get serverFormTest;

  /// No description provided for @serverFormRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get serverFormRequired;

  /// No description provided for @serverFormSaveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Server saved'**
  String get serverFormSaveSuccess;

  /// No description provided for @serverFormSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save server: {error}'**
  String serverFormSaveFailed(String error);

  /// No description provided for @serverFormTestHint.
  ///
  /// In en, this message translates to:
  /// **'Connection test can be added after client adaptation.'**
  String get serverFormTestHint;

  /// No description provided for @filesPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Files'**
  String get filesPageTitle;

  /// No description provided for @filesPath.
  ///
  /// In en, this message translates to:
  /// **'Path'**
  String get filesPath;

  /// No description provided for @filesRoot.
  ///
  /// In en, this message translates to:
  /// **'Root'**
  String get filesRoot;

  /// No description provided for @filesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'File browser placeholder'**
  String get filesEmptyTitle;

  /// No description provided for @filesEmptyDesc.
  ///
  /// In en, this message translates to:
  /// **'UI is ready. Connect file client APIs next.'**
  String get filesEmptyDesc;

  /// No description provided for @filesActionUpload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get filesActionUpload;

  /// No description provided for @filesActionNewFile.
  ///
  /// In en, this message translates to:
  /// **'New file'**
  String get filesActionNewFile;

  /// No description provided for @filesActionNewFolder.
  ///
  /// In en, this message translates to:
  /// **'New folder'**
  String get filesActionNewFolder;

  /// No description provided for @securityPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Dynamic Verification'**
  String get securityPageTitle;

  /// No description provided for @securityStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'MFA status'**
  String get securityStatusTitle;

  /// No description provided for @securityStatusEnabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get securityStatusEnabled;

  /// No description provided for @securityStatusDisabled.
  ///
  /// In en, this message translates to:
  /// **'Not enabled'**
  String get securityStatusDisabled;

  /// No description provided for @securitySecretLabel.
  ///
  /// In en, this message translates to:
  /// **'Secret'**
  String get securitySecretLabel;

  /// No description provided for @securityCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Verification code'**
  String get securityCodeLabel;

  /// No description provided for @securityCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Enter 6-digit code'**
  String get securityCodeHint;

  /// No description provided for @securityLoadInfo.
  ///
  /// In en, this message translates to:
  /// **'Load MFA info'**
  String get securityLoadInfo;

  /// No description provided for @securityBind.
  ///
  /// In en, this message translates to:
  /// **'Bind MFA'**
  String get securityBind;

  /// No description provided for @securityBindSuccess.
  ///
  /// In en, this message translates to:
  /// **'MFA binding request submitted'**
  String get securityBindSuccess;

  /// No description provided for @securityBindFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to bind MFA: {error}'**
  String securityBindFailed(String error);

  /// No description provided for @securityMockNotice.
  ///
  /// In en, this message translates to:
  /// **'Current screen uses UI adapter mode. API client can be connected later.'**
  String get securityMockNotice;

  /// No description provided for @settingsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsPageTitle;

  /// No description provided for @settingsGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get settingsGeneral;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsServerManagement.
  ///
  /// In en, this message translates to:
  /// **'Server management'**
  String get settingsServerManagement;

  /// No description provided for @settingsResetOnboarding.
  ///
  /// In en, this message translates to:
  /// **'Replay onboarding'**
  String get settingsResetOnboarding;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsResetOnboardingDone.
  ///
  /// In en, this message translates to:
  /// **'Onboarding state has been reset'**
  String get settingsResetOnboardingDone;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'Follow system'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get languageSystem;

  /// No description provided for @languageZh.
  ///
  /// In en, this message translates to:
  /// **'Chinese'**
  String get languageZh;

  /// No description provided for @languageEn.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEn;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get onboardingStart;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Manage your 1Panel servers'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDesc1.
  ///
  /// In en, this message translates to:
  /// **'Unified mobile operations for monitoring, files, and security.'**
  String get onboardingDesc1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Fast switching and clear status'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDesc2.
  ///
  /// In en, this message translates to:
  /// **'View key metrics and switch servers quickly with a card-based layout.'**
  String get onboardingDesc2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Built for progressive API integration'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDesc3.
  ///
  /// In en, this message translates to:
  /// **'UI is stable first. Missing APIs are tracked in review docs for follow-up.'**
  String get onboardingDesc3;

  /// No description provided for @coachServerAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add your first server'**
  String get coachServerAddTitle;

  /// No description provided for @coachServerAddDesc.
  ///
  /// In en, this message translates to:
  /// **'Tap here to create a server profile.'**
  String get coachServerAddDesc;

  /// No description provided for @coachServerCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Open server details'**
  String get coachServerCardTitle;

  /// No description provided for @coachServerCardDesc.
  ///
  /// In en, this message translates to:
  /// **'Tap a server card to see modules and quick actions.'**
  String get coachServerCardDesc;

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboardTitle;

  /// No description provided for @dashboardLoadFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Failed to load'**
  String get dashboardLoadFailedTitle;

  /// No description provided for @dashboardServerInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Server info'**
  String get dashboardServerInfoTitle;

  /// No description provided for @dashboardServerStatusOk.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get dashboardServerStatusOk;

  /// No description provided for @dashboardServerStatusConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting...'**
  String get dashboardServerStatusConnecting;

  /// No description provided for @dashboardHostNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Hostname'**
  String get dashboardHostNameLabel;

  /// No description provided for @dashboardOsLabel.
  ///
  /// In en, this message translates to:
  /// **'Operating system'**
  String get dashboardOsLabel;

  /// No description provided for @dashboardUptimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Uptime'**
  String get dashboardUptimeLabel;

  /// No description provided for @dashboardUptimeDaysHours.
  ///
  /// In en, this message translates to:
  /// **'{days}d {hours}h'**
  String dashboardUptimeDaysHours(int days, int hours);

  /// No description provided for @dashboardUptimeHours.
  ///
  /// In en, this message translates to:
  /// **'{hours}h'**
  String dashboardUptimeHours(int hours);

  /// No description provided for @dashboardUpdatedAt.
  ///
  /// In en, this message translates to:
  /// **'Updated at {time}'**
  String dashboardUpdatedAt(String time);

  /// No description provided for @dashboardResourceTitle.
  ///
  /// In en, this message translates to:
  /// **'System resources'**
  String get dashboardResourceTitle;

  /// No description provided for @dashboardCpuUsage.
  ///
  /// In en, this message translates to:
  /// **'CPU usage'**
  String get dashboardCpuUsage;

  /// No description provided for @dashboardMemoryUsage.
  ///
  /// In en, this message translates to:
  /// **'Memory usage'**
  String get dashboardMemoryUsage;

  /// No description provided for @dashboardDiskUsage.
  ///
  /// In en, this message translates to:
  /// **'Disk usage'**
  String get dashboardDiskUsage;

  /// No description provided for @dashboardQuickActionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get dashboardQuickActionsTitle;

  /// No description provided for @dashboardActionRestart.
  ///
  /// In en, this message translates to:
  /// **'Restart server'**
  String get dashboardActionRestart;

  /// No description provided for @dashboardActionUpdate.
  ///
  /// In en, this message translates to:
  /// **'System update'**
  String get dashboardActionUpdate;

  /// No description provided for @dashboardActionBackup.
  ///
  /// In en, this message translates to:
  /// **'Create backup'**
  String get dashboardActionBackup;

  /// No description provided for @dashboardActionSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security check'**
  String get dashboardActionSecurity;

  /// No description provided for @dashboardRestartTitle.
  ///
  /// In en, this message translates to:
  /// **'Restart server'**
  String get dashboardRestartTitle;

  /// No description provided for @dashboardRestartDesc.
  ///
  /// In en, this message translates to:
  /// **'Restarting will temporarily interrupt all services. Continue?'**
  String get dashboardRestartDesc;

  /// No description provided for @dashboardRestartSuccess.
  ///
  /// In en, this message translates to:
  /// **'Restart request sent'**
  String get dashboardRestartSuccess;

  /// No description provided for @dashboardRestartFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to restart: {error}'**
  String dashboardRestartFailed(String error);

  /// No description provided for @dashboardUpdateTitle.
  ///
  /// In en, this message translates to:
  /// **'System update'**
  String get dashboardUpdateTitle;

  /// No description provided for @dashboardUpdateDesc.
  ///
  /// In en, this message translates to:
  /// **'Start the update now? The panel may be temporarily unavailable.'**
  String get dashboardUpdateDesc;

  /// No description provided for @dashboardUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Update request sent'**
  String get dashboardUpdateSuccess;

  /// No description provided for @dashboardUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update: {error}'**
  String dashboardUpdateFailed(String error);

  /// No description provided for @dashboardActivityTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent activity'**
  String get dashboardActivityTitle;

  /// No description provided for @dashboardActivityEmpty.
  ///
  /// In en, this message translates to:
  /// **'No recent activity'**
  String get dashboardActivityEmpty;

  /// No description provided for @dashboardActivityDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String dashboardActivityDaysAgo(int count);

  /// No description provided for @dashboardActivityHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String dashboardActivityHoursAgo(int count);

  /// No description provided for @dashboardActivityMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}m ago'**
  String dashboardActivityMinutesAgo(int count);

  /// No description provided for @dashboardActivityJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get dashboardActivityJustNow;

  /// No description provided for @dashboardTopProcessesTitle.
  ///
  /// In en, this message translates to:
  /// **'Process Monitor'**
  String get dashboardTopProcessesTitle;

  /// No description provided for @dashboardCpuTab.
  ///
  /// In en, this message translates to:
  /// **'CPU'**
  String get dashboardCpuTab;

  /// No description provided for @dashboardMemoryTab.
  ///
  /// In en, this message translates to:
  /// **'Memory'**
  String get dashboardMemoryTab;

  /// No description provided for @dashboardNoProcesses.
  ///
  /// In en, this message translates to:
  /// **'No process data'**
  String get dashboardNoProcesses;

  /// No description provided for @coachDone.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get coachDone;

  /// No description provided for @notFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get notFoundTitle;

  /// No description provided for @notFoundDesc.
  ///
  /// In en, this message translates to:
  /// **'The requested page does not exist.'**
  String get notFoundDesc;

  /// No description provided for @legacyRouteRedirect.
  ///
  /// In en, this message translates to:
  /// **'This legacy route is redirected to the new shell.'**
  String get legacyRouteRedirect;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
