import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import '../../core/config/api_config.dart';
import '../../core/network/api_client.dart';

class ServerConfigPage extends StatefulWidget {
  const ServerConfigPage({Key? key}) : super(key: key);

  @override
  _ServerConfigPageState createState() => _ServerConfigPageState();
}

class _ServerConfigPageState extends State<ServerConfigPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _urlController = TextEditingController();
  final _apiKeyController = TextEditingController();
  bool _isLoading = false;
  bool _isTestingConnection = false;
  String _testResult = '';

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    _apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _testConnection() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isTestingConnection = true;
      _testResult = '';
    });

    try {
      final apiClient = ApiClient(
        baseUrl: _urlController.text,
        apiKey: _apiKeyController.text,
      );

      final response = await apiClient.dio.get('/dashboard/base/os');
      
      setState(() {
        _testResult = '连接成功!\n\n状态码: ${response.statusCode}\n\n响应数据:\n${_formatJson(response.data)}';
        _isTestingConnection = false;
      });
    } catch (e) {
      setState(() {
        _testResult = '连接失败!\n\n错误信息: $e';
        _isTestingConnection = false;
      });
    }
  }

  Future<void> _saveAndConnect() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final config = ApiConfig(
        id: const Uuid().v4(),
        name: _nameController.text,
        url: _urlController.text,
        apiKey: _apiKeyController.text,
        isDefault: true, // 第一个配置设为默认
      );

      await ApiConfigManager.saveConfig(config);
      await ApiConfigManager.setCurrentConfig(config.id);
      
      // 保存成功后跳转到主页
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('保存配置失败: $e')),
      );
    }
  }

  String _formatJson(dynamic json) {
    try {
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(json);
    } catch (e) {
      return json.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('添加服务器'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '服务器信息',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: '服务器名称',
                                hintText: '例如：生产服务器',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '请输入服务器名称';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _urlController,
                              decoration: const InputDecoration(
                                labelText: '服务器地址',
                                hintText: '例如：http://192.168.1.100:10086',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '请输入服务器地址';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _apiKeyController,
                              decoration: const InputDecoration(
                                labelText: 'API密钥',
                                hintText: '请输入API密钥',
                                border: OutlineInputBorder(),
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '请输入API密钥';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: _isTestingConnection ? null : _testConnection,
                                    child: _isTestingConnection
                                        ? const SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : const Text('测试连接'),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: FilledButton(
                                    onPressed: _isLoading ? null : _saveAndConnect,
                                    child: _isLoading
                                        ? const SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                        : const Text('保存并连接'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (_testResult.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const Text(
                      '测试结果',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          _testResult,
                          style: const TextStyle(fontFamily: 'monospace'),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'API说明',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            '1Panel v2 API使用自定义Token进行身份验证，格式为：\n\n'
                            'Token = md5(\'1panel\' + API-Key + UnixTimestamp)\n\n'
                            '每次请求必须携带以下两个Header：\n\n'
                            '- 1Panel-Token: 自定义的Token值\n'
                            '- 1Panel-Timestamp: 当前时间戳\n\n'
                            '注意事项：\n'
                            '- 确保服务器与客户端时间同步，否则会导致验证失败\n'
                            '- 建议将可信任的IP或IP段加入白名单，避免频繁Token验证的开销',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}