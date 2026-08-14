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
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    'Daily Cap  ',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  AnimatedCurrencyText(
                    value: todaySpend,
                    currencySymbol: currencySymbol,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '/ ${CurrencyFormatter.format(dailyCap, symbol: currencySymbol)}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 2.0,
                ),
                decoration: BoxDecoration(
                  color: AppColors.cardSurfaceElevated,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  '$pctText%',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: progressColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          NeonProgressBar(
            progress: progress,
            color: progressColor,
            height: 5,
          ),
        ],
      ),
    );
  }
}
