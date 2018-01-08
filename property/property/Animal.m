//
//  Animal.m
//  property
//
//  Created by 王伟虎 on 2018/1/8.
//  Copyright © 2018年 wwh. All rights reserved.
//

#import "Animal.h"

@implementation Animal

+ (void)initialize {
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

@end
