//
//  MagpieBridge.m
//  MagpieBridge
//
//  Created by 张达理 on 2019/11/27.
//

#import "MagpiePlugin.h"
#import "MagpieMessenger.h"

static NSMutableDictionary * magpieModuleRegistryMap;
void magpieModuleRegistry(NSString * name,Class cls){
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        magpieModuleRegistryMap = [NSMutableDictionary dictionary];
    });
    Class theClass = magpieModuleRegistryMap[name];
    if (theClass) {
        NSString * reason = [NSString stringWithFormat:
                             @"The module name %@ has been registered with class %@",name,NSStringFromClass(theClass)];
        NSException * exception = [[NSException alloc]initWithName:@"MagpieRegistryException" reason:reason userInfo:@{@"name":name,@"class":cls}];
        @throw exception;
    }else{
        magpieModuleRegistryMap[name] = cls;
    }
}

@interface MagpiePlugin()

@end

@implementation MagpiePlugin

+ (instancetype)sharedInstance{
    static MagpiePlugin * magpie;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        magpie = [[MagpiePlugin alloc] init];
    });
    return magpie;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _privateHandlers = [NSMutableDictionary new];
        _publicHandlers = magpieModuleRegistryMap;
    }
    return self;
}

+ (void)registerModule:(NSString *)name forClass:(Class)cls{
    if ( ![name isKindOfClass:NSString.class] || name.length == 0 || NSStringFromClass(cls).length == 0) return;
    magpieModuleRegistry(name, cls);
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"magpie_channel"
                                     binaryMessenger:[registrar messenger]];
    MagpiePlugin.sharedInstance.channel = channel;
    [registrar addMethodCallDelegate:MagpiePlugin.sharedInstance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"__magpie_action__" isEqualToString:call.method]) {
        [MagpieMessenger handleMethodCall:call result:result];
    }else if ([@"__magpie_notification__" isEqualToString:call.method]){
        [MagpieMessenger handleNotificationCall:call result:result];
    }else if ([@"__magpie_data__" isEqualToString:call.method]){
        [MagpieMessenger handleDataRequestCall:call result:result];
    }else if ([@"__magpie_log__" isEqualToString:call.method]){
        [MagpieMessenger handleLogCall:call result:result];
    }
    else {
        result(FlutterMethodNotImplemented);
    }
}

+ (void)sendEvent:(NSString *)eventName params:(NSDictionary *)params{
    [MagpieMessenger sendEvent:eventName params:params];
}

+ (void)obtainData:(NSString *)key params:(NSDictionary *)params completion:(FlutterResult )result{
    [MagpieMessenger obtainData:key params:params completion:result];
}

+ (void)setDataRequestHandler:(MagpieCallBack)handler{
    MagpiePlugin.sharedInstance.privateHandlers[@"__magpie_data__"] = handler;
}

+ (void)setLogHandler:(MagpieVoidCallBack)handler{
    MagpiePlugin.sharedInstance.privateHandlers[@"__magpie_log__"] = handler;
}

@end
