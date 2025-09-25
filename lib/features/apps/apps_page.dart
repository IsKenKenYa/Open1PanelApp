/// 应用管理页面
/// 
/// 此文件定义应用管理页面，管理已安装的应用和应用市场。

import 'package:flutter/material.dart';
import '../../shared/widgets/app_card.dart';
import '../../widgets/main_layout.dart';

class AppsPage extends StatelessWidget {
  const AppsPage({super.key});

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
                // 搜索应用
              },
            ),
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {
                // 筛选应用
              },
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamed(context, '/app-store');
              },
            ),
          ],
        ),
        body: const SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 应用统计卡片
              AppCard(
                title: '应用统计',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _AppStatItem(
                      title: '已安装',
                      value: '12',
                      color: Colors.green,
                    ),
                    _AppStatItem(
                      title: '运行中',
                      value: '8',
                      color: Colors.blue,
                    ),
                    _AppStatItem(
                      title: '已停止',
                      value: '4',
                      color: Colors.orange,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              
              // 应用分类
              Text(
                '应用分类',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _AppCategoryItem(
                    icon: Icons.web,
                    label: 'Web服务',
                    count: 5,
                  ),
                  _AppCategoryItem(
                    icon: Icons.storage,
                    label: '数据库',
                    count: 3,
                  ),
                  _AppCategoryItem(
                    icon: Icons.code,
                    label: '开发工具',
                    count: 2,
                  ),
                  _AppCategoryItem(
                    icon: Icons.security,
                    label: '安全工具',
                    count: 2,
                  ),
                ],
              ),
              SizedBox(height: 16),
              
              // 已安装应用
              Text(
                '已安装应用',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              
              // 应用列表
              _AppItem(
                name: 'Nginx',
                description: '高性能的HTTP和反向代理web服务器',
                status: '运行中',
                statusColor: Colors.green,
                icon: Icons.web,
              ),
              SizedBox(height: 12),
              
              _AppItem(
                name: 'MySQL',
                description: '流行的关系型数据库管理系统',
                status: '运行中',
                statusColor: Colors.green,
                icon: Icons.storage,
              ),
              SizedBox(height: 12),
              
              _AppItem(
                name: 'Redis',
                description: '内存数据结构存储，用作数据库、缓存和消息代理',
                status: '已停止',
                statusColor: Colors.orange,
                icon: Icons.memory,
              ),
              SizedBox(height: 12),
              
              _AppItem(
                name: 'Docker',
                description: '开源的容器化平台',
                status: '运行中',
                statusColor: Colors.green,
                icon: Icons.inventory_2,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/app-store');
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

/// 应用统计项组件
class _AppStatItem extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _AppStatItem({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(title),
      ],
    );
  }
}

/// 应用分类项组件
class _AppCategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;

  const _AppCategoryItem({
    required this.icon,
    required this.label,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        // 筛选该分类的应用
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon),
            const SizedBox(height: 8),
            Text(label),
            const SizedBox(height: 4),
            Text(
              '$count个',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 应用项组件
class _AppItem extends StatelessWidget {
  final String name;
  final String description;
  final String status;
  final Color statusColor;
  final IconData icon;

  const _AppItem({
    required this.name,
    required this.description,
    required this.status,
    required this.statusColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: name,
      subtitle: Text(description),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: statusColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          status,
          style: TextStyle(
            color: statusColor,
            fontSize: 12,
          ),
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, '/app-detail');
      },
    );
  }
}