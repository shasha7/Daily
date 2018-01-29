//
//  Square.cpp
//  C&C++
//
//  Created by 王伟虎 on 2018/1/29.
//  Copyright © 2018年 wwh. All rights reserved.
//

#include "Square.hpp"

double Square::calculateArea() {
    this->s_area = s_width*s_height/2;
    return this->s_area;
}

Square::Square(double width, double height) {
    this->s_width = width;
    this->s_height = height;
}

Square::~Square() {
    this->s_width = 0;
    this->s_height = 0;
}
