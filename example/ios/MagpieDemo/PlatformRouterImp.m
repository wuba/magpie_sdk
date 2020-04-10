//
//  DemoRouter.m
//  Runner
//
//  Created by Jidong Chen on 2018/10/22.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

#import "PlatformRouterImp.h"

@interface PlatformRouterImp()
@end

@implementation PlatformRouterImp

static NSDictionary * pageMap;
- (instancetype)init
{
    self = [super init];
    if (self) {
        pageMap = @{@"sample://flutterPage":@"flutterPage"};
    }
    return self;
}
- (UINavigationController *)navigationController{
    return (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
}


/*
- (NSBundle *)dartBundle{
    NSString * toPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingFormat:@"/bus.bundle"];
    NSBundle * bus = [NSBundle bundleWithPath:toPath];
    return bus;
}
 */


- (void)open:(NSString *)name
   urlParams:(NSDictionary *)params
        exts:(NSDictionary *)exts
  completion:(void (^)(BOOL))completion
{
    if ([name hasPrefix:@"native://"]) {
        NSLog(@"NATIVE 处理 NATIVE 路由");
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        [self.navigationController pushViewController:vc animated:YES];
               
    }
    else if ([name hasPrefix:@"sample://"]){
        NSString * pageName = pageMap[name];
        BOOL animated = [exts[@"animated"] boolValue];
        BOOL isPresent = [exts[@"present"] boolValue];
        FlutterViewController<MagpieContainer> *vc = [MagpieBridge flutterViewController];
        [vc setName:pageName params:params];
        if (isPresent) {
            [self.navigationController presentViewController:vc animated:animated completion:^{
                  if(completion) completion(YES);
              }];
        }else{
            [self.navigationController pushViewController:vc animated:animated];
            if(completion) completion(YES);
        }
    }
}

- (void)close:(NSString *)uid
       result:(NSDictionary *)result
         exts:(NSDictionary *)exts
   completion:(void (^)(BOOL))completion
{
    BOOL animated = [exts[@"animated"] boolValue]; animated = YES;
    FlutterViewController<MagpieContainer>*vc = (id)self.navigationController.presentedViewController;
    if([vc isKindOfClass:FlutterViewController.class] && [vc.uniqueIDString isEqual: uid]){
        [vc dismissViewControllerAnimated:animated completion:^{}];
    }else{
        [self.navigationController popViewControllerAnimated:animated];
    }
}
@end
