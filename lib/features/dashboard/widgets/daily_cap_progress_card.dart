import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../shared/widgets/animated_currency_text.dart';
import '../../../shared/widgets/neon_progress_bar.dart';
import '../../../shared/widgets/one_ui_card_container.dart';

class DailyCapProgressCard extends StatelessWidget {
  final double todaySpend;
  final double dailyCap;
  final double progress;
  final Color progressColor;
  final String currencySymbol;

  const DailyCapProgressCard({
    super.key,
    required this.todaySpend,
    required this.dailyCap,
    required this.progress,
    required this.progressColor,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    final pctText = (progress * 100).toStringAsFixed(0);

    return OneUICardContainer(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Today's Spend",
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 4.0,
                ),
                decoration: BoxDecoration(
                  color: AppColors.cardSurfaceElevated,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(
                  '$pctText% of Cap',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: progressColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              AnimatedCurrencyText(
                value: todaySpend,
                currencySymbol: currencySymbol,
                style: AppTextStyles.displayMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '/ ${CurrencyFormatter.format(dailyCap, symbol: currencySymbol)}',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          NeonProgressBar(
            progress: progress,
            color: progressColor,
            height: 10,
          ),
        ],
      ),
    );
  }
}
