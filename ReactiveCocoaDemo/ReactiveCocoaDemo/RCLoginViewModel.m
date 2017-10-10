//
//  RCLoginViewModel.m
//  ReactiveCocoaDemo
//
//  Created by 王伟虎 on 2017/10/10.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import "RCLoginViewModel.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "RCLoginViewController.h"
#import "RCTableViewController.h"

@implementation RCLoginViewModel

-(void)bindViewModelWithView:(id)view {
    RCLoginViewController *vc = (RCLoginViewController *)view;
    
    [[RACSignal combineLatest:@[vc.accountTextField.rac_textSignal, vc.psdTextField.rac_textSignal] reduce:^id(NSString *account, NSString *pwd){
        return @(vc.accountTextField.text.length && vc.psdTextField.text.length);
    }] subscribeNext:^(id x) {
        vc.loginBtn.enabled = [x boolValue];
    }];
    
    [[vc.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIControl *x) {
        RCTableViewController *tableVC = [[RCTableViewController alloc] init];
        [vc.navigationController pushViewController:tableVC animated:YES];
    }];
}

@end
