//
//  MagpieMessenger.m
//  MagpieBridge
//
//  Created by 张达理 on 2019/12/2.
//

#import "MagpieMessenger.h"
#import "MagpiePlugin.h"
#import <objc/runtime.h>

@implementation MagpieMessenger

+ (FlutterMethodChannel *)messenger{
    return MagpiePlugin.sharedInstance.channel;
}

+ (void)sendEvent:(NSString *)eventName params:(NSDictionary *)params{
    if(!eventName) return;
    NSMutableDictionary *message = [NSMutableDictionary new];
    message[@"name"] = eventName;
    message[@"params"] = params;
    [self.messenger invokeMethod:@"__magpie_event__" arguments:message result:nil];
}


+ (void)handleMethodCall:(FlutterMethodCall *)call
                  result:(FlutterResult)result{
    NSString  * module = call.arguments[@"module"];
    NSString  * name = call.arguments[@"name"]?:@"";
    NSString  * params = call.arguments[@"params"];
    Class class = MagpiePlugin.sharedInstance.publicHandlers[module];
    if (!class || !object_isClass(class)) return;
    id <MagpieBridgeProtocol> moduleInstance = [class respondsToSelector:@selector(standardInstance)] ?
        [class standardInstance] : [class new];
    [(NSObject *)moduleInstance setValue:params forKey:@"params"];
    [(NSObject *)moduleInstance setValue:result forKey:@"result"];
    SEL selector = NSSelectorFromString([@"magpie_" stringByAppendingString:name]);
    if ([moduleInstance respondsToSelector:selector]) {
        ((void (*)(id, SEL))[(NSObject *)moduleInstance methodForSelector:selector])(moduleInstance,selector);
    }
}

+ (void)handleDataRequestCall:(FlutterMethodCall *)call result:(FlutterResult)result{
    MagpieCallBack callBack = MagpiePlugin.sharedInstance.privateHandlers[@"__magpie_data__"];
    if (callBack) {
        NSString * name = call.arguments[@"name"];
        NSDictionary * params = call.arguments[@"params"];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            id value = callBack(name,params);
            result(value);
        });
    }
}

+ (void)handleLogCall:(FlutterMethodCall *)call result:(FlutterResult)result{
    MagpieVoidCallBack callBack = MagpiePlugin.sharedInstance.privateHandlers[@"__magpie_log__"];
    if (callBack) {
        NSString * name = call.arguments[@"name"];
        NSDictionary * params = call.arguments[@"params"];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            callBack(name,params);
        });
    }
}

+ (void)handleNotificationCall:(FlutterMethodCall *)call result:(FlutterResult)result{
    NSString * name = call.arguments[@"name"];
    NSDictionary * params = call.arguments[@"params"];
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil userInfo:params];
    NSLog(@"%@", [NSString stringWithFormat:@"向Native广播Dart的消息：key = %@, params = %@",name,params]);
}

+ (void)obtainData:(NSString *)key params:(nonnull NSDictionary *)params completion:(nonnull FlutterResult)result{
    if(!result) return;
    NSMutableDictionary *message = [NSMutableDictionary new];
    message[@"name"] = key;
    message[@"params"] = params;
    [self.messenger invokeMethod:@"__magpie_data__" arguments:message result:result];
}

@end
