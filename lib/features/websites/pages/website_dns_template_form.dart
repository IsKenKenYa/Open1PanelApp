import 'package:flutter/material.dart';

/// Field descriptor for a DNS provider's credential form.
///
/// Extracted from `website_ssl_accounts_actions_part.dart` as an import-based
/// seam so the DNS template table and its dynamic form widget are testable
/// independently of the SSL accounts page. Mirrors the import + class pattern
/// used by `website_routing_rules_*_actions.dart`.
class DnsTemplateField {
  const DnsTemplateField(
    this.key,
    this.label, {
    this.sensitive = false,
  });

  final String key;
  final String label;
  final bool sensitive;
}

/// Preset credential layout for a DNS provider type (e.g. cloudflare, aliyun).
class DnsProviderTemplate {
  const DnsProviderTemplate(this.type, this.fields);

  final String type;
  final List<DnsTemplateField> fields;
}

/// Preset credential templates for all supported DNS providers.
///
/// Keep this list aligned with the provider types accepted by the
/// `createDnsAccount` / `updateDnsAccount` V2 endpoints.
const List<DnsProviderTemplate> kDnsProviderTemplates = [
  DnsProviderTemplate('cloudflare', [
    DnsTemplateField('dnsApiToken', 'API Token', sensitive: true),
  ]),
  DnsProviderTemplate('aliyun', [
    DnsTemplateField('accessKey', 'Access Key ID'),
    DnsTemplateField('secretKey', 'Access Key Secret', sensitive: true),
  ]),
  DnsProviderTemplate('dnspod', [
    DnsTemplateField('id', 'Secret ID'),
    DnsTemplateField('token', 'Secret Token', sensitive: true),
  ]),
  DnsProviderTemplate('huaweiCloud', [
    DnsTemplateField('accessKey', 'Access Key ID'),
    DnsTemplateField('secretKey', 'Secret Access Key', sensitive: true),
  ]),
  DnsProviderTemplate('tencentCloud', [
    DnsTemplateField('secretId', 'Secret ID'),
    DnsTemplateField('secretKey', 'Secret Key', sensitive: true),
  ]),
  DnsProviderTemplate('godaddy', [
    DnsTemplateField('apiKey', 'API Key'),
    DnsTemplateField('apiSecret', 'API Secret', sensitive: true),
  ]),
  DnsProviderTemplate('route53', [
    DnsTemplateField('accessKey', 'Access Key ID'),
    DnsTemplateField('secretKey', 'Secret Access Key', sensitive: true),
    DnsTemplateField('region', 'Region'),
  ]),
  DnsProviderTemplate('digitalocean', [
    DnsTemplateField('authToken', 'Auth Token', sensitive: true),
  ]),
  DnsProviderTemplate('vultr', [
    DnsTemplateField('apiKey', 'API Key', sensitive: true),
  ]),
  DnsProviderTemplate('namecheap', [
    DnsTemplateField('apiUser', 'API User'),
    DnsTemplateField('apiKey', 'API Key', sensitive: true),
  ]),
];

/// Looks up the credential template for [type], falling back to `null` when
/// the type is not in [kDnsProviderTemplates].
DnsProviderTemplate? findDnsTemplate(String type) {
  for (final t in kDnsProviderTemplates) {
    if (t.type == type) {
      return t;
    }
  }
  return null;
}

/// Renders the dynamic credential fields for a [DnsProviderTemplate], masking
/// sensitive fields behind a visibility toggle.
class DnsDynamicAuthFields extends StatefulWidget {
  const DnsDynamicAuthFields({
    super.key,
    required this.template,
    required this.controllers,
  });

  final DnsProviderTemplate template;
  final Map<String, TextEditingController> controllers;

  @override
  State<DnsDynamicAuthFields> createState() => _DnsDynamicAuthFieldsState();
}

class _DnsDynamicAuthFieldsState extends State<DnsDynamicAuthFields> {
  final Set<String> _visibleFields = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final field in widget.template.fields) ...[
          TextField(
            controller: widget.controllers[field.key],
            obscureText: field.sensitive && !_visibleFields.contains(field.key),
            decoration: InputDecoration(
              labelText: field.label,
              suffixIcon: field.sensitive
                  ? IconButton(
                      icon: Icon(
                        _visibleFields.contains(field.key)
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      tooltip: _visibleFields.contains(field.key)
                          ? 'Hide'
                          : 'Show',
                      onPressed: () => setState(() {
                        if (_visibleFields.contains(field.key)) {
                          _visibleFields.remove(field.key);
                        } else {
                          _visibleFields.add(field.key);
                        }
                      }),
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}
