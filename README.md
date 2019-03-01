# Flutter Notification Permissions
Package to check for and ask for Notification Permissions on iOS and Android.

To use this package, you first must create an instance of `NotificationPermissions`:

```dart
var permissionManager = new NotificationPermissions();
```

## Checking Notification Permission Status
```dart
Future<PermissionStatus> permissionStatus =
    permissionManager.getNotificationPermissionStatus()
```

This method will return an enum with the following values:

```dart
enum PermissionStatus {
	granted,
	unknown,
	denied
}
```

In iOS, a permission is `unknown` when the user hasn’t accepted or refuse the notification permissions. In Android this state will never occur, since the permission will be `granted` by default and it will be `denied` if the user goes to the app settings and turns off notifications for the app.

## Requesting Notification Permissions
If the `PermissionStatus` is `denied` or `unknown`, we can ask the user for the Permissions:
```dart
Future<PermissionStatus> permissionStatus = permissionManager.getNotificationPermissionStatus()
```

On Android, if the permission is `denied`, this method will open the app settings.

In iOS, if the permission is `unknown`, it will show an alert window asking the user for the permission. On the other hand, if the permission is `denied` it has the same behaviour as Android, opening the app settings.

Note: if the permission is `granted`, this method will not do anything.

