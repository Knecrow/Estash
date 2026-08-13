import 'package:intl/intl.dart';

abstract class CurrencyFormatter {
  static String format(double amount, {String symbol = '\$', int decimalDigits = 2}) {
    final formatter = NumberFormat.currency(
      symbol: symbol,
      decimalDigits: decimalDigits,
    );
    return formatter.format(amount);
  }

  static String formatCompact(double amount, {String symbol = '\$'}) {
    final formatter = NumberFormat.compactCurrency(symbol: symbol);
    return formatter.format(amount);
  }
}
