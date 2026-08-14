import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'core/utils/notification_service.dart';
import 'data/models/category.dart';
import 'data/models/transaction.dart';
import 'data/repositories/settings_repository.dart';
import 'data/repositories/transaction_repository.dart';
import 'providers/finance_provider.dart';
import 'providers/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TransactionCategoryAdapter());
    }
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TransactionAdapter());
    }

    if (!Hive.isBoxOpen(TransactionRepository.boxName)) {
      try {
        await Hive.openBox<Transaction>(TransactionRepository.boxName);
      } catch (boxError) {
        // If box is corrupted or locked from an earlier installation, recreate cleanly
        await Hive.deleteBoxFromDisk(TransactionRepository.boxName);
        await Hive.openBox<Transaction>(TransactionRepository.boxName);
      }
    }
  } catch (e, st) {
    debugPrint('Hive init error: $e\n$st');
  }

  try {
    await NotificationService.initialize();
  } catch (e, st) {
    debugPrint('NotificationService init error: $e\n$st');
  }

  final settingsRepo = SettingsRepository();
  final transactionRepo = TransactionRepository();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(settingsRepo)..loadSettings(),
        ),
        ChangeNotifierProxyProvider<SettingsProvider, FinanceProvider>(
          create: (_) => FinanceProvider(transactionRepo)..loadTransactions(),
          update: (_, settings, finance) =>
              (finance ?? FinanceProvider(transactionRepo))
                ..updateSettings(settings),
        ),
      ],
      child: const EstashApp(),
    ),
  );
}
