//
//  MagpieBridge.m
//  MagpieBridge
//
//  Created by 张达理 on 2019/11/27.
//

#import "MagpieBridge.h"
#import <MagpieBridge/FlutterBoost.h>
#import <MagpieBridge/MagpiePlugin.h>

NSString * _Nonnull MagpieBridgeVersionNumber = @"1.0.0";

@interface MagpieBridge () <FLBPlatform>
@property (nonatomic,strong) id <MagpiePlatform> boostPlatform;
@end

@implementation MagpieBridge

+ (instancetype)sharedInstance{
    static MagpieBridge * bridge;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bridge = [[MagpieBridge alloc] init];
    });
    return bridge;
}

+ (FlutterViewController *)flutterViewController{
    return FLBFlutterViewContainer.new;
}
#pragma mark Plugin Reg
+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
    [FlutterBoostPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterBoostPlugin"]];
    [MagpiePlugin registerWithRegistrar:[registry registrarForPlugin:@"MagpiePlugin"]];
}

#pragma mark Magpie

+ (void)registerModule:(NSString *)name forClass:(Class)theClass{
    [MagpiePlugin registerModule:name forClass:theClass];
}

+ (void)sendEvent:(NSString *)eventName params:(NSDictionary *)params{
    [MagpiePlugin sendEvent:eventName params:params];
}

+ (void)obtainData:(NSString *)key params:(NSDictionary *)params completion:(FlutterResult )result{
    [MagpiePlugin obtainData:key params:params completion:result];
}

+ (void)setDataRequestHandler:(MagpieCallBack)handler{
    [MagpiePlugin setDataRequestHandler:handler];
}

+ (void)setLogHandler:(MagpieVoidCallBack)handler{
    [MagpiePlugin setLogHandler:handler];
}

#pragma mark Flutter Boost

+ (void)startFlutterWithPlatform:(id<MagpiePlatform>)platform
                         onStart:(void (^)(FlutterEngine *engine))callback{
    MagpieBridge.sharedInstance.boostPlatform = platform;
    FlutterDartProject * project;
    if ([MagpieBridge.sharedInstance respondsToSelector:@selector(flutterProject)]) {
        project = MagpieBridge.sharedInstance.flutterProject;
    }
    FlutterEngine* engine = [[FlutterEngine alloc] initWithName:@"io.flutter" project:project];
    [FlutterBoostPlugin.sharedInstance startFlutterWithPlatform:MagpieBridge.sharedInstance engine:engine onStart:callback];
    [self registerWithRegistry:engine];
}

+ (BOOL)isRunning{
    return FlutterBoostPlugin.sharedInstance.isRunning;
}

+ (FlutterViewController *)currentViewController{
    return FlutterBoostPlugin.sharedInstance.currentViewController;
}


+ (void)close:(NSString *)uniqueId
       result:(NSDictionary *)resultData
         exts:(NSDictionary *)exts
   completion:(void (^)(BOOL finished))completion{
    [FlutterBoostPlugin close:uniqueId result:resultData exts:exts completion:completion];
}

+ (void)open:(NSString *)url
   urlParams:(NSDictionary *)urlParams
        exts:(NSDictionary *)exts
       onPageFinished:(void (^)(NSDictionary *result))resultCallback
  completion:(void (^)(BOOL finished))completion{
    [FlutterBoostPlugin open:url urlParams:urlParams exts:exts onPageFinished:resultCallback completion:completion];
}

#pragma mark Protocol FLBPlatform

- (NSString *)entryForDart{
    return [_boostPlatform respondsToSelector:@selector(entryForDart)] ?
    [_boostPlatform performSelector:@selector(entryForDart)] : nil;
}

- (id)flutterProject{
    if ([self.boostPlatform respondsToSelector:@selector(dartBundle)]) {
        NSBundle * bundle = self.boostPlatform.dartBundle;
        NSString * assetsPath = [bundle objectForInfoDictionaryKey:@"FLTAssetsPath"];
        if (assetsPath) {
            FlutterDartProject * project = [[FlutterDartProject alloc]initWithPrecompiledDartBundle:bundle];
            return project;
        }
    }
    return nil;
}


- (void)open:(NSString *)url
   urlParams:(NSDictionary *)urlParams
        exts:(NSDictionary *)exts
      completion:(void (^)(BOOL finished))completion{
    if ([_boostPlatform respondsToSelector:@selector(open:urlParams:exts:completion:)]) {
        [_boostPlatform open:url urlParams:urlParams exts:exts completion:completion];
    }
}

- (void)present:(NSString *)url
   urlParams:(NSDictionary *)urlParams
        exts:(NSDictionary *)exts
     completion:(void (^)(BOOL finished))completion{
    if ([_boostPlatform respondsToSelector:@selector(open:urlParams:exts:completion:)]) {
        [_boostPlatform open:url urlParams:urlParams exts:exts completion:completion];
    }
}

- (void)close:(NSString *)uid
       result:(NSDictionary *)result
         exts:(NSDictionary *)exts
   completion:(void (^)(BOOL finished))completion{
    if ([_boostPlatform respondsToSelector:@selector(close:result:exts:completion:)]) {
        [_boostPlatform close:uid result:result exts:exts completion:completion];
    }
}

@end
