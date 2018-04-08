//
//  DBBaseView.m
//  DouBan
//
//  Created by 王伟虎 on 2018/4/8.
//  Copyright © 2018年 wwh. All rights reserved.
//

#import "DBBaseView.h"

@implementation DBBaseView

// recursively calls -pointInside:withEvent:. point is in the receiver's coordinate system
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.userInteractionEnabled == NO || self.alpha <= 0.01 || self.hidden == YES) {
        // 不管这个控件能不能处理事件，也不管触摸点在不在这个控件上，事件都会先传递给这个控件，随后再调用hitTest:withEvent:方法
        // 如果hitTest:withEvent:方法中返回nil，那么调用该方法的控件本身和其子控件都不是最合适的view，也就是在自己身上没有找到更合适的view。那么最合适的view就是该控件的父控件
        return nil;
    }
    if (![self pointInside:point withEvent:event]) return nil;
    
    NSInteger count = self.subviews.count;
    for (NSInteger i = count - 1; i>=0; i--) {
        UIView *childView = [self.subviews objectAtIndex:i];
        CGPoint childPoint = [self convertPoint:point toView:childView];
        UIView *fitView = [childView hitTest:childPoint withEvent:event];
        if (fitView) {
            return childView;
        }
    }
    return self;
}

@end
