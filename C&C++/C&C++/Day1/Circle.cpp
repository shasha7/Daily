//
//  Circle.cpp
//  C&C++
//
//  Created by 王伟虎 on 2018/1/23.
//  Copyright © 2018年 wwh. All rights reserved.
//

#include <stdio.h>
#include "Circle.h"

double Circle::getS() {
    this -> c_s = 3.1415926 *c_r*c_r;
    return 3.1415926 *c_r*c_r;
};
