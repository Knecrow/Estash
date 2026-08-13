import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/models/category.dart';

class SpendingDonutChart extends StatefulWidget {
  final Map<TransactionCategory, double> categoryMap;
  final String currencySymbol;

  const SpendingDonutChart({
    super.key,
    required this.categoryMap,
    required this.currencySymbol,
  });

  static Color getCategoryColor(TransactionCategory cat) {
    switch (cat) {
      case TransactionCategory.food:
        return AppColors.safeAccent;
      case TransactionCategory.outing:
        return AppColors.warningAccent;
      case TransactionCategory.bills:
        return AppColors.negativeRed;
      case TransactionCategory.shopping:
        return const Color(0xFF00D2FF);
      case TransactionCategory.donations:
        return const Color(0xFFA855F7);
      case TransactionCategory.other:
        return const Color(0xFFFF9F43);
    }
  }

  @override
  State<SpendingDonutChart> createState() => _SpendingDonutChartState();
}

class _SpendingDonutChartState extends State<SpendingDonutChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final totalExpense = widget.categoryMap.values.fold(0.0, (a, b) => a + b);

    if (totalExpense == 0) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            'No expense data to analyze',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    final categoryList = widget.categoryMap.keys.toList();
    final sections = widget.categoryMap.entries.map((entry) {
      final cat = entry.key;
      final amount = entry.value;
      if (amount <= 0) return null;

      final isTouched = categoryList.indexOf(cat) == touchedIndex;
      final radius = isTouched ? 38.0 : 28.0;
      final pct = (amount / totalExpense * 100).toStringAsFixed(0);

      return PieChartSectionData(
        color: SpendingDonutChart.getCategoryColor(cat),
        value: amount,
        title: '$pct%',
        radius: radius,
        titleStyle: AppTextStyles.labelSmall.copyWith(
          color: Colors.black,
          fontWeight: FontWeight.w900,
          fontSize: isTouched ? 13 : 11,
        ),
      );
    }).whereType<PieChartSectionData>().toList();

    return SizedBox(
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              borderData: FlBorderData(show: false),
              sectionsSpace: 4,
              centerSpaceRadius: 64,
              sections: sections,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Total Spent',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                CurrencyFormatter.formatCompact(totalExpense, symbol: widget.currencySymbol),
                style: AppTextStyles.headlineMedium.copyWith(
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                  fontSize: 22,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
