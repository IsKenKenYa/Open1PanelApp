import 'package:flutter/material.dart';
import 'package:onepanel_client/core/utils/snackbar_utils.dart';
import 'package:onepanel_client/data/models/ai/agent_account_models.dart';
import 'package:onepanel_client/features/ai/ai_repository.dart';

/// AI model accounts management page.
/// Mirrors frontend's ai/model page: list/create/update/delete AI accounts
/// and their model pools.
class AiAccountsPage extends StatefulWidget {
  const AiAccountsPage({super.key});

  @override
  State<AiAccountsPage> createState() => _AiAccountsPageState();
}

class _AiAccountsPageState extends State<AiAccountsPage> {
  final AIRepository _repo = AIRepository();
  List<Map<String, dynamic>> _accounts = [];
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
      final api = await _repo.getApi();
      final response = await api.pageAgentAccounts(const AgentAccountSearch());
      final data = response.data;
      if (mounted) {
        setState(() {
          _accounts = (data?.items ?? const []).whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _isLoading = false; });
    }
  }

  Future<void> _deleteAccount(int id) async {
    try {
      final api = await _repo.getApi();
      await api.deleteAgentAccount(AgentAccountDeleteReq(id: id));
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
        title: const Text('AI Accounts'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _load),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_error!),
                      const SizedBox(height: 16),
                      ElevatedButton(onPressed: _load, child: const Text('Retry')),
                    ],
                  ),
                )
              : _accounts.isEmpty
                  ? const Center(child: Text('No accounts'))
                  : ListView.builder(
                      itemCount: _accounts.length,
                      itemBuilder: (context, index) {
                        final account = _accounts[index];
                        return Card(
                          child: ListTile(
                            title: Text(account['name']?.toString() ?? ''),
                            subtitle: Text(
                              'Type: ${account['type'] ?? 'N/A'} | '
                              'Models: ${account['modelCount'] ?? 0}',
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () =>
                                  _deleteAccount(account['id'] as int),
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
