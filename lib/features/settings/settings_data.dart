import 'package:onepanel_client/data/models/setting_models.dart';
import 'package:onepanel_client/data/models/ssh_settings_models.dart';

/// Immutable snapshot of all settings UI state.
///
/// Extracted from settings_provider.dart to keep the provider file under
/// the 1000 LOC hard limit (architecture review R5 candidate 2).
class SettingsData {
  final bool isLoading;
  final bool isRefreshing;
  final String? error;
  final SystemSettingInfo? systemSettings;
  final TerminalInfo? terminalSettings;
  final List<String>? networkInterfaces;
  final MfaOtp? mfaInfo;
  final MfaStatus? mfaStatus;
  final dynamic sslInfo;
  final dynamic upgradeInfo;
  final dynamic appStoreConfig;
  final dynamic authSetting;
  final SshLocalConnectionInfo? sshConnection;
  final String? dashboardMemo;
  final bool isMemoLoading;
  final bool isMemoSaving;
  final List<PasskeyInfo> passkeys;
  final bool isPasskeysLoading;
  final bool isPasskeyRegistering;
  final String? passkeyDeletingId;
  final bool isPasskeySupported;
  final String? passkeyUnsupportedReason;
  final List<dynamic>? snapshots;
  final DateTime? lastUpdated;

  const SettingsData({
    this.isLoading = false,
    this.isRefreshing = false,
    this.error,
    this.systemSettings,
    this.terminalSettings,
    this.networkInterfaces,
    this.mfaInfo,
    this.mfaStatus,
    this.sslInfo,
    this.upgradeInfo,
    this.appStoreConfig,
    this.authSetting,
    this.sshConnection,
    this.dashboardMemo,
    this.isMemoLoading = false,
    this.isMemoSaving = false,
    this.passkeys = const <PasskeyInfo>[],
    this.isPasskeysLoading = false,
    this.isPasskeyRegistering = false,
    this.passkeyDeletingId,
    this.isPasskeySupported = false,
    this.passkeyUnsupportedReason,
    this.snapshots,
    this.lastUpdated,
  });

  SettingsData copyWith({
    bool? isLoading,
    bool? isRefreshing,
    String? error,
    SystemSettingInfo? systemSettings,
    TerminalInfo? terminalSettings,
    List<String>? networkInterfaces,
    MfaOtp? mfaInfo,
    MfaStatus? mfaStatus,
    dynamic sslInfo,
    dynamic upgradeInfo,
    dynamic appStoreConfig,
    dynamic authSetting,
    SshLocalConnectionInfo? sshConnection,
    String? dashboardMemo,
    bool? isMemoLoading,
    bool? isMemoSaving,
    List<PasskeyInfo>? passkeys,
    bool? isPasskeysLoading,
    bool? isPasskeyRegistering,
    String? passkeyDeletingId,
    bool? isPasskeySupported,
    String? passkeyUnsupportedReason,
    List<dynamic>? snapshots,
    DateTime? lastUpdated,
  }) {
    return SettingsData(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      error: error,
      systemSettings: systemSettings ?? this.systemSettings,
      terminalSettings: terminalSettings ?? this.terminalSettings,
      networkInterfaces: networkInterfaces ?? this.networkInterfaces,
      mfaInfo: mfaInfo ?? this.mfaInfo,
      mfaStatus: mfaStatus ?? this.mfaStatus,
      sslInfo: sslInfo ?? this.sslInfo,
      upgradeInfo: upgradeInfo ?? this.upgradeInfo,
      appStoreConfig: appStoreConfig ?? this.appStoreConfig,
      authSetting: authSetting ?? this.authSetting,
      sshConnection: sshConnection ?? this.sshConnection,
      dashboardMemo: dashboardMemo ?? this.dashboardMemo,
      isMemoLoading: isMemoLoading ?? this.isMemoLoading,
      isMemoSaving: isMemoSaving ?? this.isMemoSaving,
      passkeys: passkeys ?? this.passkeys,
      isPasskeysLoading: isPasskeysLoading ?? this.isPasskeysLoading,
      isPasskeyRegistering:
          isPasskeyRegistering ?? this.isPasskeyRegistering,
      passkeyDeletingId: passkeyDeletingId,
      isPasskeySupported: isPasskeySupported ?? this.isPasskeySupported,
      passkeyUnsupportedReason: passkeyUnsupportedReason,
      snapshots: snapshots ?? this.snapshots,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
