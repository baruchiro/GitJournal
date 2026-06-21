/*
 * SPDX-FileCopyrightText: 2026 Baruch Odem
 *
 * SPDX-License-Identifier: Apache-2.0
 */

package io.gitjournal.gitjournal

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

/**
 * A 1x1 home-screen widget that opens a new journal entry in a single tap.
 *
 * The tap launches [MainActivity] with the URI `gitjournal://widget/journal`,
 * which the Flutter side (see lib/app.dart) routes to the journal editor via
 * the home_widget `widgetClicked` / `initiallyLaunchedFromHomeWidget` APIs.
 */
class JournalWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.journal_widget).apply {
                val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java,
                    Uri.parse("gitjournal://widget/journal"),
                )
                setOnClickPendingIntent(R.id.widget_root, pendingIntent)
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
