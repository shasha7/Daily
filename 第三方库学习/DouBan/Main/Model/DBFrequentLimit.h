//
//  DBFrequentLimit.h
//  DouBan
//
//  Created by 王伟虎 on 2017/12/15.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBFrequentLimit : NSObject

/**
 * 限制函数调用频率
 * @param countLimit 限制的次数
 * @param secondsLimit 限制的次数/时间  secondsLimit时间内允许函数调用次数countLimit
 */
- (instancetype)initWithCountLimit:(NSInteger)countLimit secondsLimit:(CGFloat)secondsLimit;

/**
 * 是否可以调用函数
 */
- (BOOL)canTrigger;

@end
