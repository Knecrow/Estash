import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract class AppTextStyles {
  static const TextStyle displayLarge = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    letterSpacing: 0.5,
  );

  // On-dark variants
  static const TextStyle displayMediumOnDark = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textOnDark,
    letterSpacing: -0.5,
  );

  static const TextStyle titleLargeOnDark = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textOnDark,
  );

  static const TextStyle bodyMediumOnDark = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textOnDarkMuted,
  );

  static const TextStyle labelSmallOnDark = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textOnDarkMuted,
    letterSpacing: 0.5,
  );
}
