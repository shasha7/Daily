//
//  main.m
//  AssembleDemo
//
//  Created by 王伟虎 on 2017/10/11.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        struct {
            char *name;
            int age;
        }stu = {"wangweihu", 20};
        
        NSLog(@"%s", stu.name);
        /*
         结构体到底是什么东西
         AssembleDemo`main:
         0x100000e60 <+0>:  pushq  %rbp
         0x100000e61 <+1>:  movq   %rsp, %rbp
         0x100000e64 <+4>:  subq   $0x30, %rsp
         0x100000e68 <+8>:  movl   $0x0, -0x4(%rbp)
         0x100000e6f <+15>: movl   %edi, -0x8(%rbp)
         0x100000e72 <+18>: movq   %rsi, -0x10(%rbp)
         0x100000e76 <+22>: callq  0x100000eca               ; symbol stub for: objc_autoreleasePoolPush
         0x100000e7b <+27>: leaq   0x1ce(%rip), %rsi         ; @"%s"
         0x100000e82 <+34>: movq   0x1b7(%rip), %rcx
         0x100000e89 <+41>: movq   %rcx, -0x20(%rbp)
         0x100000e8d <+45>: movq   0x1b4(%rip), %rcx
         0x100000e94 <+52>: movq   %rcx, -0x18(%rbp)
         ->  0x100000e98 <+56>: movq   -0x20(%rbp), %rcx
         0x100000e9c <+60>: movq   %rsi, %rdi
         0x100000e9f <+63>: movq   %rcx, %rsi
         0x100000ea2 <+66>: movq   %rax, -0x28(%rbp)
         0x100000ea6 <+70>: movb   $0x0, %al
         0x100000ea8 <+72>: callq  0x100000ebe               ; symbol stub for: NSLog
         0x100000ead <+77>: movq   -0x28(%rbp), %rdi
         0x100000eb1 <+81>: callq  0x100000ec4               ; symbol stub for: objc_autoreleasePoolPop
         0x100000eb6 <+86>: xorl   %eax, %eax
         0x100000eb8 <+88>: addq   $0x30, %rsp
         0x100000ebc <+92>: popq   %rbp
         0x100000ebd <+93>: retq
         */
        
        // 还有一个栈帧的概念
        /*
         AssembleDemo`main:
         0x100000eb0 <+0>:  pushq  %rbp
         0x100000eb1 <+1>:  movq   %rsp, %rbp
         0x100000eb4 <+4>:  subq   $0x10, %rsp
         0x100000eb8 <+8>:  movl   $0x0, -0x4(%rbp)
         0x100000ebf <+15>: movl   %edi, -0x8(%rbp)
         0x100000ec2 <+18>: movq   %rsi, -0x10(%rbp)
         ;以上的汇编指令都是上一个函数的ebp部分
         ;栈帧开始的地方
         ->  0x100000ec6 <+22>: callq  0x100000ee2               ; symbol stub for: objc_autoreleasePoolPush
         0x100000ecb <+27>: movq   %rax, %rdi
         0x100000ece <+30>: callq  0x100000edc               ; symbol stub for: objc_autoreleasePoolPop
         0x100000ed3 <+35>: xorl   %eax, %eax
         0x100000ed5 <+37>: addq   $0x10, %rsp
         0x100000ed9 <+41>: popq   %rbp
         0x100000eda <+42>: retq
         */
        
        // 对象又是什么东东
//        Person *person = [Person new];
//        person.name = @"name";
//        NSLog(@"人名:%@", person.name);
        /*
         AssembleDemo`main:
         0x100000dd0 <+0>:   pushq  %rbp
         0x100000dd1 <+1>:   movq   %rsp, %rbp
         0x100000dd4 <+4>:   subq   $0x30, %rsp
         0x100000dd8 <+8>:   movl   $0x0, -0x4(%rbp)
         0x100000ddf <+15>:  movl   %edi, -0x8(%rbp)
         0x100000de2 <+18>:  movq   %rsi, -0x10(%rbp)
         0x100000de6 <+22>:  callq  0x100000e98               ; symbol stub for: objc_autoreleasePoolPush
         0x100000deb <+27>:  movq   0x3ee(%rip), %rsi         ; (void *)0x0000000100001218: Person
         0x100000df2 <+34>:  movq   0x3cf(%rip), %rcx         ; "new"
         0x100000df9 <+41>:  movq   %rsi, %rdi
         0x100000dfc <+44>:  movq   %rcx, %rsi
         0x100000dff <+47>:  movq   %rax, -0x20(%rbp)
         0x100000e03 <+51>:  callq  0x100000ea4               ; symbol stub for: objc_msgSend
         0x100000e08 <+56>:  leaq   0x249(%rip), %rcx         ; @"name"
         0x100000e0f <+63>:  movq   %rax, -0x18(%rbp)
         0x100000e13 <+67>:  movq   -0x18(%rbp), %rax
         0x100000e17 <+71>:  movq   0x3b2(%rip), %rsi         ; "setName:"
         0x100000e1e <+78>:  movq   %rax, %rdi
         0x100000e21 <+81>:  movq   %rcx, %rdx
         0x100000e24 <+84>:  callq  0x100000ea4               ; symbol stub for: objc_msgSend
         ->  0x100000e29 <+89>:  movq   -0x18(%rbp), %rax
         0x100000e2d <+93>:  movq   0x3a4(%rip), %rsi         ; "name"
         0x100000e34 <+100>: movq   %rax, %rdi
         0x100000e37 <+103>: callq  0x100000ea4               ; symbol stub for: objc_msgSend
         0x100000e3c <+108>: movq   %rax, %rdi
         0x100000e3f <+111>: callq  0x100000eb0               ; symbol stub for: objc_retainAutoreleasedReturnValue
         0x100000e44 <+116>: leaq   0x22d(%rip), %rcx         ; @
         0x100000e4b <+123>: movq   %rcx, %rdi
         0x100000e4e <+126>: movq   %rax, %rsi
         0x100000e51 <+129>: movq   %rax, -0x28(%rbp)
         0x100000e55 <+133>: movb   $0x0, %al
         0x100000e57 <+135>: callq  0x100000e8c               ; symbol stub for: NSLog
         0x100000e5c <+140>: movq   -0x28(%rbp), %rcx
         0x100000e60 <+144>: movq   %rcx, %rdi
         0x100000e63 <+147>: callq  0x100000eaa               ; symbol stub for: objc_release
         0x100000e68 <+152>: xorl   %r8d, %r8d
         0x100000e6b <+155>: movl   %r8d, %esi
         0x100000e6e <+158>: leaq   -0x18(%rbp), %rcx
         0x100000e72 <+162>: movq   %rcx, %rdi
         0x100000e75 <+165>: callq  0x100000ebc               ; symbol stub for: objc_storeStrong
         0x100000e7a <+170>: movq   -0x20(%rbp), %rdi
         0x100000e7e <+174>: callq  0x100000e92               ; symbol stub for: objc_autoreleasePoolPop
         0x100000e83 <+179>: xorl   %eax, %eax
         0x100000e85 <+181>: addq   $0x30, %rsp
         0x100000e89 <+185>: popq   %rbp
         0x100000e8a <+186>: retq
         */
        
//        int a = 1;
//        int b = 2;
//        int c = a + b;
//        NSLog(@"结果:%d", c);
        
        // 内联汇编 基本格式 __asm__volatile("Instruction List");
//        __asm__(
//                "pushq  %rbp"
//                "movq   %rsp, %rbp"
//                "subq   $0x30, %rsp"
//        );
        
        // 外联汇编
        // 创建后缀.s的assemble file文件，导入
        // 
        /*
         ;线程锁 总线锁定前缀“lock”
         AssembleDemo`main:
         0x100000f00 <+0>:  pushq  %rbp                      ;寄存器需要加前缀“%”
         0x100000f01 <+1>:  movq   %rsp, %rbp
         0x100000f04 <+4>:  subq   $0x30, %rsp
         0x100000f08 <+8>:  movl   $0x0, -0x4(%rbp)
         0x100000f0f <+15>: movl   %edi, -0x8(%rbp)
         0x100000f12 <+18>: movq   %rsi, -0x10(%rbp)
         0x100000f16 <+22>: callq  0x100000f6e               ; symbol stub for: objc_autoreleasePoolPush
         0x100000f1b <+27>: leaq   0x106(%rip), %rsi         ; @
         0x100000f22 <+34>: movl   $0x1, -0x14(%rbp)         ;立即数 需要加前缀“$”。
         0x100000f29 <+41>: movl   $0x2, -0x18(%rbp)
         0x100000f30 <+48>: movl   -0x14(%rbp), %edi
         0x100000f33 <+51>: addl   -0x18(%rbp), %edi
         0x100000f36 <+54>: movl   %edi, -0x1c(%rbp)
         ->  0x100000f39 <+57>: movl   -0x1c(%rbp), %edi
         0x100000f3c <+60>: movl   %edi, -0x20(%rbp)
         0x100000f3f <+63>: movq   %rsi, %rdi
         0x100000f42 <+66>: movl   -0x20(%rbp), %esi
         0x100000f45 <+69>: movq   %rax, -0x28(%rbp)
         0x100000f49 <+73>: movb   $0x0, %al
         0x100000f4b <+75>: callq  0x100000f62               ; symbol stub for: NSLog
         0x100000f50 <+80>: movq   -0x28(%rbp), %rdi
         0x100000f54 <+84>: callq  0x100000f68               ; symbol stub for: objc_autoreleasePoolPop
         0x100000f59 <+89>: xorl   %eax, %eax
         0x100000f5b <+91>: addq   $0x30, %rsp
         0x100000f5f <+95>: popq   %rbp
         0x100000f60 <+96>: retq
         */
    }
    return 0;
}
