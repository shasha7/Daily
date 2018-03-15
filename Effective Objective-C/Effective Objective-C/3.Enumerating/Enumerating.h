//
//  Enumerating.h
//  Effective Objective-C
//
//  Created by 王伟虎 on 2018/1/11.
//  Copyright © 2018年 wwh. All rights reserved.
//
//  增加代码的可读性
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WWHNetConnectStateType) {
    WWHNetConnectStateTypeUnknow = 0,
    WWHNetConnectStateTypeWIFI,
    WWHNetConnectStateType4G,
    WWHNetConnectStateType3G,
    WWHNetConnectStateType2G,
    WWHNetConnectStateTypeGPRS,
};

typedef NS_OPTIONS(NSInteger, WWHAutoRoundedMakType) {
    WWHAutoRoundedMakTypeN  = 1 << 0,
    WWHAutoRoundedMakTypeLT = 1 << 1,
    WWHAutoRoundedMakTypeLB = 1 << 2,
    WWHAutoRoundedMakTypeRT = 1 << 3,
    WWHAutoRoundedMakTypeRB = 1 << 4,
    WWHAutoRoundedMakTypeA  = 1 << 5,
};

@interface Enumerating : NSObject

@property (nonatomic, assign) WWHNetConnectStateType connectStateType;
@property (nonatomic, assign) WWHAutoRoundedMakType roundedMakType;

@end
