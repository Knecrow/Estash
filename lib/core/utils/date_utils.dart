import 'package:intl/intl.dart';

abstract class AppDateUtils {
  static String formatShortDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  static String formatRelativeOrDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diffDays = today.difference(target).inDays;

    if (diffDays == 0) {
      return 'Today';
    } else if (diffDays == 1) {
      return 'Yesterday';
    } else {
      return DateFormat('MMM d').format(date);
    }
  }

  static String formatDayName(DateTime date) {
    return DateFormat('E').format(date);
  }

  static String formatMonthName(DateTime date) {
    return DateFormat('MMM').format(date);
  }
}
