package com.motorhome

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val METHOD_CHANNEL = "com.motorhome.method.channel"
    private val EVENT_CHANNEL = "com.motorhome.event.channel"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        flutterEngine.dartExecutor.binaryMessenger.let {
            MethodChannel(it, METHOD_CHANNEL).setMethodCallHandler(ChannelHandler)
            EventChannel(it, EVENT_CHANNEL).setStreamHandler(ChannelHandler)
        }
    }
}
