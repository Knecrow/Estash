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
    this.expandedHeight = 230.0,
  });

  @override
  Widget build(BuildContext context) {
    final spendRatio = dailyCap > 0 ? (todaySpend / dailyCap) : 0.0;
    
    // Danger: Only if total balance is negative OR spending exceeds cap with low/negative net balance
    final isDanger = netBalance < 0 || (dailyCap > 0 && spendRatio >= dangerThresholdPct && netBalance < (dailyCap * 0.25));
    
    // Warning: Spending ratio reached warning threshold but net balance is positive
    final isWarning = !isDanger && (dailyCap > 0 && spendRatio >= warningThresholdPct && netBalance >= 0);

    // Dynamic Whole Hero Card Background Colors
    final heroBgColor = isDanger
        ? AppColors.dangerAccent // Pure Crimson Red
        : isWarning
            ? AppColors.warningAccent // Electric Yellow
            : AppColors.heroBackground; // Vibrant Neon Lime

    final heroInnerCardColor = isDanger
        ? const Color(0xFFFF5959) // Soft Crimson Red
        : isWarning
            ? const Color(0xFFFFE466) // Soft Yellow
            : AppColors.heroCardSurface; // Soft Lime

    final textPrimaryColor = isDanger
        ? const Color(0xFFFFFFFF) // Crisp White on Red
        : isWarning
            ? const Color(0xFF1E1900) // Deep Dark Charcoal on Yellow
            : AppColors.textOnLimePrimary; // Pitch Black on Green

    final textSecondaryColor = isDanger
        ? const Color(0xFFFFD6D6)
        : isWarning
            ? const Color(0xFF423800)
            : AppColors.textOnLimeSecondary;

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
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 48.0, bottom: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar (Profile + Working Notification Bell Button)
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
                  // Functional Bell Button
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

              // Total Balance Hero Card
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOutCubic,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: heroInnerCardColor,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'TOTAL BALANCE',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: textSecondaryColor,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    AnimatedCurrencyText(
                      value: netBalance,
                      currencySymbol: currencySymbol,
                      style: AppTextStyles.displayLarge.copyWith(
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        color: textPrimaryColor,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
