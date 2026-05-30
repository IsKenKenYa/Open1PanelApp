import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:onepanel_client/features/orchestration/providers/network_provider.dart';
import 'package:onepanel_client/features/orchestration/widgets/network_card.dart';
import 'package:onepanel_client/features/orchestration/widgets/orchestration_resource_page_body.dart';

class NetworkPage extends StatefulWidget {
  const NetworkPage({super.key});

  @override
  State<NetworkPage> createState() => _NetworkPageState();
}

class _NetworkPageState extends State<NetworkPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NetworkProvider>().loadNetworks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NetworkProvider>(
      builder: (context, provider, child) {
        return OrchestrationResourcePageBody(
          items: provider.networks,
          error: provider.error,
          isLoading: provider.isLoading,
          onRefresh: provider.loadNetworks,
          itemBuilder: (network) => NetworkCard(network: network),
        );
      },
    );
  }
}
