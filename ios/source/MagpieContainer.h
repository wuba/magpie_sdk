//
//  MPFlutterViewController.h
//  FMDB
//
//  Created by 张达理 on 2019/12/6.
//


NS_ASSUME_NONNULL_BEGIN
@protocol MagpieContainer<NSObject>
- (NSString *)name;
- (NSDictionary *)params;
- (NSString *)uniqueIDString;
- (void)setName:(NSString *)name params:(NSDictionary *)params;  
@end
NS_ASSUME_NONNULL_END
