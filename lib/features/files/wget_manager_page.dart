import 'package:flutter/material.dart';
import 'package:onepanel_client/core/utils/snackbar_utils.dart';
import 'package:onepanel_client/features/files/services/file_transfer_service.dart';

/// WGET download manager page.
/// Mirrors frontend's wget process list: shows active/completed downloads.
class WgetManagerPage extends StatefulWidget {
  const WgetManagerPage({super.key});

  @override
  State<WgetManagerPage> createState() => _WgetManagerPageState();
}

class _WgetManagerPageState extends State<WgetManagerPage> {
  final FileTransferService _service = FileTransferService();
  Map<String, dynamic>? _processData;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProcess();
  }

  Future<void> _loadProcess() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final result = await _service.getWgetProcess();
      if (mounted) setState(() { _processData = result; _isLoading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _isLoading = false; });
    }
  }

  Future<void> _stopWget(String key) async {
    try {
      await _service.stopWget(key);
      if (mounted) SnackBarUtils.showSuccess(context, 'Stopped');
      _loadProcess();
    } catch (e) {
      if (context.mounted) SnackBarUtils.showError(context, 'Stop failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WGET Downloads'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadProcess),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : _processData == null || _processData!.isEmpty
                  ? const Center(child: Text('No active downloads'))
                  : ListView.builder(
                      itemCount: (_processData!['data'] as List?)?.length ?? 0,
                      itemBuilder: (context, index) {
                        final item = (_processData!['data'] as List)[index]
                            as Map<String, dynamic>;
                        return Card(
                          child: ListTile(
                            title: Text(item['name']?.toString() ?? ''),
                            subtitle: Text(item['url']?.toString() ?? ''),
                            trailing: item['status'] == 'running'
                                ? IconButton(
                                    icon: const Icon(Icons.stop),
                                    onPressed: () => _stopWget(
                                        item['key']?.toString() ?? ''),
                                  )
                                : const Icon(Icons.check_circle,
                                    color: Colors.green),
                          ),
                        );
                      },
                    ),
    );
  }
}
