import 'package:flutter/material.dart';
import 'package:onepanel_client/features/server/server_form_page.dart';

// Thin wrapper kept for backward-compatible route references; delegates to the
// feature-level ServerFormPage which holds the actual implementation.
class ServerConfigPage extends StatelessWidget {
  const ServerConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ServerFormPage();
  }
}
