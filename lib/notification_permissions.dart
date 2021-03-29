import 'dart:async';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

class NotificationPermissions {
  static const MethodChannel _channel =
      const MethodChannel('notification_permissions');

  static Future<PermissionStatus> requestNotificationPermissions(
      {NotificationSettingsIos iosSettings = const NotificationSettingsIos(),
      bool openSettings = true}) async {
    final map = iosSettings.toMap();
    map["openSettings"] = openSettings;
    String? status =
        await _channel.invokeMethod('requestNotificationPermissions', map);
    // If we cant determine the status then pass unknown
    return _getPermissionStatus(status ?? "unknown");
  }

  static Future<PermissionStatus> getNotificationPermissionStatus() async {
    final String? status =
        await _channel.invokeMethod('getNotificationPermissionStatus');
    // If we cant determine the status then pass unknown
    return _getPermissionStatus(status ?? "unknown");
  }

  /// Gets the PermissionStatus from the channel Method
  ///
  /// Given a [String] status from the method channel, it returns a
  /// [PermissionStatus]
  static PermissionStatus _getPermissionStatus(String status) {
    switch (status) {
      case "denied":
        return PermissionStatus.denied;
      case "granted":
        return PermissionStatus.granted;
      case "provisional":
        return PermissionStatus.provisional;
      default:
        return PermissionStatus.unknown;
    }
  }
}

enum PermissionStatus { granted, unknown, denied, provisional }

class NotificationSettingsIos {
  const NotificationSettingsIos({
    this.sound = true,
    this.alert = true,
    this.badge = true,
  });
  // if we cant find a value from map set it as false instead of null
  NotificationSettingsIos._fromMap(Map<String, bool> settings)
      : sound = settings['sound'] ?? false,
        alert = settings['alert'] ?? false,
        badge = settings['badge'] ?? false;

  final bool sound;
  final bool alert;
  final bool badge;

  @visibleForTesting
  Map<String, dynamic> toMap() {
    return <String, bool>{'sound': sound, 'alert': alert, 'badge': badge};
  }

  @override
  String toString() => 'PushNotificationSettings ${toMap()}';
}
