package com.vanethos.notification_permissions;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.provider.Settings;

import androidx.core.app.NotificationManagerCompat;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class NotificationPermissionsPlugin implements MethodChannel.MethodCallHandler {
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel =
        new MethodChannel(registrar.messenger(), "notification_permissions");
    channel.setMethodCallHandler(new NotificationPermissionsPlugin(registrar));
  }

  private static final String PERMISSION_GRANTED = "granted";
  private static final String PERMISSION_DENIED = "denied";

  private final Context context;
  private final Activity activity;

  private NotificationPermissionsPlugin(Registrar registrar) {
    this.context = registrar.context();
    this.activity = registrar.activity();
  }

  @Override
  public void onMethodCall(MethodCall call, MethodChannel.Result result) {
    if ("getNotificationPermissionStatus".equalsIgnoreCase(call.method)) {
      result.success(getNotificationPermissionStatus());
    } else if ("requestNotificationPermissions".equalsIgnoreCase(call.method)) {
      if (PERMISSION_DENIED.equalsIgnoreCase(getNotificationPermissionStatus())) {
        if (activity == null) {
          result.error(call.method, "activity is null", null);
          return;
        }

        // https://stackoverflow.com/a/45192258
        final Intent intent = new Intent();

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
          // ACTION_APP_NOTIFICATION_SETTINGS was introduced in API level 26 aka Android O
          intent.setAction(Settings.ACTION_APP_NOTIFICATION_SETTINGS);
          intent.putExtra(Settings.EXTRA_APP_PACKAGE, activity.getPackageName());
        } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP){
          intent.setAction("android.settings.APP_NOTIFICATION_SETTINGS");
          intent.putExtra("app_package", activity.getPackageName());
          intent.putExtra("app_uid", activity.getApplicationInfo().uid);
        } else {
          intent.setAction(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
          intent.addCategory(Intent.CATEGORY_DEFAULT);
          intent.setData(Uri.parse("package:" + activity.getPackageName()));
        }

        activity.startActivity(intent);

        result.success(PERMISSION_DENIED);
      } else {
        result.success(PERMISSION_GRANTED);
      }
    } else {
      result.notImplemented();
    }
  }

  private String getNotificationPermissionStatus() {
    return (NotificationManagerCompat.from(context).areNotificationsEnabled())
        ? PERMISSION_GRANTED
        : PERMISSION_DENIED;
  }
}
