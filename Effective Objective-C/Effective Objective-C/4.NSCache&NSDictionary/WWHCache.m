//
//  WWHCache.m
//  Effective Objective-C
//
//  Created by 王伟虎 on 2018/1/12.
//  Copyright © 2018年 wwh. All rights reserved.
//

#import "WWHCache.h"

@interface WWHCache ()

@end

@implementation WWHCache

- (void)cache:(NSCache *)cache willEvictObject:(id)obj {
    NSLog(@"NSCacheDelegate %@ willEvictObject %@", NSStringFromSelector(_cmd), obj);
}

@end
