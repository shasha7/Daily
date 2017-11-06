//
//  JYFlowInfoManager.m
//  JYFlowInfoAd
//
//  Created by 王伟虎 on 2017/11/6.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import "JYFlowInfoManager.h"

@implementation JYFlowInfoManager

static JYFlowInfoManager *_manager = nil;

+ (instancetype)sharedFlowInfoManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[JYFlowInfoManager alloc] init];
    });
    return _manager;
}

@end
