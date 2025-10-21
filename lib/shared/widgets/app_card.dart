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
    final colorScheme = Theme.of(context).colorScheme;
    
    return Card(
      color: backgroundColor ?? colorScheme.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
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
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (trailing != null) trailing!,
                ],
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ) ?? TextStyle(),
                  child: subtitle!,
                ),
              ],
              if (child != null) ...[
                const SizedBox(height: 16),
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ) ?? TextStyle(),
                  child: child!,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}