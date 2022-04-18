//
//  AppDelegate.m
//  CPayDemoOC
//
//  Created by long.zhao on 2/7/22.
//

#import "AppDelegate.h"
#import <CPaySDK/CPaySDK-Swift.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}


#pragma mark - UISceneSession lifecycle


//- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
//    // Called when a new scene session is being created.
//    // Use this method to select a configuration to create the new scene with.
//    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
//}
//
//
//- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
//    // Called when the user discards a scene session.
//    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//}

#pragma mark - handle openURL

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    NSLog(@"application:openURL:options");
    NSLog(@"\n[URL]:\n%@\n[HOST]:\n%@\n[SCHEME]:\n%@", url, url.host, url.scheme);
    return [[CPayManager sharedInst] handleUrl:app open:url options:options];
}

//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(nonnull id)annotation {
//    return [[CPayManager sharedInst] handleUrl:app open:url options:@{}];
//}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
    NSLog(@"application:continueUserActivity:restorationHandler");
    [[CPayManager sharedInst] handleUniversalLink:userActivity];
    return YES;
}

@end
