package com.aeonian.gita

import android.os.Build
import android.os.Bundle
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Intent
import android.provider.Settings
import android.app.AlarmManager
import android.content.Context
import android.app.AppOpsManager
import android.app.AppOpsManager.MODE_ALLOWED

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.aeonian.gita/alarm_permission"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "requestExactAlarmPermission") {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                    if (!hasExactAlarmPermission()) {
                        val intent = Intent(Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM)
                        startActivityForResult(intent, 0)
                    }
                    result.success(true)
                } else {
                    result.success(true)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun hasExactAlarmPermission(): Boolean {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
            val appOps = getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
            return appOps.unsafeCheckOpNoThrow(
                "android:exact_alarm", 
                android.os.Process.myUid(), 
                applicationContext.packageName
            ) == MODE_ALLOWED
        }
        return true
    }
}
