package com.example.pdfview

import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    private val CHANNEL = "AttendanceAbsent"
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    
    // Create a MethodChannel to communicate with Flutter
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
        if (call.method == "getIntentData") {
            // Extract intent data here
            val intentData = intent.data?.toString()
            result.success(intentData)
        } else {
            result.notImplemented()
        }
    }
}
}
