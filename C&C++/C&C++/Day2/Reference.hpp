//
//  Reference.hpp
//  C&C++
//
//  Created by 王伟虎 on 2018/1/24.
//  Copyright © 2018年 wwh. All rights reserved.
//

#ifndef Reference_hpp
#define Reference_hpp

#include <stdio.h>

struct Teacher {
    // 引用可以看作一个已定义变量的别名
    // 引用的语法：Type& name = var;
    int name = 20;
    int &aliasName = name;//相当于 int *const aliasName = &name;
};

#endif /* Reference_hpp */
