//
//  NSTimer+BlocksSupport.h
//  Effective Objective-C
//
//  Created by 王伟虎 on 2018/3/12.
//  Copyright © 2018年 wwh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (BlocksSupport)

+ (NSTimer *)eoc_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                       repeats:(BOOL)repeats
                                         block:(void(^)(void))block;

@end
