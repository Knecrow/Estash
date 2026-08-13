import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/haptic_utils.dart';

class HapticKeypad extends StatelessWidget {
  final ValueChanged<String> onKeyPress;
  final VoidCallback onDeletePress;

  const HapticKeypad({
    super.key,
    required this.onKeyPress,
    required this.onDeletePress,
  });

  @override
  Widget build(BuildContext context) {
    const keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['.', '0', 'DEL'],
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: keys.map((row) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: row.map((key) {
              final isDelete = key == 'DEL';
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: InkWell(
                    onTap: () {
                      HapticUtils.selection();
                      if (isDelete) {
                        onDeletePress();
                      } else {
                        onKeyPress(key);
                      }
                    },
                    borderRadius: BorderRadius.circular(16.0),
                    child: Container(
                      height: 52,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.inputBackground,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: isDelete
                          ? const Icon(
                              Icons.backspace_outlined,
                              color: AppColors.textPrimary,
                              size: 20,
                            )
                          : Text(
                              key,
                              style: AppTextStyles.titleLarge.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}
