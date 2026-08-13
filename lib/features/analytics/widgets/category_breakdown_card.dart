import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../data/models/category.dart';
import '../../../../shared/widgets/neon_progress_bar.dart';

class CategoryBreakdownCard extends StatelessWidget {
  final Map<TransactionCategory, double> categoryTotals;
  final String currencySymbol;

  const CategoryBreakdownCard({
    super.key,
    required this.categoryTotals,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    final totalSpend = categoryTotals.values.fold(0.0, (sum, val) => sum + val);
    final sortedEntries = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    if (totalSpend == 0) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: AppColors.cardSurfaceElevated,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.pie_chart_outline_rounded,
                color: AppColors.textSecondary,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'No expenses recorded yet',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: sortedEntries.map((entry) {
        final category = entry.key;
        final amount = entry.value;
        final pct = totalSpend > 0 ? (amount / totalSpend) : 0.0;
        final pctString = (pct * 100).toStringAsFixed(0);

        if (amount == 0) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.only(bottom: 14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: AppColors.cardSurfaceElevated,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      category.iconData,
                      size: 18,
                      color: AppColors.safeAccent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      category.label,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Text(
                    CurrencyFormatter.format(amount, symbol: currencySymbol),
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.cardSurfaceElevated,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$pctString%',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.safeAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              NeonProgressBar(
                progress: pct,
                color: AppColors.safeAccent,
                height: 6,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
