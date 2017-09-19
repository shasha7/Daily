//
//  IDMonitor.h
//  InterviewDemo
//
//  Created by 王伟虎 on 2017/9/6.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDConfig.h"

NS_ASSUME_NONNULL_BEGIN

// 最低使用版本 8.0
NS_CLASS_AVAILABLE_IOS(8_0) @interface IDMonitor : NSObject

/**
 * 设置配置信息
 * @param config 配置信息包括应用版本号、应用唯一标识
 */
+ (void)setupConfiguration:(IDConfig *)config;

/**
 * 开始监控
 */
+ (void)startMonitor;

@end

NS_ASSUME_NONNULL_END
