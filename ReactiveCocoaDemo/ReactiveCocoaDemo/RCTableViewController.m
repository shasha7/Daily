//
//  RCTableViewController.m
//  ReactiveCocoaDemo
//
//  Created by 王伟虎 on 2017/10/10.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import "RCTableViewController.h"
#import "RCRequestViewModel.h"

@interface RCTableViewController ()

@property (nonatomic, strong) RCRequestViewModel *viewModel;

@end

@implementation RCTableViewController

- (RCRequestViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[RCRequestViewModel alloc] init];
    }
    return _viewModel;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"订阅频道";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.viewModel bindViewModelWithView:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
