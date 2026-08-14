import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class SectionLabel extends StatelessWidget {
  final String label;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;

  const SectionLabel({
    super.key,
    required this.label,
    this.trailing,
    this.padding = const EdgeInsets.only(left: 4.0, right: 4.0, top: 8.0, bottom: 6.0),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.textPrimary,
              fontSize: 16,
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
