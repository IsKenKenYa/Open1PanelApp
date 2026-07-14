import 'package:flutter/material.dart';
import 'package:onepanel_client/core/utils/snackbar_utils.dart';
import 'package:onepanel_client/features/ai/mcp_server_service.dart';

/// MCP Server detail page.
/// Mirrors frontend's mcp/server/config page: shows server config, connection test, status sync.
class McpServerDetailPage extends StatefulWidget {
  const McpServerDetailPage({
    super.key,
    required this.serverId,
    required this.serverName,
  });

  final int serverId;
  final String serverName;

  @override
  State<McpServerDetailPage> createState() => _McpServerDetailPageState();
}

class _McpServerDetailPageState extends State<McpServerDetailPage> {
  final McpServerService _service = McpServerService();
  Map<String, dynamic>? _detail;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final result = await _service.getServerDetail(widget.serverId);
      if (mounted) setState(() { _detail = result; _isLoading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _isLoading = false; });
    }
  }

  Future<void> _testConnection() async {
    try {
      final result = await _service.testConnection(widget.serverId);
      final success = result['success'] == true;
      if (mounted) {
        SnackBarUtils.showSuccess(
          context,
          success ? 'Connection OK' : 'Connection failed',
        );
      }
    } catch (e) {
      if (context.mounted) SnackBarUtils.showError(context, 'Test failed');
    }
  }

  Future<void> _syncStatus() async {
    try {
      await _service.syncStatus(widget.serverId);
      if (mounted) SnackBarUtils.showSuccess(context, 'Status synced');
      _loadDetail();
    } catch (e) {
      if (context.mounted) SnackBarUtils.showError(context, 'Sync failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.serverName),
        actions: [
          IconButton(
            icon: const Icon(Icons.wifi_protected_setup),
            tooltip: 'Sync status',
            onPressed: _syncStatus,
          ),
          IconButton(
            icon: const Icon(Icons.plagiarism_outlined),
            tooltip: 'Test connection',
            onPressed: _testConnection,
          ),
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadDetail),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : _detail == null
                  ? const Center(child: Text('No data'))
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        Card(
                          child: Column(
                            children: [
                              ListTile(
                                title: const Text('Server Name'),
                                subtitle: Text(_detail?['name']?.toString() ?? ''),
                              ),
                              ListTile(
                                title: const Text('Status'),
                                subtitle: Text(_detail?['status']?.toString() ?? 'unknown'),
                                trailing: Icon(
                                  _detail?['status'] == 'running'
                                      ? Icons.check_circle
                                      : Icons.error_outline,
                                  color: _detail?['status'] == 'running'
                                      ? Colors.green
                                      : Colors.orange,
                                ),
                              ),
                              ListTile(
                                title: const Text('URL'),
                                subtitle: Text(_detail?['url']?.toString() ?? ''),
                              ),
                              ListTile(
                                title: const Text('Transport'),
                                subtitle: Text(_detail?['transport']?.toString() ?? ''),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
    );
  }
}
