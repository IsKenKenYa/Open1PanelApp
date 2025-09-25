/// 仪表盘页面
/// 
/// 此文件定义仪表盘页面，显示系统概览和实时监控数据。

import 'package:flutter/material.dart';
import '../../shared/widgets/app_card.dart';
import '../../widgets/main_layout.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('仪表盘'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                // 刷新数据
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
        body: const SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 服务器信息卡片
              AppCard(
                title: '服务器信息',
                subtitle: Text('运行正常'),
                trailing: Icon(Icons.computer, color: Colors.green),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('主机名: server-01'),
                    SizedBox(height: 8),
                    Text('操作系统: Ubuntu 20.04'),
                    SizedBox(height: 8),
                    Text('运行时间: 15天 3小时'),
                  ],
                ),
              ),
              SizedBox(height: 16),
              
              // 系统资源卡片
              AppCard(
                title: '系统资源',
                child: Column(
                  children: [
                    _ResourceItem(
                      title: 'CPU使用率',
                      value: '35%',
                      color: Colors.blue,
                    ),
                    SizedBox(height: 12),
                    _ResourceItem(
                      title: '内存使用率',
                      value: '2.4GB / 8GB',
                      color: Colors.green,
                    ),
                    SizedBox(height: 12),
                    _ResourceItem(
                      title: '磁盘使用率',
                      value: '45GB / 100GB',
                      color: Colors.orange,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              
              // 快速操作卡片
              AppCard(
                title: '快速操作',
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _QuickActionItem(
                      icon: Icons.restart_alt,
                      label: '重启服务器',
                      color: Colors.red,
                    ),
                    _QuickActionItem(
                      icon: Icons.update,
                      label: '系统更新',
                      color: Colors.blue,
                    ),
                    _QuickActionItem(
                      icon: Icons.backup,
                      label: '创建备份',
                      color: Colors.green,
                    ),
                    _QuickActionItem(
                      icon: Icons.security,
                      label: '安全检查',
                      color: Colors.orange,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              
              // 最近活动卡片
              AppCard(
                title: '最近活动',
                child: Column(
                  children: [
                    _ActivityItem(
                      title: '应用更新',
                      description: 'Nginx 更新至 1.21.0',
                      time: '2小时前',
                    ),
                    SizedBox(height: 8),
                    _ActivityItem(
                      title: '备份完成',
                      description: '系统备份已成功创建',
                      time: '5小时前',
                    ),
                    SizedBox(height: 8),
                    _ActivityItem(
                      title: '安全扫描',
                      description: '系统安全扫描完成，未发现威胁',
                      time: '1天前',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 资源使用项组件
class _ResourceItem extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _ResourceItem({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(title),
        ),
        Expanded(
          flex: 2,
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

/// 快速操作项组件
class _QuickActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _QuickActionItem({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        // 处理快速操作
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(label),
          ],
        ),
      ),
    );
  }
}

/// 活动项组件
class _ActivityItem extends StatelessWidget {
  final String title;
  final String description;
  final String time;

  const _ActivityItem({
    required this.title,
    required this.description,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(description),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          time,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}