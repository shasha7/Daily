//
//  Triangle.hpp
//  C&C++
//
//  Created by 王伟虎 on 2018/1/29.
//  Copyright © 2018年 wwh. All rights reserved.
//

#ifndef Triangle_hpp
#define Triangle_hpp

#include <stdio.h>
#include "Area.hpp"

class Triangle: public Area {
public:
    virtual double calculateArea();
    Triangle(double bottomWidth, double height);
    ~Triangle();
private:
    double t_bottomWidth;
    double t_height;
    double t_area;
};

#endif /* Triangle_hpp */
