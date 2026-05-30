import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:onepanel_client/features/orchestration/providers/compose_provider.dart';
import 'package:onepanel_client/features/orchestration/widgets/compose_card.dart';
import 'package:onepanel_client/features/orchestration/widgets/orchestration_resource_page_body.dart';

class ComposePage extends StatefulWidget {
  const ComposePage({super.key});

  @override
  State<ComposePage> createState() => _ComposePageState();
}

class _ComposePageState extends State<ComposePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ComposeProvider>().loadComposes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ComposeProvider>(
      builder: (context, provider, child) {
        return OrchestrationResourcePageBody(
          items: provider.composes,
          error: provider.error,
          isLoading: provider.isLoading,
          onRefresh: provider.loadComposes,
          itemBuilder: (compose) => ComposeCard(compose: compose),
        );
      },
    );
  }
}
