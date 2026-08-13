import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/one_ui_card_container.dart';

class ThresholdSliderTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final double value;
  final Color activeColor;
  final ValueChanged<double> onChanged;

  const ThresholdSliderTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.activeColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final pctText = (value * 100).toStringAsFixed(0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: OneUICardContainer(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.cardSurfaceElevated,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    icon,
                    color: activeColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      fontSize: 15,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.cardSurfaceElevated,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$pctText%',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: activeColor,
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: activeColor,
                inactiveTrackColor: AppColors.cardSurfaceElevated,
                thumbColor: activeColor,
                overlayColor: Colors.transparent,
                trackHeight: 6,
              ),
              child: Slider(
                value: value,
                min: 0.1,
                max: 1.0,
                divisions: 18,
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
