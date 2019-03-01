package com.vanethos.notification_permissions

import android.app.NotificationManager
import android.content.Intent
import android.net.Uri
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import android.support.v4.app.NotificationManagerCompat
import android.support.v4.content.ContextCompat.startActivity
import android.net.Uri.fromParts
import android.provider.Settings
import android.provider.Settings.ACTION_APPLICATION_DETAILS_SETTINGS
import android.support.v4.view.accessibility.AccessibilityEventCompat.setAction
import android.app.Activity



class NotificationPermissionsPlugin(val registrar: Registrar): MethodCallHandler {
  val permissionGranted = "granted"
  val permissionDenied = "denied"

  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "notification_permissions")
      channel.setMethodCallHandler(NotificationPermissionsPlugin(registrar))
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "getNotificationPermissionStatus") {
      result.success(getNotificationStatus())
    } else if (call.method == "requestNotificationPermissions") {
      if (getNotificationStatus() == permissionDenied) {
        val activity = registrar.activity()
        if (activity == null) {
          result.error("NO_ACTIVITY", "Launching a URL requires a foreground activity.", null)
          return
        }
        val intent = Intent()
        intent.action = Settings.ACTION_APPLICATION_DETAILS_SETTINGS
        val uri = Uri.fromParts("package", activity.packageName, null)
        intent.data = uri
        activity.startActivity(intent)
      }
      result.success(null)
    } else {
      result.notImplemented()
    }
  }

  private fun getNotificationStatus() : String {
    return if (NotificationManagerCompat.from(registrar.context()).areNotificationsEnabled()) permissionGranted else permissionDenied
  }
}
