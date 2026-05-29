import 'package:flutter_test/flutter_test.dart';
import 'package:onepanel_client/api/v2/setting_v2.dart' as api;
import 'package:onepanel_client/data/models/setting_models.dart';
import 'package:onepanel_client/data/models/ssh_settings_models.dart';
import 'package:onepanel_client/features/settings/settings_provider.dart';
import 'package:onepanel_client/features/settings/settings_service.dart';
import 'package:onepanel_client/core/services/passkey_service.dart';

class _FakeSettingsService extends SettingsService {
  String? dashboardMemo;
  String? lastMemoUpdate;
  int loadDashboardMemoCount = 0;
  int updateDashboardMemoCount = 0;

  dynamic settingsAvailability = true;
  int checkSettingsAvailableCallCount = 0;

  dynamic _mfaStatus;
  MfaOtp? _mfaOtp;
  int loadMfaInfoCallCount = 0;
  int getMfaStatusCallCount = 0;

  String? lastBoundMfaCode;
  String? lastUnboundMfaCode;

  api.TerminalUpdate? lastTerminalUpdate;
  api.ProxyUpdate? lastProxyUpdate;
  api.PasswordUpdate? lastPasswordUpdate;
  api.UpgradeRequest? lastUpgradeRequest;

  bool shouldThrowOnLoad = false;
  bool shouldThrowOnMemo = false;

  @override
  Future<SystemSettingInfo?> getSystemSettings() async {
    if (shouldThrowOnLoad) throw Exception('load failed');
    return const SystemSettingInfo(panelName: 'Test Panel');
  }

  @override
  Future<TerminalInfo?> getTerminalSettings() async {
    if (shouldThrowOnLoad) throw Exception('load failed');
    return const TerminalInfo(fontSize: '14');
  }

  @override
  Future<List<String>?> getNetworkInterfaces() async {
    if (shouldThrowOnLoad) throw Exception('load failed');
    return const <String>['eth0'];
  }

  @override
  Future<dynamic> getAppStoreConfig() async => <String, dynamic>{};

  @override
  Future<dynamic> getAuthSetting() async => <String, dynamic>{};

  @override
  Future<SshLocalConnectionInfo> getSSHConnection() async {
    return const SshLocalConnectionInfo();
  }

  @override
  Future<String?> getDashboardMemo() async {
    loadDashboardMemoCount++;
    if (shouldThrowOnMemo) throw Exception('memo load failed');
    return dashboardMemo;
  }

  @override
  Future<void> updateDashboardMemo(String content) async {
    updateDashboardMemoCount++;
    if (shouldThrowOnMemo) throw Exception('memo update failed');
    lastMemoUpdate = content;
    dashboardMemo = content;
  }

  @override
  Future<List<PasskeyInfo>> listPasskeys() async => const <PasskeyInfo>[];

  @override
  Future<dynamic> checkSettingsAvailable() async {
    checkSettingsAvailableCallCount++;
    return settingsAvailability;
  }

  @override
  Future<MfaOtp?> loadMfaInfo(MfaLoadRequest request) async {
    loadMfaInfoCallCount++;
    return _mfaOtp;
  }

  @override
  Future<MfaStatus?> getMfaStatus() async {
    getMfaStatusCallCount++;
    return _mfaStatus as MfaStatus?;
  }

  @override
  Future<void> bindMfa(MfaBindRequest request) async {
    lastBoundMfaCode = request.code;
  }

  @override
  Future<void> unbindMfa(Map<String, dynamic> request) async {
    lastUnboundMfaCode = request['code'] as String?;
  }

  @override
  Future<void> updateTerminalSettings(api.TerminalUpdate request) async {
    lastTerminalUpdate = request;
  }

  @override
  Future<void> updateProxySettings(api.ProxyUpdate request) async {
    lastProxyUpdate = request;
  }

  @override
  Future<void> updatePasswordSettings(api.PasswordUpdate request) async {
    lastPasswordUpdate = request;
  }

  @override
  Future<void> upgrade(api.UpgradeRequest request) async {
    lastUpgradeRequest = request;
  }
}

class _FakePasskeyService implements PasskeyService {
  bool _supported = true;
  int getAvailabilityCallCount = 0;

  @override
  Future<PasskeyAvailabilityResult> getAvailability() async {
    getAvailabilityCallCount++;
    if (_supported) {
      return const PasskeyAvailabilityResult.supported();
    }
    return const PasskeyAvailabilityResult.unsupported('not available');
  }

  @override
  Future<Map<String, dynamic>> registerCredential(
      Map<String, dynamic> publicKey) async {
    return <String, dynamic>{'id': 'test'};
  }

  @override
  Future<Map<String, dynamic>> authenticateCredential(
      Map<String, dynamic> publicKey) async {
    return <String, dynamic>{'id': 'test'};
  }

  @override
  String toUserMessage(Object error) => error.toString();
}

void main() {
  group('SettingsProvider - loadDashboardMemo', () {
    test('loads memo into data', () async {
      final service = _FakeSettingsService()..dashboardMemo = 'My memo';
      final passkeyService = _FakePasskeyService();
      final provider =
          SettingsProvider(service: service, passkeyService: passkeyService);

      await provider.loadDashboardMemo();

      expect(provider.data.dashboardMemo, 'My memo');
      expect(provider.data.isMemoLoading, isFalse);
      expect(service.loadDashboardMemoCount, 1);
    });

    test('handles null memo', () async {
      final service = _FakeSettingsService()..dashboardMemo = null;
      final passkeyService = _FakePasskeyService();
      final provider =
          SettingsProvider(service: service, passkeyService: passkeyService);

      await provider.loadDashboardMemo();

      expect(provider.data.dashboardMemo, isNull);
      expect(provider.data.isMemoLoading, isFalse);
    });

    test('sets error when memo load fails', () async {
      final service = _FakeSettingsService()..shouldThrowOnMemo = true;
      final passkeyService = _FakePasskeyService();
      final provider =
          SettingsProvider(service: service, passkeyService: passkeyService);

      await provider.loadDashboardMemo();

      expect(provider.data.isMemoLoading, isFalse);
      expect(provider.data.error, contains('备忘录'));
    });
  });

  group('SettingsProvider - updateDashboardMemo', () {
    test('updates memo and returns true', () async {
      final service = _FakeSettingsService();
      final passkeyService = _FakePasskeyService();
      final provider =
          SettingsProvider(service: service, passkeyService: passkeyService);

      final result = await provider.updateDashboardMemo('New memo');

      expect(result, isTrue);
      expect(provider.data.dashboardMemo, 'New memo');
      expect(provider.data.isMemoSaving, isFalse);
      expect(service.lastMemoUpdate, 'New memo');
    });

    test('returns false and sets error when update fails', () async {
      final service = _FakeSettingsService()..shouldThrowOnMemo = true;
      final passkeyService = _FakePasskeyService();
      final provider =
          SettingsProvider(service: service, passkeyService: passkeyService);

      final result = await provider.updateDashboardMemo('Fail memo');

      expect(result, isFalse);
      expect(provider.data.isMemoSaving, isFalse);
      expect(provider.data.error, contains('备忘录'));
    });
  });

  group('SettingsProvider - loadPasskeys', () {
    test('loads passkeys when supported', () async {
      final service = _FakeSettingsService();
      final passkeyService = _FakePasskeyService().._supported = true;
      final provider =
          SettingsProvider(service: service, passkeyService: passkeyService);

      await provider.loadPasskeys();

      expect(provider.data.isPasskeySupported, isTrue);
      expect(provider.data.isPasskeysLoading, isFalse);
      expect(provider.data.passkeyUnsupportedReason, isNull);
    });

    test('sets unsupported when platform lacks support', () async {
      final service = _FakeSettingsService();
      final passkeyService = _FakePasskeyService().._supported = false;
      final provider =
          SettingsProvider(service: service, passkeyService: passkeyService);

      await provider.loadPasskeys();

      expect(provider.data.isPasskeySupported, isFalse);
      expect(provider.data.passkeyUnsupportedReason, 'not available');
      expect(provider.data.passkeys, isEmpty);
    });
  });

  group('SettingsProvider - registerPasskey', () {
    test('rejects empty name', () async {
      final service = _FakeSettingsService();
      final passkeyService = _FakePasskeyService();
      final provider =
          SettingsProvider(service: service, passkeyService: passkeyService);

      final result = await provider.registerPasskey('  ');

      expect(result, isFalse);
      expect(provider.data.error, contains('不能为空'));
    });

    test('rejects when platform unsupported', () async {
      final service = _FakeSettingsService();
      final passkeyService = _FakePasskeyService().._supported = false;
      final provider =
          SettingsProvider(service: service, passkeyService: passkeyService);

      final result = await provider.registerPasskey('My Key');

      expect(result, isFalse);
      expect(provider.data.isPasskeyRegistering, isFalse);
    });
  });

  group('SettingsProvider - clearError', () {
    test('clears error and notifies', () async {
      final service = _FakeSettingsService()..settingsAvailability = false;
      final passkeyService = _FakePasskeyService();
      final provider =
          SettingsProvider(service: service, passkeyService: passkeyService);

      await provider.updateSystemSetting('key', 'value');
      expect(provider.data.error, isNotNull);

      provider.clearError();
      expect(provider.data.error, isNull);
    });
  });

  group('SettingsProvider - load() error handling', () {
    test('sets error when main load fails', () async {
      final service = _FakeSettingsService()..shouldThrowOnLoad = true;
      final passkeyService = _FakePasskeyService();
      final provider =
          SettingsProvider(service: service, passkeyService: passkeyService);

      await provider.load();

      expect(provider.data.isLoading, isFalse);
      expect(provider.data.error, isNotNull);
    });

    test('sets isLoading during load', () async {
      final service = _FakeSettingsService();
      final passkeyService = _FakePasskeyService();
      final provider =
          SettingsProvider(service: service, passkeyService: passkeyService);

      final loadFuture = provider.load();

      expect(provider.data.isLoading, isTrue);

      await loadFuture;

      expect(provider.data.isLoading, isFalse);
    });
  });

  group('SettingsProvider - updateTerminalSettings', () {
    test('sends terminal update and reloads', () async {
      final service = _FakeSettingsService();
      final passkeyService = _FakePasskeyService();
      final provider =
          SettingsProvider(service: service, passkeyService: passkeyService);

      final result = await provider.updateTerminalSettings(
        fontSize: '16',
        fontFamily: 'Monaco',
      );

      expect(result, isTrue);
      expect(service.lastTerminalUpdate?.fontSize, '16');
      expect(service.lastTerminalUpdate?.fontFamily, 'Monaco');
    });
  });

  group('SettingsProvider - updateProxySettings', () {
    test('sends proxy update and reloads', () async {
      final service = _FakeSettingsService();
      final passkeyService = _FakePasskeyService();
      final provider =
          SettingsProvider(service: service, passkeyService: passkeyService);

      final result = await provider.updateProxySettings(
        proxyUrl: 'http://proxy.example.com',
        proxyPort: 8080,
      );

      expect(result, isTrue);
      expect(service.lastProxyUpdate?.proxyUrl, 'http://proxy.example.com');
      expect(service.lastProxyUpdate?.proxyPort, 8080);
    });
  });

  group('SettingsProvider - updatePassword', () {
    test('sends password update', () async {
      final service = _FakeSettingsService();
      final passkeyService = _FakePasskeyService();
      final provider =
          SettingsProvider(service: service, passkeyService: passkeyService);

      final result = await provider.updatePassword('old123', 'new456');

      expect(result, isTrue);
      expect(service.lastPasswordUpdate?.oldPassword, 'old123');
      expect(service.lastPasswordUpdate?.newPassword, 'new456');
    });
  });

  group('SettingsProvider - MFA operations', () {
    test('loadMfaInfo loads MFA data', () async {
      final service = _FakeSettingsService();
      final passkeyService = _FakePasskeyService();
      final provider =
          SettingsProvider(service: service, passkeyService: passkeyService);

      await provider.loadMfaInfo(const MfaLoadRequest(
        title: '1Panel',
        interval: 30,
      ));

      expect(service.loadMfaInfoCallCount, 1);
    });

    test('loadMfaStatus loads status', () async {
      final service = _FakeSettingsService();
      final passkeyService = _FakePasskeyService();
      final provider =
          SettingsProvider(service: service, passkeyService: passkeyService);

      await provider.loadMfaStatus();

      expect(service.getMfaStatusCallCount, 1);
    });

    test('bindMfaWithCode sends code and reloads status', () async {
      final service = _FakeSettingsService();
      final passkeyService = _FakePasskeyService();
      final provider =
          SettingsProvider(service: service, passkeyService: passkeyService);

      final result = await provider.bindMfaWithCode('123456', 'SECRET', '30');

      expect(result, isTrue);
      expect(service.lastBoundMfaCode, '123456');
      expect(service.getMfaStatusCallCount, 1);
    });

    test('unbindMfa sends code and reloads status', () async {
      final service = _FakeSettingsService();
      final passkeyService = _FakePasskeyService();
      final provider =
          SettingsProvider(service: service, passkeyService: passkeyService);

      final result = await provider.unbindMfa('654321');

      expect(result, isTrue);
      expect(service.lastUnboundMfaCode, '654321');
      expect(service.getMfaStatusCallCount, 1);
    });
  });

  group('SettingsProvider - upgrade', () {
    test('sends upgrade request', () async {
      final service = _FakeSettingsService();
      final passkeyService = _FakePasskeyService();
      final provider =
          SettingsProvider(service: service, passkeyService: passkeyService);

      final result = await provider.upgrade(version: '2.0.0');

      expect(result, isTrue);
      expect(service.lastUpgradeRequest?.version, '2.0.0');
    });
  });

  group('SettingsData - copyWith', () {
    test('preserves unmodified fields', () {
      const data = SettingsData(
        isLoading: true,
        dashboardMemo: 'memo',
        isMemoSaving: true,
      );

      final copied = data.copyWith(isLoading: false);

      expect(copied.isLoading, isFalse);
      expect(copied.dashboardMemo, 'memo');
      expect(copied.isMemoSaving, isTrue);
    });

    test('can reset error to null', () {
      const data = SettingsData(error: 'some error');

      final copied = data.copyWith(error: null);

      expect(copied.error, isNull);
    });

    test('can reset passkeyDeletingId to null', () {
      const data = SettingsData(passkeyDeletingId: 'some-id');

      final copied = data.copyWith(passkeyDeletingId: null);

      expect(copied.passkeyDeletingId, isNull);
    });

    test('default values are correct', () {
      const data = SettingsData();

      expect(data.isLoading, isFalse);
      expect(data.isRefreshing, isFalse);
      expect(data.error, isNull);
      expect(data.systemSettings, isNull);
      expect(data.passkeys, isEmpty);
      expect(data.isMemoLoading, isFalse);
      expect(data.isMemoSaving, isFalse);
    });
  });
}
