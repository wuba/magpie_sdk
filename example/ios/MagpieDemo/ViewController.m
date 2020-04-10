//
//  ViewController.m
//  FlutterNative
//
//  Created by 张达理 on 2019/11/22.
//  Copyright © 2019 张达理. All rights reserved.
//

#import "ViewController.h"
#import "DemoTableViewCell.h"
#import <MagpieBridge/MagpieBridge.h>

typedef void (^DemoCallBack)(void);

@interface ViewController () <UITableViewDelegate,UITableViewDataSource>

@property (strong , nonatomic) NSMutableArray * tableDatas;

@property (strong , nonatomic) IBOutlet UITableView * tableview;

@end

@implementation ViewController

//MAGPIE_EXPORT_MODULE(testModule)
//MAGPIE_EXPORT_METHOD(uploadLog){
//    self.result(self.params);
//}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.tableDatas = [NSMutableArray array];
        [self constructData];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleFlutterNotification:) name:@"notification" object:nil];
    }
    return self;
}

- (void)constructData{
    [self.tableDatas addObject:@{
        @"title":@"open flutter page",
        @"callback":^(){
            [MagpieBridge open:@"sample://flutterPage" urlParams:nil exts:@{@"animated":@(YES)} onPageFinished:^(NSDictionary *result) {
                NSLog(@"open flutter page, result is %@",result);
            } completion:^(BOOL f) {
                NSLog(@"page is opened");
            }];
        }
    }];
    
    [self.tableDatas addObject:@{
        @"title":@"open native page",
        @"callback":^(){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    
    /*
    [self.tableDatas addObject:@{
        @"title":@"send action to flutter",
        @"callback":^(){
            [MagpieBridge sendEvent:@"EventTest" params:@{@"a":@"b"}];
        }
    }];
    
    [self.tableDatas addObject:@{
        @"title":@"get dart data",
        @"callback":^(){
            [MagpieBridge obtainData:@"header" params:@{@"a":@"b"} completion:^(id  _Nullable result) {
                NSLog(@"%@", result);
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"header" message:[NSString stringWithFormat:@"%@",result] preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                     
                }]];
                [self presentViewController:alert animated:YES completion:nil];
            }];
        }
    }];
     */
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"this is native page";
    [self.tableview reloadData];
    
    [MagpieBridge setDataRequestHandler:^id _Nullable(NSString * _Nullable name, NSDictionary * _Nullable params) {
        return params;
    }];
}

- (void)handleFlutterNotification:(NSNotification *)noti{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"广播" message:[NSString stringWithFormat:@"收到了来自flutter的广播: %@ ,参数为： %@",noti.name,noti.userInfo] preferredStyle:UIAlertControllerStyleAlert];
   [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                   }]];
   [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableDatas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.f;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    DemoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellIdentifier"];
    if (cell == nil) {
        cell = [[DemoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellIdentifier"];
    }
    cell.titleLabel.text = self.tableDatas[indexPath.row][@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DemoCallBack callback = self.tableDatas[indexPath.row][@"callback"];
    if (callback) {
        callback();
    }
}



@end
