import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';

class NeonProgressBar extends StatelessWidget {
  final double progress; // 0.0 - 1.0
  final Color color;
  final double height;
  final Duration duration;

  const NeonProgressBar({
    super.key,
    required this.color,
    required this.progress,
    this.height = 10.0,
    this.duration = AppConstants.animMedium,
  });

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0);

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final filledWidth = totalWidth * clampedProgress;

        return Stack(
          children: [
            Container(
              height: height,
              width: totalWidth,
              decoration: BoxDecoration(
                color: AppColors.cardSurfaceElevated,
                borderRadius: BorderRadius.circular(height / 2),
              ),
            ),
            AnimatedContainer(
              duration: duration,
              curve: Curves.easeOutCubic,
              height: height,
              width: filledWidth,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(height / 2),
              ),
            ),
          ],
        );
      },
    );
  }
}
