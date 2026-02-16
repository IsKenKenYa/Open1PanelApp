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

  /// No description provided for @commonSaveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Saved successfully'**
  String get commonSaveSuccess;

  /// No description provided for @commonSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save'**
  String get commonSaveFailed;

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

  /// No description provided for @serverModuleDashboard.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get serverModuleDashboard;

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

  /// No description provided for @serverTestSuccess.
  ///
  /// In en, this message translates to:
  /// **'Connection successful'**
  String get serverTestSuccess;

  /// No description provided for @serverTestFailed.
  ///
  /// In en, this message translates to:
  /// **'Connection failed'**
  String get serverTestFailed;

  /// No description provided for @serverTestTesting.
  ///
  /// In en, this message translates to:
  /// **'Testing connection...'**
  String get serverTestTesting;

  /// No description provided for @serverMetricsAvailable.
  ///
  /// In en, this message translates to:
  /// **'Metrics loaded'**
  String get serverMetricsAvailable;

  /// No description provided for @serverTokenValidity.
  ///
  /// In en, this message translates to:
  /// **'Token validity (minutes)'**
  String get serverTokenValidity;

  /// No description provided for @serverTokenValidityHint.
  ///
  /// In en, this message translates to:
  /// **'Set to 0 to skip timestamp validation'**
  String get serverTokenValidityHint;

  /// No description provided for @serverFormMinutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get serverFormMinutes;

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

  /// No description provided for @authLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'1Panel Login'**
  String get authLoginTitle;

  /// No description provided for @authLoginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter your credentials'**
  String get authLoginSubtitle;

  /// No description provided for @authUsername.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get authUsername;

  /// No description provided for @authPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPassword;

  /// No description provided for @authCaptcha.
  ///
  /// In en, this message translates to:
  /// **'Captcha'**
  String get authCaptcha;

  /// No description provided for @authLogin.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get authLogin;

  /// No description provided for @authUsernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter username'**
  String get authUsernameRequired;

  /// No description provided for @authPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter password'**
  String get authPasswordRequired;

  /// No description provided for @authCaptchaRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter captcha'**
  String get authCaptchaRequired;

  /// No description provided for @authMfaTitle.
  ///
  /// In en, this message translates to:
  /// **'Two-Factor Authentication'**
  String get authMfaTitle;

  /// No description provided for @authMfaDesc.
  ///
  /// In en, this message translates to:
  /// **'Please enter the verification code from your authenticator app'**
  String get authMfaDesc;

  /// No description provided for @authMfaHint.
  ///
  /// In en, this message translates to:
  /// **'000000'**
  String get authMfaHint;

  /// No description provided for @authMfaVerify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get authMfaVerify;

  /// No description provided for @authMfaCancel.
  ///
  /// In en, this message translates to:
  /// **'Back to login'**
  String get authMfaCancel;

  /// No description provided for @authDemoMode.
  ///
  /// In en, this message translates to:
  /// **'Demo mode: Some features are limited'**
  String get authDemoMode;

  /// No description provided for @authLoginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get authLoginFailed;

  /// No description provided for @authLogoutSuccess.
  ///
  /// In en, this message translates to:
  /// **'Logged out successfully'**
  String get authLogoutSuccess;

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

  /// No description provided for @monitorDataPoints.
  ///
  /// In en, this message translates to:
  /// **'Data points'**
  String get monitorDataPoints;

  /// No description provided for @monitorDataPointsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} points ({time})'**
  String monitorDataPointsCount(int count, String time);

  /// No description provided for @monitorRefreshInterval.
  ///
  /// In en, this message translates to:
  /// **'Refresh interval'**
  String get monitorRefreshInterval;

  /// No description provided for @monitorSeconds.
  ///
  /// In en, this message translates to:
  /// **'{count} seconds'**
  String monitorSeconds(int count);

  /// No description provided for @monitorSecondsDefault.
  ///
  /// In en, this message translates to:
  /// **'{count} seconds (default)'**
  String monitorSecondsDefault(int count);

  /// No description provided for @monitorMinute.
  ///
  /// In en, this message translates to:
  /// **'{count} minute'**
  String monitorMinute(int count);

  /// No description provided for @monitorTimeMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String monitorTimeMinutes(int count);

  /// No description provided for @monitorTimeHours.
  ///
  /// In en, this message translates to:
  /// **'{count} hour'**
  String monitorTimeHours(int count);

  /// No description provided for @monitorDataPointsLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} data points'**
  String monitorDataPointsLabel(int count);

  /// No description provided for @monitorSettings.
  ///
  /// In en, this message translates to:
  /// **'Monitor Settings'**
  String get monitorSettings;

  /// No description provided for @monitorEnable.
  ///
  /// In en, this message translates to:
  /// **'Enable Monitoring'**
  String get monitorEnable;

  /// No description provided for @monitorInterval.
  ///
  /// In en, this message translates to:
  /// **'Monitor Interval'**
  String get monitorInterval;

  /// No description provided for @monitorIntervalUnit.
  ///
  /// In en, this message translates to:
  /// **'seconds'**
  String get monitorIntervalUnit;

  /// No description provided for @monitorRetention.
  ///
  /// In en, this message translates to:
  /// **'Data Retention'**
  String get monitorRetention;

  /// No description provided for @monitorRetentionUnit.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get monitorRetentionUnit;

  /// No description provided for @monitorCleanData.
  ///
  /// In en, this message translates to:
  /// **'Clean Monitor Data'**
  String get monitorCleanData;

  /// No description provided for @monitorCleanConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clean all monitor data? This action cannot be undone.'**
  String get monitorCleanConfirm;

  /// No description provided for @monitorCleanSuccess.
  ///
  /// In en, this message translates to:
  /// **'Monitor data cleaned successfully'**
  String get monitorCleanSuccess;

  /// No description provided for @monitorCleanFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to clean monitor data'**
  String get monitorCleanFailed;

  /// No description provided for @monitorSettingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Settings saved successfully'**
  String get monitorSettingsSaved;

  /// No description provided for @monitorSettingsFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save settings'**
  String get monitorSettingsFailed;

  /// No description provided for @monitorGPU.
  ///
  /// In en, this message translates to:
  /// **'GPU Monitor'**
  String get monitorGPU;

  /// No description provided for @monitorGPUName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get monitorGPUName;

  /// No description provided for @monitorGPUUtilization.
  ///
  /// In en, this message translates to:
  /// **'Utilization'**
  String get monitorGPUUtilization;

  /// No description provided for @monitorGPUMemory.
  ///
  /// In en, this message translates to:
  /// **'Memory'**
  String get monitorGPUMemory;

  /// No description provided for @monitorGPUTemperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get monitorGPUTemperature;

  /// No description provided for @monitorGPUNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'GPU monitoring not available'**
  String get monitorGPUNotAvailable;

  /// No description provided for @monitorTimeRange.
  ///
  /// In en, this message translates to:
  /// **'Time Range'**
  String get monitorTimeRange;

  /// No description provided for @monitorTimeRangeLast1h.
  ///
  /// In en, this message translates to:
  /// **'Last 1 hour'**
  String get monitorTimeRangeLast1h;

  /// No description provided for @monitorTimeRangeLast6h.
  ///
  /// In en, this message translates to:
  /// **'Last 6 hours'**
  String get monitorTimeRangeLast6h;

  /// No description provided for @monitorTimeRangeLast24h.
  ///
  /// In en, this message translates to:
  /// **'Last 24 hours'**
  String get monitorTimeRangeLast24h;

  /// No description provided for @monitorTimeRangeLast7d.
  ///
  /// In en, this message translates to:
  /// **'Last 7 days'**
  String get monitorTimeRangeLast7d;

  /// No description provided for @monitorTimeRangeCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get monitorTimeRangeCustom;

  /// No description provided for @monitorTimeRangeFrom.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get monitorTimeRangeFrom;

  /// No description provided for @monitorTimeRangeTo.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get monitorTimeRangeTo;

  /// No description provided for @systemSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'System Settings'**
  String get systemSettingsTitle;

  /// No description provided for @systemSettingsRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get systemSettingsRefresh;

  /// No description provided for @systemSettingsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load settings'**
  String get systemSettingsLoadFailed;

  /// No description provided for @systemSettingsPanelSection.
  ///
  /// In en, this message translates to:
  /// **'Panel Settings'**
  String get systemSettingsPanelSection;

  /// No description provided for @systemSettingsPanelConfig.
  ///
  /// In en, this message translates to:
  /// **'Panel Config'**
  String get systemSettingsPanelConfig;

  /// No description provided for @systemSettingsPanelConfigDesc.
  ///
  /// In en, this message translates to:
  /// **'Panel name, port, bind address, etc.'**
  String get systemSettingsPanelConfigDesc;

  /// No description provided for @systemSettingsTerminal.
  ///
  /// In en, this message translates to:
  /// **'Terminal Settings'**
  String get systemSettingsTerminal;

  /// No description provided for @systemSettingsTerminalDesc.
  ///
  /// In en, this message translates to:
  /// **'Terminal style, font, scrolling, etc.'**
  String get systemSettingsTerminalDesc;

  /// No description provided for @systemSettingsSecuritySection.
  ///
  /// In en, this message translates to:
  /// **'Security Settings'**
  String get systemSettingsSecuritySection;

  /// No description provided for @systemSettingsSecurityConfig.
  ///
  /// In en, this message translates to:
  /// **'Security Config'**
  String get systemSettingsSecurityConfig;

  /// No description provided for @systemSettingsSecurityConfigDesc.
  ///
  /// In en, this message translates to:
  /// **'MFA authentication, access control, etc.'**
  String get systemSettingsSecurityConfigDesc;

  /// No description provided for @systemSettingsApiKey.
  ///
  /// In en, this message translates to:
  /// **'API Key'**
  String get systemSettingsApiKey;

  /// No description provided for @systemSettingsBackupSection.
  ///
  /// In en, this message translates to:
  /// **'Backup & Recovery'**
  String get systemSettingsBackupSection;

  /// No description provided for @systemSettingsSnapshot.
  ///
  /// In en, this message translates to:
  /// **'Snapshot Management'**
  String get systemSettingsSnapshot;

  /// No description provided for @systemSettingsSnapshotDesc.
  ///
  /// In en, this message translates to:
  /// **'Create, restore, delete system snapshots'**
  String get systemSettingsSnapshotDesc;

  /// No description provided for @systemSettingsSystemSection.
  ///
  /// In en, this message translates to:
  /// **'System Info'**
  String get systemSettingsSystemSection;

  /// No description provided for @systemSettingsUpgrade.
  ///
  /// In en, this message translates to:
  /// **'System Upgrade'**
  String get systemSettingsUpgrade;

  /// No description provided for @systemSettingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get systemSettingsAbout;

  /// No description provided for @systemSettingsAboutDesc.
  ///
  /// In en, this message translates to:
  /// **'System info and version'**
  String get systemSettingsAboutDesc;

  /// No description provided for @systemSettingsLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: {time}'**
  String systemSettingsLastUpdated(String time);

  /// No description provided for @systemSettingsPanelName.
  ///
  /// In en, this message translates to:
  /// **'1Panel'**
  String get systemSettingsPanelName;

  /// No description provided for @systemSettingsSystemVersion.
  ///
  /// In en, this message translates to:
  /// **'System Version'**
  String get systemSettingsSystemVersion;

  /// No description provided for @systemSettingsMfaStatus.
  ///
  /// In en, this message translates to:
  /// **'MFA Status'**
  String get systemSettingsMfaStatus;

  /// No description provided for @systemSettingsEnabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get systemSettingsEnabled;

  /// No description provided for @systemSettingsDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get systemSettingsDisabled;

  /// No description provided for @systemSettingsApiKeyManage.
  ///
  /// In en, this message translates to:
  /// **'API Key Management'**
  String get systemSettingsApiKeyManage;

  /// No description provided for @systemSettingsCurrentStatus.
  ///
  /// In en, this message translates to:
  /// **'Current Status'**
  String get systemSettingsCurrentStatus;

  /// No description provided for @systemSettingsUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get systemSettingsUnknown;

  /// No description provided for @systemSettingsApiKeyLabel.
  ///
  /// In en, this message translates to:
  /// **'API Key'**
  String get systemSettingsApiKeyLabel;

  /// No description provided for @systemSettingsNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get systemSettingsNotSet;

  /// No description provided for @systemSettingsGenerateNewKey.
  ///
  /// In en, this message translates to:
  /// **'Generate New Key'**
  String get systemSettingsGenerateNewKey;

  /// No description provided for @systemSettingsApiKeyGenerated.
  ///
  /// In en, this message translates to:
  /// **'API key generated'**
  String get systemSettingsApiKeyGenerated;

  /// No description provided for @systemSettingsGenerateFailed.
  ///
  /// In en, this message translates to:
  /// **'Generation failed'**
  String get systemSettingsGenerateFailed;

  /// No description provided for @apiKeySettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'API Key Management'**
  String get apiKeySettingsTitle;

  /// No description provided for @apiKeySettingsStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get apiKeySettingsStatus;

  /// No description provided for @apiKeySettingsEnabled.
  ///
  /// In en, this message translates to:
  /// **'API Interface'**
  String get apiKeySettingsEnabled;

  /// No description provided for @apiKeySettingsInfo.
  ///
  /// In en, this message translates to:
  /// **'Key Information'**
  String get apiKeySettingsInfo;

  /// No description provided for @apiKeySettingsKey.
  ///
  /// In en, this message translates to:
  /// **'API Key'**
  String get apiKeySettingsKey;

  /// No description provided for @apiKeySettingsIpWhitelist.
  ///
  /// In en, this message translates to:
  /// **'IP Whitelist'**
  String get apiKeySettingsIpWhitelist;

  /// No description provided for @apiKeySettingsValidityTime.
  ///
  /// In en, this message translates to:
  /// **'Validity Time'**
  String get apiKeySettingsValidityTime;

  /// No description provided for @apiKeySettingsActions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get apiKeySettingsActions;

  /// No description provided for @apiKeySettingsRegenerate.
  ///
  /// In en, this message translates to:
  /// **'Regenerate'**
  String get apiKeySettingsRegenerate;

  /// No description provided for @apiKeySettingsRegenerateDesc.
  ///
  /// In en, this message translates to:
  /// **'Generate new API key'**
  String get apiKeySettingsRegenerateDesc;

  /// No description provided for @apiKeySettingsRegenerateConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to regenerate the API key? The old key will be invalid immediately.'**
  String get apiKeySettingsRegenerateConfirm;

  /// No description provided for @apiKeySettingsRegenerateSuccess.
  ///
  /// In en, this message translates to:
  /// **'API key regenerated'**
  String get apiKeySettingsRegenerateSuccess;

  /// No description provided for @apiKeySettingsEnable.
  ///
  /// In en, this message translates to:
  /// **'Enable API'**
  String get apiKeySettingsEnable;

  /// No description provided for @apiKeySettingsDisable.
  ///
  /// In en, this message translates to:
  /// **'Disable API'**
  String get apiKeySettingsDisable;

  /// No description provided for @apiKeySettingsEnableConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to enable API interface?'**
  String get apiKeySettingsEnableConfirm;

  /// No description provided for @apiKeySettingsDisableConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to disable API interface?'**
  String get apiKeySettingsDisableConfirm;

  /// No description provided for @commonCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get commonCopied;

  /// No description provided for @sslSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'SSL Certificate Management'**
  String get sslSettingsTitle;

  /// No description provided for @sslSettingsInfo.
  ///
  /// In en, this message translates to:
  /// **'Certificate Information'**
  String get sslSettingsInfo;

  /// No description provided for @sslSettingsDomain.
  ///
  /// In en, this message translates to:
  /// **'Domain'**
  String get sslSettingsDomain;

  /// No description provided for @sslSettingsStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get sslSettingsStatus;

  /// No description provided for @sslSettingsType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get sslSettingsType;

  /// No description provided for @sslSettingsProvider.
  ///
  /// In en, this message translates to:
  /// **'Provider'**
  String get sslSettingsProvider;

  /// No description provided for @sslSettingsExpiration.
  ///
  /// In en, this message translates to:
  /// **'Expiration'**
  String get sslSettingsExpiration;

  /// No description provided for @sslSettingsActions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get sslSettingsActions;

  /// No description provided for @sslSettingsUpload.
  ///
  /// In en, this message translates to:
  /// **'Upload Certificate'**
  String get sslSettingsUpload;

  /// No description provided for @sslSettingsUploadDesc.
  ///
  /// In en, this message translates to:
  /// **'Upload SSL certificate file'**
  String get sslSettingsUploadDesc;

  /// No description provided for @sslSettingsDownload.
  ///
  /// In en, this message translates to:
  /// **'Download Certificate'**
  String get sslSettingsDownload;

  /// No description provided for @sslSettingsDownloadDesc.
  ///
  /// In en, this message translates to:
  /// **'Download current SSL certificate'**
  String get sslSettingsDownloadDesc;

  /// No description provided for @sslSettingsDownloadSuccess.
  ///
  /// In en, this message translates to:
  /// **'Certificate downloaded successfully'**
  String get sslSettingsDownloadSuccess;

  /// No description provided for @sslSettingsCert.
  ///
  /// In en, this message translates to:
  /// **'Certificate Content'**
  String get sslSettingsCert;

  /// No description provided for @sslSettingsKey.
  ///
  /// In en, this message translates to:
  /// **'Private Key Content'**
  String get sslSettingsKey;

  /// No description provided for @upgradeTitle.
  ///
  /// In en, this message translates to:
  /// **'System Upgrade'**
  String get upgradeTitle;

  /// No description provided for @upgradeCurrentVersion.
  ///
  /// In en, this message translates to:
  /// **'Current Version'**
  String get upgradeCurrentVersion;

  /// No description provided for @upgradeCurrentVersionLabel.
  ///
  /// In en, this message translates to:
  /// **'Current System Version'**
  String get upgradeCurrentVersionLabel;

  /// No description provided for @upgradeAvailableVersions.
  ///
  /// In en, this message translates to:
  /// **'Available Versions'**
  String get upgradeAvailableVersions;

  /// No description provided for @upgradeNoUpdates.
  ///
  /// In en, this message translates to:
  /// **'Already up to date'**
  String get upgradeNoUpdates;

  /// No description provided for @upgradeLatest.
  ///
  /// In en, this message translates to:
  /// **'Latest'**
  String get upgradeLatest;

  /// No description provided for @upgradeConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm Upgrade'**
  String get upgradeConfirm;

  /// No description provided for @upgradeConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to upgrade to version {version}?'**
  String upgradeConfirmMessage(Object version);

  /// No description provided for @upgradeButton.
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get upgradeButton;

  /// No description provided for @upgradeStarted.
  ///
  /// In en, this message translates to:
  /// **'Upgrade started'**
  String get upgradeStarted;

  /// No description provided for @monitorSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Monitor Settings'**
  String get monitorSettingsTitle;

  /// No description provided for @monitorSettingsInterval.
  ///
  /// In en, this message translates to:
  /// **'Monitor Interval'**
  String get monitorSettingsInterval;

  /// No description provided for @monitorSettingsStoreDays.
  ///
  /// In en, this message translates to:
  /// **'Data Retention Days'**
  String get monitorSettingsStoreDays;

  /// No description provided for @monitorSettingsEnable.
  ///
  /// In en, this message translates to:
  /// **'Enable Monitoring'**
  String get monitorSettingsEnable;

  /// No description provided for @systemSettingsCurrentVersion.
  ///
  /// In en, this message translates to:
  /// **'Current Version'**
  String get systemSettingsCurrentVersion;

  /// No description provided for @systemSettingsCheckingUpdate.
  ///
  /// In en, this message translates to:
  /// **'Checking for updates...'**
  String get systemSettingsCheckingUpdate;

  /// No description provided for @systemSettingsClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get systemSettingsClose;

  /// No description provided for @panelSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Panel Settings'**
  String get panelSettingsTitle;

  /// No description provided for @panelSettingsBasicInfo.
  ///
  /// In en, this message translates to:
  /// **'Basic Info'**
  String get panelSettingsBasicInfo;

  /// No description provided for @panelSettingsPanelName.
  ///
  /// In en, this message translates to:
  /// **'Panel Name'**
  String get panelSettingsPanelName;

  /// No description provided for @panelSettingsVersion.
  ///
  /// In en, this message translates to:
  /// **'System Version'**
  String get panelSettingsVersion;

  /// No description provided for @panelSettingsPort.
  ///
  /// In en, this message translates to:
  /// **'Listen Port'**
  String get panelSettingsPort;

  /// No description provided for @panelSettingsBindAddress.
  ///
  /// In en, this message translates to:
  /// **'Bind Address'**
  String get panelSettingsBindAddress;

  /// No description provided for @panelSettingsInterface.
  ///
  /// In en, this message translates to:
  /// **'Interface Settings'**
  String get panelSettingsInterface;

  /// No description provided for @panelSettingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get panelSettingsTheme;

  /// No description provided for @panelSettingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get panelSettingsLanguage;

  /// No description provided for @panelSettingsMenuTabs.
  ///
  /// In en, this message translates to:
  /// **'Menu Tabs'**
  String get panelSettingsMenuTabs;

  /// No description provided for @panelSettingsAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced Settings'**
  String get panelSettingsAdvanced;

  /// No description provided for @panelSettingsDeveloperMode.
  ///
  /// In en, this message translates to:
  /// **'Developer Mode'**
  String get panelSettingsDeveloperMode;

  /// No description provided for @panelSettingsIpv6.
  ///
  /// In en, this message translates to:
  /// **'IPv6'**
  String get panelSettingsIpv6;

  /// No description provided for @panelSettingsSessionTimeout.
  ///
  /// In en, this message translates to:
  /// **'Session Timeout'**
  String get panelSettingsSessionTimeout;

  /// No description provided for @panelSettingsMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count} minutes'**
  String panelSettingsMinutes(String count);

  /// No description provided for @terminalSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Terminal Settings'**
  String get terminalSettingsTitle;

  /// No description provided for @terminalSettingsDisplay.
  ///
  /// In en, this message translates to:
  /// **'Display Settings'**
  String get terminalSettingsDisplay;

  /// No description provided for @terminalSettingsCursorStyle.
  ///
  /// In en, this message translates to:
  /// **'Cursor Style'**
  String get terminalSettingsCursorStyle;

  /// No description provided for @terminalSettingsCursorBlink.
  ///
  /// In en, this message translates to:
  /// **'Cursor Blink'**
  String get terminalSettingsCursorBlink;

  /// No description provided for @terminalSettingsFontSize.
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get terminalSettingsFontSize;

  /// No description provided for @terminalSettingsScroll.
  ///
  /// In en, this message translates to:
  /// **'Scroll Settings'**
  String get terminalSettingsScroll;

  /// No description provided for @terminalSettingsScrollSensitivity.
  ///
  /// In en, this message translates to:
  /// **'Scroll Sensitivity'**
  String get terminalSettingsScrollSensitivity;

  /// No description provided for @terminalSettingsScrollback.
  ///
  /// In en, this message translates to:
  /// **'Scrollback Buffer'**
  String get terminalSettingsScrollback;

  /// No description provided for @terminalSettingsStyle.
  ///
  /// In en, this message translates to:
  /// **'Style Settings'**
  String get terminalSettingsStyle;

  /// No description provided for @terminalSettingsLineHeight.
  ///
  /// In en, this message translates to:
  /// **'Line Height'**
  String get terminalSettingsLineHeight;

  /// No description provided for @terminalSettingsLetterSpacing.
  ///
  /// In en, this message translates to:
  /// **'Letter Spacing'**
  String get terminalSettingsLetterSpacing;

  /// No description provided for @securitySettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Security Settings'**
  String get securitySettingsTitle;

  /// No description provided for @securitySettingsPasswordSection.
  ///
  /// In en, this message translates to:
  /// **'Password Management'**
  String get securitySettingsPasswordSection;

  /// No description provided for @securitySettingsChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get securitySettingsChangePassword;

  /// No description provided for @securitySettingsChangePasswordDesc.
  ///
  /// In en, this message translates to:
  /// **'Change login password'**
  String get securitySettingsChangePasswordDesc;

  /// No description provided for @securitySettingsOldPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get securitySettingsOldPassword;

  /// No description provided for @securitySettingsNewPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get securitySettingsNewPassword;

  /// No description provided for @securitySettingsConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get securitySettingsConfirmPassword;

  /// No description provided for @securitySettingsPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get securitySettingsPasswordMismatch;

  /// No description provided for @securitySettingsMfaSection.
  ///
  /// In en, this message translates to:
  /// **'MFA Authentication'**
  String get securitySettingsMfaSection;

  /// No description provided for @securitySettingsMfaStatus.
  ///
  /// In en, this message translates to:
  /// **'MFA Status'**
  String get securitySettingsMfaStatus;

  /// No description provided for @securitySettingsMfaBind.
  ///
  /// In en, this message translates to:
  /// **'Bind MFA'**
  String get securitySettingsMfaBind;

  /// No description provided for @securitySettingsMfaUnbind.
  ///
  /// In en, this message translates to:
  /// **'Unbind MFA'**
  String get securitySettingsMfaUnbind;

  /// No description provided for @securitySettingsMfaUnbindDesc.
  ///
  /// In en, this message translates to:
  /// **'MFA authentication will be disabled after unbinding. Are you sure?'**
  String get securitySettingsMfaUnbindDesc;

  /// No description provided for @securitySettingsMfaScanQr.
  ///
  /// In en, this message translates to:
  /// **'Scan QR code with authenticator app'**
  String get securitySettingsMfaScanQr;

  /// No description provided for @securitySettingsMfaSecret.
  ///
  /// In en, this message translates to:
  /// **'Secret: {secret}'**
  String securitySettingsMfaSecret(Object secret);

  /// No description provided for @securitySettingsMfaCode.
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get securitySettingsMfaCode;

  /// No description provided for @securitySettingsUnbindMfa.
  ///
  /// In en, this message translates to:
  /// **'Unbind MFA'**
  String get securitySettingsUnbindMfa;

  /// No description provided for @securitySettingsAccessControl.
  ///
  /// In en, this message translates to:
  /// **'Access Control'**
  String get securitySettingsAccessControl;

  /// No description provided for @securitySettingsSecurityEntrance.
  ///
  /// In en, this message translates to:
  /// **'Security Entrance'**
  String get securitySettingsSecurityEntrance;

  /// No description provided for @securitySettingsBindDomain.
  ///
  /// In en, this message translates to:
  /// **'Bind Domain'**
  String get securitySettingsBindDomain;

  /// No description provided for @securitySettingsAllowIPs.
  ///
  /// In en, this message translates to:
  /// **'Allowed IPs'**
  String get securitySettingsAllowIPs;

  /// No description provided for @securitySettingsPasswordPolicy.
  ///
  /// In en, this message translates to:
  /// **'Password Policy'**
  String get securitySettingsPasswordPolicy;

  /// No description provided for @securitySettingsComplexityVerification.
  ///
  /// In en, this message translates to:
  /// **'Complexity Verification'**
  String get securitySettingsComplexityVerification;

  /// No description provided for @securitySettingsExpirationDays.
  ///
  /// In en, this message translates to:
  /// **'Expiration Days'**
  String get securitySettingsExpirationDays;

  /// No description provided for @securitySettingsEnableMfa.
  ///
  /// In en, this message translates to:
  /// **'Enable MFA'**
  String get securitySettingsEnableMfa;

  /// No description provided for @securitySettingsDisableMfa.
  ///
  /// In en, this message translates to:
  /// **'Disable MFA'**
  String get securitySettingsDisableMfa;

  /// No description provided for @securitySettingsEnableMfaConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to enable MFA?'**
  String get securitySettingsEnableMfaConfirm;

  /// No description provided for @securitySettingsDisableMfaConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to disable MFA?'**
  String get securitySettingsDisableMfaConfirm;

  /// No description provided for @securitySettingsEnterMfaCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter MFA verification code'**
  String get securitySettingsEnterMfaCode;

  /// No description provided for @securitySettingsVerifyCode.
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get securitySettingsVerifyCode;

  /// No description provided for @securitySettingsMfaCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Enter 6-digit code'**
  String get securitySettingsMfaCodeHint;

  /// No description provided for @securitySettingsMfaUnbound.
  ///
  /// In en, this message translates to:
  /// **'MFA unbound'**
  String get securitySettingsMfaUnbound;

  /// No description provided for @securitySettingsUnbindFailed.
  ///
  /// In en, this message translates to:
  /// **'Unbind failed'**
  String get securitySettingsUnbindFailed;

  /// No description provided for @snapshotTitle.
  ///
  /// In en, this message translates to:
  /// **'Snapshot Management'**
  String get snapshotTitle;

  /// No description provided for @snapshotCreate.
  ///
  /// In en, this message translates to:
  /// **'Create Snapshot'**
  String get snapshotCreate;

  /// No description provided for @snapshotEmpty.
  ///
  /// In en, this message translates to:
  /// **'No snapshots'**
  String get snapshotEmpty;

  /// No description provided for @snapshotCreatedAt.
  ///
  /// In en, this message translates to:
  /// **'Created At'**
  String get snapshotCreatedAt;

  /// No description provided for @snapshotDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get snapshotDescription;

  /// No description provided for @snapshotRecover.
  ///
  /// In en, this message translates to:
  /// **'Recover'**
  String get snapshotRecover;

  /// No description provided for @snapshotDownload.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get snapshotDownload;

  /// No description provided for @snapshotDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get snapshotDelete;

  /// No description provided for @snapshotEnterDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter snapshot description (optional)'**
  String get snapshotEnterDesc;

  /// No description provided for @snapshotDescLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get snapshotDescLabel;

  /// No description provided for @snapshotDescHint.
  ///
  /// In en, this message translates to:
  /// **'Enter snapshot description'**
  String get snapshotDescHint;

  /// No description provided for @snapshotCreateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Snapshot created successfully'**
  String get snapshotCreateSuccess;

  /// No description provided for @snapshotCreateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to create snapshot'**
  String get snapshotCreateFailed;

  /// No description provided for @snapshotDownloadDev.
  ///
  /// In en, this message translates to:
  /// **'Download feature in development'**
  String get snapshotDownloadDev;

  /// No description provided for @snapshotRecoverTitle.
  ///
  /// In en, this message translates to:
  /// **'Recover Snapshot'**
  String get snapshotRecoverTitle;

  /// No description provided for @snapshotRecoverConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to recover this snapshot? Current configuration will be overwritten.'**
  String get snapshotRecoverConfirm;

  /// No description provided for @snapshotRecoverSuccess.
  ///
  /// In en, this message translates to:
  /// **'Snapshot recovered successfully'**
  String get snapshotRecoverSuccess;

  /// No description provided for @snapshotRecoverFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to recover snapshot'**
  String get snapshotRecoverFailed;

  /// No description provided for @snapshotDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Snapshot'**
  String get snapshotDeleteTitle;

  /// No description provided for @snapshotDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete selected snapshots? This action cannot be undone.'**
  String get snapshotDeleteConfirm;

  /// No description provided for @snapshotDeleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Snapshot deleted successfully'**
  String get snapshotDeleteSuccess;

  /// No description provided for @snapshotDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete snapshot'**
  String get snapshotDeleteFailed;

  /// No description provided for @serverModuleSystemSettings.
  ///
  /// In en, this message translates to:
  /// **'System Settings'**
  String get serverModuleSystemSettings;
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
