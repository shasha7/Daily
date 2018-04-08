//
//  DBViewTwo.m
//  DouBan
//
//  Created by 王伟虎 on 2018/4/8.
//  Copyright © 2018年 wwh. All rights reserved.
//

#import "DBViewTwo.h"

@implementation DBViewTwo

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    // 1.自己先处理事件...
    NSLog(@"do somthing...DBViewTwo");
    
    // 2.再调用系统的默认做法，再把事件交给上一个响应者处理
    [super touchesBegan:touches withEvent:event];
}

@end
