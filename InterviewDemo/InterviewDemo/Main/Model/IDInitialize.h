//
//  IDInitialize.h
//  InterviewDemo
//
//  Created by 王伟虎 on 2017/9/6.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class IDTabBarController;

@interface IDInitialize : NSObject

/**
 * Returns the same instance no matter how many times an application requests it
 */
+ (instancetype)sharedInitialize;

/**
 * Setup the application's tabBar appearance
 */
+ (void)setupTabBarAppearance;

/**
 * Setup application's navigationBar appearance
 */
+ (void)setupNavigationBarAppearance;

@end

NS_ASSUME_NONNULL_END
