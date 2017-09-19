//
//  IDMonitor.m
//  InterviewDemo
//
//  Created by 王伟虎 on 2017/9/6.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import "IDMonitor.h"

@interface IDMonitor ()

@end

@implementation IDMonitor

static IDConfig *_config;

+ (void)setupConfiguration:(IDConfig *)config {
    _config = config;
    NSLog(@"当前监控器版本号：%@, 唯一标识符：%@", config.version, config.identifier);
}

+ (void)startMonitor {
    
}

@end
