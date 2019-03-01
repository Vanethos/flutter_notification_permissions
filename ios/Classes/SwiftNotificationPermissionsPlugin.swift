import Flutter
import UIKit

public class SwiftNotificationPermissionsPlugin: NSObject, FlutterPlugin {
  var permissionGranted:String = "granted"
  var permissionUnknown:String = "unknown"
  var permissionDenied:String = "denied"

  public static func register(with registrar: FlutterPluginRegistrar) {
      let channel = FlutterMethodChannel(name: "notification_permissions", binaryMessenger: registrar.messenger())
      let instance = SwiftNotificationPermissionsPlugin()
      registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      if (call.method == "requestNotificationPermissions") {
          // check if we can ask for permissions
          getNotificationStatus(completion: { status in
              if (status == self.permissionUnknown) {
                  // If the permission status is unknown, the user hasn't denied it
                  var notificationTypes = UIUserNotificationType(rawValue: 0)
                  if let arguments = call.arguments as? Dictionary<String, Bool> {
                      if arguments["sound"] != nil {
                          notificationTypes.insert(UIUserNotificationType.sound)
                      }
                      if arguments["alert"] != nil  {
                          notificationTypes.insert(UIUserNotificationType.alert)
                      }
                      if arguments["badge"] != nil  {
                          notificationTypes.insert(UIUserNotificationType.badge)
                      }
                      var settings: UIUserNotificationSettings? = nil

                      settings = UIUserNotificationSettings(types: notificationTypes, categories: nil)

                      if let settings = settings {
                          UIApplication.shared.registerUserNotificationSettings(settings)
                      }
                  }
              } else if (status == self.permissionDenied) {
                  // The user has denied the permission he must go to the settings screen
                  if let url = URL(string:UIApplicationOpenSettingsURLString) {
                      if UIApplication.shared.canOpenURL(url) {
                          if #available(iOS 10.0, *) {
                              UIApplication.shared.open(url, options: [:], completionHandler: nil)
                          } else {
                              UIApplication.shared.openURL(url)
                          }
                      }
                  }
              }
              result(nil)
          })
          result(nil)
      } else if (call.method == "getNotificationPermissionStatus") {
          getNotificationStatus(completion: { status in
              result(status)
          })
      } else {
          result(FlutterMethodNotImplemented)
      }
  }

  func getNotificationStatus(completion: @escaping ((String) -> Void)) {
      if #available(iOS 10.0, *) {
          let current = UNUserNotificationCenter.current()
          current.getNotificationSettings(completionHandler: { settings in
              if settings.authorizationStatus == .notDetermined {
                  completion(self.permissionUnknown)
              } else if settings.authorizationStatus == .denied {
                  completion(self.permissionDenied)
              } else if settings.authorizationStatus == .authorized {
                  completion(self.permissionGranted)
              }
          })
      } else {
          // Fallback on earlier versions
          if UIApplication.shared.isRegisteredForRemoteNotifications {
              completion(self.permissionGranted)
          } else {
              completion(self.permissionDenied)
          }
      }
  }
}
