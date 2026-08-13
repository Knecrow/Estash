import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_currencies.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/haptic_utils.dart';
import '../../core/utils/notification_service.dart';
import '../../providers/finance_provider.dart';
import '../../providers/settings_provider.dart';
import 'widgets/settings_section_header.dart';
import 'widgets/settings_tile.dart';
import 'widgets/threshold_slider_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const String _githubUrl = 'https://github.com/Knecrow/Estash';
  static const String _creatorName = 'Knecrow';
  static const String _appVersion = 'v1.0.0';

  Future<void> _openGitHub(BuildContext context) async {
    HapticUtils.light();
    final uri = Uri.parse(_githubUrl);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        await Clipboard.setData(const ClipboardData(text: _githubUrl));
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('GitHub link copied to clipboard!'),
              backgroundColor: AppColors.cardSurface,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          );
        }
      }
    } catch (_) {
      await Clipboard.setData(const ClipboardData(text: _githubUrl));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('GitHub link copied to clipboard!'),
            backgroundColor: AppColors.cardSurface,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
      }
    }
  }

  void _showNumberInputDialog(
    BuildContext context, {
    required String title,
    required double initialValue,
    required String currencySymbol,
    required ValueChanged<double> onSave,
  }) {
    final controller = TextEditingController(text: initialValue.toStringAsFixed(0));
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.cardSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Text(
            title,
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              prefixText: currencySymbol,
              prefixStyle: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.safeAccent,
                fontWeight: FontWeight.bold,
              ),
              filled: true,
              fillColor: AppColors.inputBackground,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.safeAccent,
                foregroundColor: AppColors.actionDark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                final val = double.tryParse(controller.text);
                if (val != null && val >= 0) onSave(val);
                Navigator.pop(context);
              },
              child: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  void _showCurrencyPickerSheet(BuildContext context, SettingsProvider settings) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            String searchQuery = '';
            final filteredItems = AppCurrencies.items.where((c) {
              final query = searchQuery.toLowerCase();
              return c.country.toLowerCase().contains(query) ||
                  c.name.toLowerCase().contains(query) ||
                  c.code.toLowerCase().contains(query) ||
                  c.symbol.toLowerCase().contains(query);
            }).toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.cardSurfaceElevated,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Select Currency',
                    style: AppTextStyles.titleLarge.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    onChanged: (q) => setState(() => searchQuery = q),
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Search by country or currency code...',
                      hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                      prefixIcon: const Icon(Icons.search_rounded, color: AppColors.safeAccent),
                      filled: true,
                      fillColor: AppColors.inputBackground,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.separated(
                      itemCount: filteredItems.length,
                      separatorBuilder: (_, __) => const Divider(color: Colors.transparent, height: 4),
                      itemBuilder: (context, index) {
                        final currency = filteredItems[index];
                        final isSelected = settings.currencySymbol == currency.symbol;

                        return InkWell(
                          onTap: () {
                            HapticUtils.selection();
                            settings.setCurrencySymbol(currency.symbol);
                            Navigator.pop(context);
                          },
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.safeAccent.withValues(alpha: 0.15)
                                  : AppColors.inputBackground,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  currency.flag,
                                  style: const TextStyle(fontSize: 24),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${currency.country} (${currency.code})',
                                        style: AppTextStyles.bodyLarge.copyWith(
                                          color: isSelected
                                              ? AppColors.safeAccent
                                              : AppColors.textPrimary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        currency.name,
                                        style: AppTextStyles.bodyMedium.copyWith(
                                          color: AppColors.textSecondary,
                                          fontSize: 12.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.cardSurface,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    currency.symbol,
                                    style: AppTextStyles.titleLarge.copyWith(
                                      color: isSelected
                                          ? AppColors.safeAccent
                                          : AppColors.textPrimary,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showResetConfirmationDialog(
    BuildContext context,
    FinanceProvider finance,
    SettingsProvider settings,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.cardSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Text(
            'Reset All Data?',
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.dangerAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'This will permanently delete all transactions and restore settings to default. This action cannot be undone.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.dangerAccent,
                foregroundColor: AppColors.textPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () async {
                await finance.clearAllData();
                await settings.resetToDefaults();
                NotificationService.cancelReminders();
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('All app data has been reset'),
                      backgroundColor: AppColors.cardSurface,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  );
                }
              },
              child: const Text('Reset', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final finance = context.watch<FinanceProvider>();
    final activeCurrency = AppCurrencies.findBySymbol(settings.currencySymbol);

    return Scaffold(
      backgroundColor: AppColors.canvasBackground,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.pagePadding),
          children: [
            const SizedBox(height: 12),
            Text(
              'Settings',
              style: AppTextStyles.displayMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
                fontSize: 30,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            const SettingsSectionHeader(title: 'Spending Limits'),
            SettingsTile(
              icon: Icons.speed_rounded,
              title: 'Daily Spending Cap',
              subtitle: CurrencyFormatter.format(settings.dailyCap, symbol: settings.currencySymbol),
              onTap: () => _showNumberInputDialog(
                context,
                title: 'Daily Cap',
                initialValue: settings.dailyCap,
                currencySymbol: settings.currencySymbol,
                onSave: settings.setDailyCap,
              ),
            ),
            SettingsTile(
              icon: Icons.account_balance_rounded,
              title: 'Min. Balance Alert',
              subtitle: CurrencyFormatter.format(settings.minBalanceThreshold, symbol: settings.currencySymbol),
              onTap: () => _showNumberInputDialog(
                context,
                title: 'Minimum Balance',
                initialValue: settings.minBalanceThreshold,
                currencySymbol: settings.currencySymbol,
                onSave: settings.setMinBalanceThreshold,
              ),
            ),
            const SettingsSectionHeader(title: 'Warning Thresholds'),
            ThresholdSliderTile(
              icon: Icons.warning_amber_rounded,
              title: 'Warning Level (Yellow)',
              value: settings.warningThresholdPct,
              activeColor: AppColors.warningAccent,
              onChanged: (val) {
                if (val < settings.dangerThresholdPct) {
                  settings.setWarningThresholdPct(val);
                }
              },
            ),
            ThresholdSliderTile(
              icon: Icons.error_outline_rounded,
              title: 'Danger Level (Red)',
              value: settings.dangerThresholdPct,
              activeColor: AppColors.dangerAccent,
              onChanged: (val) {
                if (val > settings.warningThresholdPct) {
                  settings.setDangerThresholdPct(val);
                }
              },
            ),
            const SettingsSectionHeader(title: 'Preferences'),
            SettingsTile(
              icon: Icons.public_rounded,
              title: 'Currency & Country',
              subtitle: '${activeCurrency.flag} ${activeCurrency.country} (${activeCurrency.symbol})',
              onTap: () => _showCurrencyPickerSheet(context, settings),
            ),
            const SettingsSectionHeader(title: 'Notifications'),
            SettingsTile(
              icon: Icons.notifications_none_rounded,
              title: '30-Minute Reminders',
              subtitle: settings.remindersEnabled ? 'Enabled' : 'Disabled',
              trailing: Switch(
                value: settings.remindersEnabled,
                activeThumbColor: AppColors.actionDark,
                activeTrackColor: AppColors.safeAccent,
                onChanged: (enabled) {
                  settings.setRemindersEnabled(enabled);
                  if (enabled) {
                    NotificationService.schedulePeriodicReminders();
                  } else {
                    NotificationService.cancelReminders();
                  }
                },
              ),
            ),
            const SettingsSectionHeader(title: 'Data Management'),
            SettingsTile(
              icon: Icons.restart_alt_rounded,
              title: 'Reset All Data',
              subtitle: 'Clear all transactions & reset settings',
              onTap: () => _showResetConfirmationDialog(context, finance, settings),
            ),
            const SettingsSectionHeader(title: 'About Estash'),
            SettingsTile(
              icon: Icons.code_rounded,
              title: 'Creator',
              subtitle: _creatorName,
            ),
            SettingsTile(
              icon: Icons.open_in_new_rounded,
              title: 'GitHub Repository',
              subtitle: _githubUrl,
              onTap: () => _openGitHub(context),
            ),
            SettingsTile(
              icon: Icons.info_outline_rounded,
              title: 'App Version',
              subtitle: 'Estash $_appVersion',
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
