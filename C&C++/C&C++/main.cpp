//
//  main.cpp
//  C&C++
//
//  Created by 王伟虎 on 2018/1/23.
//  Copyright © 2018年 wwh. All rights reserved.
//

#include <iostream>
#include "Circle.h"
#include "Reference.hpp"

/**************Day2**************/
void ReferenceTest(void) {
    Teacher t1;
    t1.name = 20;
    cout << "Teacher的名字：" << t1.name << endl;
    cout << "Teacher的名字：" << t1.aliasName << endl;
}
// 以下两个函数重载了
void SwapTwoNumber(int &a, int &b) {
    int c = 0;
    c = a;
    a = b;
    b = c;
}

void SwapTwoNumber(int *a, int *b) {
    int c = 0;
    c = *a;
    *a = *b;
    *b = c;
}

void ReferenceTest2(void) {
    int a = 30;
    int b = 20;
    SwapTwoNumber(&a, &b); //间接
    // SwapTwoNumber(a, b); //引用
    cout << "a：" << a << endl;
    cout << "b：" << b << endl;
}

/**************Day1**************/
void CircleTest(void) {
    Circle circleOne;//对象分配在栈上
    cout << "请输入半径：";//标准输出函数，相当于C语言中的 printf("请输入半径：\n");
    cin >> circleOne.c_r;//标准输入函数，相当于C语言中的 scanf(&(circleOne.c_r));
    cout << "圆的面积：" << circleOne.getS() << endl;
    cout << "Hello, World!\n";
}

int main(int argc, const char * argv[]) {
    // insert code here...

    return 0;
}


