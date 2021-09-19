package com.vanethos.notification_permissions;

import android.app.Activity;
import android.content.Context;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;

public class NotificationPermissionsPlugin implements FlutterPlugin, ActivityAware {
  @SuppressWarnings("deprecation")
  public static void registerWith(io.flutter.plugin.common.PluginRegistry.Registrar registrar) {
    final NotificationPermissionsPlugin plugin = new NotificationPermissionsPlugin();
    plugin.onAttachedToEngine(registrar.context(), registrar.messenger());

    if (registrar.activity() != null) {
      plugin.onActivityChanged(registrar.activity());
    }
  }

  @Nullable
  private MethodChannel channel;

  @Nullable
  private MethodCallHandlerImpl methodCallHandler;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    onAttachedToEngine(binding.getApplicationContext(), binding.getBinaryMessenger());
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    if (channel != null) {
      channel.setMethodCallHandler(null);
    }
    channel = null;
  }

  private void onAttachedToEngine(Context applicationContext, BinaryMessenger messenger) {
    channel = new MethodChannel(messenger, "notification_permissions");
    methodCallHandler = new MethodCallHandlerImpl(applicationContext);
    channel.setMethodCallHandler(methodCallHandler);
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    onActivityChanged(binding.getActivity());
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    onActivityChanged(null);
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    onActivityChanged(binding.getActivity());
  }

  @Override
  public void onDetachedFromActivity() {
    onActivityChanged(null);
  }

  private void onActivityChanged(@Nullable Activity activity) {
    if (methodCallHandler != null) {
      methodCallHandler.setActivity(activity);
    }
  }
}
