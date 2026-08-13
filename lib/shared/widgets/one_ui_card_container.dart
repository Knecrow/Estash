import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import 'smooth_tap_scale.dart';

class OneUICardContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Color? backgroundColor;
  final Border? border;
  final VoidCallback? onTap;

  const OneUICardContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.borderRadius = AppConstants.cardRadius,
    this.backgroundColor,
    this.border,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardDecoration = BoxDecoration(
      color: backgroundColor ?? AppColors.cardSurface,
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      border: border,
    );

    final container = Container(
      padding: padding,
      decoration: cardDecoration,
      child: child,
    );

    if (onTap != null) {
      return SmoothTapScale(
        onTap: onTap,
        child: container,
      );
    }

    return container;
  }
}
