package com.motorhome

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.PersistableBundle
import android.os.PowerManager
import android.provider.Settings
import android.util.Log
import android.view.WindowManager
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val METHOD_CHANNEL = "com.motorhome.method.channel"
    private val EVENT_CHANNEL = "com.motorhome.event.channel"

    override fun onCreate(savedInstanceState: Bundle?) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            this.setTurnScreenOn(true);
        } else {
            window.addFlags(WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON);
        }
        (getSystemService(POWER_SERVICE) as PowerManager)
            .newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "Motorhome::WakeLock")
            .acquire(10000L)
        setScreenTimeout()
        super.onCreate(savedInstanceState)
    }

    private fun setScreenTimeout() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (Settings.System.canWrite(this)) {
                Settings.System.putInt(contentResolver, Settings.System.SCREEN_OFF_TIMEOUT, 2147483000);
            } else {
                startActivity(Intent(Settings.ACTION_MANAGE_WRITE_SETTINGS))
            }
        }
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        flutterEngine.dartExecutor.binaryMessenger.let {
            MethodChannel(it, METHOD_CHANNEL).setMethodCallHandler(ChannelHandler)
            EventChannel(it, EVENT_CHANNEL).setStreamHandler(ChannelHandler)
        }
    }
}
