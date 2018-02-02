//
//  JYEncDecProtocal.hpp
//  C&C++
//
//  Created by 王伟虎 on 2018/2/1.
//  Copyright © 2018年 wwh. All rights reserved.
//

#ifndef JYEncDecProtocal_hpp
#define JYEncDecProtocal_hpp

#include <stdio.h>

class JYEncDecProtocal {
public:
    // 虚析构函数、有继承、会发生多态
    virtual ~JYEncDecProtocal(){
        
    };
    
    // 纯虚函数
    virtual bool onEncriptData() = 0;
    virtual bool onDecriptData() = 0;
};

#endif /* JYEncDecProtocal_hpp */
