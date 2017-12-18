//
//  DBProfileViewController.m
//  DouBan
//
//  Created by 王伟虎 on 2017/10/2.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import "DBProfileViewController.h"
#import "DBSettingViewController.h"
#import "UINavigationController+ExchangeToTopViewController.h"

@interface DBProfileViewController ()

@end

@implementation DBProfileViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"设置";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(setting)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setting {
    DBSettingViewController *settingVC = [[DBSettingViewController alloc] init];
    [self.navigationController exchangeToTopViewController:settingVC animated:YES];
}

@end
