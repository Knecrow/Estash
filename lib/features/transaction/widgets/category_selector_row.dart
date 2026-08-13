import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/haptic_utils.dart';
import '../../../data/models/category.dart';

class CategorySelectorRow extends StatelessWidget {
  final TransactionCategory selectedCategory;
  final ValueChanged<TransactionCategory> onSelectCategory;

  const CategorySelectorRow({
    super.key,
    required this.selectedCategory,
    required this.onSelectCategory,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: TransactionCategory.values.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final cat = TransactionCategory.values[index];
          final isSelected = cat == selectedCategory;

          return InkWell(
            onTap: () {
              HapticUtils.light();
              onSelectCategory(cat);
            },
            borderRadius: BorderRadius.circular(16.0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 74,
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.safeAccent
                    : AppColors.inputBackground,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    cat.iconData,
                    color: isSelected
                        ? AppColors.actionDark
                        : AppColors.textSecondary,
                    size: 24,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    cat.label,
                    style: AppTextStyles.labelSmall.copyWith(
                      fontSize: 10,
                      color: isSelected
                          ? AppColors.actionDark
                          : AppColors.textSecondary,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
