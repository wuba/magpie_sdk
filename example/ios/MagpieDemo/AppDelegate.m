//
//  AppDelegate.m
//  FlutterNative
//
//  Created by 张达理 on 2019/11/22.
//  Copyright © 2019 张达理. All rights reserved.
//

#import "AppDelegate.h"

#import "PlatformRouterImp.h"
#import <MagpieBridge/MagpieBridge.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
    PlatformRouterImp *router = [PlatformRouterImp new];
    [MagpieBridge startFlutterWithPlatform:router onStart:^(FlutterEngine *engine) {
                                                                
    }];
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
