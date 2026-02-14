import 'package:flutter/material.dart';
import 'package:onepanelapp_app/core/i18n/l10n_x.dart';
import 'package:onepanelapp_app/core/theme/app_design_tokens.dart';
import 'package:onepanelapp_app/data/models/monitoring_models.dart';
import 'package:onepanelapp_app/shared/widgets/app_card.dart';
import 'package:onepanelapp_app/shared/widgets/metric_card.dart';
import 'package:provider/provider.dart';
import 'monitoring_provider.dart';

class MonitoringPage extends StatefulWidget {
  const MonitoringPage({super.key});

  @override
  State<MonitoringPage> createState() => _MonitoringPageState();
}

class _MonitoringPageState extends State<MonitoringPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<MonitoringProvider>().load());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.serverModuleMonitoring),
        actions: [
          Consumer<MonitoringProvider>(
            builder: (context, provider, _) => IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: provider.data.isLoading ? null : provider.refresh,
              tooltip: l10n.commonRefresh,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: AppDesignTokens.pagePadding,
        child: Consumer<MonitoringProvider>(
          builder: (context, provider, _) {
            return _buildBody(context, provider.data, provider.refresh);
          },
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    MonitoringData data,
    Future<void> Function() onRefresh,
  ) {
    final l10n = context.l10n;

    if (data.error != null &&
        data.cpuMetrics == null &&
        data.memoryMetrics == null &&
        data.diskMetrics == null &&
        data.networkMetrics.isEmpty) {
      return _ErrorView(
        title: l10n.commonLoadFailedTitle,
        error: data.error!,
        onRetry: onRefresh,
      );
    }

    if (data.isLoading &&
        data.cpuMetrics == null &&
        data.memoryMetrics == null &&
        data.diskMetrics == null &&
        data.networkMetrics.isEmpty) {
      return const _LoadingView();
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        children: [
          MetricCard(
            title: l10n.serverCpuLabel,
            metrics: data.cpuMetrics,
            currentLabel: l10n.monitorMetricCurrent,
            minLabel: l10n.monitorMetricMin,
            avgLabel: l10n.monitorMetricAvg,
            maxLabel: l10n.monitorMetricMax,
          ),
          const SizedBox(height: AppDesignTokens.spacingSm),
          MetricCard(
            title: l10n.serverMemoryLabel,
            metrics: data.memoryMetrics,
            currentLabel: l10n.monitorMetricCurrent,
            minLabel: l10n.monitorMetricMin,
            avgLabel: l10n.monitorMetricAvg,
            maxLabel: l10n.monitorMetricMax,
          ),
          const SizedBox(height: AppDesignTokens.spacingSm),
          MetricCard(
            title: l10n.serverDiskLabel,
            metrics: data.diskMetrics,
            currentLabel: l10n.monitorMetricCurrent,
            minLabel: l10n.monitorMetricMin,
            avgLabel: l10n.monitorMetricAvg,
            maxLabel: l10n.monitorMetricMax,
          ),
          const SizedBox(height: AppDesignTokens.spacingMd),
          if (data.networkMetrics.isEmpty)
            _EmptyView(title: l10n.commonEmpty)
          else
            ...data.networkMetrics.map(
              (metric) => Padding(
                padding: const EdgeInsets.only(bottom: AppDesignTokens.spacingSm),
                child: AppCard(
                  title: metric.interface ?? '',
                  subtitle: _buildNetworkSubtitle(context, metric),
                  child: _buildNetworkDetail(context, metric),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget? _buildNetworkSubtitle(BuildContext context, NetworkMetrics metric) {
    final l10n = context.l10n;
    final parts = <String>[];
    if (metric.receiveSpeed != null) {
      parts.add('↓ ${metric.receiveSpeed!.toStringAsFixed(2)}');
    }
    if (metric.transmitSpeed != null) {
      parts.add('↑ ${metric.transmitSpeed!.toStringAsFixed(2)}');
    }
    if (parts.isEmpty) {
      return null;
    }
    return Text('${l10n.monitorNetworkLabel} · ${parts.join(' · ')}');
  }

  Widget _buildNetworkDetail(BuildContext context, NetworkMetrics metric) {
    return Wrap(
      spacing: AppDesignTokens.spacingSm,
      runSpacing: AppDesignTokens.spacingSm,
      children: [
        MetricIconValue(
          icon: Icons.download_outlined,
          value: _formatBytes(metric.bytesReceived),
        ),
        MetricIconValue(
          icon: Icons.upload_outlined,
          value: _formatBytes(metric.bytesSent),
        ),
      ],
    );
  }

  String _formatBytes(int? bytes) {
    if (bytes == null) {
      return '--';
    }
    const units = ['B', 'KB', 'MB', 'GB', 'TB'];
    double value = bytes.toDouble();
    int index = 0;
    while (value >= 1024 && index < units.length - 1) {
      value /= 1024;
      index++;
    }
    return '${value.toStringAsFixed(1)} ${units[index]}';
  }
}


class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: AppDesignTokens.spacingMd),
          Text(l10n.commonLoading),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inbox_outlined, size: 48),
          const SizedBox(height: AppDesignTokens.spacingMd),
          Text(title),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.title,
    required this.error,
    required this.onRetry,
  });

  final String title;
  final String error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDesignTokens.spacingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64),
            const SizedBox(height: AppDesignTokens.spacingMd),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppDesignTokens.spacingSm),
            Text(
              error,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDesignTokens.spacingLg),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(l10n.commonRetry),
            ),
          ],
        ),
      ),
    );
  }
}
