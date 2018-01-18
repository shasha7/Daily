//
//  NSObject+Calculate.m
//  MasonryDemo
//
//  Created by 王伟虎 on 2017/9/30.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import "NSObject+Calculate.h"

@implementation NSObject (Calculate)

+ (NSInteger)wwh_makeCaculate:(void(^)(CalculateMaker *))block {
    CalculateMaker *maker = [[CalculateMaker alloc] init];
    block(maker);
    return [maker result];
}

@end
