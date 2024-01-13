package com.example.v2

import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.os.Build;

class MainActivity : FlutterActivity() {
    private val CHANNEL = "devyuji.com/anima"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            if (call.method == "toastMessage") {
                val text = call.argument<String>("text")
                val duration = Toast.LENGTH_SHORT

                val toast = Toast.makeText(applicationContext, text, duration)
                toast.show()
                result.success("")
            } else if (call.method == "SupportedAbis") {
                val abis = Build.SUPPORTED_ABIS;

                result.success(abis[0])
            } else {
                result.notImplemented()
            }
        }
    }
}
