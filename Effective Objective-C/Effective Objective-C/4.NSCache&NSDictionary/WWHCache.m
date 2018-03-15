//
//  WWHCache.m
//  Effective Objective-C
//
//  Created by wangweihu on 2018/3/15.
//  Copyright © 2018年 wwh. All rights reserved.
//

#import "WWHCache.h"
#import <UIKit/UIKit.h>

@implementation WWHCache

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAllObjects) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

@end
