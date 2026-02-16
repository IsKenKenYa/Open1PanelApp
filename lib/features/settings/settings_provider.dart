import 'package:flutter/foundation.dart';
import 'settings_service.dart';
import '../../api/v2/setting_v2.dart' as api;
import '../../data/models/setting_models.dart';

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
      snapshots: snapshots ?? this.snapshots,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

class SettingsProvider extends ChangeNotifier {
  SettingsData _data = const SettingsData();
  final SettingsService _service = SettingsService();

  SettingsData get data => _data;

  Future<void> loadSystemSettings() async {
    _data = _data.copyWith(isLoading: true, error: null);
    notifyListeners();

    try {
      final settings = await _service.getSystemSettings();
      
      _data = _data.copyWith(
        systemSettings: settings,
        isLoading: false,
        lastUpdated: DateTime.now(),
      );
      notifyListeners();
    } catch (e) {
      debugPrint('[SettingsProvider] loadSystemSettings error: $e');
      _data = _data.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      notifyListeners();
    }
  }

  Future<void> loadTerminalSettings() async {
    try {
      final settings = await _service.getTerminalSettings();
      
      _data = _data.copyWith(terminalSettings: settings);
      notifyListeners();
    } catch (e) {
      debugPrint('[SettingsProvider] loadTerminalSettings error: $e');
    }
  }

  Future<void> loadNetworkInterfaces() async {
    try {
      final interfaces = await _service.getNetworkInterfaces();
      
      _data = _data.copyWith(networkInterfaces: interfaces);
      notifyListeners();
    } catch (e) {
      debugPrint('[SettingsProvider] loadNetworkInterfaces error: $e');
    }
  }

  Future<void> loadMfaInfo(MfaCredential request) async {
    try {
      final mfaInfo = await _service.loadMfaInfo(request);
      
      _data = _data.copyWith(mfaInfo: mfaInfo);
      notifyListeners();
    } catch (e) {
      debugPrint('[SettingsProvider] loadMfaInfo error: $e');
    }
  }

  Future<void> loadMfaStatus() async {
    try {
      final status = await _service.getMfaStatus();
      
      _data = _data.copyWith(mfaStatus: status);
      notifyListeners();
    } catch (e) {
      debugPrint('[SettingsProvider] loadMfaStatus error: $e');
    }
  }

  Future<void> loadSSLInfo() async {
    try {
      final sslInfo = await _service.getSSLInfo();
      
      _data = _data.copyWith(sslInfo: sslInfo);
      notifyListeners();
    } catch (e) {
      debugPrint('[SettingsProvider] loadSSLInfo error: $e');
    }
  }

  Future<void> loadUpgradeInfo() async {
    try {
      final upgradeInfo = await _service.getUpgradeInfo();
      
      _data = _data.copyWith(upgradeInfo: upgradeInfo);
      notifyListeners();
    } catch (e) {
      debugPrint('[SettingsProvider] loadUpgradeInfo error: $e');
    }
  }

  Future<void> loadSnapshots() async {
    try {
      final result = await _service.searchSnapshots(api.SnapshotSearch());
      
      _data = _data.copyWith(snapshots: result?['items'] as List<dynamic>?);
      notifyListeners();
    } catch (e) {
      debugPrint('[SettingsProvider] loadSnapshots error: $e');
    }
  }

  Future<bool> updateSystemSetting(String key, String value) async {
    try {
      await _service.updateSystemSetting(api.SettingUpdate(key: key, value: value));
      await loadSystemSettings();
      return true;
    } catch (e) {
      debugPrint('[SettingsProvider] updateSystemSetting error: $e');
      return false;
    }
  }

  Future<bool> updateTerminalSettings({
    String? lineTheme,
    String? fontSize,
    String? fontFamily,
    String? cursorStyle,
    String? cursorBlink,
    String? scrollSensitivity,
    String? scrollback,
    String? lineHeight,
    String? letterSpacing,
  }) async {
    try {
      await _service.updateTerminalSettings(
        api.TerminalUpdate(
          lineTheme: lineTheme,
          fontSize: fontSize,
          fontFamily: fontFamily,
          cursorStyle: cursorStyle,
          cursorBlink: cursorBlink,
          scrollSensitivity: scrollSensitivity,
          scrollback: scrollback,
          lineHeight: lineHeight,
          letterSpacing: letterSpacing,
        ),
      );
      await loadTerminalSettings();
      return true;
    } catch (e) {
      debugPrint('[SettingsProvider] updateTerminalSettings error: $e');
      return false;
    }
  }

  Future<bool> bindMfa(MfaBindRequest request) async {
    try {
      await _service.bindMfa(request);
      await loadMfaStatus();
      return true;
    } catch (e) {
      debugPrint('[SettingsProvider] bindMfa error: $e');
      return false;
    }
  }

  Future<bool> unbindMfa(String code) async {
    try {
      await _service.unbindMfa({'code': code});
      await loadMfaStatus();
      return true;
    } catch (e) {
      debugPrint('[SettingsProvider] unbindMfa error: $e');
      return false;
    }
  }

  Future<bool> generateApiKey() async {
    try {
      final result = await _service.generateApiKey();
      if (result != null) {
        await loadSystemSettings();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('[SettingsProvider] generateApiKey error: $e');
      return false;
    }
  }

  Future<bool> createSnapshot({String? description}) async {
    try {
      await _service.createSnapshot(api.SnapshotCreate(description: description));
      await loadSnapshots();
      return true;
    } catch (e) {
      debugPrint('[SettingsProvider] createSnapshot error: $e');
      return false;
    }
  }

  Future<bool> deleteSnapshot(List<int> ids) async {
    try {
      await _service.deleteSnapshot(api.SnapshotDelete(ids: ids));
      await loadSnapshots();
      return true;
    } catch (e) {
      debugPrint('[SettingsProvider] deleteSnapshot error: $e');
      return false;
    }
  }

  Future<bool> recoverSnapshot(int id) async {
    try {
      await _service.recoverSnapshot(api.SnapshotRecover(id: id));
      return true;
    } catch (e) {
      debugPrint('[SettingsProvider] recoverSnapshot error: $e');
      return false;
    }
  }

  Future<bool> upgrade({String? version}) async {
    try {
      await _service.upgrade(api.UpgradeRequest(version: version));
      return true;
    } catch (e) {
      debugPrint('[SettingsProvider] upgrade error: $e');
      return false;
    }
  }

  Future<List<dynamic>?> getUpgradeReleases() async {
    try {
      return await _service.getUpgradeReleases();
    } catch (e) {
      debugPrint('[SettingsProvider] getUpgradeReleases error: $e');
      return null;
    }
  }

  Future<void> load() async {
    _data = _data.copyWith(isLoading: true, error: null);
    notifyListeners();

    try {
      final results = await Future.wait([
        _service.getSystemSettings(),
        _service.getTerminalSettings(),
        _service.getNetworkInterfaces(),
      ]);

      _data = _data.copyWith(
        systemSettings: results[0] as SystemSettingInfo?,
        terminalSettings: results[1] as TerminalInfo?,
        networkInterfaces: results[2] as List<String>?,
        isLoading: false,
        lastUpdated: DateTime.now(),
      );
      notifyListeners();
    } catch (e) {
      debugPrint('[SettingsProvider] load error: $e');
      _data = _data.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    _data = _data.copyWith(isRefreshing: true, error: null);
    notifyListeners();

    try {
      await load();
      _data = _data.copyWith(isRefreshing: false);
      notifyListeners();
    } catch (e) {
      _data = _data.copyWith(isRefreshing: false, error: e.toString());
      notifyListeners();
    }
  }

  void clearError() {
    _data = _data.copyWith(error: null);
    notifyListeners();
  }
}
