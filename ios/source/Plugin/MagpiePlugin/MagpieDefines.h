//
//  MagpieDefines.h
//  Pods
//
//  Created by 张达理 on 2019/12/6.
//

/**
 * 版本号
*/
FOUNDATION_EXPORT NSString * _Nonnull MagpieBridgeVersionNumber;

/**
 * Magpie Module的自动注册宏
 *
 * @Param name ModuleName
 */
#define MAGPIE_EXPORT_MODULE(name) \
extern void magpieModuleRegistry(NSString * name,Class cls); \
@synthesize params; \
@synthesize result; \
+ (void)load {NSString *n=@#name;if (n && n.length>0) {magpieModuleRegistry(n,self);}}

/**
* Magpie Module的Action实现宏
*
* @Param name ActionName
*/
#define MAGPIE_EXPORT_METHOD(action) \
- (void)magpie_##action

typedef id _Nullable   (^MagpieCallBack) (NSString * _Nullable name, NSDictionary * _Nullable params);
typedef void (^MagpieVoidCallBack) (NSString * _Nullable name, NSDictionary * _Nullable params);
typedef void (^MagpieResult)   (NSDictionary * _Nullable result);

