//
//  MagpieBridge.h
//  MagpieBridge
//
//  Created by 张达理 on 2019/11/27.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import <MagpieBridge/MagpieDefines.h>
#import <MagpieBridge/MagpiePlatform.h>
#import <MagpieBridge/MagpieContainer.h>
#import <MagpieBridge/MagpieBridgeProtocol.h>


@interface MagpieBridge : NSObject

/**
 * 初始化Magpie混合栈环境。应在程序使用混合栈之前调用。如在AppDelegate中
 *
 * @param platform 平台层实现MagpiePlatform的对象
 * @param callback 启动之后回调
*/
+ (void)startFlutterWithPlatform:(id<MagpiePlatform>)platform
                         onStart:(void (^)(FlutterEngine *engine))callback;

/**
 * 初始化Futter的载体页。需要显式调用setName:params:进行配置
*/
+ (FlutterViewController <MagpieContainer> *)flutterViewController;

/**
 * Flutter engine当前持有的载体页。
*/
+ (FlutterViewController <MagpieContainer> *)currentViewController;

/**
 * Flutter engine是否已初始化。
*/
+ (BOOL)isRunning;

/**
 * 打开新页面
 *
 * @param url 打开的页面资源定位符
 * @param urlParams 传人页面的参数;
 * @param exts 额外参数
 * @param resultCallback 当页面结束返回时执行的回调，通过这个回调可以取得页面的返回数据，如close函数传入的resultData
 * @param completion 打开页面的即时回调，页面一旦打开即回调
*/
+ (void)open:(NSString *)url
   urlParams:(NSDictionary *)urlParams
        exts:(NSDictionary *)exts
       onPageFinished:(void (^)(NSDictionary *result))resultCallback
  completion:(void (^)(BOOL finished))completion;

/**
 * 关闭页面
 *
 * @param uniqueId 关闭的页面唯一ID符
 * @param resultData 页面要返回的结果，open方法参数resultCallback的回调参数
 * @param exts 额外参数
 * @param completion 关闭页面的即时回调，页面一旦关闭即回调
*/
+ (void)close:(NSString *)uniqueId
       result:(NSDictionary *)resultData
         exts:(NSDictionary *)exts
   completion:(void (^)(BOOL finished))completion;

/**
 * 向Dart发送事件
 *
 * @param eventName 事件名字
 * @param params 参数
 */
+ (void)sendEvent:(NSString *)eventName params:(NSDictionary *)params;

/**
 * 向Dart发送数据要求
 *
 * @param key 数据的key
 * @param params 参数
 * @param result 得到数据的回调
 */
+ (void)obtainData:(NSString *)key params:(NSDictionary *)params completion:(FlutterResult )result;

/**
 * 设置来自Dart数据请求的响应回调
 *
 * @param handler 响应回调
 */
+ (void)setDataRequestHandler:(MagpieCallBack)handler;

/**
 * 设置来自Dart日志请求的响应回调
 *
 * @param handler 响应回调
 */
+ (void)setLogHandler:(MagpieVoidCallBack)handler;


/**
 * Magpie module的手动注册方法
 *
 * @param name module名字
 * @param theClass module的类,需要遵循MagpieBridgeProtocol
 */
+ (void)registerModule:(NSString *)name forClass:(Class)theClass;

@end
