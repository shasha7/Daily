//
//  Area.hpp
//  C&C++
//
//  Created by 王伟虎 on 2018/1/29.
//  Copyright © 2018年 wwh. All rights reserved.
//

#ifndef Area_hpp
#define Area_hpp

#include <stdio.h>

/*
 C++中是否有Java中的接口概念？
    绝大多数面向对象语言都不支持多继承(Java、Objective-C等均没有多继承)
    绝大多数面向对象语言都支持接口的概念
 C++中没有接口的概念
 C++中可以使用纯虚函数实现接口
    接口类中只有函数原型定义，没有任何数据的定义。
 class Interface {
 public:
    // 纯虚函数
    virtual void func1() = 0;
    virtual void func2(int i) = 0;
    virtual void func3(int i) = 0;
 };
 
 class Area {
 public:
    // virtual 虚函数
    // 函数重载、重写、重定义的区别
    virtual double calculateArea() = 0;
 };
 */

/*
 面向对象语言的三大特性：封装、继承、多态
 */
class Area {//抽象类
public:
    // virtual 纯虚函数
    // 只有函数原型定义，没有任何数据的定义
    // 函数重载、重写、重定义的区别
    virtual double calculateArea() = 0;
};

#endif /* Area_hpp */
