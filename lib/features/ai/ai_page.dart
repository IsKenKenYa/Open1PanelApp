/// AI模块页面
/// 
/// 此文件包含AI功能相关的所有页面，
/// 包括Ollama模型管理、GPU信息展示、域名绑定等页面。

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:onepanelapp_app/core/i18n/app_localizations.dart';
import 'ai_provider.dart';
import '../../core/services/logger/logger_service.dart';

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
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.aiManagement),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: localizations.ollamaModels),
            Tab(text: localizations.gpuInfo),
            Tab(text: localizations.domainBinding),
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
    try {
      final aiProvider = Provider.of<AIProvider>(context);
      final localizations = AppLocalizations.of(context)!;
      return _buildModelPage(context, aiProvider);
    } catch (e) {
      appLogger.eWithPackage('ai.model', '获取AIProvider失败: $e');
      final localizations = AppLocalizations.of(context)!;
      return _buildErrorPage(localizations.configLoadError);
    }
  }

  Widget _buildModelPage(BuildContext context, AIProvider aiProvider) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      body: Column(
        children: [
          // 搜索栏
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: localizations.ollamaModels,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
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
                    label: Text(localizations.ollamaModels),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _showCreateModelDialog(context, aiProvider);
                    },
                    icon: const Icon(Icons.add),
                    label: Text('${localizations.ollamaModels} ${localizations.create}'),
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
                              child: Text(localizations.retry),
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
                                  PopupMenuItem(
                                    value: 'load',
                                    child: Text(localizations.load),
                                  ),
                                  PopupMenuItem(
                                    value: 'close',
                                    child: Text(localizations.close),
                                  ),
                                  PopupMenuItem(
                                    value: 'recreate',
                                    child: Text('${localizations.recreate} ${localizations.ollamaModels}'),
                                  ),
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: Text(localizations.delete),
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

  Widget _buildErrorPage(String errorMessage) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              errorMessage,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // 可以在这里添加重试逻辑，比如导航到服务器配置页面
                appLogger.iWithPackage('ai.model', '用户点击重试按钮');
              },
              child: Text(localizations.retry),
            ),
          ],
        ),
      ),
    );
  }

  /// 显示创建模型对话框
  void _showCreateModelDialog(BuildContext context, AIProvider aiProvider) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController taskIdController = TextEditingController();
    final localizations = AppLocalizations.of(context)!;

    appLogger.dWithPackage('ai.model', '显示创建模型对话框');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${localizations.create} ${localizations.ollamaModels}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: '${localizations.ollamaModels} ${localizations.name}',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: taskIdController,
              decoration: InputDecoration(
                labelText: '${localizations.taskId} (${localizations.optional})',
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(localizations.cancel),
          ),
          FilledButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                appLogger.iWithPackage('ai.model', '创建Ollama模型: ${nameController.text}');
                
                aiProvider.createOllamaModel(
                  name: nameController.text,
                  taskId: taskIdController.text.isNotEmpty
                      ? taskIdController.text
                      : null,
                );
                Navigator.of(context).pop();
              }
            },
            child: Text(localizations.create),
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
    final localizations = AppLocalizations.of(context)!;

    appLogger.wWithPackage('ai.model', '显示删除模型对话框，模型ID: $modelId');

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('${localizations.delete} ${localizations.ollamaModels}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${localizations.confirm} ${localizations.delete} ${localizations.ollamaModels}?'),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: Text('${localizations.force} ${localizations.delete}'),
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
              child: Text(localizations.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                appLogger.wWithPackage('ai.model', '删除Ollama模型，模型ID: $modelId，强制删除: $forceDelete');
                
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
              child: Text(localizations.delete),
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
    try {
      final aiProvider = Provider.of<AIProvider>(context);
      return _buildGpuInfoPage(context, aiProvider);
    } catch (e) {
      appLogger.eWithPackage('ai.gpu', '获取AIProvider失败: $e');
      final localizations = AppLocalizations.of(context)!;
      return _buildErrorPage(localizations.configLoadError);
    }
  }

  Widget _buildGpuInfoPage(BuildContext context, AIProvider aiProvider) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      body: Column(
        children: [
          // 操作按钮
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                appLogger.iWithPackage('ai.gpu', '刷新GPU信息');
                aiProvider.loadGpuInfo();
              },
              icon: const Icon(Icons.refresh),
              label: Text('${localizations.refresh} ${localizations.gpuInfo}'),
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
                              child: Text(localizations.retry),
                            ),
                          ],
                        ),
                      )
                    : aiProvider.gpuInfoList.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.info_outline, size: 64, color: Colors.blue),
                                const SizedBox(height: 16),
                                Text(
                                  '${localizations.notFound} ${localizations.gpuInfo}',
                                  style: const TextStyle(fontSize: 16),
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
                                        '${localizations.gpu} ${gpu.index}',
                                        style: Theme.of(context).textTheme.titleLarge,
                                      ),
                                      const SizedBox(height: 8),
                                      Text('${localizations.name}: ${gpu.productName}'),
                                      const SizedBox(height: 4),
                                      Text('${localizations.temperature}: ${gpu.temperature}°C'),
                                      const SizedBox(height: 4),
                                      Text('${localizations.fanSpeed}: ${gpu.fanSpeed}%'),
                                      const SizedBox(height: 4),
                                      Text('${localizations.gpuUsage}: ${gpu.gpuUtil}%'),
                                      const SizedBox(height: 4),
                                      Text('${localizations.memoryUsage}: ${gpu.memoryUsage}%'),
                                      const SizedBox(height: 4),
                                      Text('${localizations.totalMemory}: ${gpu.memTotal} MB'),
                                      const SizedBox(height: 4),
                                      Text('${localizations.usedMemory}: ${gpu.memUsed} MB'),
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

  Widget _buildErrorPage(String errorMessage) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              errorMessage,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // 可以在这里添加重试逻辑，比如导航到服务器配置页面
                appLogger.iWithPackage('ai.gpu', '用户点击重试按钮');
              },
              child: const Text('重试'),
            ),
          ],
        ),
      ),
    );
  }
}

/// 域名绑定页面
class DomainBindingPage extends StatefulWidget {
  const DomainBindingPage({super.key});

  @override
  State<DomainBindingPage> createState() => _DomainBindingPageState();
}

class _DomainBindingPageState extends State<DomainBindingPage> {
  final ApiService _apiService = ApiService();
  List<DomainBinding> _domainBindings = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDomainBindings();
  }

  Future<void> _loadDomainBindings() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await _apiService.get('/ai/domain-bindings');
      setState(() {
        _domainBindings = (response['data'] as List)
            .map((item) => DomainBinding.fromJson(item))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.domainBinding),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildErrorPage(context, localizations)
              : _buildDomainBindingList(context, localizations),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showBindDomainDialog(context, localizations),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildErrorPage(BuildContext context, AppLocalizations localizations) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_error ?? localizations.unknownError),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadDomainBindings,
            child: Text(localizations.retry),
          ),
        ],
      ),
    );
  }

  Widget _buildDomainBindingList(BuildContext context, AppLocalizations localizations) {
    if (_domainBindings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(localizations.notFound + ' ' + localizations.domainBinding),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showBindDomainDialog(context, localizations),
              child: Text(localizations.domainBinding),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _domainBindings.length,
      itemBuilder: (context, index) {
        final binding = _domainBindings[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text(binding.domain),
            subtitle: Text('${localizations.appId}: ${binding.appId}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _showDeleteBindingDialog(context, binding, localizations),
            ),
          ),
        );
      },
    );
  }

  void _showBindDomainDialog(BuildContext context, AppLocalizations localizations) {
    final TextEditingController _domainController = TextEditingController();
    final TextEditingController _appIdController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.domainBinding),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _domainController,
              decoration: InputDecoration(
                labelText: localizations.domain,
                hintText: 'example.com',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _appIdController,
              decoration: InputDecoration(
                labelText: '${localizations.appId} *',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              final domain = _domainController.text.trim();
              final appId = _appIdController.text.trim();

              if (domain.isEmpty || appId.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(localizations.requiredFields)),
                );
                return;
              }

              try {
                await _apiService.post('/ai/domain-bindings', {
                  'domain': domain,
                  'app_id': appId,
                });
                Navigator.pop(context);
                _loadDomainBindings();
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.toString())),
                );
              }
            },
            child: Text(localizations.bind),
          ),
        ],
      ),
    );
  }

  void _showDeleteBindingDialog(
      BuildContext context, DomainBinding binding, AppLocalizations localizations) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.delete),
        content: Text('${localizations.confirm} ${localizations.delete} ${binding.domain}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await _apiService.delete('/ai/domain-bindings/${binding.id}');
                Navigator.pop(context);
                _loadDomainBindings();
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.toString())),
                );
              }
            },
            child: Text(localizations.delete),
          ),
        ],
      ),
    );
  }
}