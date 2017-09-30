//
//  CalculateMaker.m
//  MasonryDemo
//
//  Created by 王伟虎 on 2017/9/30.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import "CalculateMaker.h"

@implementation CalculateMaker

- (CalculateMaker *(^)(NSInteger))add {
    return ^CalculateMaker *(NSInteger num) {
        _result += num;
        return self;
    };
}

- (CalculateMaker * (^)(NSInteger))minus {
    return ^CalculateMaker *(NSInteger num) {
        _result -= num;
        return self;
    };
}

- (CalculateMaker * (^)(NSInteger))multiply {
    return ^CalculateMaker *(NSInteger num) {
        _result *= num;
        return self;
    };
}

- (NSInteger)result {
    return _result;
}

@end
