import 'package:flutter/material.dart';
import 'package:onepanel_client/features/server/server_list_page.dart';

// Thin wrapper; coach marks are disabled because this page is for explicit
// server selection, not the primary dashboard entry point.
class ServerSelectionPage extends StatelessWidget {
  const ServerSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ServerListPage(enableCoach: false);
  }
}
