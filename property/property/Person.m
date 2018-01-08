//
//  Person.m
//  property
//
//  Created by 王伟虎 on 2018/1/6.
//  Copyright © 2018年 wwh. All rights reserved.
//

#import "Person.h"

@implementation Person

// +initialize 只会在对应类的方法第一次被使用时，才会被调用
// 未初始化的类发送 +initialize 消息，不过会强制父类先发送 +initialize
+ (void)initialize {
    if ([self isKindOfClass:[Person class]]) {
        NSLog(@"%@",NSStringFromSelector(_cmd));
    }
}

@end
