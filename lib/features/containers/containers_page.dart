/// 容器管理页面
/// 
/// 此文件定义容器管理页面，管理Docker容器和镜像。

import 'package:flutter/material.dart';
import '../../shared/widgets/app_card.dart';
import '../../widgets/main_layout.dart';

class ContainersPage extends StatelessWidget {
  const ContainersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentIndex: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('容器管理'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // 搜索容器
              },
            ),
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {
                // 筛选容器
              },
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamed(context, '/container-create');
              },
            ),
          ],
        ),
        body: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              const TabBar(
                tabs: [
                  Tab(text: '容器'),
                  Tab(text: '镜像'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    // 容器标签页
                    _ContainersTab(),
                    // 镜像标签页
                    _ImagesTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/container-create');
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

/// 容器标签页
class _ContainersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 容器统计卡片
          AppCard(
            title: '容器统计',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ContainerStatItem(
                  title: '总数',
                  value: '8',
                  color: Colors.blue,
                ),
                _ContainerStatItem(
                  title: '运行中',
                  value: '6',
                  color: Colors.green,
                ),
                _ContainerStatItem(
                  title: '已停止',
                  value: '2',
                  color: Colors.orange,
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          
          // 容器列表标题
          Text(
            '容器列表',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          
          // 容器列表
          _ContainerItem(
            name: 'nginx',
            image: 'nginx:latest',
            status: '运行中',
            statusColor: Colors.green,
            ports: '80->80/tcp',
          ),
          SizedBox(height: 12),
          
          _ContainerItem(
            name: 'mysql',
            image: 'mysql:8.0',
            status: '运行中',
            statusColor: Colors.green,
            ports: '3306->3306/tcp',
          ),
          SizedBox(height: 12),
          
          _ContainerItem(
            name: 'redis',
            image: 'redis:alpine',
            status: '已停止',
            statusColor: Colors.orange,
            ports: '6379->6379/tcp',
          ),
        ],
      ),
    );
  }
}

/// 镜像标签页
class _ImagesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 镜像统计卡片
          AppCard(
            title: '镜像统计',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ContainerStatItem(
                  title: '总数',
                  value: '12',
                  color: Colors.blue,
                ),
                _ContainerStatItem(
                  title: '已使用',
                  value: '8',
                  color: Colors.green,
                ),
                _ContainerStatItem(
                  title: '未使用',
                  value: '4',
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          
          // 镜像列表标题
          Text(
            '镜像列表',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          
          // 镜像列表
          _ImageItem(
            name: 'nginx',
            tag: 'latest',
            size: '142MB',
            created: '2天前',
          ),
          SizedBox(height: 12),
          
          _ImageItem(
            name: 'mysql',
            tag: '8.0',
            size: '521MB',
            created: '1周前',
          ),
          SizedBox(height: 12),
          
          _ImageItem(
            name: 'redis',
            tag: 'alpine',
            size: '32MB',
            created: '2周前',
          ),
        ],
      ),
    );
  }
}

/// 容器统计项组件
class _ContainerStatItem extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _ContainerStatItem({
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

/// 容器项组件
class _ContainerItem extends StatelessWidget {
  final String name;
  final String image;
  final String status;
  final Color statusColor;
  final String ports;

  const _ContainerItem({
    required this.name,
    required this.image,
    required this.status,
    required this.statusColor,
    required this.ports,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: name,
      subtitle: Text(image),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '端口: $ports',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  // 启动/停止容器
                },
                child: Text(status == '运行中' ? '停止' : '启动'),
              ),
              TextButton(
                onPressed: () {
                  // 重启容器
                },
                child: const Text('重启'),
              ),
              TextButton(
                onPressed: () {
                  // 删除容器
                },
                child: const Text('删除'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 镜像项组件
class _ImageItem extends StatelessWidget {
  final String name;
  final String tag;
  final String size;
  final String created;

  const _ImageItem({
    required this.name,
    required this.tag,
    required this.size,
    required this.created,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: '$name:$tag',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '大小: $size',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '创建时间: $created',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  // 创建容器
                },
                child: const Text('创建容器'),
              ),
              TextButton(
                onPressed: () {
                  // 删除镜像
                },
                child: const Text('删除'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}