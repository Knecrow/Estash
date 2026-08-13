import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/category.dart';

class SpendingRadarChart extends StatelessWidget {
  final Map<TransactionCategory, double> categoryTotals;

  const SpendingRadarChart({
    super.key,
    required this.categoryTotals,
  });

  @override
  Widget build(BuildContext context) {
    final categories = TransactionCategory.values;
    final maxSpend = categoryTotals.values.isEmpty
        ? 1.0
        : categoryTotals.values.reduce(math.max);
    final safeMax = maxSpend == 0 ? 1.0 : maxSpend;

    return AspectRatio(
      aspectRatio: 1.3,
      child: CustomPaint(
        painter: _RadarChartPainter(
          categories: categories,
          categoryTotals: categoryTotals,
          maxSpend: safeMax,
        ),
      ),
    );
  }
}

class _RadarChartPainter extends CustomPainter {
  final List<TransactionCategory> categories;
  final Map<TransactionCategory, double> categoryTotals;
  final double maxSpend;

  _RadarChartPainter({
    required this.categories,
    required this.categoryTotals,
    required this.maxSpend,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2.6;
    final numSides = categories.length;
    final angleStep = (2 * math.pi) / numSides;

    // Paint Grid Circles/Polygons
    final gridPaint = Paint()
      ..color = AppColors.cardDivider.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    const gridLevels = 3;
    for (int level = 1; level <= gridLevels; level++) {
      final levelRadius = radius * (level / gridLevels);
      final path = Path();
      for (int i = 0; i < numSides; i++) {
        final angle = i * angleStep - math.pi / 2;
        final x = center.dx + levelRadius * math.cos(angle);
        final y = center.dy + levelRadius * math.sin(angle);
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      canvas.drawPath(path, gridPaint);
    }

    // Paint Axis Lines
    final axisPaint = Paint()
      ..color = AppColors.cardDivider.withValues(alpha: 0.3)
      ..strokeWidth = 1.0;

    for (int i = 0; i < numSides; i++) {
      final angle = i * angleStep - math.pi / 2;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      canvas.drawLine(center, Offset(x, y), axisPaint);
    }

    // Data Polygon
    final dataPath = Path();
    final points = <Offset>[];

    for (int i = 0; i < numSides; i++) {
      final cat = categories[i];
      final spend = categoryTotals[cat] ?? 0.0;
      final ratio = (spend / maxSpend).clamp(0.12, 1.0);
      final pointRadius = radius * ratio;

      final angle = i * angleStep - math.pi / 2;
      final x = center.dx + pointRadius * math.cos(angle);
      final y = center.dy + pointRadius * math.sin(angle);
      final pt = Offset(x, y);
      points.add(pt);

      if (i == 0) {
        dataPath.moveTo(pt.dx, pt.dy);
      } else {
        dataPath.lineTo(pt.dx, pt.dy);
      }
    }
    dataPath.close();

    // Fill Polygon
    final fillPaint = Paint()
      ..color = AppColors.safeAccent.withValues(alpha: 0.35)
      ..style = PaintingStyle.fill;
    canvas.drawPath(dataPath, fillPaint);

    // Stroke Polygon
    final strokePaint = Paint()
      ..color = AppColors.safeAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawPath(dataPath, strokePaint);

    // Draw Data Point Circles
    final pointPaint = Paint()
      ..color = AppColors.safeAccent
      ..style = PaintingStyle.fill;

    for (final pt in points) {
      canvas.drawCircle(pt, 4.0, pointPaint);
    }

    // Draw Category Icons & Labels around Radar
    const textStyle = TextStyle(
      color: AppColors.textSecondary,
      fontSize: 10.5,
      fontWeight: FontWeight.w700,
    );

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (int i = 0; i < numSides; i++) {
      final cat = categories[i];
      final angle = i * angleStep - math.pi / 2;
      final labelRadius = radius + 20;
      final lx = center.dx + labelRadius * math.cos(angle);
      final ly = center.dy + labelRadius * math.sin(angle);

      textPainter.text = TextSpan(
        text: cat.label,
        style: textStyle,
      );
      textPainter.layout();

      final tx = lx - (textPainter.width / 2);
      final ty = ly - (textPainter.height / 2);
      textPainter.paint(canvas, Offset(tx, ty));
    }
  }

  @override
  bool shouldRepaint(covariant _RadarChartPainter oldDelegate) {
    return oldDelegate.maxSpend != maxSpend ||
        oldDelegate.categoryTotals != categoryTotals;
  }
}
