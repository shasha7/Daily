//
//  IDConfig.h
//  InterviewDemo
//
//  Created by 王伟虎 on 2017/9/6.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDConfig : NSObject

/**
 * 应用版本号
 */
@property (nonatomic, strong) NSString *version;

/**
 * 应用唯一标识
 */
@property (nonatomic, strong) NSString *identifier;

@end
