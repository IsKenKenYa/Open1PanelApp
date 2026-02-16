// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => '1Panel Open';

  @override
  String get commonLoading => 'Loading...';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonSave => 'Save';

  @override
  String get commonSaveSuccess => 'Saved successfully';

  @override
  String get commonSaveFailed => 'Failed to save';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonRefresh => 'Refresh';

  @override
  String get commonComingSoon => 'Coming soon';

  @override
  String get commonEmpty => 'No data';

  @override
  String get commonLoadFailedTitle => 'Failed to load';

  @override
  String get monitorNetworkLabel => 'Network';

  @override
  String get monitorMetricCurrent => 'Current';

  @override
  String get monitorMetricMin => 'Min';

  @override
  String get monitorMetricAvg => 'Avg';

  @override
  String get monitorMetricMax => 'Max';

  @override
  String get navServer => 'Servers';

  @override
  String get navFiles => 'Files';

  @override
  String get navSecurity => 'Verification';

  @override
  String get navSettings => 'Settings';

  @override
  String get serverPageTitle => 'Servers';

  @override
  String get serverSearchHint => 'Search server name or IP';

  @override
  String get serverAdd => 'Add';

  @override
  String get serverListEmptyTitle => 'No servers yet';

  @override
  String get serverListEmptyDesc =>
      'Add your first 1Panel server to get started.';

  @override
  String get serverOnline => 'Online';

  @override
  String get serverOffline => 'Offline';

  @override
  String get serverCurrent => 'Current';

  @override
  String get serverDefault => 'Default';

  @override
  String get serverIpLabel => 'IP';

  @override
  String get serverCpuLabel => 'CPU';

  @override
  String get serverMemoryLabel => 'Memory';

  @override
  String get serverLoadLabel => 'Load';

  @override
  String get serverDiskLabel => 'Disk';

  @override
  String get serverMetricsUnavailable => 'Metrics unavailable';

  @override
  String get serverOpenDetail => 'Open details';

  @override
  String get serverDetailTitle => 'Server Details';

  @override
  String get serverModulesTitle => 'Modules';

  @override
  String get serverModuleDashboard => 'Overview';

  @override
  String get serverModuleApps => 'Apps';

  @override
  String get serverModuleContainers => 'Containers';

  @override
  String get serverModuleWebsites => 'Websites';

  @override
  String get serverModuleDatabases => 'Databases';

  @override
  String get serverModuleFirewall => 'Firewall';

  @override
  String get serverModuleTerminal => 'Terminal';

  @override
  String get serverModuleMonitoring => 'Monitoring';

  @override
  String get serverModuleFiles => 'File Manager';

  @override
  String get serverInsightsTitle => 'Overview';

  @override
  String get serverActionsTitle => 'Quick Actions';

  @override
  String get serverActionRefresh => 'Refresh';

  @override
  String get serverActionSwitch => 'Switch server';

  @override
  String get serverActionSecurity => 'Verification';

  @override
  String get serverFormTitle => 'Add Server';

  @override
  String get serverFormName => 'Server name';

  @override
  String get serverFormNameHint => 'e.g. Production';

  @override
  String get serverFormUrl => 'Server URL';

  @override
  String get serverFormUrlHint => 'e.g. https://panel.example.com';

  @override
  String get serverFormApiKey => 'API key';

  @override
  String get serverFormApiKeyHint => 'Enter API key';

  @override
  String get serverFormSaveConnect => 'Save and continue';

  @override
  String get serverFormTest => 'Test connection';

  @override
  String get serverFormRequired => 'This field is required';

  @override
  String get serverFormSaveSuccess => 'Server saved';

  @override
  String serverFormSaveFailed(String error) {
    return 'Failed to save server: $error';
  }

  @override
  String get serverFormTestHint =>
      'Connection test can be added after client adaptation.';

  @override
  String get serverTestSuccess => 'Connection successful';

  @override
  String get serverTestFailed => 'Connection failed';

  @override
  String get serverTestTesting => 'Testing connection...';

  @override
  String get serverMetricsAvailable => 'Metrics loaded';

  @override
  String get serverTokenValidity => 'Token validity (minutes)';

  @override
  String get serverTokenValidityHint => 'Set to 0 to skip timestamp validation';

  @override
  String get serverFormMinutes => 'minutes';

  @override
  String get filesPageTitle => 'Files';

  @override
  String get filesPath => 'Path';

  @override
  String get filesRoot => 'Root';

  @override
  String get filesEmptyTitle => 'File browser placeholder';

  @override
  String get filesEmptyDesc => 'UI is ready. Connect file client APIs next.';

  @override
  String get filesActionUpload => 'Upload';

  @override
  String get filesActionNewFile => 'New file';

  @override
  String get filesActionNewFolder => 'New folder';

  @override
  String get securityPageTitle => 'Dynamic Verification';

  @override
  String get securityStatusTitle => 'MFA status';

  @override
  String get securityStatusEnabled => 'Enabled';

  @override
  String get securityStatusDisabled => 'Not enabled';

  @override
  String get securitySecretLabel => 'Secret';

  @override
  String get securityCodeLabel => 'Verification code';

  @override
  String get securityCodeHint => 'Enter 6-digit code';

  @override
  String get securityLoadInfo => 'Load MFA info';

  @override
  String get securityBind => 'Bind MFA';

  @override
  String get securityBindSuccess => 'MFA binding request submitted';

  @override
  String securityBindFailed(String error) {
    return 'Failed to bind MFA: $error';
  }

  @override
  String get securityMockNotice =>
      'Current screen uses UI adapter mode. API client can be connected later.';

  @override
  String get settingsPageTitle => 'Settings';

  @override
  String get settingsGeneral => 'General';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsServerManagement => 'Server management';

  @override
  String get settingsResetOnboarding => 'Replay onboarding';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsResetOnboardingDone => 'Onboarding state has been reset';

  @override
  String get themeSystem => 'Follow system';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get languageSystem => 'System';

  @override
  String get languageZh => 'Chinese';

  @override
  String get languageEn => 'English';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingStart => 'Start';

  @override
  String get onboardingTitle1 => 'Manage your 1Panel servers';

  @override
  String get onboardingDesc1 =>
      'Unified mobile operations for monitoring, files, and security.';

  @override
  String get onboardingTitle2 => 'Fast switching and clear status';

  @override
  String get onboardingDesc2 =>
      'View key metrics and switch servers quickly with a card-based layout.';

  @override
  String get onboardingTitle3 => 'Built for progressive API integration';

  @override
  String get onboardingDesc3 =>
      'UI is stable first. Missing APIs are tracked in review docs for follow-up.';

  @override
  String get coachServerAddTitle => 'Add your first server';

  @override
  String get coachServerAddDesc => 'Tap here to create a server profile.';

  @override
  String get coachServerCardTitle => 'Open server details';

  @override
  String get coachServerCardDesc =>
      'Tap a server card to see modules and quick actions.';

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get dashboardLoadFailedTitle => 'Failed to load';

  @override
  String get dashboardServerInfoTitle => 'Server info';

  @override
  String get dashboardServerStatusOk => 'Running';

  @override
  String get dashboardServerStatusConnecting => 'Connecting...';

  @override
  String get dashboardHostNameLabel => 'Hostname';

  @override
  String get dashboardOsLabel => 'Operating system';

  @override
  String get dashboardUptimeLabel => 'Uptime';

  @override
  String dashboardUptimeDaysHours(int days, int hours) {
    return '${days}d ${hours}h';
  }

  @override
  String dashboardUptimeHours(int hours) {
    return '${hours}h';
  }

  @override
  String dashboardUpdatedAt(String time) {
    return 'Updated at $time';
  }

  @override
  String get dashboardResourceTitle => 'System resources';

  @override
  String get dashboardCpuUsage => 'CPU usage';

  @override
  String get dashboardMemoryUsage => 'Memory usage';

  @override
  String get dashboardDiskUsage => 'Disk usage';

  @override
  String get dashboardQuickActionsTitle => 'Quick actions';

  @override
  String get dashboardActionRestart => 'Restart server';

  @override
  String get dashboardActionUpdate => 'System update';

  @override
  String get dashboardActionBackup => 'Create backup';

  @override
  String get dashboardActionSecurity => 'Security check';

  @override
  String get dashboardRestartTitle => 'Restart server';

  @override
  String get dashboardRestartDesc =>
      'Restarting will temporarily interrupt all services. Continue?';

  @override
  String get dashboardRestartSuccess => 'Restart request sent';

  @override
  String dashboardRestartFailed(String error) {
    return 'Failed to restart: $error';
  }

  @override
  String get dashboardUpdateTitle => 'System update';

  @override
  String get dashboardUpdateDesc =>
      'Start the update now? The panel may be temporarily unavailable.';

  @override
  String get dashboardUpdateSuccess => 'Update request sent';

  @override
  String dashboardUpdateFailed(String error) {
    return 'Failed to update: $error';
  }

  @override
  String get dashboardActivityTitle => 'Recent activity';

  @override
  String get dashboardActivityEmpty => 'No recent activity';

  @override
  String dashboardActivityDaysAgo(int count) {
    return '${count}d ago';
  }

  @override
  String dashboardActivityHoursAgo(int count) {
    return '${count}h ago';
  }

  @override
  String dashboardActivityMinutesAgo(int count) {
    return '${count}m ago';
  }

  @override
  String get dashboardActivityJustNow => 'Just now';

  @override
  String get dashboardTopProcessesTitle => 'Process Monitor';

  @override
  String get dashboardCpuTab => 'CPU';

  @override
  String get dashboardMemoryTab => 'Memory';

  @override
  String get dashboardNoProcesses => 'No process data';

  @override
  String get authLoginTitle => '1Panel Login';

  @override
  String get authLoginSubtitle => 'Please enter your credentials';

  @override
  String get authUsername => 'Username';

  @override
  String get authPassword => 'Password';

  @override
  String get authCaptcha => 'Captcha';

  @override
  String get authLogin => 'Login';

  @override
  String get authUsernameRequired => 'Please enter username';

  @override
  String get authPasswordRequired => 'Please enter password';

  @override
  String get authCaptchaRequired => 'Please enter captcha';

  @override
  String get authMfaTitle => 'Two-Factor Authentication';

  @override
  String get authMfaDesc =>
      'Please enter the verification code from your authenticator app';

  @override
  String get authMfaHint => '000000';

  @override
  String get authMfaVerify => 'Verify';

  @override
  String get authMfaCancel => 'Back to login';

  @override
  String get authDemoMode => 'Demo mode: Some features are limited';

  @override
  String get authLoginFailed => 'Login failed';

  @override
  String get authLogoutSuccess => 'Logged out successfully';

  @override
  String get coachDone => 'Got it';

  @override
  String get notFoundTitle => 'Page not found';

  @override
  String get notFoundDesc => 'The requested page does not exist.';

  @override
  String get legacyRouteRedirect =>
      'This legacy route is redirected to the new shell.';

  @override
  String get monitorDataPoints => 'Data points';

  @override
  String monitorDataPointsCount(int count, String time) {
    return '$count points ($time)';
  }

  @override
  String get monitorRefreshInterval => 'Refresh interval';

  @override
  String monitorSeconds(int count) {
    return '$count seconds';
  }

  @override
  String monitorSecondsDefault(int count) {
    return '$count seconds (default)';
  }

  @override
  String monitorMinute(int count) {
    return '$count minute';
  }

  @override
  String monitorTimeMinutes(int count) {
    return '$count min';
  }

  @override
  String monitorTimeHours(int count) {
    return '$count hour';
  }

  @override
  String monitorDataPointsLabel(int count) {
    return '$count data points';
  }

  @override
  String get monitorSettings => 'Monitor Settings';

  @override
  String get monitorEnable => 'Enable Monitoring';

  @override
  String get monitorInterval => 'Monitor Interval';

  @override
  String get monitorIntervalUnit => 'seconds';

  @override
  String get monitorRetention => 'Data Retention';

  @override
  String get monitorRetentionUnit => 'days';

  @override
  String get monitorCleanData => 'Clean Monitor Data';

  @override
  String get monitorCleanConfirm =>
      'Are you sure you want to clean all monitor data? This action cannot be undone.';

  @override
  String get monitorCleanSuccess => 'Monitor data cleaned successfully';

  @override
  String get monitorCleanFailed => 'Failed to clean monitor data';

  @override
  String get monitorSettingsSaved => 'Settings saved successfully';

  @override
  String get monitorSettingsFailed => 'Failed to save settings';

  @override
  String get monitorGPU => 'GPU Monitor';

  @override
  String get monitorGPUName => 'Name';

  @override
  String get monitorGPUUtilization => 'Utilization';

  @override
  String get monitorGPUMemory => 'Memory';

  @override
  String get monitorGPUTemperature => 'Temperature';

  @override
  String get monitorGPUNotAvailable => 'GPU monitoring not available';

  @override
  String get monitorTimeRange => 'Time Range';

  @override
  String get monitorTimeRangeLast1h => 'Last 1 hour';

  @override
  String get monitorTimeRangeLast6h => 'Last 6 hours';

  @override
  String get monitorTimeRangeLast24h => 'Last 24 hours';

  @override
  String get monitorTimeRangeLast7d => 'Last 7 days';

  @override
  String get monitorTimeRangeCustom => 'Custom';

  @override
  String get monitorTimeRangeFrom => 'From';

  @override
  String get monitorTimeRangeTo => 'To';

  @override
  String get systemSettingsTitle => 'System Settings';

  @override
  String get systemSettingsRefresh => 'Refresh';

  @override
  String get systemSettingsLoadFailed => 'Failed to load settings';

  @override
  String get systemSettingsPanelSection => 'Panel Settings';

  @override
  String get systemSettingsPanelConfig => 'Panel Config';

  @override
  String get systemSettingsPanelConfigDesc =>
      'Panel name, port, bind address, etc.';

  @override
  String get systemSettingsTerminal => 'Terminal Settings';

  @override
  String get systemSettingsTerminalDesc =>
      'Terminal style, font, scrolling, etc.';

  @override
  String get systemSettingsSecuritySection => 'Security Settings';

  @override
  String get systemSettingsSecurityConfig => 'Security Config';

  @override
  String get systemSettingsSecurityConfigDesc =>
      'MFA authentication, access control, etc.';

  @override
  String get systemSettingsApiKey => 'API Key';

  @override
  String get systemSettingsBackupSection => 'Backup & Recovery';

  @override
  String get systemSettingsSnapshot => 'Snapshot Management';

  @override
  String get systemSettingsSnapshotDesc =>
      'Create, restore, delete system snapshots';

  @override
  String get systemSettingsSystemSection => 'System Info';

  @override
  String get systemSettingsUpgrade => 'System Upgrade';

  @override
  String get systemSettingsAbout => 'About';

  @override
  String get systemSettingsAboutDesc => 'System info and version';

  @override
  String systemSettingsLastUpdated(String time) {
    return 'Last updated: $time';
  }

  @override
  String get systemSettingsPanelName => '1Panel';

  @override
  String get systemSettingsSystemVersion => 'System Version';

  @override
  String get systemSettingsMfaStatus => 'MFA Status';

  @override
  String get systemSettingsEnabled => 'Enabled';

  @override
  String get systemSettingsDisabled => 'Disabled';

  @override
  String get systemSettingsApiKeyManage => 'API Key Management';

  @override
  String get systemSettingsCurrentStatus => 'Current Status';

  @override
  String get systemSettingsUnknown => 'Unknown';

  @override
  String get systemSettingsApiKeyLabel => 'API Key';

  @override
  String get systemSettingsNotSet => 'Not set';

  @override
  String get systemSettingsGenerateNewKey => 'Generate New Key';

  @override
  String get systemSettingsApiKeyGenerated => 'API key generated';

  @override
  String get systemSettingsGenerateFailed => 'Generation failed';

  @override
  String get apiKeySettingsTitle => 'API Key Management';

  @override
  String get apiKeySettingsStatus => 'Status';

  @override
  String get apiKeySettingsEnabled => 'API Interface';

  @override
  String get apiKeySettingsInfo => 'Key Information';

  @override
  String get apiKeySettingsKey => 'API Key';

  @override
  String get apiKeySettingsIpWhitelist => 'IP Whitelist';

  @override
  String get apiKeySettingsValidityTime => 'Validity Time';

  @override
  String get apiKeySettingsActions => 'Actions';

  @override
  String get apiKeySettingsRegenerate => 'Regenerate';

  @override
  String get apiKeySettingsRegenerateDesc => 'Generate new API key';

  @override
  String get apiKeySettingsRegenerateConfirm =>
      'Are you sure you want to regenerate the API key? The old key will be invalid immediately.';

  @override
  String get apiKeySettingsRegenerateSuccess => 'API key regenerated';

  @override
  String get apiKeySettingsEnable => 'Enable API';

  @override
  String get apiKeySettingsDisable => 'Disable API';

  @override
  String get apiKeySettingsEnableConfirm =>
      'Are you sure you want to enable API interface?';

  @override
  String get apiKeySettingsDisableConfirm =>
      'Are you sure you want to disable API interface?';

  @override
  String get commonCopied => 'Copied to clipboard';

  @override
  String get sslSettingsTitle => 'SSL Certificate Management';

  @override
  String get sslSettingsInfo => 'Certificate Information';

  @override
  String get sslSettingsDomain => 'Domain';

  @override
  String get sslSettingsStatus => 'Status';

  @override
  String get sslSettingsType => 'Type';

  @override
  String get sslSettingsProvider => 'Provider';

  @override
  String get sslSettingsExpiration => 'Expiration';

  @override
  String get sslSettingsActions => 'Actions';

  @override
  String get sslSettingsUpload => 'Upload Certificate';

  @override
  String get sslSettingsUploadDesc => 'Upload SSL certificate file';

  @override
  String get sslSettingsDownload => 'Download Certificate';

  @override
  String get sslSettingsDownloadDesc => 'Download current SSL certificate';

  @override
  String get sslSettingsDownloadSuccess =>
      'Certificate downloaded successfully';

  @override
  String get sslSettingsCert => 'Certificate Content';

  @override
  String get sslSettingsKey => 'Private Key Content';

  @override
  String get upgradeTitle => 'System Upgrade';

  @override
  String get upgradeCurrentVersion => 'Current Version';

  @override
  String get upgradeCurrentVersionLabel => 'Current System Version';

  @override
  String get upgradeAvailableVersions => 'Available Versions';

  @override
  String get upgradeNoUpdates => 'Already up to date';

  @override
  String get upgradeLatest => 'Latest';

  @override
  String get upgradeConfirm => 'Confirm Upgrade';

  @override
  String upgradeConfirmMessage(Object version) {
    return 'Are you sure you want to upgrade to version $version?';
  }

  @override
  String get upgradeButton => 'Upgrade';

  @override
  String get upgradeStarted => 'Upgrade started';

  @override
  String get monitorSettingsTitle => 'Monitor Settings';

  @override
  String get monitorSettingsInterval => 'Monitor Interval';

  @override
  String get monitorSettingsStoreDays => 'Data Retention Days';

  @override
  String get monitorSettingsEnable => 'Enable Monitoring';

  @override
  String get systemSettingsCurrentVersion => 'Current Version';

  @override
  String get systemSettingsCheckingUpdate => 'Checking for updates...';

  @override
  String get systemSettingsClose => 'Close';

  @override
  String get panelSettingsTitle => 'Panel Settings';

  @override
  String get panelSettingsBasicInfo => 'Basic Info';

  @override
  String get panelSettingsPanelName => 'Panel Name';

  @override
  String get panelSettingsVersion => 'System Version';

  @override
  String get panelSettingsPort => 'Listen Port';

  @override
  String get panelSettingsBindAddress => 'Bind Address';

  @override
  String get panelSettingsInterface => 'Interface Settings';

  @override
  String get panelSettingsTheme => 'Theme';

  @override
  String get panelSettingsLanguage => 'Language';

  @override
  String get panelSettingsMenuTabs => 'Menu Tabs';

  @override
  String get panelSettingsAdvanced => 'Advanced Settings';

  @override
  String get panelSettingsDeveloperMode => 'Developer Mode';

  @override
  String get panelSettingsIpv6 => 'IPv6';

  @override
  String get panelSettingsSessionTimeout => 'Session Timeout';

  @override
  String panelSettingsMinutes(String count) {
    return '$count minutes';
  }

  @override
  String get terminalSettingsTitle => 'Terminal Settings';

  @override
  String get terminalSettingsDisplay => 'Display Settings';

  @override
  String get terminalSettingsCursorStyle => 'Cursor Style';

  @override
  String get terminalSettingsCursorBlink => 'Cursor Blink';

  @override
  String get terminalSettingsFontSize => 'Font Size';

  @override
  String get terminalSettingsScroll => 'Scroll Settings';

  @override
  String get terminalSettingsScrollSensitivity => 'Scroll Sensitivity';

  @override
  String get terminalSettingsScrollback => 'Scrollback Buffer';

  @override
  String get terminalSettingsStyle => 'Style Settings';

  @override
  String get terminalSettingsLineHeight => 'Line Height';

  @override
  String get terminalSettingsLetterSpacing => 'Letter Spacing';

  @override
  String get securitySettingsTitle => 'Security Settings';

  @override
  String get securitySettingsPasswordSection => 'Password Management';

  @override
  String get securitySettingsChangePassword => 'Change Password';

  @override
  String get securitySettingsChangePasswordDesc => 'Change login password';

  @override
  String get securitySettingsOldPassword => 'Current Password';

  @override
  String get securitySettingsNewPassword => 'New Password';

  @override
  String get securitySettingsConfirmPassword => 'Confirm Password';

  @override
  String get securitySettingsPasswordMismatch => 'Passwords do not match';

  @override
  String get securitySettingsMfaSection => 'MFA Authentication';

  @override
  String get securitySettingsMfaStatus => 'MFA Status';

  @override
  String get securitySettingsMfaBind => 'Bind MFA';

  @override
  String get securitySettingsMfaUnbind => 'Unbind MFA';

  @override
  String get securitySettingsMfaUnbindDesc =>
      'MFA authentication will be disabled after unbinding. Are you sure?';

  @override
  String get securitySettingsMfaScanQr => 'Scan QR code with authenticator app';

  @override
  String securitySettingsMfaSecret(Object secret) {
    return 'Secret: $secret';
  }

  @override
  String get securitySettingsMfaCode => 'Verification Code';

  @override
  String get securitySettingsUnbindMfa => 'Unbind MFA';

  @override
  String get securitySettingsAccessControl => 'Access Control';

  @override
  String get securitySettingsSecurityEntrance => 'Security Entrance';

  @override
  String get securitySettingsBindDomain => 'Bind Domain';

  @override
  String get securitySettingsAllowIPs => 'Allowed IPs';

  @override
  String get securitySettingsPasswordPolicy => 'Password Policy';

  @override
  String get securitySettingsComplexityVerification =>
      'Complexity Verification';

  @override
  String get securitySettingsExpirationDays => 'Expiration Days';

  @override
  String get securitySettingsEnableMfa => 'Enable MFA';

  @override
  String get securitySettingsDisableMfa => 'Disable MFA';

  @override
  String get securitySettingsEnableMfaConfirm =>
      'Are you sure you want to enable MFA?';

  @override
  String get securitySettingsDisableMfaConfirm =>
      'Are you sure you want to disable MFA?';

  @override
  String get securitySettingsEnterMfaCode =>
      'Please enter MFA verification code';

  @override
  String get securitySettingsVerifyCode => 'Verification Code';

  @override
  String get securitySettingsMfaCodeHint => 'Enter 6-digit code';

  @override
  String get securitySettingsMfaUnbound => 'MFA unbound';

  @override
  String get securitySettingsUnbindFailed => 'Unbind failed';

  @override
  String get snapshotTitle => 'Snapshot Management';

  @override
  String get snapshotCreate => 'Create Snapshot';

  @override
  String get snapshotEmpty => 'No snapshots';

  @override
  String get snapshotCreatedAt => 'Created At';

  @override
  String get snapshotDescription => 'Description';

  @override
  String get snapshotRecover => 'Recover';

  @override
  String get snapshotDownload => 'Download';

  @override
  String get snapshotDelete => 'Delete';

  @override
  String get snapshotEnterDesc => 'Enter snapshot description (optional)';

  @override
  String get snapshotDescLabel => 'Description';

  @override
  String get snapshotDescHint => 'Enter snapshot description';

  @override
  String get snapshotCreateSuccess => 'Snapshot created successfully';

  @override
  String get snapshotCreateFailed => 'Failed to create snapshot';

  @override
  String get snapshotDownloadDev => 'Download feature in development';

  @override
  String get snapshotRecoverTitle => 'Recover Snapshot';

  @override
  String get snapshotRecoverConfirm =>
      'Are you sure you want to recover this snapshot? Current configuration will be overwritten.';

  @override
  String get snapshotRecoverSuccess => 'Snapshot recovered successfully';

  @override
  String get snapshotRecoverFailed => 'Failed to recover snapshot';

  @override
  String get snapshotDeleteTitle => 'Delete Snapshot';

  @override
  String get snapshotDeleteConfirm =>
      'Are you sure you want to delete selected snapshots? This action cannot be undone.';

  @override
  String get snapshotDeleteSuccess => 'Snapshot deleted successfully';

  @override
  String get snapshotDeleteFailed => 'Failed to delete snapshot';

  @override
  String get serverModuleSystemSettings => 'System Settings';
}
