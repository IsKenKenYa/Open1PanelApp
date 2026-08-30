import 'package:flutter/material.dart';
import 'package:onepanel_client/core/i18n/l10n_x.dart';
import 'package:onepanel_client/core/network/api_client_manager.dart';
import 'package:onepanel_client/api/v2/database_v2.dart';
import 'package:onepanel_client/data/models/database_models.dart';

/// MongoDB management page.
/// Mirrors frontend's database/mongodb page.
class DatabaseMongodbPage extends StatefulWidget {
  const DatabaseMongodbPage({super.key, required this.databaseName});

  final String databaseName;

  @override
  State<DatabaseMongodbPage> createState() => _DatabaseMongodbPageState();
}

class _DatabaseMongodbPageState extends State<DatabaseMongodbPage> {
  List<dynamic> _databases = [];
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
      final api = DatabaseV2Api(await ApiClientManager.instance.getCurrentClient());
      final response = await api.searchMongodbDatabases(
        DatabaseSearch(database: widget.databaseName),
      );
      if (mounted) {
        final data = response.data;
        setState(() {
          _databases = data?.items ?? [];
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
      appBar: AppBar(title: Text('${widget.databaseName} - MongoDB')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : _databases.isEmpty
                  ?  Center(child: Text(context.l10n.databaseMongodbEmpty))
                  : ListView.builder(
                      itemCount: _databases.length,
                      itemBuilder: (context, index) {
                        final db = _databases[index] as Map? ?? {};
                        return Card(
                          child: ListTile(
                            title: Text(db['name']?.toString() ?? ''),
                            subtitle: Text(context.l10n.databaseMongodbSizeWith(db['size'] ?? 'N/A')),
                          ),
                        );
                      },
                    ),
    );
  }
}
