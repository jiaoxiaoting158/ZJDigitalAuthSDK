//
//  AppDelegate.m
//  Example
//
//  Created by jiaoxt on 2021/4/25.
//

#import "AppDelegate.h"
#import <ZJDigitalAuthSDK/ZJDigitalAuthSDK.h>

#import <YYKit/YYKit.h>
#import "AppConfig.h"
#import <WXApi.h>
#import "ViewController.h"

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [WXApi registerApp:@"xxxx"  universalLink:@"universalLink"];
    [ZJDigitalAuthSDK initWithAppId:ZJAuthAppID
                          appSecret:ZJAuthAppID
                         completion:^(NSDictionary * _Nullable resultData, NSError * _Nullable error) {
        if (error == nil) {
            
            NSDictionary *resultDic = resultData[@"result"];
            NSString *ticket = resultDic[@"ticket"];
            [AppConfig share].ticket = ticket;
            [[AppConfig share] saveToLocal];
            NSLog(@"ZJDigitalAuthSDK 初始化成功");
        }
    }];
    return YES;
}



- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WXApi handleOpenURL:url delegate:self];
}
#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler{
    return [WXApi handleOpenUniversalLink:userActivity delegate:self];
}

- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
