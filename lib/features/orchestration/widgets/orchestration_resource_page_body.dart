import 'package:flutter/material.dart';
import 'package:onepanel_client/core/i18n/l10n_x.dart';
import 'package:onepanel_client/shared/widgets/operations/module_error_state_widget.dart';
import 'package:onepanel_client/shared/widgets/operations/partial_error_toast_listener.dart';

typedef OrchestrationResourceLoader = Future<void> Function();

class OrchestrationResourcePageBody<T> extends StatelessWidget {
  const OrchestrationResourcePageBody({
    super.key,
    required this.items,
    required this.error,
    required this.isLoading,
    required this.onRefresh,
    required this.itemBuilder,
    this.emptyMessage,
  });

  final List<T> items;
  final String? error;
  final bool isLoading;
  final OrchestrationResourceLoader onRefresh;
  final Widget Function(T item) itemBuilder;
  final String? emptyMessage;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    if (isLoading && items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null && items.isEmpty) {
      return ModuleErrorStateWidget(
        message: error,
        onRetry: () => onRefresh(),
      );
    }

    if (items.isEmpty) {
      return Center(child: Text(emptyMessage ?? l10n.commonEmpty));
    }

    return PartialErrorToastListener(
      errorMessage: error,
      hasCachedData: items.isNotEmpty,
      onRetry: () => onRefresh(),
      child: RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (isLoading)
              const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: LinearProgressIndicator(minHeight: 2),
              ),
            ...items.map(itemBuilder),
          ],
        ),
      ),
    );
  }
}
