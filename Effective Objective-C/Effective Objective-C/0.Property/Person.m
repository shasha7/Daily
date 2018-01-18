//
//  Person.m
//  property
//
//  Created by 王伟虎 on 2018/1/6.
//  Copyright © 2018年 wwh. All rights reserved.
//

#import "Person.h"
#import "Dog.h"

@implementation Person

+ (void)load {
    NSLog(@"Person load");
    [Dog eat];
}

+ (void)initialize {
    if (self == [Person class]) {
        NSLog(@"Person%@",NSStringFromSelector(_cmd));
    }
}

@end
