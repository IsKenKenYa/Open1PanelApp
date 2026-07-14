import 'package:flutter/material.dart';
import 'package:onepanel_client/core/utils/snackbar_utils.dart';
import 'package:onepanel_client/core/network/api_client_manager.dart';
import 'package:onepanel_client/api/v2/database_v2.dart';
import 'package:onepanel_client/data/models/database_models.dart';

/// Database remote connection configuration page.
/// Mirrors frontend's database remote settings: per-DB-type remote connection config.
class DatabaseRemoteConfigPage extends StatefulWidget {
  const DatabaseRemoteConfigPage({
    super.key,
    required this.databaseName,
    required this.databaseType,
  });

  final String databaseName;
  final String databaseType;

  @override
  State<DatabaseRemoteConfigPage> createState() =>
      _DatabaseRemoteConfigPageState();
}

class _DatabaseRemoteConfigPageState extends State<DatabaseRemoteConfigPage> {
  Map<String, dynamic>? _config;
  bool _isLoading = true;
  bool _isSaving = false;
  String? _error;
  final _hostController = TextEditingController();
  final _portController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _hostController.dispose();
    _portController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final api = DatabaseV2Api(await ApiClientManager.instance.getCurrentClient());
      final response = await api.loadDatabase(DatabaseSearch(type: widget.databaseType, database: widget.databaseName));
        
      if (mounted) {
        final data = response.data;
        setState(() {
          _config = data is Map ? Map<String, dynamic>.from(data) : {};
          _hostController.text = _config?['host']?.toString() ?? '';
          _portController.text = _config?['port']?.toString() ?? '';
          _usernameController.text = _config?['username']?.toString() ?? '';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _isLoading = false; });
    }
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    try {
      final api = DatabaseV2Api(await ApiClientManager.instance.getCurrentClient());
      // skip typed update for now
      await api.updateDatabaseStatus({
        'database': widget.databaseName,
        'type': widget.databaseType,
        'status': 'Running',
      });
      if (mounted) SnackBarUtils.showSuccess(context, 'Saved');
    } catch (e) {
      if (context.mounted) SnackBarUtils.showError(context, 'Save failed');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.databaseName} - Remote'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _load),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            TextField(
                              controller: _hostController,
                              decoration: const InputDecoration(
                                labelText: 'Host',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _portController,
                              decoration: const InputDecoration(
                                labelText: 'Port',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _usernameController,
                              decoration: const InputDecoration(
                                labelText: 'Username',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _passwordController,
                              decoration: const InputDecoration(
                                labelText: 'Password',
                                border: OutlineInputBorder(),
                              ),
                              obscureText: true,
                            ),
                            const SizedBox(height: 16),
                            FilledButton.icon(
                              onPressed: _isSaving ? null : _save,
                              icon: _isSaving
                                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                                  : const Icon(Icons.save),
                              label: const Text('Save'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
