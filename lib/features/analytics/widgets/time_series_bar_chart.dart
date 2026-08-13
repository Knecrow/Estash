import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_utils.dart';

enum TimeSeriesRange { daily, weekly, monthly }

class TimeSeriesBarChart extends StatefulWidget {
  final Map<DateTime, double> dailyData;
  final Map<DateTime, double> weeklyData;
  final Map<DateTime, double> monthlyData;
  final String currencySymbol;

  const TimeSeriesBarChart({
    super.key,
    required this.dailyData,
    required this.weeklyData,
    required this.monthlyData,
    required this.currencySymbol,
  });

  @override
  State<TimeSeriesBarChart> createState() => _TimeSeriesBarChartState();
}

class _TimeSeriesBarChartState extends State<TimeSeriesBarChart> {
  TimeSeriesRange _selectedRange = TimeSeriesRange.daily;

  Map<DateTime, double> get _activeData {
    switch (_selectedRange) {
      case TimeSeriesRange.daily:
        return widget.dailyData;
      case TimeSeriesRange.weekly:
        return widget.weeklyData;
      case TimeSeriesRange.monthly:
        return widget.monthlyData;
    }
  }

  String _formatLabel(DateTime dt) {
    switch (_selectedRange) {
      case TimeSeriesRange.daily:
        return AppDateUtils.formatDayName(dt);
      case TimeSeriesRange.weekly:
        return 'W${(dt.day ~/ 7) + 1}';
      case TimeSeriesRange.monthly:
        return AppDateUtils.formatMonthName(dt);
    }
  }

  @override
  Widget build(BuildContext context) {
    final entries = _activeData.entries.toList();
    final maxY = entries.fold(0.0, (prev, e) => e.value > prev ? e.value : prev);

    return Column(
      children: [
        // Segmented Control
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: TimeSeriesRange.values.map((range) {
              final isSelected = range == _selectedRange;
              final label = range.name[0].toUpperCase() + range.name.substring(1);
              return GestureDetector(
                onTap: () => setState(() => _selectedRange = range),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.safeAccent : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    label,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: isSelected ? AppColors.actionDark : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 180,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxY == 0 ? 100 : maxY * 1.2,
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (_) => AppColors.cardSurfaceElevated,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      CurrencyFormatter.format(rod.toY, symbol: widget.currencySymbol),
                      AppTextStyles.labelSmall.copyWith(
                        color: AppColors.safeAccent,
                        fontWeight: FontWeight.w900,
                      ),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final idx = value.toInt();
                      if (idx < 0 || idx >= entries.length) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          _formatLabel(entries[idx].key),
                          style: AppTextStyles.labelSmall.copyWith(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: maxY == 0 ? 50 : maxY / 4,
                getDrawingHorizontalLine: (_) => FlLine(
                  color: AppColors.cardSurfaceElevated,
                  strokeWidth: 1,
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups: List.generate(entries.length, (i) {
                final amount = entries[i].value;
                return BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: amount,
                      color: AppColors.safeAccent,
                      width: 16,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(8),
                      ),
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        toY: maxY == 0 ? 100 : maxY * 1.2,
                        color: AppColors.cardSurfaceElevated,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
