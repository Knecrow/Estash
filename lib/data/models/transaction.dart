import 'package:hive/hive.dart';
import 'category.dart';

part 'transaction.g.dart';

@HiveType(typeId: 0)
class Transaction extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late double amount;

  @HiveField(2)
  late bool isExpense;

  @HiveField(3)
  late TransactionCategory category;

  @HiveField(4)
  late DateTime date;

  @HiveField(5)
  String? note;

  Transaction({
    required this.id,
    required this.amount,
    required this.isExpense,
    required this.category,
    required this.date,
    this.note,
  });

  Transaction copyWith({
    String? id,
    double? amount,
    bool? isExpense,
    TransactionCategory? category,
    DateTime? date,
    String? note,
  }) {
    return Transaction(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      isExpense: isExpense ?? this.isExpense,
      category: category ?? this.category,
      date: date ?? this.date,
      note: note ?? this.note,
    );
  }
}
