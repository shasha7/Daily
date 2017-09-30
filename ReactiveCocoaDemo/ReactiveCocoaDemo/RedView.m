//
//  RedView.m
//  ReactiveCocoaDemo
//
//  Created by 王伟虎 on 2017/9/30.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import "RedView.h"

@implementation RedView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn.backgroundColor = [UIColor redColor];
        self.btn.frame = CGRectMake(100, 100, 100, 30);
        [self.btn setTitle:@"Button" forState:UIControlStateNormal];
        [self addSubview:self.btn];
    }
    return self;
}
    
@end
