import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  static const String _keyDailyCap = 'daily_cap';
  static const String _keyCurrencySymbol = 'currency_symbol';
  static const String _keyMinBalanceThreshold = 'min_balance_threshold';
  static const String _keyWarningThresholdPct = 'warning_threshold_pct';
  static const String _keyDangerThresholdPct = 'danger_threshold_pct';
  static const String _keyRemindersEnabled = 'reminders_enabled';

  double getDailyCap(SharedPreferences prefs) {
    return prefs.getDouble(_keyDailyCap) ?? 500.0;
  }

  Future<bool> setDailyCap(SharedPreferences prefs, double value) {
    return prefs.setDouble(_keyDailyCap, value);
  }

  String getCurrencySymbol(SharedPreferences prefs) {
    return prefs.getString(_keyCurrencySymbol) ?? '\$';
  }

  Future<bool> setCurrencySymbol(SharedPreferences prefs, String symbol) {
    return prefs.setString(_keyCurrencySymbol, symbol);
  }

  double getMinBalanceThreshold(SharedPreferences prefs) {
    return prefs.getDouble(_keyMinBalanceThreshold) ?? 100.0;
  }

  Future<bool> setMinBalanceThreshold(SharedPreferences prefs, double value) {
    return prefs.setDouble(_keyMinBalanceThreshold, value);
  }

  double getWarningThresholdPct(SharedPreferences prefs) {
    return prefs.getDouble(_keyWarningThresholdPct) ?? 0.70;
  }

  Future<bool> setWarningThresholdPct(SharedPreferences prefs, double pct) {
    return prefs.setDouble(_keyWarningThresholdPct, pct);
  }

  double getDangerThresholdPct(SharedPreferences prefs) {
    return prefs.getDouble(_keyDangerThresholdPct) ?? 0.90;
  }

  Future<bool> setDangerThresholdPct(SharedPreferences prefs, double pct) {
    return prefs.setDouble(_keyDangerThresholdPct, pct);
  }

  bool getRemindersEnabled(SharedPreferences prefs) {
    return prefs.getBool(_keyRemindersEnabled) ?? false;
  }

  Future<bool> setRemindersEnabled(SharedPreferences prefs, bool enabled) {
    return prefs.setBool(_keyRemindersEnabled, enabled);
  }
}
