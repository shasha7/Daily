//
//  Circle.h
//  C&C++
//
//  Created by 王伟虎 on 2018/1/23.
//  Copyright © 2018年 wwh. All rights reserved.
//

#ifndef Circle_h
#define Circle_h

#include <ostream>
#include "Area.hpp"

class Circle: public Area {
public:
    // 对于单纯常量，最好以const或enum替代#defines
    // 对于形似函数的宏，最好以inline函数来替换#defines
    // 静态变量的初始化的两种方法
    static const int number;
    static const int refNumber = 5;
    
    // #define kNumber 10 不可取地址
    // enum {kNumber = 5};不可取地址 enum hack 模板元编程
    // 如果不想别人获取一个pointer或者reference,可以用宏定义、枚举声明
    enum {kNumber = 5};
    int numbers[kNumber];
    
    // 虚函数
    virtual double calculateArea();
    
    // 构造函数,定义了构造函数就一定要使用，否则编译错误，提示初始化不正确
    // No matching constructor for initialization of 'Circle'
    Circle(double c_r = 0.0f);
    
    // 赋值（copy）构造函数
    Circle(const Circle &circle);
    
    // 析构函数，销毁对象时销毁内部资源
    virtual ~Circle();
    
    // 成员函数
    // 面积
    double getS();
    double getR();
    void setR(double r);
private:
    double c_s;//面积
    double c_r;//半径
};

#endif /* Circle_h */
