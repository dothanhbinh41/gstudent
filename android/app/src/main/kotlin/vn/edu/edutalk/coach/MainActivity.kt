package vn.edu.edutalk.coach

import android.Manifest
import android.app.Activity
import android.os.Build
import android.os.Bundle
import android.view.WindowManager
import androidx.core.app.ActivityCompat
import com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin
import com.facebook.FacebookSdk
import com.facebook.appevents.AppEventsLogger
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.PluginRegistry


class MainActivity: FlutterActivity() , PluginRegistry.PluginRegistrantCallback {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            window.attributes.layoutInDisplayCutoutMode = WindowManager.LayoutParams.LAYOUT_IN_DISPLAY_CUTOUT_MODE_SHORT_EDGES
        }
        window.setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN)
        FacebookSdk.sdkInitialize(applicationContext)
        AppEventsLogger.activateApp(this.application)
        requestBlePermissions(this,1)
    }
    private val BLE_PERMISSIONS = arrayOf<String>(
            Manifest.permission.ACCESS_COARSE_LOCATION,
            Manifest.permission.ACCESS_FINE_LOCATION)

    private val ANDROID_12_BLE_PERMISSIONS = arrayOf<String>(
            Manifest.permission.BLUETOOTH_SCAN,
            Manifest.permission.BLUETOOTH_CONNECT,
            Manifest.permission.ACCESS_FINE_LOCATION)



    fun requestBlePermissions(activity: Activity, requestCode: Int) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) ActivityCompat.requestPermissions(activity, ANDROID_12_BLE_PERMISSIONS, requestCode) else ActivityCompat.requestPermissions(activity, BLE_PERMISSIONS, requestCode)
    }

    override fun registerWith(registry: PluginRegistry) {
//        TODO("Not yet implemented")
        if (!registry!!.hasPlugin("com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin")) {
            FlutterLocalNotificationsPlugin.registerWith(registry!!.registrarFor("com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin"));
        }
    }

}
