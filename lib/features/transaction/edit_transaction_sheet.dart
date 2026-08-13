import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/date_utils.dart';
import '../../core/utils/haptic_utils.dart';
import '../../data/models/category.dart';
import '../../data/models/transaction.dart';
import '../../providers/finance_provider.dart';
import '../../providers/settings_provider.dart';
import 'widgets/category_selector_row.dart';
import 'widgets/haptic_keypad.dart';

class EditTransactionSheet extends StatefulWidget {
  final Transaction transaction;

  const EditTransactionSheet({
    super.key,
    required this.transaction,
  });

  static Future<void> show(BuildContext context, Transaction transaction) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.canvasBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
      ),
      builder: (_) => EditTransactionSheet(transaction: transaction),
    );
  }

  @override
  State<EditTransactionSheet> createState() => _EditTransactionSheetState();
}

class _EditTransactionSheetState extends State<EditTransactionSheet> {
  late bool _isExpense;
  late TransactionCategory _category;
  late DateTime _selectedDate;
  late TextEditingController _noteController;
  late String _amountString;

  @override
  void initState() {
    super.initState();
    _isExpense = widget.transaction.isExpense;
    _category = widget.transaction.category;
    _selectedDate = widget.transaction.date;
    _noteController = TextEditingController(text: widget.transaction.note ?? '');
    _amountString = widget.transaction.amount.toStringAsFixed(
      widget.transaction.amount.truncateToDouble() == widget.transaction.amount ? 0 : 2,
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _onKeyPress(String key) {
    setState(() {
      if (key == '.') {
        if (!_amountString.contains('.')) _amountString += '.';
      } else {
        if (_amountString == '0') {
          _amountString = key;
        } else {
          if (_amountString.contains('.')) {
            final parts = _amountString.split('.');
            if (parts.length > 1 && parts[1].length >= 2) return;
          }
          _amountString += key;
        }
      }
    });
  }

  void _onDeletePress() {
    setState(() {
      if (_amountString.length > 1) {
        _amountString = _amountString.substring(0, _amountString.length - 1);
      } else {
        _amountString = '0';
      }
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.safeAccent,
              surface: AppColors.canvasBackground,
              onPrimary: AppColors.actionDark,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _update() async {
    final amount = double.tryParse(_amountString) ?? 0.0;
    if (amount <= 0) return;

    final updated = widget.transaction.copyWith(
      amount: amount,
      isExpense: _isExpense,
      category: _isExpense ? _category : TransactionCategory.other,
      date: _selectedDate,
      note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
    );

    HapticUtils.heavy();
    await context.read<FinanceProvider>().updateTransaction(updated);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final currencySymbol = context.watch<SettingsProvider>().currencySymbol;
    final amountColor = _isExpense ? AppColors.negativeRed : AppColors.safeAccent;
    final btnColor = _isExpense ? AppColors.negativeRed : AppColors.safeAccent;
    final btnTextColor = _isExpense ? AppColors.textPrimary : AppColors.actionDark;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.canvasBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        top: 12,
        left: 16,
        right: 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.cardSurfaceElevated,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() {
                      _isExpense = true;
                      if (_category == TransactionCategory.other) {
                        _category = TransactionCategory.food;
                      }
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _isExpense ? AppColors.negativeRed : AppColors.cardSurface,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        'Expense',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _isExpense ? AppColors.textPrimary : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() {
                      _isExpense = false;
                      _category = TransactionCategory.other;
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: !_isExpense ? AppColors.safeAccent : AppColors.cardSurface,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        'Income',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          color: !_isExpense ? AppColors.actionDark : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                '$currencySymbol$_amountString',
                style: AppTextStyles.displayLarge.copyWith(
                  color: amountColor,
                  fontSize: 44,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            if (_isExpense) ...[
              const SizedBox(height: 16),
              CategorySelectorRow(
                selectedCategory: _category,
                onSelectCategory: (cat) => setState(() => _category = cat),
              ),
            ],
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _noteController,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      hintText: _isExpense ? 'Add note (optional)' : 'Income description (e.g. Salary, Refund)',
                      hintStyle: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      filled: true,
                      fillColor: AppColors.cardSurface,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.cardSurface,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_rounded, size: 18, color: AppColors.safeAccent),
                        const SizedBox(width: 6),
                        Text(
                          AppDateUtils.formatShortDate(_selectedDate),
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (MediaQuery.of(context).viewInsets.bottom == 0) ...[
              HapticKeypad(
                onKeyPress: _onKeyPress,
                onDeletePress: _onDeletePress,
              ),
              const SizedBox(height: 16),
            ],
            ElevatedButton(
              onPressed: _amountString == '0' ? null : _update,
              style: ElevatedButton.styleFrom(
                backgroundColor: btnColor,
                foregroundColor: btnTextColor,
                disabledBackgroundColor: AppColors.cardSurfaceElevated,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                _isExpense ? 'Update Expense' : 'Update Income',
                style: AppTextStyles.titleLarge.copyWith(
                  color: btnTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
