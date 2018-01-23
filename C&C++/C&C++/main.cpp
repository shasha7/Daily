//
//  main.cpp
//  C&C++
//
//  Created by 王伟虎 on 2018/1/23.
//  Copyright © 2018年 wwh. All rights reserved.
//

#include <iostream>
#include "Circle.h"

int main(int argc, const char * argv[]) {
    // insert code here...
    

    return 0;
}

/**************Day1**************/
void CircleTest(void) {
    Circle circleOne;//对象分配在栈上
    cout << "请输入半径：";//标准输出函数，相当于C语言中的 printf("请输入半径：\n");
    cin >> circleOne.c_r;//标准输入函数，相当于C语言中的 scanf(&(circleOne.c_r));
    cout << "圆的面积：" << circleOne.getS() << endl;
    cout << "Hello, World!\n";
}
