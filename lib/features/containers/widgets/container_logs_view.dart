import 'package:flutter/material.dart';
import 'package:onepanel_client/core/i18n/l10n_x.dart';
import 'package:onepanel_client/shared/widgets/operations/module_error_state_widget.dart';
import 'package:onepanel_client/shared/widgets/operations/partial_error_toast_listener.dart';
import 'package:onepanel_client/features/containers/providers/container_detail_provider.dart';
import 'package:provider/provider.dart';
import 'package:onepanel_client/shared/widgets/log_viewer/log_viewer.dart';

class ContainerLogsView extends StatefulWidget {
  const ContainerLogsView({super.key});

  @override
  State<ContainerLogsView> createState() => _ContainerLogsViewState();
}

class _ContainerLogsViewState extends State<ContainerLogsView> {
  final _controller = LogViewerController();
  String _lastLogs = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final provider = context.watch<ContainerDetailProvider>();

    if (provider.logs != _lastLogs) {
      _lastLogs = provider.logs;
      _controller.setLogs(provider.logs);
    }

    if (provider.logsLoading && _controller.logs.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.logsError != null && _controller.logs.isEmpty) {
      return ModuleErrorStateWidget(
        message: l10n.containerOperateFailed(provider.logsError!),
        onRetry: provider.loadLogs,
      );
    }

    return PartialErrorToastListener(
      errorMessage: provider.logsError != null
          ? l10n.containerOperateFailed(provider.logsError!)
          : null,
      hasCachedData: _controller.logs.isNotEmpty,
      onRetry: provider.loadLogs,
      child: LogViewer(
        controller: _controller,
        onRefresh: provider.loadLogs,
        emptyMessage: l10n.containerNoLogs,
      ),
    );
  }
}
