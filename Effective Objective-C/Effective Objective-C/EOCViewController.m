//
//  EOCViewController.m
//  Effective Objective-C
//
//  Created by wangweihu on 2018/4/11.
//  Copyright © 2018年 wwh. All rights reserved.
//

#import "EOCViewController.h"
#import "EOCNotificationCenter.h"

@interface EOCViewController ()

@end

@implementation EOCViewController

- (void)dealloc {
    NSLog(@"EOCViewController-----dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"通知中心";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[EOCNotificationCenter defaultCenter] addObserver:self selector:@selector(run) name:@"run" object:nil];
}

- (void)run {
    
    NSLog(@"崩溃？？？");
}

@end
