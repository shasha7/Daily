//
//  WWHKVONotifying_Person.m
//  MasonryDemo
//
//  Created by 王伟虎 on 2017/9/30.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import "WWHKVONotifying_Person.h"
#import "NSObject+KVO.h"
#import <objc/runtime.h>

@implementation WWHKVONotifying_Person

- (void)setAge:(NSInteger)age {
    [super setAge:age];
    
    id observer = objc_getAssociatedObject(self, kObserverKey);
    [observer observeValueForKeyPath:@"age" ofObject:self change:nil context:nil];
}

@end
