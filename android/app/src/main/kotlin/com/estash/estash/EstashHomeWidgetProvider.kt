package com.estash.estash

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

class EstashHomeWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.home_widget).apply {
                val netBalance = widgetData.getString("net_balance", "$0.00")
                val todaySpend = widgetData.getString("today_spend", "$0.00")
                setTextViewText(R.id.net_balance, netBalance)
                setTextViewText(R.id.today_spend, "Today: $todaySpend")
            }
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
