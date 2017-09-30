//
//  NSObject+Calculate.h
//  MasonryDemo
//
//  Created by 王伟虎 on 2017/9/30.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalculateMaker.h"

@interface NSObject (Calculate)

+ (NSInteger)wwh_makeCaculate:(void(^)(CalculateMaker *))block;
    
@end
