import 'package:flutter/material.dart';
import 'package:onepanel_client/core/network/api_client_manager.dart';
import 'package:onepanel_client/api/v2/container_v2.dart';
import 'package:onepanel_client/data/models/container_models.dart';

/// Container inspect detail page.
/// Mirrors frontend's container inspect view: shows raw JSON config.
class ContainerInspectPage extends StatefulWidget {
  const ContainerInspectPage({
    super.key,
    required this.containerId,
    required this.containerName,
  });

  final String containerId;
  final String containerName;

  @override
  State<ContainerInspectPage> createState() => _ContainerInspectPageState();
}

class _ContainerInspectPageState extends State<ContainerInspectPage> {
  Map<String, dynamic>? _inspectData;
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
      final api = ContainerV2Api(await ApiClientManager.instance.getCurrentClient());
      final response = await api.inspectContainer(InspectReq(id: widget.containerId, type: 'container'));
      if (mounted) {
        setState(() {
          _inspectData = response.data is Map ? Map<String, dynamic>.from(response.data as Map) : null;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.containerName} - Inspect'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _load),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : _inspectData == null
                  ? const Center(child: Text('No data'))
                  : DefaultTabController(
                      length: 3,
                      child: Column(
                        children: [
                          const TabBar(
                            tabs: [
                              Tab(text: 'Config'),
                              Tab(text: 'Network'),
                              Tab(text: 'Raw'),
                            ],
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                _buildConfigTab(),
                                _buildNetworkTab(),
                                _buildRawTab(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }

  Widget _buildConfigTab() {
    final config = _inspectData?['Config'] as Map? ?? {};
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(child: ListTile(title: const Text('Image'), subtitle: Text(config['Image']?.toString() ?? ''))),
        Card(child: ListTile(title: const Text('Command'), subtitle: Text(config['Cmd']?.toString() ?? ''))),
        Card(child: ListTile(title: const Text('Working Dir'), subtitle: Text(config['WorkingDir']?.toString() ?? ''))),
        Card(child: ListTile(title: const Text('Entrypoint'), subtitle: Text(config['Entrypoint']?.toString() ?? ''))),
      ],
    );
  }

  Widget _buildNetworkTab() {
    final networkSettings = _inspectData?['NetworkSettings'] as Map? ?? {};
    final networks = networkSettings['Networks'] as Map? ?? {};
    return ListView(
      padding: const EdgeInsets.all(16),
      children: networks.keys.map((name) {
        final net = networks[name] as Map? ?? {};
        return Card(
          child: ListTile(
            title: Text(name.toString()),
            subtitle: Text('IP: ${net['IPAddress'] ?? 'N/A'} | Gateway: ${net['Gateway'] ?? 'N/A'}'),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRawTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: SelectableText(
        _inspectData.toString(),
        style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
      ),
    );
  }
}
