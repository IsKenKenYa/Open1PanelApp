import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/widgets/app_card.dart';
import '../../widgets/main_layout.dart';
import 'apps_provider.dart';

class AppsPage extends StatefulWidget {
  const AppsPage({super.key});

  @override
  State<AppsPage> createState() => _AppsPageState();
}

class _AppsPageState extends State<AppsPage> {
  @override
  void initState() {
    super.initState();
    // 页面加载时获取数据
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<AppsProvider>().loadAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('应用管理'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // TODO: 搜索应用
              },
            ),
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {
                // TODO: 筛选应用
              },
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                context.read<AppsProvider>().refresh();
              },
            ),
          ],
        ),
        body: Consumer<AppsProvider>(
          builder: (context, provider, child) {
            final data = provider.data;

            // 显示错误
            if (data.error != null) {
              return _ErrorView(
                error: data.error!,
                onRetry: () => provider.loadAll(),
              );
            }

            // 显示加载状态
            if (data.isLoading && data.installedApps.isEmpty) {
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
                    // 应用统计卡片
                    _StatsCard(stats: data.stats),
                    const SizedBox(height: 16),
                    
                    // 应用分类
                    Text(
                      '应用分类',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _AppCategoriesGrid(),
                    const SizedBox(height: 16),
                    
                    // 已安装应用
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '已安装应用',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/app-store');
                          },
                          child: const Text('应用商店'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    // 应用列表
                    if (data.installedApps.isEmpty && !data.isLoading)
                      const _EmptyView(
                        icon: Icons.apps_outlined,
                        title: '暂无已安装应用',
                        subtitle: '前往应用商店安装应用',
                      )
                    else
                      ...data.installedApps.map((app) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _InstalledAppCard(
                            app: app,
                            onStart: () => provider.startApp(app.id?.toString() ?? ''),
                            onStop: () => provider.stopApp(app.id?.toString() ?? ''),
                            onRestart: () => provider.restartApp(app.id?.toString() ?? ''),
                            onUninstall: () => _showUninstallDialog(context, app, provider),
                          ),
                        );
                      }),
                  ],
                ),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, '/app-store');
          },
          icon: const Icon(Icons.add),
          label: const Text('安装应用'),
        ),
      ),
    );
  }

  void _showUninstallDialog(
    BuildContext context,
    dynamic app,
    AppsProvider provider,
  ) {
    final parentContext = context;
    showDialog(
      context: parentContext,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.delete_outline, color: Colors.red),
        title: const Text('卸载应用'),
        content: Text('确定要卸载 ${app.appName ?? '此应用'} 吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              final success = await provider.uninstallApp(app.id?.toString() ?? '');
              if (!parentContext.mounted) return;
              if (success) {
                ScaffoldMessenger.of(parentContext).showSnackBar(
                  const SnackBar(content: Text('应用已卸载')),
                );
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('卸载'),
          ),
        ],
      ),
    );
  }
}

/// 加载中视图
class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('加载中...'),
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
    final colorScheme = Theme.of(context).colorScheme;
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              '加载失败',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('重试'),
            ),
          ],
        ),
      ),
    );
  }
}

/// 统计卡片
class _StatsCard extends StatelessWidget {
  final AppStats stats;

  const _StatsCard({required this.stats});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return AppCard(
      title: '应用统计',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            title: '已安装',
            value: stats.installed.toString(),
            color: colorScheme.primary,
            icon: Icons.download_done,
          ),
          _StatItem(
            title: '运行中',
            value: stats.running.toString(),
            color: Colors.green,
            icon: Icons.play_circle,
          ),
          _StatItem(
            title: '已停止',
            value: stats.stopped.toString(),
            color: Colors.orange,
            icon: Icons.stop_circle,
          ),
        ],
      ),
    );
  }
}

/// 统计项
class _StatItem extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const _StatItem({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// 应用分类网格
class _AppCategoriesGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categories = [
      _CategoryData(
        icon: Icons.web,
        label: 'Web服务',
        color: Colors.blue,
      ),
      _CategoryData(
        icon: Icons.storage,
        label: '数据库',
        color: Colors.green,
      ),
      _CategoryData(
        icon: Icons.code,
        label: '开发工具',
        color: Colors.purple,
      ),
      _CategoryData(
        icon: Icons.security,
        label: '安全工具',
        color: Colors.orange,
      ),
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: categories.map((category) {
        return _AppCategoryItem(
          icon: category.icon,
          label: category.label,
          color: category.color,
          onTap: () {
            // TODO: 筛选该分类的应用
          },
        );
      }).toList(),
    );
  }
}

class _CategoryData {
  final IconData icon;
  final String label;
  final Color color;

  const _CategoryData({
    required this.icon,
    required this.label,
    required this.color,
  });
}

/// 应用分类项组件
class _AppCategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _AppCategoryItem({
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 空状态视图
class _EmptyView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _EmptyView({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/app-store');
              },
              icon: const Icon(Icons.store),
              label: const Text('前往应用商店'),
            ),
          ],
        ),
      ),
    );
  }
}

/// 已安装应用卡片
class _InstalledAppCard extends StatelessWidget {
  final dynamic app;
  final VoidCallback onStart;
  final VoidCallback onStop;
  final VoidCallback onRestart;
  final VoidCallback onUninstall;

  const _InstalledAppCard({
    required this.app,
    required this.onStart,
    required this.onStop,
    required this.onRestart,
    required this.onUninstall,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isRunning = app.status?.toLowerCase() == 'running';
    final statusColor = isRunning ? Colors.green : Colors.orange;
    
    return AppCard(
      title: app.appName ?? '未命名应用',
      subtitle: Text(app.appVersion ?? '未知版本'),
      trailing: _StatusChip(
        status: isRunning ? '运行中' : '已停止',
        color: statusColor,
      ),
      onTap: () {
        Navigator.pushNamed(
          context,
          '/app-detail',
          arguments: {'appId': app.id},
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        if (app.appVersion != null)
            Text(
            '版本: ${app.appVersion}',
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 14,
              ),
            ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (isRunning) ...[
                _ActionButton(
                  icon: Icons.stop,
                  label: '停止',
                  color: Colors.orange,
                  onTap: onStop,
                ),
                const SizedBox(width: 8),
                _ActionButton(
                  icon: Icons.restart_alt,
                  label: '重启',
                  color: colorScheme.primary,
                  onTap: onRestart,
                ),
              ] else ...[
                _ActionButton(
                  icon: Icons.play_arrow,
                  label: '启动',
                  color: Colors.green,
                  onTap: onStart,
                ),
              ],
              const SizedBox(width: 8),
              _ActionButton(
                icon: Icons.delete_outline,
                label: '卸载',
                color: Colors.red,
                onTap: onUninstall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 状态标签
class _StatusChip extends StatelessWidget {
  final String status;
  final Color color;

  const _StatusChip({
    required this.status,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

/// 操作按钮
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
