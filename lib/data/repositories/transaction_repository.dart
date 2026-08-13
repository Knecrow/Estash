import 'package:hive/hive.dart';
import '../models/transaction.dart';

class TransactionRepository {
  static const String boxName = 'transactions';

  Box<Transaction> get _box => Hive.box<Transaction>(boxName);

  List<Transaction> getAll() {
    return _box.values.toList();
  }

  Future<void> add(Transaction transaction) async {
    await _box.put(transaction.id, transaction);
  }

  Future<void> update(Transaction transaction) async {
    await _box.put(transaction.id, transaction);
  }

  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  Future<void> clearAll() async {
    await _box.clear();
  }
}
