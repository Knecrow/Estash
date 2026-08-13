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

  await Hive.initFlutter();
  Hive.registerAdapter(TransactionCategoryAdapter());
  Hive.registerAdapter(TransactionAdapter());

  await Hive.openBox<Transaction>(TransactionRepository.boxName);

  await NotificationService.initialize();

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
