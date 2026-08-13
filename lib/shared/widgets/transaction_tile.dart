import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_utils.dart';
import '../../core/utils/haptic_utils.dart';
import '../../data/models/category.dart';
import '../../data/models/transaction.dart';
import 'smooth_tap_scale.dart';

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
    final amountText = CurrencyFormatter.format(
      transaction.amount,
      symbol: currencySymbol,
    );

    return Dismissible(
      key: Key(transaction.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        HapticUtils.medium();
        onDelete();
      },
      background: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF2B0C0C),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        child: const Icon(
          Icons.delete_outline_rounded,
          color: AppColors.dangerAccent,
          size: 24,
        ),
      ),
      child: SmoothTapScale(
        onTap: () {
          HapticUtils.light();
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          child: Row(
            children: [
              // Flat Category Icon Badge
              Container(
                width: 44,
                height: 44,
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
                    const SizedBox(height: 2),
                    Text(
                      AppDateUtils.formatRelativeOrDate(transaction.date),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Amount
              Text(
                '${transaction.isExpense ? '-' : '+'}$amountText',
                style: AppTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                  color: transaction.isExpense
                      ? AppColors.negativeRed
                      : AppColors.positiveGreen,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
