import 'dart:async';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

class NotificationPermissions {
  static const MethodChannel _channel =
      const MethodChannel('notification_permissions');

  Future<void> requestNotificationPermissions(
      [IosNotificationSettings iosSettings = const IosNotificationSettings()]) {
    return _channel.invokeMethod(
        'requestNotificationPermissions', iosSettings.toMap());
  }

  Future<PermissionStatus> getNotificationPermissionStatus() async {
    final String status =
        await _channel.invokeMethod('getNotificationPermissionStatus');
    return _getPermissionStatus(status);
  }

  /// Gets the PermissionStatus from the channel Method
  ///
  /// Given a [String] status from the method channel, it returns a
  /// [PermissionStatus]
  PermissionStatus _getPermissionStatus(String status) {
    switch (status) {
      case "denied":
        return PermissionStatus.denied;
      case "granted":
        return PermissionStatus.granted;
      default:
        return PermissionStatus.unknown;
    }
  }
}

enum PermissionStatus { granted, unknown, denied }

class IosNotificationSettings {
  const IosNotificationSettings({
    this.sound = true,
    this.alert = true,
    this.badge = true,
  });

  IosNotificationSettings._fromMap(Map<String, bool> settings)
      : sound = settings['sound'],
        alert = settings['alert'],
        badge = settings['badge'];

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
