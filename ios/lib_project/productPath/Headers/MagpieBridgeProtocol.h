//
//  MagpieBridgeProtocol.h
//  FMDB
//
//  Created by 张达理 on 2019/12/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MagpieBridgeProtocol <NSObject>
@optional
@property (nonatomic,strong, readonly) NSDictionary   * params;         //Action执行时的参数
@property (nonatomic,copy  , readonly) MagpieResult     result;         //Action的回调
+ (instancetype)standardInstance;
@end

NS_ASSUME_NONNULL_END
