import 'package:flutter/material.dart';

import 'package:onepanel_client/core/theme/app_design_tokens.dart';

class DatabasePageUnsupportedWidget extends StatelessWidget {
  const DatabasePageUnsupportedWidget({
    super.key,
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppDesignTokens.pagePadding,
        child: Text(message, textAlign: TextAlign.center),
      ),
    );
  }
}

class DatabasePageEmptyWidget extends StatelessWidget {
  const DatabasePageEmptyWidget({
    super.key,
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message, textAlign: TextAlign.center));
  }
}
