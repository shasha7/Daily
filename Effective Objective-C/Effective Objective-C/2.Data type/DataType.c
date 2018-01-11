//
//  DataType.c
//  Effective Objective-C
//
//  Created by 王伟虎 on 2018/1/11.
//  Copyright © 2018年 wwh. All rights reserved.
//

#include "DataType.h"

void testPointerNoParameter (void) {
    // 直接修改变量的大小
    int a;
    a = 10;
    
    // 间接修改变量的大小，这是指针存在的最大意义
    // 指针指向某个变量，就是把某个变量地址传给指针
    // &a的地址值0x00007ffee378cb2c等于变量p的地址值0x00007ffee378cb2c
    int *p;
    p = &a;
    *p = 20;
}

/*
 *p间接赋值成立条件：3个条件
 a) 2个变量（通常一个实参，一个形参）
 b) 建立关系，实参取地址赋给形参指针
 c) *p形参去间接修改实参的值
 
 引申：函数调用时,用n级指针（形参）改变n-1级指针（实参）的值
 函数调用时，用实参取地址，传给形参，在被调用函数里面用*p，来改变实参，把运算结果传出来
 */
void testPointer (int *a) {
    int *tmp = a;
    *tmp = 20;
}


