//
//  JYSocketProtocal.hpp
//  C&C++
//
//  Created by 王伟虎 on 2018/2/1.
//  Copyright © 2018年 wwh. All rights reserved.
//

#ifndef JYSocketProtocal_hpp
#define JYSocketProtocal_hpp

#include <stdio.h>

class JYSocketProtocal {
public:
    // 虚析构函数、有继承、会发生多态
    virtual ~JYSocketProtocal(){
        
    };
    
    // 纯虚函数
    virtual bool onSocketConnect() = 0;
    virtual bool onSocketReadData() = 0;
    virtual bool onSocketReceiveData() = 0;
    virtual bool onSocketDisConnect() = 0;
};

#endif /* JYSocketProtocal_hpp */
