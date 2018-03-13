//
//  NSTimer+BlocksSupport.m
//  Effective Objective-C
//
//  Created by 王伟虎 on 2018/3/12.
//  Copyright © 2018年 wwh. All rights reserved.
//

#import "NSTimer+BlocksSupport.h"

@implementation NSTimer (BlocksSupport)

+ (NSTimer *)eoc_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                       repeats:(BOOL)repeats
                                         block:(void(^)(void))block {
    return [self scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(eoc_blockInvoke:)
                                       userInfo:[block copy]
                                        repeats:repeats];
}

+ (void)eoc_blockInvoke:(NSTimer *)timer {
    void (^block)(void) = timer.userInfo;
    if(block) {
        block();
    }
}

@end
