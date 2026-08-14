import 'package:hive/hive.dart';
import '../models/transaction.dart';

class TransactionRepository {
  static const String boxName = 'transactions';

  Box<Transaction>? get _box {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<Transaction>(boxName);
    }
    return null;
  }

  List<Transaction> getAll() {
    try {
      return _box?.values.toList() ?? [];
    } catch (_) {
      return [];
    }
  }

  Future<void> add(Transaction transaction) async {
    try {
      await _box?.put(transaction.id, transaction);
    } catch (_) {}
  }

  Future<void> update(Transaction transaction) async {
    try {
      await _box?.put(transaction.id, transaction);
    } catch (_) {}
  }

  Future<void> delete(String id) async {
    try {
      await _box?.delete(id);
    } catch (_) {}
  }

  Future<void> clearAll() async {
    try {
      await _box?.clear();
    } catch (_) {}
  }
}
