import 'package:flutter_test/flutter_test.dart';
import 'package:onepanel_client/core/config/logger_config.dart';
import 'package:onepanel_client/core/services/logger/log_category.dart';

void main() {
  group('LoggerConfig.defaultCategoryForPackage', () {
    test('features.* maps to UI', () {
      expect(
        LoggerConfig.defaultCategoryForPackage('features.dashboard.dashboard_provider'),
        LogCategory.ui,
      );
    });

    test('core.network.* maps to NETWORK', () {
      expect(
        LoggerConfig.defaultCategoryForPackage('core.network.dio_client'),
        LogCategory.network,
      );
    });

    test('data.repositories.* maps to DB', () {
      expect(
        LoggerConfig.defaultCategoryForPackage('data.repositories.user'),
        LogCategory.db,
      );
    });

    test('features.auth.* maps to AUTH', () {
      expect(
        LoggerConfig.defaultCategoryForPackage('features.auth.login_provider'),
        LogCategory.auth,
      );
    });

    test('core.services.logger.* maps to SYSTEM', () {
      expect(
        LoggerConfig.defaultCategoryForPackage('core.services.logger.logger_service'),
        LogCategory.system,
      );
    });

    test('unknown package maps to UNCLASSIFIED', () {
      expect(
        LoggerConfig.defaultCategoryForPackage('mypackage.something'),
        LogCategory.unclassified,
      );
    });

    test('empty package maps to UNCLASSIFIED', () {
      expect(
        LoggerConfig.defaultCategoryForPackage(''),
        LogCategory.unclassified,
      );
    });
  });

  group('LogCategory', () {
    test('shortTag is non-empty for all values', () {
      for (final c in LogCategory.values) {
        expect(c.shortTag.isNotEmpty, isTrue, reason: '$c has no shortTag');
      }
    });

    test('label is non-empty for all values', () {
      for (final c in LogCategory.values) {
        expect(c.label.isNotEmpty, isTrue, reason: '$c has no label');
      }
    });
  });
}
