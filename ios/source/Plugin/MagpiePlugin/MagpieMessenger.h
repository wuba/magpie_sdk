//
//  MagpieMessenger.h
//  MagpieBridge
//
//  Created by 张达理 on 2019/12/2.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface MagpieMessenger : NSObject

+ (void)sendEvent:(NSString *)eventName params:(NSDictionary *)params;

+ (void)handleMethodCall:(FlutterMethodCall *)call
                  result:(FlutterResult)result;

+ (void)handleNotificationCall:(FlutterMethodCall *)call result:(FlutterResult)result;

+ (void)handleDataRequestCall:(FlutterMethodCall *)call result:(FlutterResult)result;

+ (void)handleLogCall:(FlutterMethodCall *)call result:(FlutterResult)result;

+ (void)obtainData:(NSString *)key params:(NSDictionary *)params completion:(FlutterResult )result;
@end

NS_ASSUME_NONNULL_END
