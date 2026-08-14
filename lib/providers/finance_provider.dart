import 'package:flutter/material.dart';
import '../data/models/category.dart';
import '../data/models/transaction.dart';
import '../data/repositories/transaction_repository.dart';
import 'settings_provider.dart';

class FinanceProvider extends ChangeNotifier {
  final TransactionRepository _repo;

  FinanceProvider(this._repo);

  List<Transaction> _transactions = [];
  Transaction? _lastDeleted;
  bool _isLoading = false;
  SettingsProvider? _settingsProvider;

  List<Transaction> get allTransactions => List.unmodifiable(_transactions);

  List<Transaction> get recentTransactions {
    final sorted = List<Transaction>.from(_transactions)
      ..sort((a, b) => b.date.compareTo(a.date));
    return sorted.take(5).toList();
  }

  double get totalIncome {
    return _transactions
        .where((t) => !t.isExpense)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get totalExpenses {
    return _transactions
        .where((t) => t.isExpense)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get netBalance => totalIncome - totalExpenses;

  double get todaySpend {
    final now = DateTime.now();
    return _transactions
        .where((t) =>
            t.isExpense &&
            t.date.year == now.year &&
            t.date.month == now.month &&
            t.date.day == now.day)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  Map<TransactionCategory, double> get spendingByCategory {
    final map = <TransactionCategory, double>{};
    for (final cat in TransactionCategory.values) {
      map[cat] = 0.0;
    }
    for (final t in _transactions.where((t) => t.isExpense)) {
      map[t.category] = (map[t.category] ?? 0.0) + t.amount;
    }
    return map;
  }

  Map<DateTime, double> get dailySpendingMap {
    final map = <DateTime, double>{};
    final now = DateTime.now();
    for (int i = 6; i >= 0; i--) {
      final date = DateTime(now.year, now.month, now.day).subtract(Duration(days: i));
      map[date] = 0.0;
    }
    for (final t in _transactions.where((t) => t.isExpense)) {
      final d = DateTime(t.date.year, t.date.month, t.date.day);
      if (map.containsKey(d)) {
        map[d] = (map[d] ?? 0.0) + t.amount;
      }
    }
    return map;
  }

  Map<DateTime, double> get weeklySpendingMap {
    final map = <DateTime, double>{};
    final now = DateTime.now();
    for (int i = 3; i >= 0; i--) {
      final weekStart = DateTime(now.year, now.month, now.day).subtract(Duration(days: i * 7));
      map[weekStart] = 0.0;
    }
    for (final t in _transactions.where((t) => t.isExpense)) {
      for (final weekStart in map.keys) {
        final weekEnd = weekStart.add(const Duration(days: 7));
        if (t.date.isAfter(weekStart.subtract(const Duration(seconds: 1))) &&
            t.date.isBefore(weekEnd)) {
          map[weekStart] = (map[weekStart] ?? 0.0) + t.amount;
          break;
        }
      }
    }
    return map;
  }

  Map<DateTime, double> get monthlySpendingMap {
    final map = <DateTime, double>{};
    final now = DateTime.now();
    for (int i = 5; i >= 0; i--) {
      final m = DateTime(now.year, now.month - i, 1);
      map[m] = 0.0;
    }
    for (final t in _transactions.where((t) => t.isExpense)) {
      final m = DateTime(t.date.year, t.date.month, 1);
      if (map.containsKey(m)) {
        map[m] = (map[m] ?? 0.0) + t.amount;
      }
    }
    return map;
  }

  bool get isLoading => _isLoading;
  bool get hasUndoItem => _lastDeleted != null;

  void updateSettings(SettingsProvider settings) {
    _settingsProvider = settings;
  }

  Future<void> loadTransactions() async {
    _isLoading = true;
    notifyListeners();
    try {
      _transactions = _repo.getAll();
      _sortTransactions();
    } catch (_) {
      _transactions = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTransaction(Transaction t) async {
    await _repo.add(t);
    _transactions.add(t);
    _sortTransactions();
    notifyListeners();
  }

  Future<void> updateTransaction(Transaction t) async {
    await _repo.update(t);
    final idx = _transactions.indexWhere((item) => item.id == t.id);
    if (idx != -1) {
      _transactions[idx] = t;
    }
    _sortTransactions();
    notifyListeners();
  }

  Future<void> deleteTransaction(String id) async {
    final idx = _transactions.indexWhere((item) => item.id == id);
    if (idx != -1) {
      _lastDeleted = _transactions[idx];
      _transactions.removeAt(idx);
      await _repo.delete(id);
      notifyListeners();
    }
  }

  Future<void> undoDelete() async {
    if (_lastDeleted != null) {
      final t = _lastDeleted!;
      _lastDeleted = null;
      await addTransaction(t);
    }
  }

  Future<void> clearAllData() async {
    await _repo.clearAll();
    _transactions.clear();
    _lastDeleted = null;
    notifyListeners();
  }

  void _sortTransactions() {
    _transactions.sort((a, b) => b.date.compareTo(a.date));
  }
}
