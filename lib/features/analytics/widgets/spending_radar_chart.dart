import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../data/models/category.dart';

class SpendingRadarChart extends StatelessWidget {
  final Map<TransactionCategory, double> categoryTotals;
  final String currencySymbol;

  const SpendingRadarChart({
    super.key,
    required this.categoryTotals,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    final totalSpend = categoryTotals.values.fold(0.0, (sum, val) => sum + val);

    if (totalSpend == 0) {
      return Container(
        height: 220,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: AppColors.cardSurfaceElevated,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.radar_rounded,
                color: AppColors.textSecondary,
                size: 26,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'No expense stats yet',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
    }

    final maxSpend = categoryTotals.values.reduce(math.max);
    final safeMax = maxSpend <= 0 ? 1.0 : maxSpend;

    return AspectRatio(
      aspectRatio: 1.25,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
        builder: (context, animValue, child) {
          return CustomPaint(
            painter: _RadarChartPainter(
              categories: TransactionCategory.values,
              categoryTotals: categoryTotals,
              maxSpend: safeMax,
              animProgress: animValue,
            ),
          );
        },
      ),
    );
  }
}

class _RadarChartPainter extends CustomPainter {
  final List<TransactionCategory> categories;
  final Map<TransactionCategory, double> categoryTotals;
  final double maxSpend;
  final double animProgress;

  _RadarChartPainter({
    required this.categories,
    required this.categoryTotals,
    required this.maxSpend,
    required this.animProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2.8;
    final numSides = categories.length;
    final angleStep = (2 * math.pi) / numSides;

    // Grid Concentric Circles & Axis Spokes
    final gridPaint = Paint()
      ..color = AppColors.cardDivider.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final axisPaint = Paint()
      ..color = AppColors.cardDivider.withValues(alpha: 0.25)
      ..strokeWidth = 1.0;

    const gridLevels = 3;
    for (int level = 1; level <= gridLevels; level++) {
      final levelRadius = radius * (level / gridLevels);
      final gridPath = Path();
      for (int i = 0; i < numSides; i++) {
        final angle = i * angleStep - math.pi / 2;
        final x = center.dx + levelRadius * math.cos(angle);
        final y = center.dy + levelRadius * math.sin(angle);
        if (i == 0) {
          gridPath.moveTo(x, y);
        } else {
          gridPath.lineTo(x, y);
        }
      }
      gridPath.close();
      canvas.drawPath(gridPath, gridPaint);
    }

    // Spokes
    for (int i = 0; i < numSides; i++) {
      final angle = i * angleStep - math.pi / 2;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      canvas.drawLine(center, Offset(x, y), axisPaint);
    }

    // Compute Animated Polygon Points
    final dataPath = Path();

    for (int i = 0; i < numSides; i++) {
      final cat = categories[i];
      final spend = categoryTotals[cat] ?? 0.0;
      final rawRatio = maxSpend > 0 ? (spend / maxSpend) : 0.0;
      final ratio = spend > 0 ? (0.15 + 0.85 * rawRatio) * animProgress : 0.05 * animProgress;
      final pointRadius = radius * ratio;

      final angle = i * angleStep - math.pi / 2;
      final x = center.dx + pointRadius * math.cos(angle);
      final y = center.dy + pointRadius * math.sin(angle);
      final pt = Offset(x, y);

      if (i == 0) {
        dataPath.moveTo(pt.dx, pt.dy);
      } else {
        dataPath.lineTo(pt.dx, pt.dy);
      }
    }
    dataPath.close();

    // Fill Radar Polygon
    final fillPaint = Paint()
      ..color = AppColors.safeAccent.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;
    canvas.drawPath(dataPath, fillPaint);

    // Stroke Radar Polygon Boundary
    final strokePaint = Paint()
      ..color = AppColors.safeAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(dataPath, strokePaint);

    // Draw Category Spoke Labels Only (No Numbers, No Dots)
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (int i = 0; i < numSides; i++) {
      final cat = categories[i];
      final spend = categoryTotals[cat] ?? 0.0;
      final angle = i * angleStep - math.pi / 2;
      final labelRadius = radius + 20;

      final lx = center.dx + labelRadius * math.cos(angle);
      final ly = center.dy + labelRadius * math.sin(angle);

      textPainter.text = TextSpan(
        text: cat.label,
        style: TextStyle(
          color: spend > 0 ? AppColors.textPrimary : AppColors.textSecondary,
          fontSize: 11.0,
          fontWeight: spend > 0 ? FontWeight.bold : FontWeight.w500,
        ),
      );
      textPainter.textAlign = TextAlign.center;
      textPainter.layout();

      final tx = lx - (textPainter.width / 2);
      final ty = ly - (textPainter.height / 2);
      textPainter.paint(canvas, Offset(tx, ty));
    }
  }

  @override
  bool shouldRepaint(covariant _RadarChartPainter oldDelegate) {
    return oldDelegate.maxSpend != maxSpend ||
        oldDelegate.animProgress != animProgress ||
        oldDelegate.categoryTotals != categoryTotals;
  }
}
