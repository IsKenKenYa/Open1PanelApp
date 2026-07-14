import 'package:flutter/material.dart';
import 'package:onepanel_client/core/utils/snackbar_utils.dart';
import 'package:onepanel_client/features/ai/ai_repository.dart';
import 'package:onepanel_client/data/models/ai_models.dart';

/// Ollama model management page (deep).
/// Mirrors frontend's ai/model/ollama page: list/load/delete/sync models.
class AiOllamaModelsPage extends StatefulWidget {
  const AiOllamaModelsPage({super.key});

  @override
  State<AiOllamaModelsPage> createState() => _AiOllamaModelsPageState();
}

class _AiOllamaModelsPageState extends State<AiOllamaModelsPage> {
  final AIRepository _repo = AIRepository();
  List<OllamaModel> _models = [];
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
      final result = await _repo.searchOllamaModels(page: 1, pageSize: 100);
      if (mounted) setState(() { _models = result.items; _isLoading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _isLoading = false; });
    }
  }

  Future<void> _deleteModel(int id) async {
    try {
      await _repo.deleteOllamaModel(ids: [id]);
      if (mounted) SnackBarUtils.showSuccess(context, 'Deleted');
      _load();
    } catch (e) {
      if (context.mounted) SnackBarUtils.showError(context, 'Delete failed');
    }
  }

  Future<void> _loadModel(String name) async {
    try {
      await _repo.loadOllamaModel(name: name, taskID: '');
      if (mounted) SnackBarUtils.showSuccess(context, 'Loading');
    } catch (e) {
      if (context.mounted) SnackBarUtils.showError(context, 'Load failed');
    }
  }

  Future<void> _syncModels() async {
    try {
      await _repo.syncOllamaModels();
      if (mounted) SnackBarUtils.showSuccess(context, 'Synced');
      _load();
    } catch (e) {
      if (context.mounted) SnackBarUtils.showError(context, 'Sync failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ollama Models'),
        actions: [
          IconButton(icon: const Icon(Icons.sync), onPressed: _syncModels, tooltip: 'Sync'),
          IconButton(icon: const Icon(Icons.refresh), onPressed: _load),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : _models.isEmpty
                  ? const Center(child: Text('No models'))
                  : ListView.builder(
                      itemCount: _models.length,
                      itemBuilder: (context, index) {
                        final m = _models[index];
                        return Card(
                          child: ListTile(
                            title: Text(m.name ?? 'Unknown'),
                            subtitle: Text('Size: ${m.size ?? 'N/A'} | Modified: ${m.modified ?? 'N/A'}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.download_for_offline),
                                  tooltip: 'Load',
                                  onPressed: () => _loadModel(m.name ?? ''),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  tooltip: 'Delete',
                                  onPressed: () => _deleteModel(m.id ?? 0),
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
