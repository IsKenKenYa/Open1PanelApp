import 'package:flutter/foundation.dart';
import 'package:onepanel_client/core/presentation/safe_change_notifier.dart';
import 'package:onepanel_client/core/config/api_config.dart';
import 'package:onepanel_client/core/network/api_client_manager.dart';

class CurrentServerController extends ChangeNotifier with SafeChangeNotifier {
  bool _isLoading = false;
  List<ApiConfig> _servers = const [];
  ApiConfig? _currentServer;

  bool get isLoading => _isLoading;
  List<ApiConfig> get servers => _servers;
  ApiConfig? get currentServer => _currentServer;
  String? get currentServerId => _currentServer?.id;
  bool get hasServer => _currentServer != null;
  bool get hasAvailableServers => _servers.isNotEmpty;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    try {
      _servers = await ApiConfigManager.getConfigs();
      _currentServer = await ApiConfigManager.getCurrentConfig();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> selectServer(String id) async {
    await ApiConfigManager.setCurrentConfig(id);
    // Clear all HTTP clients so the next API call uses the new server's
    // base URL and API key — otherwise stale connections would be reused.
    ApiClientManager.instance.clearAllClients();
    await load();
  }

  Future<void> refresh() async {
    await load();
  }
}
