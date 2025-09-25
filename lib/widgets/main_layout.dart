/// 应用主布局组件
/// 
/// 此文件定义应用的主布局组件，包含底部标签栏和侧边菜单。

import 'package:flutter/material.dart';
import '../widgets/navigation/app_bottom_navigation_bar.dart';
import '../widgets/navigation/app_drawer.dart';

class MainLayout extends StatefulWidget {
  final Widget child;
  final int currentIndex;

  const MainLayout({
    super.key,
    required this.child,
    required this.currentIndex,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/dashboard');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/apps');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/containers');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/websites');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/files');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: widget.child,
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}