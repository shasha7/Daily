//
//  DBJS.m
//  DouBan
//
//  Created by wangweihu on 2018/4/6.
//  Copyright © 2018年 wwh. All rights reserved.
//

#import "DBJS.h"

@implementation DBJS

- (NSString *)getClientId {
    NSLog(@"thread = %@", [NSThread currentThread]);//子线程
    return @"getClientId";
}

- (NSString *)getVersionId {
    NSLog(@"thread = %@", [NSThread currentThread]);//子线程
    return @"getVersionId";
}

- (NSString *)getChannelId {
    NSLog(@"thread = %@", [NSThread currentThread]);//子线程
    return @"getChannelId";
}

@end
