/// 网站管理页面
/// 
/// 此文件定义网站管理页面，管理网站和域名。

import 'package:flutter/material.dart';
import '../../shared/widgets/app_card.dart';
import '../../widgets/main_layout.dart';

class WebsitesPage extends StatelessWidget {
  const WebsitesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentIndex: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('网站管理'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // 搜索网站
              },
            ),
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {
                // 筛选网站
              },
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamed(context, '/website-create');
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
                  Tab(text: '网站'),
                  Tab(text: '域名'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    // 网站标签页
                    _WebsitesTab(),
                    // 域名标签页
                    _DomainsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/website-create');
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

/// 网站标签页
class _WebsitesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 网站统计卡片
          AppCard(
            title: '网站统计',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _WebsiteStatItem(
                  title: '总数',
                  value: '5',
                  color: Colors.blue,
                ),
                _WebsiteStatItem(
                  title: '运行中',
                  value: '4',
                  color: Colors.green,
                ),
                _WebsiteStatItem(
                  title: '已停止',
                  value: '1',
                  color: Colors.orange,
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          
          // 网站列表标题
          Text(
            '网站列表',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          
          // 网站列表
          _WebsiteItem(
            name: '我的博客',
            domain: 'blog.example.com',
            status: '运行中',
            statusColor: Colors.green,
            type: 'WordPress',
          ),
          SizedBox(height: 12),
          
          _WebsiteItem(
            name: '公司官网',
            domain: 'www.example.com',
            status: '运行中',
            statusColor: Colors.green,
            type: '静态网站',
          ),
          SizedBox(height: 12),
          
          _WebsiteItem(
            name: 'API服务',
            domain: 'api.example.com',
            status: '已停止',
            statusColor: Colors.orange,
            type: 'Node.js',
          ),
        ],
      ),
    );
  }
}

/// 域名标签页
class _DomainsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 域名统计卡片
          AppCard(
            title: '域名统计',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _WebsiteStatItem(
                  title: '总数',
                  value: '8',
                  color: Colors.blue,
                ),
                _WebsiteStatItem(
                  title: '已绑定',
                  value: '5',
                  color: Colors.green,
                ),
                _WebsiteStatItem(
                  title: '未绑定',
                  value: '3',
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          
          // 域名列表标题
          Text(
            '域名列表',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          
          // 域名列表
          _DomainItem(
            domain: 'example.com',
            status: '已绑定',
            statusColor: Colors.green,
            registrar: 'GoDaddy',
            expiry: '2024-12-31',
          ),
          SizedBox(height: 12),
          
          _DomainItem(
            domain: 'blog.example.com',
            status: '已绑定',
            statusColor: Colors.green,
            registrar: 'Namecheap',
            expiry: '2025-03-15',
          ),
          SizedBox(height: 12),
          
          _DomainItem(
            domain: 'api.example.com',
            status: '已绑定',
            statusColor: Colors.green,
            registrar: 'Cloudflare',
            expiry: '2024-11-20',
          ),
        ],
      ),
    );
  }
}

/// 网站统计项组件
class _WebsiteStatItem extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _WebsiteStatItem({
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

/// 网站项组件
class _WebsiteItem extends StatelessWidget {
  final String name;
  final String domain;
  final String status;
  final Color statusColor;
  final String type;

  const _WebsiteItem({
    required this.name,
    required this.domain,
    required this.status,
    required this.statusColor,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: name,
      subtitle: Text(domain),
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
            '类型: $type',
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
                  // 访问网站
                },
                child: const Text('访问'),
              ),
              TextButton(
                onPressed: () {
                  // 管理网站
                },
                child: const Text('管理'),
              ),
              TextButton(
                onPressed: () {
                  // 删除网站
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

/// 域名项组件
class _DomainItem extends StatelessWidget {
  final String domain;
  final String status;
  final Color statusColor;
  final String registrar;
  final String expiry;

  const _DomainItem({
    required this.domain,
    required this.status,
    required this.statusColor,
    required this.registrar,
    required this.expiry,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: domain,
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
            '注册商: $registrar',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '到期时间: $expiry',
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
                  // 解析设置
                },
                child: const Text('解析设置'),
              ),
              TextButton(
                onPressed: () {
                  // SSL证书
                },
                child: const Text('SSL证书'),
              ),
              TextButton(
                onPressed: () {
                  // 绑定网站
                },
                child: const Text('绑定网站'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}