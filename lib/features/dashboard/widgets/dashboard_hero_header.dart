import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/haptic_utils.dart';
import '../../../shared/widgets/animated_currency_text.dart';

class DashboardHeroHeader extends StatelessWidget {
  final double netBalance;
  final double todaySpend;
  final double dailyCap;
  final double warningThresholdPct;
  final double dangerThresholdPct;
  final String currencySymbol;
  final bool remindersEnabled;
  final VoidCallback? onToggleReminders;

  const DashboardHeroHeader({
    super.key,
    required this.netBalance,
    required this.todaySpend,
    required this.dailyCap,
    required this.warningThresholdPct,
    required this.dangerThresholdPct,
    required this.currencySymbol,
    this.remindersEnabled = false,
    this.onToggleReminders,
  });

  @override
  Widget build(BuildContext context) {
    final spendRatio = dailyCap > 0 ? (todaySpend / dailyCap) : 0.0;

    final isDanger = netBalance < 0 ||
        (dailyCap > 0 &&
            spendRatio >= dangerThresholdPct &&
            netBalance < (dailyCap * 0.25));
    final isWarning = !isDanger &&
        (dailyCap > 0 && spendRatio >= warningThresholdPct && netBalance >= 0);

    final heroBgColor = isDanger
        ? AppColors.dangerAccent
        : isWarning
            ? AppColors.warningAccent
            : AppColors.heroBackground;

    final heroInnerCardColor = isDanger
        ? const Color(0xFFFF5959)
        : isWarning
            ? const Color(0xFFFFE466)
            : AppColors.heroCardSurface;

    final textPrimaryColor = isDanger
        ? const Color(0xFFFFFFFF)
        : isWarning
            ? const Color(0xFF1E1900)
            : AppColors.textOnLimePrimary;

    final badgeBgColor = isDanger
        ? const Color(0xFF990000)
        : isWarning
            ? const Color(0xFF423800)
            : AppColors.actionDark;

    final badgeIconColor = isDanger
        ? const Color(0xFFFFFFFF)
        : isWarning
            ? AppColors.warningAccent
            : AppColors.safeAccent;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
      decoration: BoxDecoration(
        color: heroBgColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      padding: EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        top: MediaQuery.of(context).padding.top + 8.0,
        bottom: 14.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top Profile & Action row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: badgeBgColor,
                child: Icon(Icons.person_rounded, size: 18, color: badgeIconColor),
              ),
              InkWell(
                onTap: () {
                  HapticUtils.light();
                  if (onToggleReminders != null) onToggleReminders!();
                },
                borderRadius: BorderRadius.circular(19),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: badgeBgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    remindersEnabled
                        ? Icons.notifications_active_rounded
                        : Icons.notifications_none_rounded,
                    color: badgeIconColor,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Title
          Text(
            'Estash',
            style: AppTextStyles.displayMedium.copyWith(
              color: textPrimaryColor,
              fontWeight: FontWeight.w900,
              fontSize: 28,
              letterSpacing: -1.0,
            ),
          ),
          const SizedBox(height: 8),
          // Fully pill-like balance card container
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOutCubic,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: heroInnerCardColor,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Center(
              child: AnimatedCurrencyText(
                value: netBalance,
                currencySymbol: currencySymbol,
                style: AppTextStyles.displayLarge.copyWith(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  color: textPrimaryColor,
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
