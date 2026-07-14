import 'package:flutter/material.dart';
import 'package:onepanel_client/core/utils/snackbar_utils.dart';
import 'package:onepanel_client/core/network/api_client_manager.dart';
import 'package:onepanel_client/api/v2/file_v2.dart';

/// File history & version restore page.
/// Mirrors frontend's file history tab: view/restore/delete file versions.
class FileHistoryPage extends StatefulWidget {
  const FileHistoryPage({
    super.key,
    required this.path,
  });

  final String path;

  @override
  State<FileHistoryPage> createState() => _FileHistoryPageState();
}

class _FileHistoryPageState extends State<FileHistoryPage> {
  List<Map<String, dynamic>> _history = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final api = FileV2Api(await ApiClientManager.instance.getCurrentClient());
      final response = await api.searchHistory({'path': widget.path});
      if (mounted) {
        setState(() {
          _history = (response.data ?? const <dynamic>[])
              .whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _isLoading = false; });
    }
  }

  Future<void> _restore(Map<String, dynamic> entry) async {
    try {
      final api = FileV2Api(await ApiClientManager.instance.getCurrentClient());
      await api.restoreHistory(entry);
      if (mounted) SnackBarUtils.showSuccess(context, 'Restored');
    } catch (e) {
      if (context.mounted) SnackBarUtils.showError(context, 'Restore failed');
    }
  }

  Future<void> _delete(Map<String, dynamic> entry) async {
    try {
      final api = FileV2Api(await ApiClientManager.instance.getCurrentClient());
      await api.deleteHistory(entry);
      if (mounted) SnackBarUtils.showSuccess(context, 'Deleted');
      _load();
    } catch (e) {
      if (context.mounted) SnackBarUtils.showError(context, 'Delete failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History: ${widget.path}'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _load),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : _history.isEmpty
                  ? const Center(child: Text('No history'))
                  : ListView.builder(
                      itemCount: _history.length,
                      itemBuilder: (context, index) {
                        final entry = _history[index];
                        return Card(
                          child: ListTile(
                            title: Text(entry['time']?.toString() ?? ''),
                            subtitle: Text(entry['size']?.toString() ?? ''),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.restore),
                                  tooltip: 'Restore',
                                  onPressed: () => _restore(entry),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  tooltip: 'Delete',
                                  onPressed: () => _delete(entry),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
