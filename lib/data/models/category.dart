import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 1)
enum TransactionCategory {
  @HiveField(0)
  food,
  @HiveField(1)
  outing,
  @HiveField(2)
  bills,
  @HiveField(3)
  shopping,
  @HiveField(4)
  donations,
  @HiveField(5)
  other,
}

extension TransactionCategoryX on TransactionCategory {
  String get label {
    switch (this) {
      case TransactionCategory.food:
        return 'Food';
      case TransactionCategory.outing:
        return 'Outing';
      case TransactionCategory.bills:
        return 'Bills';
      case TransactionCategory.shopping:
        return 'Shopping';
      case TransactionCategory.donations:
        return 'Donations';
      case TransactionCategory.other:
        return 'Other';
    }
  }

  IconData get iconData {
    switch (this) {
      case TransactionCategory.food:
        return Icons.restaurant_rounded;
      case TransactionCategory.outing:
        return Icons.sports_esports_rounded;
      case TransactionCategory.bills:
        return Icons.receipt_long_rounded;
      case TransactionCategory.shopping:
        return Icons.shopping_bag_rounded;
      case TransactionCategory.donations:
        return Icons.volunteer_activism_rounded;
      case TransactionCategory.other:
        return Icons.grid_view_rounded;
    }
  }
}
