import 'package:flutter/material.dart';
import 'package:onepanel_client/core/i18n/l10n_x.dart';
import 'package:onepanel_client/core/utils/snackbar_utils.dart';
import 'package:onepanel_client/data/models/website_ssl_crud_models.dart';
import 'package:onepanel_client/data/repositories/website_config_repository.dart';
import 'package:onepanel_client/features/websites/widgets/website_async_state_view.dart';

/// Website HTTPS configuration page.
///
/// Mirrors the frontend's website HTTPS tab: view/update HTTPS settings
/// including certificate selection, HSTS, and HTTP-to-HTTPS redirect.
class WebsiteHttpsPage extends StatefulWidget {
  const WebsiteHttpsPage({
    super.key,
    required this.websiteId,
    required this.displayName,
  });

  final int websiteId;
  final String displayName;

  @override
  State<WebsiteHttpsPage> createState() => _WebsiteHttpsPageState();
}

class _WebsiteHttpsPageState extends State<WebsiteHttpsPage> {
  final WebsiteConfigRepository _repo = WebsiteConfigRepository();
  WebsiteHttpsConfig? _config;
  bool _isLoading = true;
  bool _isSaving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final result = await _repo.getHttpsConfig(widget.websiteId);
      if (mounted) {
        setState(() {
          _config = result;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _updateConfig({
    bool? enable,
    bool? hsts,
    String? httpConfig,
  }) async {
    setState(() => _isSaving = true);
    try {
      final request = WebsiteHttpsUpdateRequest(
        websiteId: widget.websiteId,
        enable: enable ?? _config?.enable ?? false,
        hsts: hsts ?? _config?.hsts ?? false,
        httpConfig: httpConfig ?? _config?.httpConfig ?? '',
      );
      final result = await _repo.updateHttpsConfig(
        websiteId: widget.websiteId,
        request: request,
      );
      if (mounted) {
        setState(() => _config = result);
        SnackBarUtils.showSuccess(context, 'Updated');
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showError(context, 'Failed to update HTTPS config');
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text('${widget.displayName} - HTTPS')),
      body: WebsiteAsyncStateView(
        isLoading: _isLoading,
        error: _error,
        onRetry: _loadConfig,
        child: _config == null
            ? const Center(child: Text('No data'))
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    child: Column(
                      children: [
                        SwitchListTile(
                          title: const Text('HTTPS'),
                          subtitle: Text(
                            _config?.enable == true
                                ? 'Enabled'
                                : 'Disabled',
                          ),
                          value: _config?.enable ?? false,
                          onChanged: _isSaving
                              ? null
                              : (v) => _updateConfig(enable: v),
                        ),
                        if (_config?.enable == true) ...[
                          SwitchListTile(
                            title: const Text('HSTS'),
                            subtitle: const Text(
                                'HTTP Strict Transport Security'),
                            value: _config?.hsts ?? false,
                            onChanged: _isSaving
                                ? null
                                : (v) => _updateConfig(hsts: v),
                          ),
                          if (_config?.ssl != null)
                            ListTile(
                              title: const Text('SSL Certificate'),
                              subtitle: Text(
                                _config?.ssl?.primaryDomain ?? 'N/A',
                              ),
                              trailing: const Icon(Icons.verified_user),
                            ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
