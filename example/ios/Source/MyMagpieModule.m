//
//  MyMagpieModule.m
//  FlutterNative
//
//  Created by 张达理 on 2019/12/3.
//  Copyright © 2019 张达理. All rights reserved.
//

#import "MyMagpieModule.h"

@implementation MyMagpieModule


//手动注册
@synthesize params;
@synthesize result;
+ (void)load{
    [MagpieBridge registerModule:@"testModule" forClass:self];
}

//宏注册
//MAGPIE_EXPORT_MODULE(testModule)

MAGPIE_EXPORT_METHOD(uploadLog){
    //回调Dart侧
    self.result(@{@"key":[NSString stringWithFormat:@"执行完成了！参数是:%@ ",self.params]});
}





@end


