//
//  CalculateMaker.h
//  MasonryDemo
//
//  Created by 王伟虎 on 2017/9/30.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import <Foundation/Foundation.h>

// 有时候宏也是可以当做注释用的
#define ADD
#define MINUS
#define MUTIPLY
#define KVO

@interface CalculateMaker : NSObject

@property (nonatomic, assign) KVO NSInteger result;

- (CalculateMaker * (^)(NSInteger))add; ADD
- (CalculateMaker * (^)(NSInteger))minus; MINUS
- (CalculateMaker * (^)(NSInteger))multiply; MUTIPLY

@end
