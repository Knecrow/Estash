import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../shared/widgets/one_ui_card_container.dart';

class MinBalanceAlertBanner extends StatelessWidget {
  final double netBalance;
  final String currencySymbol;
  final double threshold;

  const MinBalanceAlertBanner({
    super.key,
    required this.netBalance,
    required this.threshold,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: netBalance < threshold
          ? Padding(
              key: const ValueKey('alert'),
              padding: const EdgeInsets.only(bottom: 12.0),
              child: OneUICardContainer(
                backgroundColor: const Color(0xFF2B0C0C),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 14.0,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(
                        color: Color(0xFF401010),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.warning_amber_rounded,
                        color: AppColors.dangerAccent,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Low Balance Alert',
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.dangerAccent,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Balance below ${CurrencyFormatter.format(threshold, symbol: currencySymbol)} threshold',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const SizedBox.shrink(key: ValueKey('empty')),
    );
  }
}
