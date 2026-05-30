import 'package:flutter/material.dart';
import 'package:onepanel_client/shared/widgets/operations/async_state_page_body_widget.dart';

class WebsiteAsyncStateView extends StatelessWidget {
  const WebsiteAsyncStateView({
    super.key,
    this.isLoading = false,
    this.error,
    this.onRetry,
    this.child,
  });

  final bool isLoading;
  final String? error;
  final VoidCallback? onRetry;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return AsyncStatePageBodyWidget(
      isLoading: isLoading,
      errorMessage: error,
      onRetry: onRetry,
      child: child ?? const SizedBox.shrink(),
    );
  }
}
