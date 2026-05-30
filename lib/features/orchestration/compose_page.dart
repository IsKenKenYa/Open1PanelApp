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
  bool _requestedInitialLoad = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_requestedInitialLoad) {
      return;
    }
    _requestedInitialLoad = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      final provider = context.read<ComposeProvider>();
      if (!provider.isLoading && provider.composes.isEmpty) {
        provider.loadComposes();
      }
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
          itemKey: (compose) => orchestrationListItemKey(compose),
          itemBuilder: (compose) => ComposeCard(compose: compose),
        );
      },
    );
  }
}
