//
//  EOCWeakProxy.h
//  Effective Objective-C
//
//  Created by 王伟虎 on 2018/3/12.
//  Copyright © 2018年 wwh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EOCWeakProxy : NSObject

/**
 The proxy target.
 */
@property (nullable, nonatomic, weak, readonly) id target;

/**
 Creates a new weak proxy for target.
 
 @param target Target object.
 
 @return A new proxy object.
 */
- (instancetype)initWithTarget:(id)target;

/**
 Creates a new weak proxy for target.
 
 @param target Target object.
 
 @return A new proxy object.
 */
+ (instancetype)proxyWithTarget:(id)target;

@end

NS_ASSUME_NONNULL_END
