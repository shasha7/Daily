//
//  RedView.m
//  ReactiveCocoaDemo
//
//  Created by 王伟虎 on 2017/9/30.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import "RedView.h"

@implementation RedView

- (RACSubject *)subject {
    if (!_subject) {
        _subject = [RACSubject subject];
    }
    return _subject;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn.backgroundColor = [UIColor redColor];
        self.btn.frame = CGRectMake(100, 100, 100, 30);
        [self.btn setTitle:@"Button" forState:UIControlStateNormal];
        [self.btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btn];
    }
    return self;
}

- (void)btnClick:(UIButton *)sender {
    NSLog(@"红色View内的按钮被点击了");
    [self.subject sendNext:@(1)];
    /*
     // 内部执行这个方法
     - (void)sendNext:(id)value {
        [self enumerateSubscribersUsingBlock:^(id<RACSubscriber> subscriber) {
            [subscriber sendNext:value];
        }];
     }
     - (void)enumerateSubscribersUsingBlock:(void (^)(id<RACSubscriber> subscriber))block {
        NSArray *subscribers;
        @synchronized (self.subscribers) {
            subscribers = [self.subscribers copy];
        }
     
        for (id<RACSubscriber> subscriber in subscribers) {
            // 执行[subscriber sendNext:value];
            block(subscriber);
        }
     }
     - (void)sendNext:(id)value {
        @synchronized (self) {
            void (^nextBlock)(id) = [self.next copy];
            if (nextBlock == nil) return;
            nextBlock(value);
        }
     }
     */
}

@end
