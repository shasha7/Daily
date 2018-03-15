//
//  Enumerating.m
//  Effective Objective-C
//
//  Created by 王伟虎 on 2018/1/11.
//  Copyright © 2018年 wwh. All rights reserved.
//

#import "Enumerating.h"

@implementation Enumerating

- (void)setConnectStateType:(WWHNetConnectStateType)connectStateType {
    _connectStateType = connectStateType;
    NSLog(@"WWHNetConnectStateType = %ld", (long)connectStateType);
}

- (void)setRoundedMakType:(WWHAutoRoundedMakType)roundedMakType {
    /*
     左移操作符
     WWHAutoRoundedMakTypeN  = 1 << 0, 0000 0001  1
     WWHAutoRoundedMakTypeLT = 1 << 1, 0000 0010  2
     WWHAutoRoundedMakTypeLB = 1 << 2, 0000 0100  4
     WWHAutoRoundedMakTypeRT = 1 << 3, 0000 1000  8
     WWHAutoRoundedMakTypeRB = 1 << 4, 0001 0000  16
     WWHAutoRoundedMakTypeA  = 1 << 5, 0010 0000  32
     
     这些所有的值进行或的话                0011 1111
     */
    if (roundedMakType & WWHAutoRoundedMakTypeN) {
        // 结果值在&上WWHAutoRoundedMakTypeN,结果恰巧是 0000 0001，这也恰好是WWHAutoRoundedMakTypeN，一下判断均为此
        NSLog(@"没有任何圆角");
    }
    
    if (roundedMakType & WWHAutoRoundedMakTypeLT) {
        NSLog(@"左上角进行圆角");
    }
    
    if (roundedMakType & WWHAutoRoundedMakTypeRT) {
        NSLog(@"右上角进行圆角");
    }
    
    if (roundedMakType & WWHAutoRoundedMakTypeLB) {
        NSLog(@"左下角进行圆角");
    }
    
    if (roundedMakType & WWHAutoRoundedMakTypeRB) {
        NSLog(@"右下角进行圆角");
    }
    
    if (roundedMakType & WWHAutoRoundedMakTypeA) {
        NSLog(@"四周进行圆角");
    }
}

@end
