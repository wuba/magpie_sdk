//
//  MagpiePlatform.h
//  FMDB
//
//  Created by 张达理 on 2019/12/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MagpiePlatform <NSObject>
@optional
/**
 * Dart代码入口，默认为main()
 */
- (NSString *)entryForDart;

/**
 * Dart业务资源文件
 * Bundle中必须有info.plist ,其中必须有key:@"FLTAssetsPath"，value为flutter_assets目录在mainbundle中的位置，例: @"/Frameworks/App.framework/flutter_assets"
*/
- (NSBundle *)dartBundle;

@required

/**
 * Dart的页面打开能力依赖这个实现
 *
 * @param url 打开的页面资源定位符
 * @param urlParams 传人页面的参数;
 * @param exts 额外参数
 * @param completion 打开页面的即时回调，页面一旦打开即回调
*/
- (void)open:(NSString *)url
   urlParams:(NSDictionary *)urlParams
        exts:(NSDictionary *)exts
      completion:(void (^)(BOOL finished))completion;

/**
 * 关闭页面
 *
 * @param uid 关闭的页面唯一ID符
 * @param result 页面要返回的结果，open方法参数resultCallback的回调参数
 * @param exts 额外参数
 * @param completion 关闭页面的即时回调，页面一旦关闭即回调
*/
- (void)close:(NSString *)uid
       result:(NSDictionary *)result
         exts:(NSDictionary *)exts
   completion:(void (^)(BOOL finished))completion;
@end


NS_ASSUME_NONNULL_END
