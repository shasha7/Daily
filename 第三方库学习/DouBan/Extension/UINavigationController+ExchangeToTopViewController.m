//
//  UINavigationController+ExchangeToTopViewController.m
//  DouBan
//
//  Created by 王伟虎 on 2017/12/18.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import "UINavigationController+ExchangeToTopViewController.h"

@implementation UINavigationController (ExchangeToTopViewController)

- (void)exchangeToTopViewController:(UIViewController *)topViewController animated:(BOOL)animated {
    // the topViewController can not be nil
    if (!topViewController) {
        return;
    }
    
    // The current view controller stack.
    NSMutableArray *viewControllers = [self.viewControllers mutableCopy];
    if (viewControllers.count <= 1) {
        [self pushViewController:topViewController animated:animated];
        return;
    }
    [viewControllers replaceObjectAtIndex:viewControllers.count - 1 withObject:topViewController];
    
    // If animated is YES, then simulate a push or pop depending on whether the new top view controller was previously in the stack.
    [self setViewControllers:[viewControllers copy] animated:animated];
}

@end
