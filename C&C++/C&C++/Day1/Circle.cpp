//
//  Circle.cpp
//  C&C++
//
//  Created by 王伟虎 on 2018/1/23.
//  Copyright © 2018年 wwh. All rights reserved.
//

#include <stdio.h>
#include "Circle.hpp"

const int Circle::number = 10;
const int Circle::refNumber;

double Circle::calculateArea() {
    this ->c_s = 3.1415926 *c_r*c_r;
    return 3.1415926 *c_r*c_r;
}

Circle::Circle(const Circle &circle) {
    this->c_r = circle.c_r;
};

Circle::Circle(double c_r) {
    this->c_r = c_r;
}

double Circle::getS() {
    this ->c_s = 3.1415926 *c_r*c_r;
    return 3.1415926 *c_r*c_r;
};

double Circle::getR() {
    return this -> c_r;
};

void Circle::setR(double r) {
    this->c_r = r;
};

Circle::~Circle() {
    this->c_r = 0.0f;
    this->c_s = 0.0f;
};
