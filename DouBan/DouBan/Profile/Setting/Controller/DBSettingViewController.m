//
//  DBSettingViewController.m
//  DouBan
//
//  Created by 王伟虎 on 2017/12/18.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import "DBSettingViewController.h"

@interface DBSettingViewController ()

@end

@implementation DBSettingViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"设置";
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
