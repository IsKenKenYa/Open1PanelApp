import 'package:flutter/material.dart';
import 'package:onepanel_client/core/utils/snackbar_utils.dart';
import 'package:onepanel_client/data/repositories/website_config_repository.dart';

/// Website log viewer page integrated into the logs module.
/// Mirrors frontend's log/website page.
class WebsiteLogTabWidget extends StatefulWidget {
  const WebsiteLogTabWidget({super.key, required this.websiteId});

  final int websiteId;

  @override
  State<WebsiteLogTabWidget> createState() => _WebsiteLogTabWidgetState();
}

class _WebsiteLogTabWidgetState extends State<WebsiteLogTabWidget> {
  final WebsiteConfigRepository _repo = WebsiteConfigRepository();
  List<Map<String, dynamic>> _logs = [];
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
      final result = await _repo.searchWebsiteLogs({
        'websiteId': widget.websiteId,
        'page': 1,
        'pageSize': 50,
      });
      if (mounted) setState(() { _logs = result; _isLoading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: _load, child: const Text('Retry')),
          ],
        ),
      );
    }
    if (_logs.isEmpty) return const Center(child: Text('No logs'));
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        itemCount: _logs.length,
        itemBuilder: (context, index) {
          final log = _logs[index];
          return ListTile(
            title: Text(log['message']?.toString() ?? ''),
            subtitle: Text(log['time']?.toString() ?? ''),
            dense: true,
          );
        },
      ),
    );
  }
}
