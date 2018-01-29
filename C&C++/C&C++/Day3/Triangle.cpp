//
//  Triangle.cpp
//  C&C++
//
//  Created by 王伟虎 on 2018/1/29.
//  Copyright © 2018年 wwh. All rights reserved.
//

#include "Triangle.hpp"

double Triangle::calculateArea() {
    this->t_area = t_bottomWidth*t_height/2;
    return this->t_area;
}

Triangle::Triangle(double bottomWidth, double height) {
    this->t_bottomWidth = bottomWidth;
    this->t_height = height;
}

Triangle::~Triangle() {
    this->t_bottomWidth = 0.0f;
    this->t_height = 0.0f;
}
