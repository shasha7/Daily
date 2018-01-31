//
//  main.c
//  C基础
//
//  Created by 王伟虎 on 2018/1/30.
//  Copyright © 2018年 wwh. All rights reserved.
//

#include <stdio.h>

typedef struct Teacher {
    int age;
    char *name;
}Teacher;

/*
 结论：
 C语言中的const变量
    C语言中const变量是只读变量，有自己的存储空间
 C++中的const常量
    可能分配存储空间,也可能不分配存储空间
    当const常量为全局，并且需要在其它文件中使用
    当使用&操作符取const常量的地址
 C++编译器对const常量的处理
    当碰见常量声明时，在符号表中放入常量 问题：那有如何解释取地址?
    编译过程中若发现使用常量则直接以符号表中的值替换
    编译过程中若发现对const使用了extern或者&操作符，则给对应的常量分配存储空间（兼容C）
 */
// const修饰形参的时候，在利用形参不能修改指针所向的内存空间
int setTeacher_err(const Teacher *p){
    return 0;
}

void constTest() {
    // 这两者没啥区别
    // 在C语言中 初级理解：const是定义常量 ==>> const意味着只读
    
     //const的好处
     //1.指针做函数参数，可以有效的提高代码可读性，减少bug
     //2.清楚的分清参数的输入和输出特性
    /*
    const int a =  10;
    int const b =  10;
    
    const int *c = NULL;//c指向的内存区域不可变 c是一个指向常整形数的指针(所指向的内存数据不能被修改，但是本身可以修改)
    int * const d = NULL;//c变量不可变，即指向内存区域可变 c是一个指向常整形数的指针(所指向的内存数据不能被修改，但是本身可以修改)
    const int * const e = NULL;//指向常量的常指针
    
    //c++编译器：Cannot initialize a variable of type 'int *' with an rvalue of type 'const int *'报错
    //c编译器：Initializing 'int *' with an expression of type 'const int *' discards qualifiers 警告
    int *p = &a;
    *p = 20;
    printf("A value:%d\n", *p);
    
    p = &b;
    *p = 20;
    printf("B value:%d\n", *p);
     */
}

int main(int argc, const char * argv[]) {
    // insert code here...

    printf("Hello, World!\n");
    return 0;
}
