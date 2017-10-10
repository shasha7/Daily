//
//  RCLoginViewController.m
//  ReactiveCocoaDemo
//
//  Created by 王伟虎 on 2017/10/10.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import "RCLoginViewController.h"
#import "RCLoginViewModel.h"

@interface RCLoginViewController ()

@property (nonatomic, strong) RCLoginViewModel *viewModel;

@end

@implementation RCLoginViewController

- (RCLoginViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[RCLoginViewModel alloc] init];
    }
    return _viewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 常用于登录界面业务逻辑处理  只有账号、密码都存在时候 登录按钮才可以点击
    [self.viewModel bindViewModelWithView:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
