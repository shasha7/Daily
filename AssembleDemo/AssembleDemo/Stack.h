//
//  Stack.h
//  AssembleDemo
//
//  Created by 王伟虎 on 2017/10/11.
//  Copyright © 2017年 wwh. All rights reserved.
//

#ifndef Stack_h
#define Stack_h

/*
 栈段
 SS寄存器
 SS:SP栈顶
 push ax 栈顶指针变小
 pop ax  栈顶指针变大
 push pop操作的数据都是2个字节
 我们可以将一组长度为N（N<=64KB）、地址连续、起始地址为16倍数的内存单元，当做栈空间来使用，称为栈段。比如用10010H~1001FH这段内存空间当做栈来使用，我们就可以认为10010H~1001FH是一个栈段，它的段地址为1001H，长度为16字节
 用SS存放栈段的段地址，用SP存放栈顶的偏移地址
 */

#endif /* Stack_h */
