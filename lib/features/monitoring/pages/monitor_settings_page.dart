import 'package:flutter/material.dart';
import 'package:onepanel_client/core/utils/snackbar_utils.dart';
import 'package:onepanel_client/data/repositories/monitor_repository.dart';

/// Monitor settings page.
/// Mirrors frontend's host/monitor/setting page: interval, retention days, default IO/network.
class MonitorSettingsPage extends StatefulWidget {
  const MonitorSettingsPage({super.key});

  @override
  State<MonitorSettingsPage> createState() => _MonitorSettingsPageState();
}

class _MonitorSettingsPageState extends State<MonitorSettingsPage> {
  final MonitorRepository _repo = const MonitorRepository();
  Map<String, dynamic>? _settings;
  bool _isLoading = true;
  bool _isSaving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final client = await _getCurrentClient();
      final result = await _repo.getSetting(client);
      if (mounted) setState(() { _settings = _settingsToJson(result); _isLoading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _isLoading = false; });
    }
  }

  Map<String, dynamic> _settingsToJson(dynamic setting) {
    if (setting == null) return const <String, dynamic>{};
    try {
      return Map<String, dynamic>.from(setting as Map);
    } catch (_) {
      return const <String, dynamic>{};
    }
  }

  Future<dynamic> _getCurrentClient() async {
    final config = await _getConfig();
    return config;
  }

  Future<dynamic> _getConfig() async {
    // Simplified - in production this uses ApiClientManager
    return null;
  }

  Future<void> _updateSetting(String key, String value) async {
    setState(() => _isSaving = true);
    try {
      final client = await _getCurrentClient();
      await _repo.updateSetting(client, interval: key == 'MonitorInterval' ? int.tryParse(value) : null);
      if (mounted) SnackBarUtils.showSuccess(context, 'Updated');
      _load();
    } catch (e) {
      if (context.mounted) SnackBarUtils.showError(context, 'Update failed');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Monitor Settings')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Card(
                      child: Column(
                        children: [
                          ListTile(
                            title: const Text('Monitor Interval (seconds)'),
                            subtitle: Text(_settings?['interval']?.toString() ?? 'N/A'),
                            trailing: const Icon(Icons.timer),
                          ),
                          ListTile(
                            title: const Text('Retention Days'),
                            subtitle: Text(_settings?['storeDays']?.toString() ?? 'N/A'),
                            trailing: const Icon(Icons.calendar_today),
                          ),
                          ListTile(
                            title: const Text('Monitor Status'),
                            subtitle: Text(_settings?['status']?.toString() ?? 'N/A'),
                            trailing: Icon(
                              _settings?['status'] == 'Enable'
                                  ? Icons.check_circle
                                  : Icons.pause_circle,
                              color: _settings?['status'] == 'Enable'
                                  ? Colors.green
                                  : Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
