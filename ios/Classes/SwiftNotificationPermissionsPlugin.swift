import Flutter
import UIKit
import UserNotifications

public class SwiftNotificationPermissionsPlugin: NSObject, FlutterPlugin {
  var permissionGranted:String = "granted"
  var permissionUnknown:String = "unknown"
  var permissionDenied:String = "denied"
  var permissionProvisional:String = "provisional"

  public static func register(with registrar: FlutterPluginRegistrar) {
      let channel = FlutterMethodChannel(name: "notification_permissions", binaryMessenger: registrar.messenger())
      let instance = SwiftNotificationPermissionsPlugin()
      registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      if (call.method == "requestNotificationPermissions") {
          // check if we can ask for permissions
          getNotificationStatus(completion: { status in
              if (status == self.permissionUnknown || status == self.permissionProvisional) {
				  if #available(iOS 10.0, *) {
					  let center = UNUserNotificationCenter.current()
					  var options = UNAuthorizationOptions()
					  if let arguments = call.arguments as? Dictionary<String, Bool> {
						  if(arguments["sound"] != nil){
							options.insert(.sound)
						  }
						  if(arguments["alert"] != nil){
							options.insert(.alert)
						  }
						  if(arguments["badge"] != nil){
							options.insert(.badge)
						  }
					  }
					  center.requestAuthorization(options: options) { (success, error) in
						  if error == nil {
							  if success == true {
								  result(self.permissionGranted)
							  }
							  else {
								  result(self.permissionDenied)
							  }
						  }
						  else {
							  result(error?.localizedDescription)
						  }
					}
				  } else {
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
						  self.getNotificationStatus(completion: { status in
						  	result(status)
						  });
					  }
				  }
              } else if (status == self.permissionDenied) {
                  // The user has denied the permission he must go to the settings screen
                  if let arguments = call.arguments as? Dictionary<String, Bool> {
					  if (arguments["openSettings"] != nil && arguments["openSettings"] == false)  {
						  result(self.permissionDenied)
						  return
					  }
				  }
                  if let url = URL(string:UIApplication.openSettingsURLString) {
                      if UIApplication.shared.canOpenURL(url) {
                          if #available(iOS 10.0, *) {
                              UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                          } else {
                              UIApplication.shared.openURL(url)
                          }
                      }
                  }
                  result(nil)
              } else {
                  result(nil)
              }
          })
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
              } else if #available(iOS 12.0, *){
                  if (settings.authorizationStatus == .provisional){
                      completion(self.permissionProvisional)
                  }
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

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
