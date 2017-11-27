//
//  JYApplication.m
//  JYFlowInfoAd
//
//  Created by 王伟虎 on 2017/11/27.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import "JYApplication.h"
#import "WWHTableViewController.h"

@implementation JYApplication

- (void)sendEvent:(UIEvent *)event {
    [super sendEvent:event];
}

- (BOOL)sendAction:(SEL)action to:(id)target from:(id)sender forEvent:(UIEvent *)event {
    if ([target isKindOfClass:[WWHTableViewController class]] && [sender isKindOfClass:[UIScrollView class]] && [NSStringFromSelector(action) isEqualToString:@"scrollViewDidScroll:"]) {
        // 记录登录行为日志 或上报服务器
        NSLog(@"无侵入式埋点统计");
        return YES;
    }
    return [super sendAction:action to:target from:sender forEvent:event];
}

@end
