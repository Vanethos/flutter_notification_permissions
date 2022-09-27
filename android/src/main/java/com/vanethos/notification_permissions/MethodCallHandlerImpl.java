package com.vanethos.notification_permissions;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.provider.Settings;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.app.NotificationManagerCompat;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.PluginRegistry;

public class MethodCallHandlerImpl implements MethodCallHandler, PluginRegistry.RequestPermissionsResultListener {
  private static final String PERMISSION_GRANTED = "granted";
  private static final String PERMISSION_DENIED = "denied";

  private static final int REQUEST_CODE = MethodCallHandlerImpl.class.hashCode();

  private final Context applicationContext;

  @Nullable
  private Activity activity;

  @Nullable
  private MethodChannel.Result permissionRequestResult;

  public MethodCallHandlerImpl(Context applicationContext) {
    this.applicationContext = applicationContext;
  }

  public void setActivity(@Nullable Activity activity) {
    this.activity = activity;
    this.permissionRequestResult = null;
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
    if ("getNotificationPermissionStatus".equalsIgnoreCase(call.method)) {
      result.success(getNotificationPermissionStatus());
    } else if ("requestNotificationPermissions".equalsIgnoreCase(call.method)) {
      if (PERMISSION_DENIED.equalsIgnoreCase(getNotificationPermissionStatus())) {
        final Activity activity = this.activity;

        if (activity == null) {
          result.error(call.method, "context is not instance of Activity", null);
          return;
        }

        // Since TIRAMISU (API level 33) POST_NOTIFICATIONS permission can be requested
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
          permissionRequestResult = result;
          activity.requestPermissions(new String[]{Manifest.permission.POST_NOTIFICATIONS}, REQUEST_CODE);
          return;
        }

        // https://stackoverflow.com/a/45192258
        final Intent intent = new Intent();

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
          // ACTION_APP_NOTIFICATION_SETTINGS was introduced in API level 26 aka Android O
          intent.setAction(Settings.ACTION_APP_NOTIFICATION_SETTINGS);
          intent.putExtra(Settings.EXTRA_APP_PACKAGE, activity.getPackageName());
        } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
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

  @Override
  public boolean onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
    if (requestCode != REQUEST_CODE || permissions.length == 0) {
      return false;
    }

    if (permissionRequestResult != null) {
      permissionRequestResult.success(
              grantResults[0] == PackageManager.PERMISSION_GRANTED
                      ? PERMISSION_GRANTED
                      : PERMISSION_DENIED
      );
    }

    return true;
  }

  private String getNotificationPermissionStatus() {
    return (NotificationManagerCompat.from(applicationContext).areNotificationsEnabled())
            ? PERMISSION_GRANTED
            : PERMISSION_DENIED;
  }
}
