//
//  UINavigationController+ExchangeToTopViewController.h
//  DouBan
//
//  Created by 王伟虎 on 2017/12/18.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (ExchangeToTopViewController)

/**
 * 替换栈顶控制器(当且仅且栈中控制器大于1)
 * @param topViewController 替换后会处于栈顶的控制器
 * @param animated          push或present是否需要动画
 */
- (void)exchangeToTopViewController:(UIViewController *_Nullable)topViewController animated:(BOOL)animated;

@end
