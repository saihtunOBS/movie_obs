package com.obs.movie

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.provider.Settings
import io.flutter.plugin.common.EventChannel

class AutoRotateService(private val context: Context) : EventChannel.StreamHandler {
    private var receiver: BroadcastReceiver? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        receiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                val resolver = context?.contentResolver
                val isEnabled = Settings.System.getInt(resolver, Settings.System.ACCELEROMETER_ROTATION, 0) == 1
                events?.success(isEnabled)
            }
        }

        val filter = IntentFilter(Settings.ACTION_SETTINGS)
        
        // ✅ Fix: Specify RECEIVER_NOT_EXPORTED to prevent crash on Android 13+
        context.registerReceiver(receiver, filter, Context.RECEIVER_NOT_EXPORTED)
    }

    override fun onCancel(arguments: Any?) {
        context.unregisterReceiver(receiver)
    }
}

