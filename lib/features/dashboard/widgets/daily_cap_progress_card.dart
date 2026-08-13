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
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
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
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '/ ${CurrencyFormatter.format(dailyCap, symbol: currencySymbol)}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
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
                  '$pctText%',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: progressColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
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
