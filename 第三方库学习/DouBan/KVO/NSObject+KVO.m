//
//  NSObject+KVO.m
//  MasonryDemo
//
//  Created by 王伟虎 on 2017/9/30.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import "NSObject+KVO.h"
#import <objc/runtime.h>
#import "WWHKVONotifying_Person.h"

static char *kObserverKey = "observer";

@implementation NSObject (KVO)

- (void)wwh_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context {
    
    object_setClass(self, [WWHKVONotifying_Person class]);
    
    objc_setAssociatedObject(self, kObserverKey, observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
