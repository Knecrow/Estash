import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/category.dart';
import 'spending_donut_chart.dart';

class ChartLegendRow extends StatelessWidget {
  final Map<TransactionCategory, double> categoryMap;

  const ChartLegendRow({
    super.key,
    required this.categoryMap,
  });

  @override
  Widget build(BuildContext context) {
    final activeCategories = categoryMap.entries.where((e) => e.value > 0).toList();

    if (activeCategories.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 16,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: activeCategories.map((entry) {
        final cat = entry.key;
        final color = SpendingDonutChart.getCategoryColor(cat);

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              cat.label,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
