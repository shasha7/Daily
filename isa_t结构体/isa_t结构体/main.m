//
//  main.m
//  isa_t结构体
//
//  Created by 王伟虎 on 2018/1/8.
//  Copyright © 2018年 wwh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NSString *binaryWithInter(NSUInteger decInt) {
    NSString *str = @"";
    NSUInteger x = decInt;
    while (x > 0) {
        str = [[NSString stringWithFormat:@"%lu", x&1] stringByAppendingString:str];
        x = x >> 1;
    }
    return str;
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        struct objc_object *objct = (__bridge struct objc_object *)([NSObject new]);
        
        // 使用整个指针大小的内存来存储isa指针有些浪费，尤其在6 位的CPU上。在ARM64运行的iOS只使用了 33位作为指针(与结构体中的33位无关，Mac OS上为4位)，而剩下的31位用于其它目的。类的指针也同样根据字节对齐了，每一个类指针的地址都能够被8整除，也就是使最后3bits为0，为isa留下34位用于性能的优化。
        NSLog(@"%@", binaryWithInter(objct->isa));
        NSLog(@"%@", binaryWithInter((uintptr_t)[NSObject class]));
        // 0000000001011101111111111111111110010000110100100000000101000001补全64位
        // 11111111111111110010000110100100000000101000000
    }
    return 0;
}
