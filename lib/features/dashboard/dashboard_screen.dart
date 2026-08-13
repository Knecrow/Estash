import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/notification_service.dart';
import '../../providers/finance_provider.dart';
import '../../providers/settings_provider.dart';
import '../../shared/widgets/one_ui_card_container.dart';
import '../../shared/widgets/section_label.dart';
import '../../shared/widgets/staggered_entrance.dart';
import '../../shared/widgets/transaction_tile.dart';
import '../transaction/add_transaction_sheet.dart';
import '../transaction/edit_transaction_sheet.dart';
import 'widgets/daily_cap_progress_card.dart';
import 'widgets/min_balance_alert_banner.dart';
import 'widgets/quick_add_fab_row.dart';
import 'widgets/sliver_one_ui_header.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  void _showUndoSnackBar(BuildContext context, FinanceProvider financeProvider) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Transaction deleted',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        backgroundColor: AppColors.cardSurface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: AppColors.safeAccent,
          onPressed: financeProvider.undoDelete,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final finance = context.watch<FinanceProvider>();
    final settings = context.watch<SettingsProvider>();

    final recentList = finance.recentTransactions;
    final progress = settings.capProgress(finance.todaySpend);
    final progressColor = settings.capProgressColor(progress);

    return Scaffold(
      backgroundColor: AppColors.canvasBackground,
      body: CustomScrollView(
        slivers: [
          SliverOneUIHeader(
            netBalance: finance.netBalance,
            todaySpend: finance.todaySpend,
            dailyCap: settings.dailyCap,
            warningThresholdPct: settings.warningThresholdPct,
            dangerThresholdPct: settings.dangerThresholdPct,
            currencySymbol: settings.currencySymbol,
            remindersEnabled: settings.remindersEnabled,
            onToggleReminders: () {
              final newStatus = !settings.remindersEnabled;
              settings.setRemindersEnabled(newStatus);
              if (newStatus) {
                NotificationService.schedulePeriodicReminders();
              } else {
                NotificationService.cancelReminders();
              }
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    newStatus
                        ? '30-Minute Reminders Enabled'
                        : '30-Minute Reminders Disabled',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  backgroundColor: AppColors.cardSurface,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
              );
            },
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.pagePadding,
              vertical: 12,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                MinBalanceAlertBanner(
                  netBalance: finance.netBalance,
                  threshold: settings.minBalanceThreshold,
                  currencySymbol: settings.currencySymbol,
                ),
                StaggeredEntrance(
                  index: 0,
                  child: DailyCapProgressCard(
                    todaySpend: finance.todaySpend,
                    dailyCap: settings.dailyCap,
                    progress: progress,
                    progressColor: progressColor,
                    currencySymbol: settings.currencySymbol,
                  ),
                ),
                const StaggeredEntrance(
                  index: 1,
                  child: SectionLabel(label: 'Transactions'),
                ),
                if (recentList.isEmpty)
                  StaggeredEntrance(
                    index: 2,
                    child: OneUICardContainer(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: const BoxDecoration(
                              color: AppColors.cardSurfaceElevated,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.receipt_long_rounded,
                              size: 28,
                              color: AppColors.safeAccent,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No transactions yet',
                            style: AppTextStyles.titleLarge.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tap Income or Expense to get started',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  StaggeredEntrance(
                    index: 2,
                    child: OneUICardContainer(
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: [
                          for (int i = 0; i < recentList.length; i++) ...[
                            TransactionTile(
                              transaction: recentList[i],
                              currencySymbol: settings.currencySymbol,
                              onDelete: () {
                                finance.deleteTransaction(recentList[i].id);
                                _showUndoSnackBar(context, finance);
                              },
                              onTap: () => EditTransactionSheet.show(context, recentList[i]),
                            ),
                            if (i < recentList.length - 1)
                              Divider(
                                color: AppColors.cardDivider.withValues(alpha: 0.3),
                                height: 1,
                                indent: 16,
                                endIndent: 16,
                              ),
                          ],
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: AppColors.canvasBackground,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: QuickAddFabRow(
              onAddIncome: () => AddTransactionSheet.show(context, isExpense: false),
              onAddExpense: () => AddTransactionSheet.show(context, isExpense: true),
            ),
          ),
        ),
      ),
    );
  }
}
