# Flutter Notification Permissions
Package to check for and ask for Notification Permissions on iOS and Android.

## Checking Notification Permission Status
```dart
Future<PermissionStatus> permissionStatus =
    NotificationPermissions.getNotificationPermissionStatus();
```

This method will return an enum with the following values:

```dart
enum PermissionStatus {
  provisional, // iOS Only
	granted,
	unknown,
	denied
}
```

In iOS, a permission is `unknown` when the user hasn’t accepted or refuse the notification permissions. In Android this state will never occur, since the permission will be `granted` by default and it will be `denied` if the user goes to the app settings and turns off notifications for the app. The `provisional` status will also offer the same behavior.

## Requesting Notification Permissions
If the `PermissionStatus` is `denied` or `unknown`, we can ask the user for the Permissions:
```dart
Future<PermissionStatus> permissionStatus = NotificationPermissions.requestNotificationPermissions({NotificationSettingsIos iosSettings, bool openSettings});
```

On Android, if the permission is `denied`, this method will open the app settings.

In iOS, if the permission is `unknown` or `provisional`, it will show an alert window asking the user for the permission. On the other hand, if the permission is `denied` it has the same behaviour as Android, opening the app settings.
Also in iOS if you set `openSettings` to false settings window won't be opened. You will get `denied` status. 
`NotificationPermissions.requestNotificationPermissions` returns status after user select answer from native permission popup.

Note: if the permission is `granted`, this method will not do anything.

## iOS Error: Swift.h not found

If your project is in Objective-C, you will have to do the changes referenced in [this SO post](https://stackoverflow.com/a/53453243/4499889) in order to solve the issue:

```
'notification_permissions/notification_permissions-Swift.h' file not found
    #import <notification_permissions/notification_permissions-Swift.h>
            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    1 error generated.
```

Add `use_frameworks!` in target Runner in your `(YOUR_PROJECT)/ios/Podfile`

```
target 'Runner' do
  use_frameworks! # Add here
```

## Special Thanks
Special thanks to [fedecastelli](https://github.com/fedecastelli) for helping me in the Swift Code!
