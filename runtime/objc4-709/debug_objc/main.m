//
//  main.m
//  debug_objc
//
//  Created by Holy_Han on 19/09/2017.
//
//

#import <Foundation/Foundation.h>
#import "Dog.h"

int main(int argc, const char * argv[]) {

    @autoreleasepool {
        // insert code here...
        /*
         libdyld.dylib`start:
         0x7fffa2f15234 <+0>:
         0x7fffa2f15235 <+1>: movl   %eax, %edi
         0x7fffa2f15237 <+3>: callq  0x7fffa2f15292            ; symbol stub for: exit
         0x7fffa2f1523c <+8>:
         
         8086CPU 汇编语言集合
         王爽 <<汇编语言>>
         硬件结构
         如何执行-硬盘、内存、CPU
         最关键的是了解内存与CPU
         */
        Dog *dog = [[Dog alloc] init];
        NSLog(@"%@", dog);
    }
    return 0;
}
