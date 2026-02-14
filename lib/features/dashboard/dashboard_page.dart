import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:onepanelapp_app/core/i18n/l10n_x.dart';
import '../../shared/widgets/app_card.dart';
import '../../widgets/main_layout.dart';
import '../../data/models/common_models.dart';
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
    // 页面加载时获取数据
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<DashboardProvider>().loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.dashboardTitle),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                context.read<DashboardProvider>().refresh();
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ],
        ),
        body: Consumer<DashboardProvider>(
          builder: (context, provider, child) {
            final data = provider.data;

            // 显示错误
            if (data.error != null) {
              return _ErrorView(
                error: data.error!,
                onRetry: () => provider.loadData(),
              );
            }

            // 显示加载状态
            if (data.isLoading && data.systemInfo == null) {
              return const _LoadingView();
            }

            return RefreshIndicator(
              onRefresh: () => provider.refresh(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 服务器信息卡片
                    _ServerInfoCard(data: data),
                    const SizedBox(height: 16),
                    
                    // 系统资源卡片
                    _ResourceCard(data: data),
                    const SizedBox(height: 16),
                    
                    // 快速操作卡片
                    const _QuickActionsCard(),
                    const SizedBox(height: 16),
                    
                    // 最近活动卡片
                    _ActivityCard(activities: data.activities),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// 加载中视图
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
          const SizedBox(height: 16),
          Text(l10n.commonLoading),
        ],
      ),
    );
  }
}

/// 错误视图
class _ErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.dashboardLoadFailedTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
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

/// 服务器信息卡片
class _ServerInfoCard extends StatelessWidget {
  final DashboardData data;

  const _ServerInfoCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final systemInfo = data.systemInfo;
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return AppCard(
      title: l10n.dashboardServerInfoTitle,
      subtitle: Text(
        systemInfo != null ? l10n.dashboardServerStatusOk : l10n.dashboardServerStatusConnecting,
        style: TextStyle(
          color: systemInfo != null ? Colors.green : Colors.orange,
        ),
      ),
      trailing: Icon(
        Icons.computer,
        color: systemInfo != null ? Colors.green : Colors.orange,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoRow(
            label: l10n.dashboardHostNameLabel,
            value: systemInfo?.hostname ?? '--',
          ),
          const SizedBox(height: 8),
          _InfoRow(
            label: l10n.dashboardOsLabel,
            value: _formatOsInfo(systemInfo),
          ),
          const SizedBox(height: 8),
          _InfoRow(
            label: l10n.dashboardUptimeLabel,
            value: _formatUptime(context, data.uptime),
          ),
          if (data.lastUpdated != null) ...[
            const SizedBox(height: 8),
            Text(
              l10n.dashboardUpdatedAt(_formatTime(data.lastUpdated!)),
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatOsInfo(SystemInfo? info) {
    if (info == null) return '--';
    final os = info.os ?? '--';
    final platform = info.platform ?? '';
    final platformVersion = info.platformVersion ?? '';
    if (platform.isNotEmpty && platformVersion.isNotEmpty) {
      return '$os $platform $platformVersion';
    }
    return os;
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';
  }

  String _formatUptime(BuildContext context, String uptime) {
    if (uptime == '--') return uptime;
    final seconds = int.tryParse(uptime);
    if (seconds == null) return uptime;
    final days = seconds ~/ 86400;
    final hours = (seconds % 86400) ~/ 3600;
    if (days > 0) {
      return context.l10n.dashboardUptimeDaysHours(days, hours);
    }
    return context.l10n.dashboardUptimeHours(hours);
  }
}

/// 信息行组件
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

/// 系统资源卡片
class _ResourceCard extends StatelessWidget {
  final DashboardData data;

  const _ResourceCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: context.l10n.dashboardResourceTitle,
      child: Column(
        children: [
          _ResourceItem(
            title: context.l10n.dashboardCpuUsage,
            value: data.cpuPercent != null
                ? '${data.cpuPercent!.toStringAsFixed(1)}%'
                : '--',
            percent: data.cpuPercent,
            color: Colors.blue,
          ),
          const SizedBox(height: 12),
          _ResourceItem(
            title: context.l10n.dashboardMemoryUsage,
            value: data.memoryPercent != null
                ? '${data.memoryPercent!.toStringAsFixed(1)}%'
                : '--',
            subtitle: data.memoryUsage,
            percent: data.memoryPercent,
            color: Colors.green,
          ),
          const SizedBox(height: 12),
          _ResourceItem(
            title: context.l10n.dashboardDiskUsage,
            value: data.diskPercent != null
                ? '${data.diskPercent!.toStringAsFixed(1)}%'
                : '--',
            subtitle: data.diskUsage,
            percent: data.diskPercent,
            color: Colors.orange,
          ),
        ],
      ),
    );
  }
}

/// 资源使用项组件
class _ResourceItem extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final double? percent;
  final Color color;

  const _ResourceItem({
    required this.title,
    required this.value,
    this.subtitle,
    this.percent,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                title,
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    value,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        if (percent != null) ...[
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: percent! / 100,
            backgroundColor: color.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ],
      ],
    );
  }
}

/// 快速操作卡片
class _QuickActionsCard extends StatelessWidget {
  const _QuickActionsCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: context.l10n.dashboardQuickActionsTitle,
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          _QuickActionItem(
            icon: Icons.restart_alt,
            label: context.l10n.dashboardActionRestart,
            color: Colors.red,
            onTap: () => _showRestartDialog(context),
          ),
          _QuickActionItem(
            icon: Icons.update,
            label: context.l10n.dashboardActionUpdate,
            color: Colors.blue,
            onTap: () => _showUpdateDialog(context),
          ),
          _QuickActionItem(
            icon: Icons.backup,
            label: context.l10n.dashboardActionBackup,
            color: Colors.green,
            onTap: () {
              Navigator.pushNamed(context, '/backups');
            },
          ),
          _QuickActionItem(
            icon: Icons.security,
            label: context.l10n.dashboardActionSecurity,
            color: Colors.orange,
            onTap: () {
              Navigator.pushNamed(context, '/security');
            },
          ),
        ],
      ),
    );
  }

  void _showRestartDialog(BuildContext context) {
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.dashboardRestartTitle),
        content: Text(l10n.dashboardRestartDesc),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await context.read<DashboardProvider>().restartSystem();
                if (!context.mounted) {
                  return;
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.dashboardRestartSuccess)),
                );
              } catch (e) {
                if (!context.mounted) {
                  return;
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.dashboardRestartFailed(e.toString()))),
                );
              }
            },
            child: Text(l10n.commonConfirm),
          ),
        ],
      ),
    );
  }

  void _showUpdateDialog(BuildContext context) {
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.dashboardUpdateTitle),
        content: Text(l10n.dashboardUpdateDesc),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await context.read<DashboardProvider>().upgradeSystem();
                if (!context.mounted) {
                  return;
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.dashboardUpdateSuccess)),
                );
              } catch (e) {
                if (!context.mounted) {
                  return;
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.dashboardUpdateFailed(e.toString()))),
                );
              }
            },
            child: Text(l10n.commonConfirm),
          ),
        ],
      ),
    );
  }
}

/// 快速操作项组件
class _QuickActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon, 
              color: color,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 活动卡片
class _ActivityCard extends StatelessWidget {
  final List<DashboardActivity> activities;

  const _ActivityCard({required this.activities});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: context.l10n.dashboardActivityTitle,
      child: activities.isEmpty
          ? Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(context.l10n.dashboardActivityEmpty),
              ),
            )
          : Column(
              children: activities.map((activity) {
                return _ActivityItem(
                  title: activity.title,
                  description: activity.description,
                  time: _formatTimeAgo(context, activity.time),
                  type: activity.type,
                );
              }).toList(),
            ),
    );
  }

  String _formatTimeAgo(BuildContext context, DateTime time) {
    final l10n = context.l10n;
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inDays > 0) {
      return l10n.dashboardActivityDaysAgo(diff.inDays);
    } else if (diff.inHours > 0) {
      return l10n.dashboardActivityHoursAgo(diff.inHours);
    } else if (diff.inMinutes > 0) {
      return l10n.dashboardActivityMinutesAgo(diff.inMinutes);
    } else {
      return l10n.dashboardActivityJustNow;
    }
  }
}

/// 活动项组件
class _ActivityItem extends StatelessWidget {
  final String title;
  final String description;
  final String time;
  final ActivityType type;

  const _ActivityItem({
    required this.title,
    required this.description,
    required this.time,
    this.type = ActivityType.info,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTypeIcon(),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            time,
            style: TextStyle(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeIcon() {
    IconData iconData;
    Color color;

    switch (type) {
      case ActivityType.success:
        iconData = Icons.check_circle;
        color = Colors.green;
        break;
      case ActivityType.warning:
        iconData = Icons.warning;
        color = Colors.orange;
        break;
      case ActivityType.error:
        iconData = Icons.error;
        color = Colors.red;
        break;
      case ActivityType.info:
        iconData = Icons.info;
        color = Colors.blue;
        break;
    }

    return Icon(iconData, color: color, size: 20);
  }
}
