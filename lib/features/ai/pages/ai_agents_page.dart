import 'package:flutter/material.dart';
import 'package:onepanel_client/core/utils/snackbar_utils.dart';
import 'package:onepanel_client/features/ai/agents/agents_repository.dart';
import 'package:onepanel_client/features/ai/agents/agents_provider.dart';
import 'package:onepanel_client/data/models/ai/agent_core_models.dart';
import 'package:provider/provider.dart';

/// AI Agent management page.
/// Mirrors frontend's ai/agents/agent page: list/create/delete agents.
class AiAgentsPage extends StatefulWidget {
  const AiAgentsPage({super.key});

  @override
  State<AiAgentsPage> createState() => _AiAgentsPageState();
}

class _AiAgentsPageState extends State<AiAgentsPage> {
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
      final provider = context.read<AgentsProvider>();
      await provider.loadInitial();
      if (mounted) setState(() => _isLoading = false);
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _isLoading = false; });
    }
  }

  Future<void> _deleteAgent(int agentId) async {
    try {
      final repo = AgentsRepository();
      await repo.deleteAgent(AgentDeleteReq(id: agentId));
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
        title: const Text('AI Agents'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _load),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : Consumer<AgentsProvider>(
                  builder: (context, provider, _) {
                    final agents = provider.agents;
                    if (agents.isEmpty) {
                      return const Center(child: Text('No agents'));
                    }
                    return ListView.builder(
                      itemCount: agents.length,
                      itemBuilder: (context, index) {
                        final agent = agents[index];
                        return Card(
                          child: ListTile(
                            title: Text(agent.name ?? 'Unnamed'),
                            subtitle: Text('Type: ${agent.agentType ?? 'N/A'} | Status: ${agent.status ?? 'N/A'}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => _deleteAgent(agent.id ?? 0),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
