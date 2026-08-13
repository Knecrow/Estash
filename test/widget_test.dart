import 'package:estash/core/constants/app_colors.dart';
import 'package:estash/data/repositories/settings_repository.dart';
import 'package:estash/providers/settings_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SettingsProvider Unit Tests', () {
    late SettingsProvider settingsProvider;

    setUp(() {
      settingsProvider = SettingsProvider(SettingsRepository());
    });

    test('Default values check', () {
      expect(settingsProvider.dailyCap, equals(500.0));
      expect(settingsProvider.currencySymbol, equals('\$'));
      expect(settingsProvider.minBalanceThreshold, equals(100.0));
      expect(settingsProvider.warningThresholdPct, equals(0.70));
      expect(settingsProvider.dangerThresholdPct, equals(0.90));
      expect(settingsProvider.remindersEnabled, isFalse);
    });

    test('Cap progress color transitions dynamically', () {
      // < 70% -> Safe Accent (Neon Green)
      expect(settingsProvider.capProgressColor(0.50), equals(AppColors.safeAccent));

      // 70%-90% -> Warning Accent (Neon Yellow)
      expect(settingsProvider.capProgressColor(0.75), equals(AppColors.warningAccent));

      // > 90% -> Danger Accent (Neon Pink-Red)
      expect(settingsProvider.capProgressColor(0.95), equals(AppColors.dangerAccent));
    });

    test('Cap progress clamping', () {
      expect(settingsProvider.capProgress(250.0), equals(0.5));
      expect(settingsProvider.capProgress(600.0), equals(1.0));
      expect(settingsProvider.capProgress(0.0), equals(0.0));
    });
  });
}
