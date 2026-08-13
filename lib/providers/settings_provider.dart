import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_colors.dart';
import '../data/repositories/settings_repository.dart';

class SettingsProvider extends ChangeNotifier {
  final SettingsRepository _repo;

  SettingsProvider(this._repo);

  double _dailyCap = 500.0;
  String _currencySymbol = '\$';
  double _minBalanceThreshold = 100.0;
  double _warningThresholdPct = 0.70;
  double _dangerThresholdPct = 0.90;
  bool _remindersEnabled = false;

  double get dailyCap => _dailyCap;
  String get currencySymbol => _currencySymbol;
  double get minBalanceThreshold => _minBalanceThreshold;
  double get warningThresholdPct => _warningThresholdPct;
  double get dangerThresholdPct => _dangerThresholdPct;
  bool get remindersEnabled => _remindersEnabled;

  Color capProgressColor(double spendRatio) {
    if (spendRatio < _warningThresholdPct) {
      return AppColors.safeAccent;
    } else if (spendRatio < _dangerThresholdPct) {
      return AppColors.warningAccent;
    } else {
      return AppColors.dangerAccent;
    }
  }

  double capProgress(double todaySpend) {
    if (_dailyCap <= 0) return 0.0;
    final ratio = todaySpend / _dailyCap;
    return ratio.clamp(0.0, 1.0);
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _dailyCap = _repo.getDailyCap(prefs);
    _currencySymbol = _repo.getCurrencySymbol(prefs);
    _minBalanceThreshold = _repo.getMinBalanceThreshold(prefs);
    _warningThresholdPct = _repo.getWarningThresholdPct(prefs);
    _dangerThresholdPct = _repo.getDangerThresholdPct(prefs);
    _remindersEnabled = _repo.getRemindersEnabled(prefs);
    notifyListeners();
  }

  Future<void> setDailyCap(double value) async {
    _dailyCap = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await _repo.setDailyCap(prefs, value);
  }

  Future<void> setCurrencySymbol(String symbol) async {
    _currencySymbol = symbol;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await _repo.setCurrencySymbol(prefs, symbol);
  }

  Future<void> setMinBalanceThreshold(double value) async {
    _minBalanceThreshold = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await _repo.setMinBalanceThreshold(prefs, value);
  }

  Future<void> setWarningThresholdPct(double pct) async {
    _warningThresholdPct = pct;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await _repo.setWarningThresholdPct(prefs, pct);
  }

  Future<void> setDangerThresholdPct(double pct) async {
    _dangerThresholdPct = pct;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await _repo.setDangerThresholdPct(prefs, pct);
  }

  Future<void> setRemindersEnabled(bool enabled) async {
    _remindersEnabled = enabled;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await _repo.setRemindersEnabled(prefs, enabled);
  }

  Future<void> resetToDefaults() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _dailyCap = 500.0;
    _currencySymbol = '\$';
    _minBalanceThreshold = 100.0;
    _warningThresholdPct = 0.70;
    _dangerThresholdPct = 0.90;
    _remindersEnabled = false;
    notifyListeners();
  }
}
