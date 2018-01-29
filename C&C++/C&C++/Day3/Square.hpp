//
//  Square.hpp
//  C&C++
//
//  Created by 王伟虎 on 2018/1/29.
//  Copyright © 2018年 wwh. All rights reserved.
//

#ifndef Square_hpp
#define Square_hpp

#include <stdio.h>
#include "Area.hpp"

class Square: public Area{
public:
    virtual double calculateArea();
    Square(double width, double height);
    ~Square();
private:
    double s_width;
    double s_height;
    double s_area;
};

#endif /* Square_hpp */
