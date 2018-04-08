//
//  DBSafeMutableDictionary.m
//  DouBan
//
//  Created by wangweihu on 2018/4/8.
//  Copyright © 2018年 wwh. All rights reserved.
//

#import "DBSafeMutableDictionary.h"

@interface DBSafeMutableDictionary ()

@property (nonatomic, strong) NSMutableDictionary *dictionary;
@property (nonatomic, strong) dispatch_queue_t dispatchQueue;

@end

@implementation DBSafeMutableDictionary

- (instancetype)init {
    if (self = [super init]) {
        _dictionary = [NSMutableDictionary new];
        _dispatchQueue = dispatch_queue_create("com.jiayuan.jiayuanmutabledictionary", DISPATCH_QUEUE_SERIAL);
    }
    
    return self;
}

- (NSArray *)allKeys {
    __block NSArray *allKeys = nil;
    dispatch_sync(self.dispatchQueue, ^{
        allKeys = [self.dictionary allKeys];
    });
    return allKeys;
}

- (id)objectForKey:(id)aKey {
    __block id returnObject = nil;
    
    dispatch_sync(self.dispatchQueue, ^{
        returnObject = [self.dictionary objectForKey:aKey];
    });
    
    return returnObject;
}

- (void)setObject:(id)anObject forKey:(id <NSCopying>)aKey {
    dispatch_sync(self.dispatchQueue, ^{
        [self.dictionary setObject:anObject forKey:aKey];
    });
}

- (void)removeObjectForKey:(id)aKey {
    dispatch_sync(self.dispatchQueue, ^{
        [self.dictionary removeObjectForKey:aKey];
    });
}

@end
