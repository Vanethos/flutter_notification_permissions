#import "NotificationPermisionsPlugin.h"
#import <notification_permisions/notification_permisions-Swift.h>

@implementation NotificationPermisionsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftNotificationPermisionsPlugin registerWithRegistrar:registrar];
}
@end
