import 'package:flutter/material.dart';
import '../../../core/i18n/l10n_x.dart';

class DashboardLoadingView extends StatelessWidget {
  const DashboardLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(context.l10n.commonLoading),
        ],
      ),
    );
  }
}
