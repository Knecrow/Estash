import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_utils.dart';
import '../../core/utils/haptic_utils.dart';
import '../../data/models/category.dart';
import '../../data/models/transaction.dart';
import 'one_ui_card_container.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;
  final String currencySymbol;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const TransactionTile({
    super.key,
    required this.transaction,
    required this.currencySymbol,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final amountColor = transaction.isExpense
        ? AppColors.negativeRed
        : AppColors.positiveGreen;
    final amountPrefix = transaction.isExpense ? '- ' : '+ ';

    return Dismissible(
      key: Key(transaction.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        HapticUtils.medium();
        onDelete();
      },
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        decoration: BoxDecoration(
          color: const Color(0xFF2B0C0C),
          borderRadius: BorderRadius.circular(22.0),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        child: const Icon(
          Icons.delete_outline_rounded,
          color: AppColors.dangerAccent,
          size: 24,
        ),
      ),
      child: OneUICardContainer(
        onTap: () {
          HapticUtils.light();
          onTap();
        },
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        child: Row(
          children: [
            // Flat Category Icon Badge
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.cardSurfaceElevated,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                transaction.category.iconData,
                color: transaction.isExpense
                    ? AppColors.negativeRed
                    : AppColors.safeAccent,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            // Title & Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.note != null && transaction.note!.isNotEmpty
                        ? transaction.note!
                        : transaction.category.label,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${transaction.category.label} • ${AppDateUtils.formatRelativeOrDate(transaction.date)}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Amount
            Text(
              '$amountPrefix${CurrencyFormatter.format(transaction.amount, symbol: currencySymbol)}',
              style: AppTextStyles.titleLarge.copyWith(
                color: amountColor,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
