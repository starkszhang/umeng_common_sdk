#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import <UMCommon/UMConfigure.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [UMConfigure setLogEnabled:YES];
    [UMConfigure initWithAppkey:@"5861e5daf5ade41326001eab" channel:@"App Store"];
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
