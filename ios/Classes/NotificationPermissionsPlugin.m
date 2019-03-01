#import "NotificationPermissionsPlugin.h"
#import <notification_permissions/notification_permissions-Swift.h>

@implementation NotificationPermissionsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftNotificationPermissionsPlugin registerWithRegistrar:registrar];
}
@end
