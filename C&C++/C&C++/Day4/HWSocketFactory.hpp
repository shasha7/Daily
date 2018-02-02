//
//  HWSocketFactory.hpp
//  C&C++
//
//  Created by 王伟虎 on 2018/2/1.
//  Copyright © 2018年 wwh. All rights reserved.
//

#ifndef HWSocketFactory_hpp
#define HWSocketFactory_hpp

#include <stdio.h>
#include "JYSocketProtocal.hpp"

class HWSocketFactory: public JYSocketProtocal {
public:
    ~HWSocketFactory();
    
    // 虚函数
    virtual bool onSocketConnect();
    virtual bool onSocketReadData();
    virtual bool onSocketReceiveData();
    virtual bool onSocketDisConnect();
public:
    char *s_inData;
    unsigned long s_inLength;
    int s_ip;
    int s_port;
};

#endif /* HWSocketFactory_hpp */
