# 0.5.0

* Adds null safety [anoop4real]

# 0.4.8

* Fixes iOS Privisional Status not opening [#30](https://github.com/Vanethos/flutter_notification_permissions/pull/30), 
[DuncanKelbie]

# 0.4.7

* Adds iOS Provisional Status [#28](https://github.com/Vanethos/flutter_notification_permissions/pull/28), [DuncanKelbie]

# 0.4.6
* Fixes open android Settings via [#25](https://github.com/Vanethos/flutter_notification_permissions/pull/25) , [britannio]

# 0.4.5
* Fixes Android giving unknown permission error [Zazo032]

# 0.4.4
* Corrected the path to the license file in .podspec
* Define CLANG module, so that the plugin can be used statically
* Ensure correct version is listed in .podspec

# 0.4.3 
* Added option to open settings or not in iOS when permition is denied [pawlowskim]
* Adding possibility for iOS 10.0 to wait for call requestNotificationPermissions (iOS permission dialog) [kuzmisin]
* Fix missing result() call for Android when PERMISSION_DENIED [kuzmisin]
* Fixed warnings on XCode [ened]

# 0.4.0 
* **Breaking change** Changed implementation to use static methods. Changed `IosNotificationSettings` to `NotificationSettingsIos` to avoid conflict with Firebase

# 0.3.1
* Changed the README to present the quick-fix for installing this plugin in a Objective-C Flutter Project

# 0.3.0
* Replace Kotlin implementation with simple Java to ease future maintenance.

## 0.2.2
* Added support for latest kotlin version

## 0.2.1
* Port iOS codebase to Swift 4.2

## 0.2.0
* **Breaking change**. Migrate from the deprecated original Android Support Library to AndroidX. This shouldn't result in any functional changes, but it requires any Android apps using this plugin to [also migrate](https://developer.android.com/jetpack/androidx/migrate) if they're using the original support library.

## 0.1.0
* Initial release of the package
