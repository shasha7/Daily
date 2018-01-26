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

using namespace std;

class Circle {
private:
    double c_s;//面积
    double c_r;//半径
public:
    // 构造函数,定义了构造函数就一定要使用，否则编译错误，提示初始化不正确
    // No matching constructor for initialization of 'Circle'
    Circle(double c_r = 0.0f);
    
    // 赋值（copy）构造函数
    Circle(const Circle &circle);
    
    // 析构函数，销毁对象时销毁内部资源
    ~Circle();
    
    // 成员函数
    // 面积
    double getS();
    double getR();
    void setR(double r);
};

#endif /* Circle_h */
