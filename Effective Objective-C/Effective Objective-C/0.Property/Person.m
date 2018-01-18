//
//  Person.m
//  property
//
//  Created by 王伟虎 on 2018/1/6.
//  Copyright © 2018年 wwh. All rights reserved.
//

#import "Person.h"

@implementation Person

+ (void)initialize {
    if ([self isKindOfClass:[Person class]]) {
        NSLog(@"%@",NSStringFromSelector(_cmd));
    }
}

@end
