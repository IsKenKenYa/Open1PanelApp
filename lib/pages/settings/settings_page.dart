import 'package:flutter/material.dart';
import 'api_config_page.dart';
import 'api_test_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const ApiConfigPage(),
    const ApiTestPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'API配置',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.api),
            label: 'API测试',
          ),
        ],
      ),
    );
  }
}