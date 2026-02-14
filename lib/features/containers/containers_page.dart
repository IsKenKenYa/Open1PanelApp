import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/widgets/app_card.dart';
import '../../widgets/main_layout.dart';
import 'containers_provider.dart';

class ContainersPage extends StatefulWidget {
  const ContainersPage({super.key});

  @override
  State<ContainersPage> createState() => _ContainersPageState();
}

class _ContainersPageState extends State<ContainersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // 页面加载时获取数据
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ContainersProvider>().loadAll();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return MainLayout(
      currentIndex: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('容器管理'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // TODO: 搜索容器
              },
            ),
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {
                // TODO: 筛选容器
              },
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: '容器'),
              Tab(text: '镜像'),
            ],
            indicatorColor: colorScheme.primary,
            labelColor: colorScheme.primary,
            unselectedLabelColor: colorScheme.onSurfaceVariant,
          ),
        ),
        body: Consumer<ContainersProvider>(
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
            if (data.isLoading && data.containers.isEmpty) {
              return const _LoadingView();
            }

            return TabBarView(
              controller: _tabController,
              children: [
                // 容器标签页
                _ContainersTab(
                  containers: data.containers,
                  stats: data.containerStats,
                  isLoading: data.isLoading,
                  onRefresh: () => provider.refresh(),
                  onStart: (id) => provider.startContainer(id),
                  onStop: (id) => provider.stopContainer(id),
                  onRestart: (id) => provider.restartContainer(id),
                  onDelete: (id) => _showDeleteContainerDialog(context, id, provider),
                ),
                // 镜像标签页
                _ImagesTab(
                  images: data.images,
                  stats: data.imageStats,
                  isLoading: data.isLoading,
                  onRefresh: () => provider.refresh(),
                  onDelete: (id) => _showDeleteImageDialog(context, id, provider),
                ),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, '/container-create');
          },
          icon: const Icon(Icons.add),
          label: const Text('创建容器'),
        ),
      ),
    );
  }

  void _showDeleteContainerDialog(
    BuildContext context,
    String containerId,
    ContainersProvider provider,
  ) {
    final parentContext = context;
    showDialog(
      context: parentContext,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.delete_outline, color: Colors.red),
        title: const Text('删除容器'),
        content: const Text('确定要删除这个容器吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              final success = await provider.deleteContainer(containerId);
              if (!parentContext.mounted) return;
              if (success) {
                ScaffoldMessenger.of(parentContext).showSnackBar(
                  const SnackBar(content: Text('容器已删除')),
                );
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }

  void _showDeleteImageDialog(
    BuildContext context,
    String imageId,
    ContainersProvider provider,
  ) {
    final parentContext = context;
    showDialog(
      context: parentContext,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.delete_outline, color: Colors.red),
        title: const Text('删除镜像'),
        content: const Text('确定要删除这个镜像吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              final success = await provider.deleteImage(imageId);
              if (!parentContext.mounted) return;
              if (success) {
                ScaffoldMessenger.of(parentContext).showSnackBar(
                  const SnackBar(content: Text('镜像已删除')),
                );
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('删除'),
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

/// 容器标签页
class _ContainersTab extends StatelessWidget {
  final List<dynamic> containers;
  final ContainerStats stats;
  final bool isLoading;
  final Future<void> Function() onRefresh;
  final Future<bool> Function(String) onStart;
  final Future<bool> Function(String) onStop;
  final Future<bool> Function(String) onRestart;
  final void Function(String) onDelete;

  const _ContainersTab({
    required this.containers,
    required this.stats,
    required this.isLoading,
    required this.onRefresh,
    required this.onStart,
    required this.onStop,
    required this.onRestart,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 容器统计卡片
            _StatsCard(
              title: '容器统计',
              stats: [
                _StatItem(
                  title: '总数',
                  value: stats.total.toString(),
                  color: colorScheme.primary,
                  icon: Icons.inventory_2,
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
            const SizedBox(height: 16),
            
            // 容器列表
            if (containers.isEmpty && !isLoading)
              const _EmptyView(
                icon: Icons.inventory_2_outlined,
                title: '暂无容器',
                subtitle: '点击右下角按钮创建容器',
              )
            else
              ...containers.map((container) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _ContainerCard(
                    container: container,
                    onStart: () => onStart(container.id ?? ''),
                    onStop: () => onStop(container.id ?? ''),
                    onRestart: () => onRestart(container.id ?? ''),
                    onDelete: () => onDelete(container.id ?? ''),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}

/// 镜像标签页
class _ImagesTab extends StatelessWidget {
  final List<dynamic> images;
  final ImageStats stats;
  final bool isLoading;
  final Future<void> Function() onRefresh;
  final void Function(String) onDelete;

  const _ImagesTab({
    required this.images,
    required this.stats,
    required this.isLoading,
    required this.onRefresh,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 镜像统计卡片
            _StatsCard(
              title: '镜像统计',
              stats: [
                _StatItem(
                  title: '总数',
                  value: stats.total.toString(),
                  color: colorScheme.primary,
                  icon: Icons.image,
                ),
                _StatItem(
                  title: '已使用',
                  value: stats.used.toString(),
                  color: Colors.green,
                  icon: Icons.check_circle,
                ),
                _StatItem(
                  title: '未使用',
                  value: stats.unused.toString(),
                  color: Colors.grey,
                  icon: Icons.hide_image,
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // 镜像列表
            if (images.isEmpty && !isLoading)
              const _EmptyView(
                icon: Icons.image_outlined,
                title: '暂无镜像',
                subtitle: '拉取或构建镜像后将显示在这里',
              )
            else
              ...images.map((image) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _ImageCard(
                    image: image,
                    onDelete: () => onDelete(image.id ?? ''),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}

/// 统计卡片
class _StatsCard extends StatelessWidget {
  final String title;
  final List<_StatItem> stats;

  const _StatsCard({
    required this.title,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: title,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: stats,
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
          ],
        ),
      ),
    );
  }
}

/// 容器卡片
class _ContainerCard extends StatelessWidget {
  final dynamic container;
  final VoidCallback onStart;
  final VoidCallback onStop;
  final VoidCallback onRestart;
  final VoidCallback onDelete;

  const _ContainerCard({
    required this.container,
    required this.onStart,
    required this.onStop,
    required this.onRestart,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isRunning = container.state?.toLowerCase() == 'running';
    final statusColor = isRunning ? Colors.green : Colors.orange;
    
    return AppCard(
      title: container.name ?? '未命名容器',
      subtitle: Text(container.image ?? '未知镜像'),
      trailing: _StatusChip(
        status: isRunning ? '运行中' : '已停止',
        color: statusColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (container.ports != null && container.ports.isNotEmpty)
            Text(
              '端口: ${_formatPorts(container.ports)}',
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
                label: '删除',
                color: Colors.red,
                onTap: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatPorts(dynamic ports) {
    if (ports is List) {
      return ports.take(3).join(', ');
    }
    return ports.toString();
  }
}

/// 镜像卡片
class _ImageCard extends StatelessWidget {
  final dynamic image;
  final VoidCallback onDelete;

  const _ImageCard({
    required this.image,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final repoTags = image.repoTags ?? [];
    final name = repoTags.isNotEmpty ? repoTags.first : '未命名镜像';
    
    return AppCard(
      title: name,
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline),
        color: Colors.red,
        onPressed: onDelete,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '大小: ${_formatSize(image.size ?? 0)}',
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '创建时间: ${_formatTime(_parseTimestamp(image.created))}',
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FilledButton.tonal(
                onPressed: () {
                  // TODO: 创建容器
                },
                child: const Text('创建容器'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
  }

  int _parseTimestamp(dynamic created) {
    if (created == null) return 0;
    if (created is int) return created;
    if (created is DateTime) return created.millisecondsSinceEpoch ~/ 1000;
    if (created is String) {
      final parsedInt = int.tryParse(created);
      if (parsedInt != null) return parsedInt;
      final parsedDate = DateTime.tryParse(created);
      if (parsedDate != null) {
        return parsedDate.millisecondsSinceEpoch ~/ 1000;
      }
    }
    return 0;
  }

  String _formatTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final now = DateTime.now();
    final diff = now.difference(date);
    
    if (diff.inDays > 0) return '${diff.inDays}天前';
    if (diff.inHours > 0) return '${diff.inHours}小时前';
    if (diff.inMinutes > 0) return '${diff.inMinutes}分钟前';
    return '刚刚';
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
