//
//  DBSafeMutableDictionary.h
//  DouBan
//
//  Created by wangweihu on 2018/4/8.
//  Copyright © 2018年 wwh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBSafeMutableDictionary : NSObject

- (id)objectForKey:(id)aKey;
- (NSArray *)allKeys;
- (void)setObject:(id)anObject forKey:(id <NSCopying>)aKey;
- (void)removeObjectForKey:(id)aKey;

@end
