#import "NotificationPermissionsPlugin.h"

#if __has_include(<notification_permissions/notification_permissions-Swift.h>)
#import <notification_permissions/notification_permissions-Swift.h>
#else
#import "notification_permissions-Swift.h"
#endif

@implementation NotificationPermissionsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftNotificationPermissionsPlugin registerWithRegistrar:registrar];
}
@end
