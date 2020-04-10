//
//  MagpieBridge.h
//  MagpieBridge
//
//  Created by 张达理 on 2019/11/27.
//

#import <Flutter/Flutter.h>
#import <MagpieBridge/MagpieDefines.h>
#import <MagpieBridge/MagpieBridgeProtocol.h>

NS_ASSUME_NONNULL_BEGIN


@interface MagpiePlugin : NSObject<FlutterPlugin>

@property (nonatomic, strong) FlutterMethodChannel                                   * channel;
@property (nonatomic, strong) NSMutableDictionary <NSString *, Class>                * publicHandlers;
@property (nonatomic, strong) NSMutableDictionary                                    * privateHandlers;

+ (instancetype)sharedInstance;

+ (void)registerModule:(NSString *)name forClass:(Class<MagpieBridgeProtocol>)cls;

+ (void)sendEvent:(NSString *)eventName params:(NSDictionary *)params;

+ (void)obtainData:(NSString *)key params:(NSDictionary *)params completion:(FlutterResult )result;

+ (void)setDataRequestHandler:(MagpieCallBack)handler;

+ (void)setLogHandler:(MagpieVoidCallBack)handler;


@end

NS_ASSUME_NONNULL_END
