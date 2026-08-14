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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: AppColors.cardDivider.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: progressColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.data_usage_rounded,
                  size: 14,
                  color: progressColor,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Today: ',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              AnimatedCurrencyText(
                value: todaySpend,
                currencySymbol: currencySymbol,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  fontSize: 14,
                ),
              ),
              Text(
                ' / ${CurrencyFormatter.format(dailyCap, symbol: currencySymbol)}',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
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
              color: progressColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Text(
              '$pctText%',
              style: TextStyle(
                color: progressColor,
                fontWeight: FontWeight.w900,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
