import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_text_styles.dart';
import '../../providers/finance_provider.dart';
import '../../providers/settings_provider.dart';
import '../../shared/widgets/one_ui_card_container.dart';
import '../../shared/widgets/section_label.dart';
import 'widgets/chart_legend_row.dart';
import 'widgets/spending_radar_chart.dart';
import 'widgets/time_series_bar_chart.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final finance = context.watch<FinanceProvider>();
    final settings = context.watch<SettingsProvider>();

    final totals = finance.spendingByCategory;

    return Scaffold(
      backgroundColor: AppColors.canvasBackground,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.pagePadding),
          children: [
            const SizedBox(height: 8),
            Text(
              'Stats',
              style: AppTextStyles.displayMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
                fontSize: 30,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 14),

            // Radar Chart Section
            OneUICardContainer(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  SpendingRadarChart(categoryTotals: totals),
                  const SizedBox(height: 16),
                  ChartLegendRow(categoryMap: totals),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Time-Series Bar Chart Section
            const SectionLabel(label: 'Trends'),
            OneUICardContainer(
              padding: const EdgeInsets.all(20.0),
              child: TimeSeriesBarChart(
                dailyData: finance.dailySpendingMap,
                weeklyData: finance.weeklySpendingMap,
                monthlyData: finance.monthlySpendingMap,
                currencySymbol: settings.currencySymbol,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
