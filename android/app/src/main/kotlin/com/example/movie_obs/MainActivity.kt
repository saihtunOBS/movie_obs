package com.obs.movie

// MainActivity.kt

import android.content.ContentResolver
import android.database.ContentObserver
import android.net.Uri
import android.os.Handler
import android.os.Looper
import android.provider.Settings.System
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import com.folksable.volume_listener.VolumeListenerActivity

class MainActivity : VolumeListenerActivity() {
    private val EVENT_CHANNEL = "rotation_channel"
    private var rotationObserver: ContentObserver? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                    // Create observer
                    rotationObserver = object : ContentObserver(Handler(Looper.getMainLooper())) {
                        override fun onChange(selfChange: Boolean, uri: Uri?) {
                            try {
                                val isAutoRotateOn = System.getInt(
                                    contentResolver,
                                    System.ACCELEROMETER_ROTATION,
                                    0
                                ) == 1
                                events.success(isAutoRotateOn)
                                android.util.Log.d("RotationDetection", "Auto-rotate changed: $isAutoRotateOn")
                            } catch (e: Exception) {
                                events.error("ERROR", "Failed to get rotation state", e.toString())
                            }
                        }
                    }

                    // Register observer
                    try {
                        contentResolver.registerContentObserver(
                            System.getUriFor(System.ACCELEROMETER_ROTATION),
                            false,
                            rotationObserver!!
                        )
                        // Send initial state
                        val initialValue = System.getInt(
                            contentResolver,
                            System.ACCELEROMETER_ROTATION,
                            0
                        ) == 1
                        events.success(initialValue)
                        android.util.Log.d("RotationDetection", "Initial auto-rotate state: $initialValue")
                    } catch (e: Exception) {
                        events.error("ERROR", "Failed to register observer", e.toString())
                    }
                }

                override fun onCancel(arguments: Any?) {
                    rotationObserver?.let {
                        contentResolver.unregisterContentObserver(it)
                        rotationObserver = null
                    }
                    android.util.Log.d("RotationDetection", "Rotation observer cancelled")
                }
            }
        )
    }

    override fun onDestroy() {
        rotationObserver?.let {
            contentResolver.unregisterContentObserver(it)
        }
        super.onDestroy()
    }
}

