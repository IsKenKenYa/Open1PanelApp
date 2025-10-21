import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import '../../core/config/api_config.dart';
import '../../core/network/api_client.dart';
import '../../core/services/logger/logger_service.dart';

class ServerSelectionPage extends StatefulWidget {
  const ServerSelectionPage({Key? key}) : super(key: key);

  @override
  _ServerSelectionPageState createState() => _ServerSelectionPageState();
}

class _ServerSelectionPageState extends State<ServerSelectionPage> {
  bool _isLoading = false;
  List<ApiConfig> _configs = [];
  ApiConfig? _currentConfig;

  @override
  void initState() {
    super.initState();
    _loadConfigs();
  }

  Future<void> _loadConfigs() async {
    setState(() {
      _isLoading = true;
    });

    try {
      appLogger.dWithPackage('server.config', '开始加载服务器配置');
      
      final configs = await ApiConfigManager.getConfigs();
      final currentConfig = await ApiConfigManager.getCurrentConfig();
      
      setState(() {
        _configs = configs;
        _currentConfig = currentConfig;
        _isLoading = false;
      });
      
      appLogger.dWithPackage('server.config', '服务器配置加载成功，共${configs.length}个配置');
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      appLogger.eWithPackage('server.config', '加载服务器配置失败', error: e);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('加载配置失败: $e')),
      );
    }
  }

  Future<void> _connectToServer(ApiConfig config) async {
    setState(() {
      _isLoading = true;
    });

    try {
      appLogger.iWithPackage('server.connection', '开始连接到服务器: ${config.name}');
      
      await ApiConfigManager.setCurrentConfig(config.id);
      
      appLogger.iWithPackage('server.connection', '成功连接到服务器: ${config.name}');
      
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      appLogger.eWithPackage('server.connection', '连接到服务器失败: ${config.name}', error: e);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('连接服务器失败: $e')),
      );
    }
  }

  Future<void> _deleteConfig(String id) async {
    final config = _configs.firstWhere((c) => c.id == id);
    
    appLogger.wWithPackage('server.config', '删除服务器配置: ${config.name}');
    
    setState(() {
      _isLoading = true;
    });

    try {
      await ApiConfigManager.deleteConfig(id);
      await _loadConfigs();
      
      appLogger.wWithPackage('server.config', '服务器配置删除成功: ${config.name}');
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('服务器配置 "${config.name}" 已删除')),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      appLogger.eWithPackage('server.config', '删除服务器配置失败: ${config.name}', error: e);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('删除配置失败: $e')),
      );
    }
  }

  Future<void> _testConnection(ApiConfig config) async {
    setState(() {
      _isLoading = true;
    });

    try {
      appLogger.iWithPackage('server.connection', '开始测试服务器连接: ${config.name}');
      
      final apiClient = ApiClient(
        baseUrl: config.url,
        apiKey: config.apiKey,
      );

      final response = await apiClient.dio.get('/api/v2/dashboard/base/os');
      
      setState(() {
        _isLoading = false;
      });
      
      appLogger.iWithPackage('server.connection', '服务器连接测试成功: ${config.name}');
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('连接测试成功')),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      appLogger.eWithPackage('server.connection', '服务器连接测试失败: ${config.name}', error: e);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('连接测试失败: $e')),
      );
    }
  }

  void _showDeleteConfirmDialog(ApiConfig config) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除服务器"${config.name}"吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteConfig(config.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('选择服务器'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/server-config').then((_) {
                _loadConfigs();
              });
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _configs.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        '暂无服务器配置',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/server-config').then((_) {
                            _loadConfigs();
                          });
                        },
                        child: const Text('添加服务器'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadConfigs,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _configs.length,
                    itemBuilder: (context, index) {
                      final config = _configs[index];
                      final isCurrent = _currentConfig?.id == config.id;
                      
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  config.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              if (config.isDefault)
                                const Tooltip(
                                  message: '默认服务器',
                                  child: Icon(Icons.star, color: Colors.amber),
                                ),
                              if (isCurrent)
                                const Tooltip(
                                  message: '当前服务器',
                                  child: Icon(Icons.check_circle, color: Colors.green),
                                ),
                            ],
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(config.url),
                                const SizedBox(height: 4),
                                Text(
                                  'API密钥: ${config.apiKey.substring(0, 8)}...',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'connect') {
                                _connectToServer(config);
                              } else if (value == 'test') {
                                _testConnection(config);
                              } else if (value == 'delete') {
                                _showDeleteConfirmDialog(config);
                              }
                            },
                            itemBuilder: (context) => [
                              if (!isCurrent)
                                const PopupMenuItem(
                                  value: 'connect',
                                  child: Text('连接到此服务器'),
                                ),
                              const PopupMenuItem(
                                value: 'test',
                                child: Text('测试连接'),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('删除', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                          onTap: () {
                            if (!isCurrent) {
                              _connectToServer(config);
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/server-config').then((_) {
            _loadConfigs();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}