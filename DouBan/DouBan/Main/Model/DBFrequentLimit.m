//
//  DBFrequentLimit.m
//  DouBan
//
//  Created by 王伟虎 on 2017/12/15.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import "DBFrequentLimit.h"

@interface DBFrequentLimit ()

@property (nonatomic, assign) NSInteger countLimit;
@property (nonatomic, assign) CGFloat secondsLimit;
@property (nonatomic, assign) CGFloat preTime;
@property (nonatomic, assign) NSInteger curCount;

@end

@implementation DBFrequentLimit

- (instancetype)initWithCountLimit:(NSInteger)countLimit secondsLimit:(CGFloat)secondsLimit {
    if (self == [super init]) {
        _countLimit = countLimit;
        _secondsLimit = secondsLimit;
        _preTime = 0.0f;
    }
    return self;
}

- (BOOL)canTrigger {
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    if (_preTime == 0 || currentTime - _preTime > _secondsLimit) {
        _preTime = currentTime;
        _curCount = 0;
    }
    if (_curCount >= _countLimit) {
        return NO;
    }
    _curCount++;
    return YES;
}

@end
