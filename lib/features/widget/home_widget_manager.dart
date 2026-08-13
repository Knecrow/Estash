import 'package:home_widget/home_widget.dart';

abstract class HomeWidgetManager {
  static const String appGroupId = 'group.com.estash.app';
  static const String androidWidgetName = 'EstashHomeWidgetProvider';

  static Future<void> updateWidgetData({
    required double netBalance,
    required double todaySpend,
    required String currencySymbol,
  }) async {
    try {
      await HomeWidget.saveWidgetData<String>(
        'net_balance',
        '$currencySymbol${netBalance.toStringAsFixed(2)}',
      );
      await HomeWidget.saveWidgetData<String>(
        'today_spend',
        '$currencySymbol${todaySpend.toStringAsFixed(2)}',
      );
      await HomeWidget.updateWidget(
        name: androidWidgetName,
        iOSName: 'EstashWidget',
      );
    } catch (_) {
      // Ignore if widgets not configured on current environment
    }
  }
}
