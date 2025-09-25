/// 应用卡片组件
/// 
/// 此文件定义应用中使用的通用卡片组件，
/// 用于展示相关信息的集合，如服务器信息、应用列表等。

import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  final String title;
  final Widget? subtitle;
  final Widget? child;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? backgroundColor;

  const AppCard({
    super.key,
    required this.title,
    this.subtitle,
    this.child,
    this.trailing,
    this.padding,
    this.onTap,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: padding ?? const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  if (trailing != null) trailing!,
                ],
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                subtitle!,
              ],
              if (child != null) ...[
                const SizedBox(height: 16),
                child!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}