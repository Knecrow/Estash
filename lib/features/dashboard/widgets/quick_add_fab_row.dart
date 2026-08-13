import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/haptic_utils.dart';

class QuickAddFabRow extends StatelessWidget {
  final VoidCallback onAddIncome;
  final VoidCallback onAddExpense;

  const QuickAddFabRow({
    super.key,
    required this.onAddIncome,
    required this.onAddExpense,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              HapticUtils.light();
              onAddIncome();
            },
            icon: const Icon(Icons.add_rounded, size: 20),
            label: const Text('Income'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.safeAccent,
              foregroundColor: AppColors.actionDark,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              textStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              HapticUtils.light();
              onAddExpense();
            },
            icon: const Icon(Icons.remove_rounded, size: 20),
            label: const Text('Expense'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.negativeRed,
              foregroundColor: AppColors.textPrimary,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              textStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
