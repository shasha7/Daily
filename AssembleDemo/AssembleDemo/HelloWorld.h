//
//  HelloWorld.h
//  AssembleDemo
//
//  Created by 王伟虎 on 2017/10/11.
//  Copyright © 2017年 wwh. All rights reserved.
//

#ifndef HelloWorld_h
#define HelloWorld_h

/*
 基础知识
 CPU 常见架构的代表i8086cpu
 16个16位的内存代码块
 内存地址是由段地址和偏移地址组成
 8086有一个段寄存器DS 专门用于存储访问数据的段地址，也成为数据段。
 CS:IP 标记过的内存  cpu才会认为这块内存中的数据是指令 而不是简单的
 
 修改DS内存只能通过类似于这种方式
 mov ax, 1000H
 mov ds, ax
 这两行执行完之后就相当于
 mov ds, 1000H
 
 mov al, [0] == mov al, ds:[偏移地址]
 ax(16位) = ah(高八位) + al(低八位)
 
 大小端
 大端模式，是指数据的高字节保存在内存的低地址中，而数据的低字节保存在内存的高地址中（高低\低高） (Big Endian) 代表PowerPC IBM Sun
 小端模式，是指数据的高字节保存在内存的高地址中，而数据的低字节保存在内存的低地址中（高高\低低） (Little Endian) 代表 x86 DEC
 ARM均可
 
 mov 内存单元，内存单元  这种是不允许的
 
 Mac debug 调试
 常用指令
 R(查看改变CPU寄存器的内容)
 D(查看内存中的内容)
 U(将机器指令编译成汇编指令)
 T(执行指令)
 A(以汇编指令d额格式za内存中写入一条机器指令)
 E(改写n内存中的内容)
 Q(退出debug)
 P(跳过loop循环)
 G(跳到指定代码位置)
 
 
 完整的一个程序
 新建test.asm文件 里面写一下代码并保存
 assume cs:code
 
 code segment
 
 mov ax, 3344H
 mov bx, 1122H
 add ax, bx
 
 ;退出程序  逗号注释作用
 mov ah, 4ch 或者 mov ax, 4c00h
 int 21h  中断   分为软硬中断
 code ends
 
 end
 
 如何编译连接
 
 在win7命令行打开masm.exe test.asm 然后编译 生成目标文件test.obj
 在执行link.exe test.obj 链接 生成可执行文件test.exe
 在执行debug test.exe 调试
 
 代码解读
 汇编指令 mov add sub 有对应的机器指令
 伪指令  ends end segment assume  没有对应的机器指令
 
 一个有意义的汇编程序  至少要有一个段作为代码段存放代码
 
 段名 segment
 这里面是汇编指令
 段名 ends
 
 assume将代码段的和CPU寄存器关联起来
 
 int [中断码] 内存中有一个中断码表 用来存储处理中断程序的入口地址
 */


#endif /* HelloWorld_h */
