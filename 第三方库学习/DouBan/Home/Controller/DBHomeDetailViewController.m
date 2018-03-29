//
//  DBHomeDetailViewController.m
//  DouBan
//
//  Created by 王伟虎 on 2017/12/18.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import "DBHomeDetailViewController.h"

@interface DBHomeDetailViewController ()

@end

@implementation DBHomeDetailViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"详情";
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    
    UIApplication *application = [UIApplication sharedApplication];
    // 打开其他家应用 前提是手机上有安装需要打开的应用
    if ([application canOpenURL:[NSURL URLWithString:@"jiayuan://"]]) {
        if (@available(iOS 10.0, *)) {
            //?{\"jsonValue\": 1,\"jsonParams\": {\"go\": 4}}
//            NSString *str = @"{\"jsonValue\": 1,\"jsonParams\": {\"go\": 4}}";
            NSDictionary *dict = @{@"go":@(4)};
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
            NSRange range = {0,jsonString.length};
            //去掉字符串中的空格
            [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
            NSRange range2 = {0,mutStr.length};
            //去掉字符串中的换行符
            [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
            NSString *json = [NSString stringWithFormat:@"jiayuan://xxx?jsonValue=1&jsonParams=%@",mutStr];
            [application openURL:[NSURL URLWithString:json] options:@{} completionHandler:^(BOOL success) {
                NSLog(@"success = %@", @(success));
            }];
        } else {
            // Fallback on earlier versions
        }
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"sorry the application is not load" delegate:self cancelButtonTitle:@"Cacell" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
