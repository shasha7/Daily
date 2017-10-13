//
//  Call.h
//  AssembleDemo
//
//  Created by 王伟虎 on 2017/10/11.
//  Copyright © 2017年 wwh. All rights reserved.
//

#ifndef Call_h
#define Call_h

/*
 Xcode AT&T格式
 
 $美元符号开头 一般是常量值
 %开头的一般是寄存器
 */

/*
 call ret配合使用就实现了函数调用功能
 
 ret 将栈顶的值出栈，赋值给ip
 call标记 将下一条指令的ip压栈 转到标记处执行指令
 call指令 理论上相当于 push(将下一条指令的偏移地址压栈)  jmp(转到标记处执行指令)


 无参无返回值
 ==============================
 assume cs:code ds:data ss:stack
 
 ;栈段
 stack segment
    db 20 dup(0)
 stack ends
 
 ;数据段
 data segment
    db 20 dup(0)
    string db 'helloworld!$'
 data ends
 
 ;代码段
 code segment
 start:
    mov ax, data
    mov ds, ax
    mov ax, stack
    mov ss, ax
 
    call print
 
    mov ah, 4ch
    int 21h
 sum:
 
    ret 4
 print:
    mov ds, offset string
    mov ah, 9h
    int 21h
    ret
 code ends
 end start
 
 
 有参有返回值
 实现两个数相加并返回结果
 ==============================
 
 传参数就是压栈 出栈
 push 4h
 push 3h
 call sum
 
 sum:
    mov bp, sp
    mov ax, [bp + 2]
    add ax, [bp + 4]
 
 */

#endif /* Call_h */
