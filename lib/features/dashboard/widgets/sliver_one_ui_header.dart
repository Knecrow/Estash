import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/haptic_utils.dart';
import '../../../shared/widgets/animated_currency_text.dart';

class SliverOneUIHeader extends StatelessWidget {
  final double netBalance;
  final double todaySpend;
  final double dailyCap;
  final double warningThresholdPct;
  final double dangerThresholdPct;
  final String currencySymbol;
  final bool remindersEnabled;
  final VoidCallback? onToggleReminders;
  final double expandedHeight;

  const SliverOneUIHeader({
    super.key,
    required this.netBalance,
    required this.todaySpend,
    required this.dailyCap,
    required this.warningThresholdPct,
    required this.dangerThresholdPct,
    required this.currencySymbol,
    this.remindersEnabled = false,
    this.onToggleReminders,
    this.expandedHeight = 210.0,
  });

  @override
  Widget build(BuildContext context) {
    final spendRatio = dailyCap > 0 ? (todaySpend / dailyCap) : 0.0;
    
    final isDanger = netBalance < 0 || (dailyCap > 0 && spendRatio >= dangerThresholdPct && netBalance < (dailyCap * 0.25));
    final isWarning = !isDanger && (dailyCap > 0 && spendRatio >= warningThresholdPct && netBalance >= 0);

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

    return SliverAppBar(
      pinned: true,
      expandedHeight: expandedHeight,
      backgroundColor: AppColors.canvasBackground,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOutCubic,
          decoration: BoxDecoration(
            color: heroBgColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
          ),
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 46.0, bottom: 18.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Minimal Top Bar
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: badgeBgColor,
                    child: Icon(Icons.person_rounded, size: 20, color: badgeIconColor),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Estash',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: textPrimaryColor,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      HapticUtils.light();
                      if (onToggleReminders != null) onToggleReminders!();
                    },
                    borderRadius: BorderRadius.circular(19),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: badgeBgColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        remindersEnabled
                            ? Icons.notifications_active_rounded
                            : Icons.notifications_none_rounded,
                        color: badgeIconColor,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Total Balance Hero Container (Minimal Text)
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOutCubic,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: heroInnerCardColor,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: AnimatedCurrencyText(
                  value: netBalance,
                  currencySymbol: currencySymbol,
                  style: AppTextStyles.displayLarge.copyWith(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: textPrimaryColor,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
