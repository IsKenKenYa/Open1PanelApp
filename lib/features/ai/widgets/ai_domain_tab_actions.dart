import 'package:flutter/material.dart';
import 'package:onepanel_client/core/i18n/l10n_x.dart';
import 'package:onepanel_client/core/utils/snackbar_utils.dart';
import 'package:onepanel_client/features/ai/ai_provider.dart';
import 'package:provider/provider.dart';

class AIDomainTabActions {
  static int? parseInt(String text) {
    if (text.trim().isEmpty) return null;
    return int.tryParse(text.trim());
  }

  static void fillFromProvider({
    required AIProvider provider,
    required TextEditingController domainController,
    required TextEditingController ipListController,
    required TextEditingController sslIdController,
    required TextEditingController websiteIdController,
  }) {
    final info = provider.bindDomainInfo;
    if (info == null) return;

    domainController.text = info.domain ?? '';
    ipListController.text = (info.allowIPs ?? const <String>[]).join('\n');
    sslIdController.text = info.sslID?.toString() ?? '';
    websiteIdController.text = info.websiteID?.toString() ?? '';
  }

  static Future<void> loadDomainBinding(
    BuildContext context, {
    required TextEditingController appInstallIdController,
    required TextEditingController domainController,
    required TextEditingController ipListController,
    required TextEditingController sslIdController,
    required TextEditingController websiteIdController,
  }) async {
    final l10n = context.l10n;
    final provider = context.read<AIProvider>();
    final appInstallId = parseInt(appInstallIdController.text);

    if (appInstallId == null || appInstallId <= 0) {
      SnackBarUtils.showSuccess(context, l10n.aiAppInstallIdRequired);
      return;
    }

    final success = await provider.getBindDomain(appInstallId: appInstallId);
    if (!context.mounted) return;

    if (success) {
      fillFromProvider(
        provider: provider,
        domainController: domainController,
        ipListController: ipListController,
        sslIdController: sslIdController,
        websiteIdController: websiteIdController,
      );
      SnackBarUtils.showSuccess(context, l10n.aiOperationSuccess);
      return;
    }

    SnackBarUtils.showError(
      context,
      l10n.aiOperationFailed(
        provider.errorMessage ?? l10n.commonUnknownError,
      ),
      action: SnackBarAction(
        label: l10n.commonRetry,
        onPressed: () {
          loadDomainBinding(
            context,
            appInstallIdController: appInstallIdController,
            domainController: domainController,
            ipListController: ipListController,
            sslIdController: sslIdController,
            websiteIdController: websiteIdController,
          );
        },
      ),
    );
  }

  static Future<void> submitDomainBinding(
    BuildContext context, {
    required GlobalKey<FormState> formKey,
    required TextEditingController appInstallIdController,
    required TextEditingController domainController,
    required TextEditingController ipListController,
    required TextEditingController sslIdController,
    required TextEditingController websiteIdController,
  }) async {
    if (!formKey.currentState!.validate()) return;

    final provider = context.read<AIProvider>();
    final appInstallId = parseInt(appInstallIdController.text) ?? 0;

    final success = await provider.bindDomain(
      appInstallId: appInstallId,
      domain: domainController.text.trim(),
      ipList: ipListController.text.trim().isEmpty
          ? null
          : ipListController.text.trim(),
      sslId: parseInt(sslIdController.text),
      websiteId: parseInt(websiteIdController.text),
    );

    if (!context.mounted) return;

    final l10n = context.l10n;

    if (success) {
      fillFromProvider(
        provider: provider,
        domainController: domainController,
        ipListController: ipListController,
        sslIdController: sslIdController,
        websiteIdController: websiteIdController,
      );
      SnackBarUtils.showSuccess(context, context.l10n.aiOperationSuccess);
      return;
    }

    SnackBarUtils.showError(
      context,
      l10n.aiOperationFailed(
        provider.errorMessage ?? l10n.commonUnknownError,
      ),
      action: SnackBarAction(
        label: l10n.commonRetry,
        onPressed: () {
          submitDomainBinding(
            context,
            formKey: formKey,
            appInstallIdController: appInstallIdController,
            domainController: domainController,
            ipListController: ipListController,
            sslIdController: sslIdController,
            websiteIdController: websiteIdController,
          );
        },
      ),
    );
  }

}
