#import "UmengCommonSdkPlugin.h"
#import <UMCommon/UMConfigure.h>
#import <UMCommon/MobClick.h>
#import <UMAPM/UMCrashConfigure.h>
#import <UMAPM/UMLaunch.h>
#import <UMAPM/UMAPMConfig.h>
#import <UMCommonLog/UMCommonLogHeaders.h>

@interface UMengflutterpluginForUMCommon : NSObject
@end
@implementation UMengflutterpluginForUMCommon

+ (BOOL)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result{
    BOOL resultCode = YES;
    if ([@"initCommon" isEqualToString:call.method]){
        NSArray* arguments = (NSArray *)call.arguments;
        NSString* appkey = arguments[1];
        NSString* channel = arguments[2];
        [UMConfigure initWithAppkey:appkey channel:channel];
        //result(@"success");

        //设置启动模块自定义函数开始
            [UMLaunch beginLaunch:@"intUmeng"];
            //初始化友盟SDK
            UMAPMConfig* config = [UMAPMConfig defaultConfig];
            config.crashAndBlockMonitorEnable = YES;
            config.launchMonitorEnable = YES;
            config.memMonitorEnable = YES;
            config.oomMonitorEnable = YES;
            config.networkEnable = YES;
            [UMCrashConfigure setAPMConfig:config];
            [UMConfigure initWithAppkey:appkey channel:channel];
            //设置启动模块自定义函数开始
            [UMLaunch endLaunch:@"intUmeng"];
            NSLog(@"UMAPM version:%@",[UMCrashConfigure getVersion]);
            //设置预定义DidFinishLaunchingEnd时间
            [UMLaunch setPredefineLaunchType:UMPredefineLaunchType_DidFinishLaunchingEnd];
            [UMCommonLogManager setUpUMCommonLogManager];
    }
    else{
        resultCode = NO;
    }
    return resultCode;
}
@end

@interface UMengflutterpluginForAnalytics : NSObject
@end
@implementation UMengflutterpluginForAnalytics : NSObject

+ (BOOL)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result{
    BOOL resultCode = YES;
    NSArray* arguments = (NSArray *)call.arguments;
    if ([@"onEvent" isEqualToString:call.method]){
        NSString* eventName = arguments[0];
        NSDictionary* properties = arguments[1];
        [MobClick event:eventName attributes:properties];
        //result(@"success");
    }
    else if ([@"onProfileSignIn" isEqualToString:call.method]){
        NSString* userID = arguments[0];
        [MobClick profileSignInWithPUID:userID];
        //result(@"success");
    }
    else if ([@"onProfileSignOff" isEqualToString:call.method]){
        [MobClick profileSignOff];
        //result(@"success");
    }
    else if ([@"setPageCollectionModeAuto" isEqualToString:call.method]){
        [MobClick setAutoPageEnabled:YES];
        //result(@"success");
    }
    else if ([@"setPageCollectionModeManual" isEqualToString:call.method]){
        [MobClick setAutoPageEnabled:NO];
        //result(@"success");
    }
    else if ([@"onPageStart" isEqualToString:call.method]){
        NSString* pageName = arguments[0];
        [MobClick beginLogPageView:pageName];
        //result(@"success");
    }
    else if ([@"onPageEnd" isEqualToString:call.method]){
        NSString* pageName = arguments[0];
        [MobClick endLogPageView:pageName];
        //result(@"success");
    }
    else if ([@"reportError" isEqualToString:call.method]){
        NSLog(@"reportError API not existed ");
        //result(@"success");
     }
    else if ([@"postError" isEqualToString:call.method]){
        NSString* name= @"myUnity";
        NSString* reason = arguments[0];
        NSArray* stackTrace = [NSArray arrayWithObjects:arguments[1],nil];
        [UMCrashConfigure reportExceptionWithName:name reason:reason stackTrace:stackTrace];
    }
    else{
        resultCode = NO;
    }
    return resultCode;
}

@end

@implementation UmengCommonSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"umeng_common_sdk"
            binaryMessenger:[registrar messenger]];
  UmengCommonSdkPlugin* instance = [[UmengCommonSdkPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else {
    //result(FlutterMethodNotImplemented);
  }

    BOOL resultCode = [UMengflutterpluginForUMCommon handleMethodCall:call result:result];
    if (resultCode) return;

    resultCode = [UMengflutterpluginForAnalytics handleMethodCall:call result:result];
    if (resultCode) return;

    result(FlutterMethodNotImplemented);
}

@end
