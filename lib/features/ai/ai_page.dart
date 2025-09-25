/// AI模块页面
/// 
/// 此文件包含AI功能相关的所有页面，
/// 包括Ollama模型管理、GPU信息展示、域名绑定等页面。

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ai_provider.dart';

/// AI模块主页面
class AIPage extends StatefulWidget {
  const AIPage({super.key});

  @override
  State<AIPage> createState() => _AIPageState();
}

/// AI模块主页面状态
class _AIPageState extends State<AIPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI管理'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '模型管理'),
            Tab(text: 'GPU信息'),
            Tab(text: '域名绑定'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          OllamaModelPage(),
          GpuInfoPage(),
          DomainBindingPage(),
        ],
      ),
    );
  }
}

/// Ollama模型管理页面
class OllamaModelPage extends StatelessWidget {
  const OllamaModelPage({super.key});

  @override
  Widget build(BuildContext context) {
    final aiProvider = Provider.of<AIProvider>(context);

    return Scaffold(
      body: Column(
        children: [
          // 搜索栏
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: '搜索模型',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                aiProvider.searchOllamaModels(
                  page: 1,
                  pageSize: 10,
                  info: value,
                );
              },
            ),
          ),
          // 操作按钮
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      aiProvider.syncOllamaModels();
                    },
                    icon: const Icon(Icons.sync),
                    label: const Text('同步模型'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _showCreateModelDialog(context, aiProvider);
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('创建模型'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // 模型列表
          Expanded(
            child: aiProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : aiProvider.errorMessage != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline, size: 64, color: Colors.red),
                            const SizedBox(height: 16),
                            Text(
                              aiProvider.errorMessage!,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                aiProvider.clearError();
                                aiProvider.searchOllamaModels(
                                  page: 1,
                                  pageSize: 10,
                                );
                              },
                              child: const Text('重试'),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: aiProvider.ollamaModelList.length,
                        itemBuilder: (context, index) {
                          final model = aiProvider.ollamaModelList[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: ListTile(
                              title: Text(model.name),
                              subtitle: Text(model.id.toString()),
                              trailing: PopupMenuButton<String>(
                                onSelected: (value) {
                                  switch (value) {
                                    case 'load':
                                      aiProvider.loadOllamaModel(
                                        name: model.name,
                                      );
                                      break;
                                    case 'close':
                                      aiProvider.closeOllamaModel(
                                        name: model.name,
                                      );
                                      break;
                                    case 'delete':
                                      _showDeleteModelDialog(
                                        context,
                                        aiProvider,
                                        model.id,
                                      );
                                      break;
                                    case 'recreate':
                                      aiProvider.recreateOllamaModel(
                                        name: model.name,
                                      );
                                      break;
                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'load',
                                    child: Text('加载'),
                                  ),
                                  const PopupMenuItem(
                                    value: 'close',
                                    child: Text('关闭'),
                                  ),
                                  const PopupMenuItem(
                                    value: 'recreate',
                                    child: Text('重新创建'),
                                  ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Text('删除'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  /// 显示创建模型对话框
  void _showCreateModelDialog(BuildContext context, AIProvider aiProvider) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController taskIdController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('创建模型'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: '模型名称',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: taskIdController,
              decoration: const InputDecoration(
                labelText: '任务ID (可选)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                aiProvider.createOllamaModel(
                  name: nameController.text,
                  taskId: taskIdController.text.isNotEmpty
                      ? taskIdController.text
                      : null,
                );
                Navigator.of(context).pop();
              }
            },
            child: const Text('创建'),
          ),
        ],
      ),
    );
  }

  /// 显示删除模型对话框
  void _showDeleteModelDialog(
    BuildContext context,
    AIProvider aiProvider,
    int modelId,
  ) {
    bool forceDelete = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('删除模型'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('确定要删除此模型吗？'),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('强制删除'),
                value: forceDelete,
                onChanged: (value) {
                  setState(() {
                    forceDelete = value ?? false;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () {
                aiProvider.deleteOllamaModel(
                  ids: [modelId],
                  forceDelete: forceDelete,
                );
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('删除'),
            ),
          ],
        ),
      ),
    );
  }
}

/// GPU信息页面
class GpuInfoPage extends StatelessWidget {
  const GpuInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final aiProvider = Provider.of<AIProvider>(context);

    return Scaffold(
      body: Column(
        children: [
          // 操作按钮
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                aiProvider.loadGpuInfo();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('刷新GPU信息'),
            ),
          ),
          // GPU信息列表
          Expanded(
            child: aiProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : aiProvider.errorMessage != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline, size: 64, color: Colors.red),
                            const SizedBox(height: 16),
                            Text(
                              aiProvider.errorMessage!,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                aiProvider.clearError();
                                aiProvider.loadGpuInfo();
                              },
                              child: const Text('重试'),
                            ),
                          ],
                        ),
                      )
                    : aiProvider.gpuInfoList.isEmpty
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.info_outline, size: 64, color: Colors.blue),
                                SizedBox(height: 16),
                                Text(
                                  '未找到GPU信息',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: aiProvider.gpuInfoList.length,
                            itemBuilder: (context, index) {
                              final gpu = aiProvider.gpuInfoList[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 8.0,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'GPU ${gpu.index}',
                                        style: Theme.of(context).textTheme.titleLarge,
                                      ),
                                      const SizedBox(height: 8),
                                      Text('名称: ${gpu.productName}'),
                                      const SizedBox(height: 4),
                                      Text('温度: ${gpu.temperature}°C'),
                                      const SizedBox(height: 4),
                                      Text('风扇速度: ${gpu.fanSpeed}%'),
                                      const SizedBox(height: 4),
                                      Text('GPU使用率: ${gpu.gpuUtil}%'),
                                      const SizedBox(height: 4),
                                      Text('内存使用率: ${gpu.memoryUsage}%'),
                                      const SizedBox(height: 4),
                                      Text('总内存: ${gpu.memTotal} MB'),
                                      const SizedBox(height: 4),
                                      Text('已用内存: ${gpu.memUsed} MB'),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}

/// 域名绑定页面
class DomainBindingPage extends StatelessWidget {
  const DomainBindingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final aiProvider = Provider.of<AIProvider>(context);

    return Scaffold(
      body: Column(
        children: [
          // 操作按钮
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                _showBindDomainDialog(context, aiProvider);
              },
              icon: const Icon(Icons.link),
              label: const Text('绑定域名'),
            ),
          ),
          // 域名绑定信息
          Expanded(
            child: aiProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : aiProvider.errorMessage != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline, size: 64, color: Colors.red),
                            const SizedBox(height: 16),
                            Text(
                              aiProvider.errorMessage!,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                aiProvider.clearError();
                                // TODO: 获取应用安装ID
                                // aiProvider.getBindDomain(appInstallId: '');
                              },
                              child: const Text('重试'),
                            ),
                          ],
                        ),
                      )
                    : aiProvider.bindDomainInfo == null
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.info_outline, size: 64, color: Colors.blue),
                                SizedBox(height: 16),
                                Text(
                                  '未绑定域名',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          )
                        : Card(
                            margin: const EdgeInsets.all(16.0),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '域名绑定信息',
                                    style: Theme.of(context).textTheme.titleLarge,
                                  ),
                                  const SizedBox(height: 16),
                                  Text('连接URL: ${aiProvider.bindDomainInfo!.connUrl}'),
                                  const SizedBox(height: 8),
                                  Text('ACME账户ID: ${aiProvider.bindDomainInfo!.acmeAccountID}'),
                                  const SizedBox(height: 8),
                                  Text('允许IP: ${aiProvider.bindDomainInfo!.allowIPs?.join(', ') ?? ''}'),
                                  const SizedBox(height: 8),
                                  Text('域名: ${aiProvider.bindDomainInfo!.domain}'),
                                  const SizedBox(height: 8),
                                  Text('SSL证书ID: ${aiProvider.bindDomainInfo!.sslID}'),
                                  const SizedBox(height: 8),
                                  Text('网站ID: ${aiProvider.bindDomainInfo!.websiteID}'),
                                ],
                              ),
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  /// 显示绑定域名对话框
  void _showBindDomainDialog(BuildContext context, AIProvider aiProvider) {
    final TextEditingController appInstallIdController = TextEditingController();
    final TextEditingController domainController = TextEditingController();
    final TextEditingController ipListController = TextEditingController();
    final TextEditingController sslIdController = TextEditingController();
    final TextEditingController websiteIdController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('绑定域名'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: appInstallIdController,
                decoration: const InputDecoration(
                  labelText: '应用安装ID *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: domainController,
                decoration: const InputDecoration(
                  labelText: '域名',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: ipListController,
                decoration: const InputDecoration(
                  labelText: 'IP列表 (逗号分隔)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: sslIdController,
                decoration: const InputDecoration(
                  labelText: 'SSL证书ID',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: websiteIdController,
                decoration: const InputDecoration(
                  labelText: '网站ID',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              if (appInstallIdController.text.isNotEmpty) {
                aiProvider.bindDomain(
                  appInstallId: int.tryParse(appInstallIdController.text) ?? 0,
                  domain: domainController.text.isNotEmpty
                      ? domainController.text
                      : null,
                  ipList: ipListController.text.isNotEmpty
                      ? ipListController.text
                      : null,
                  sslId: sslIdController.text.isNotEmpty
                      ? int.tryParse(sslIdController.text)
                      : null,
                  websiteId: websiteIdController.text.isNotEmpty
                      ? int.tryParse(websiteIdController.text)
                      : null,
                );
                Navigator.of(context).pop();
              }
            },
            child: const Text('绑定'),
          ),
        ],
      ),
    );
  }
}