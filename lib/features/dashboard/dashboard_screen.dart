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
import 'widgets/dashboard_hero_header.dart';
import 'widgets/min_balance_alert_banner.dart';
import 'widgets/quick_add_fab_row.dart';

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

    final transactions = finance.allTransactions;
    final progress = settings.capProgress(finance.todaySpend);
    final progressColor = settings.capProgressColor(progress);

    return Scaffold(
      backgroundColor: AppColors.canvasBackground,
      body: Column(
        children: [
          // ── Fixed / Pinned Top Header ─────────────────────────
          DashboardHeroHeader(
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
                  content: Row(
                    children: [
                      Icon(
                        newStatus
                            ? Icons.notifications_active_rounded
                            : Icons.notifications_off_rounded,
                        color: newStatus ? AppColors.safeAccent : AppColors.textSecondary,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          newStatus
                              ? '30-Minute Reminders Enabled'
                              : '30-Minute Reminders Disabled',
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
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

          // ── Fixed Overview (Daily Cap Badge & Section Label) ───
          Padding(
            padding: const EdgeInsets.only(
              left: AppConstants.pagePadding,
              right: AppConstants.pagePadding,
              top: 8,
              bottom: 4,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MinBalanceAlertBanner(
                  netBalance: finance.netBalance,
                  threshold: settings.minBalanceThreshold,
                  currencySymbol: settings.currencySymbol,
                ),
                DailyCapProgressCard(
                  todaySpend: finance.todaySpend,
                  dailyCap: settings.dailyCap,
                  progress: progress,
                  progressColor: progressColor,
                  currencySymbol: settings.currencySymbol,
                ),
                const SectionLabel(
                  label: 'Transactions',
                  padding: EdgeInsets.only(left: 4.0, right: 4.0, top: 8.0, bottom: 6.0),
                ),
              ],
            ),
          ),

          // ── Scrollable Transactions Area ─────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.pagePadding,
              ),
              child: transactions.isEmpty
                  ? SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: StaggeredEntrance(
                        index: 2,
                        child: OneUICardContainer(
                          padding: const EdgeInsets.all(28.0),
                          child: Column(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: const BoxDecoration(
                                  color: AppColors.cardSurfaceElevated,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.receipt_long_rounded,
                                  size: 24,
                                  color: AppColors.safeAccent,
                                ),
                              ),
                              const SizedBox(height: 12),
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
                      ),
                    )
                  : StaggeredEntrance(
                      index: 2,
                      child: ClipRRect(
                        borderRadius: AppConstants.squircleRadius,
                        child: OneUICardContainer(
                          padding: EdgeInsets.zero,
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            physics: const BouncingScrollPhysics(),
                            itemCount: transactions.length,
                            separatorBuilder: (_, __) => Divider(
                              color: AppColors.cardDivider.withValues(alpha: 0.3),
                              height: 1,
                              indent: 16,
                              endIndent: 16,
                            ),
                            itemBuilder: (context, i) {
                              return TransactionTile(
                                transaction: transactions[i],
                                currencySymbol: settings.currencySymbol,
                                onDelete: () {
                                  finance.deleteTransaction(transactions[i].id);
                                  _showUndoSnackBar(context, finance);
                                },
                                onTap: () => EditTransactionSheet.show(
                                  context,
                                  transactions[i],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 6),
        ],
      ),
      bottomNavigationBar: Container(
        color: AppColors.canvasBackground,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
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
