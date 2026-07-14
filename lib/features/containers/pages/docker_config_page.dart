import 'package:flutter/material.dart';
import 'package:onepanel_client/core/utils/snackbar_utils.dart';
import 'package:onepanel_client/core/network/api_client_manager.dart';
import 'package:onepanel_client/api/v2/container_v2.dart';
import 'package:onepanel_client/data/models/container_models.dart';

/// Docker daemon configuration page.
/// Mirrors frontend's container/setting page: view/edit daemon.json.
class DockerConfigPage extends StatefulWidget {
  const DockerConfigPage({super.key});

  @override
  State<DockerConfigPage> createState() => _DockerConfigPageState();
}

class _DockerConfigPageState extends State<DockerConfigPage> {
  String _configContent = '';
  bool _isLoading = true;
  bool _isSaving = false;
  String? _error;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final api = ContainerV2Api(await ApiClientManager.instance.getCurrentClient());
      final response = await api.getDaemonJsonFile();
      final content = response.data ?? '';
      _controller.text = content;
      if (mounted) {
        setState(() {
          _configContent = content;
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
      final api = ContainerV2Api(await ApiClientManager.instance.getCurrentClient());
      await api.updateDaemonJsonByFile(DaemonJsonUpdateByFile(file: _controller.text));
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
        title: const Text('Docker Configuration'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isSaving ? null : _save,
            tooltip: 'Save',
          ),
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
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _controller,
                    maxLines: null,
                    expands: true,
                    decoration: const InputDecoration(
                      labelText: 'daemon.json',
                      border: OutlineInputBorder(),
                      hintText: '{\n  "registry-mirrors": []\n}',
                    ),
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 14),
                  ),
                ),
    );
  }
}
