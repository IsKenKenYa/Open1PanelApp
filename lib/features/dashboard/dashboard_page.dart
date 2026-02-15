import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/i18n/l10n_x.dart';
import 'widgets/widgets.dart';
import 'dashboard_provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.dashboardTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<DashboardProvider>().refresh(),
          ),
        ],
      ),
      body: Consumer<DashboardProvider>(
        builder: (context, provider, child) {
          switch (provider.status) {
            case DashboardStatus.initial:
            case DashboardStatus.loading:
              return const DashboardLoadingView();

            case DashboardStatus.error:
              return DashboardErrorView(
                error: provider.errorMessage,
                onRetry: () => provider.loadData(),
              );

            case DashboardStatus.loaded:
              return _buildContent(context, provider);
          }
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, DashboardProvider provider) {
    return RefreshIndicator(
      onRefresh: () => provider.refresh(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              return _buildTabletLayout(provider);
            }
            return _buildMobileLayout(provider);
          },
        ),
      ),
    );
  }

  Widget _buildMobileLayout(DashboardProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ServerInfoCard(data: provider.data),
        const SizedBox(height: 16),
        ResourceCard(data: provider.data),
        const SizedBox(height: 16),
        TopProcessesCard(
          cpuProcesses: provider.data.topCpuProcesses,
          memoryProcesses: provider.data.topMemoryProcesses,
          isLoading: provider.isLoadingTopProcesses,
          onRefresh: () => provider.loadTopProcesses(),
        ),
        const SizedBox(height: 16),
        const QuickActionsCard(),
        const SizedBox(height: 16),
        ActivityCard(activities: provider.activities),
      ],
    );
  }

  Widget _buildTabletLayout(DashboardProvider provider) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ServerInfoCard(data: provider.data),
              const SizedBox(height: 16),
              ResourceCard(data: provider.data),
              const SizedBox(height: 16),
              TopProcessesCard(
                cpuProcesses: provider.data.topCpuProcesses,
                memoryProcesses: provider.data.topMemoryProcesses,
                isLoading: provider.isLoadingTopProcesses,
                onRefresh: () => provider.loadTopProcesses(),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const QuickActionsCard(),
              const SizedBox(height: 16),
              ActivityCard(activities: provider.activities),
            ],
          ),
        ),
      ],
    );
  }
}
