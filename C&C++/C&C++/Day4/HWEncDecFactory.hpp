//
//  HWEncDecFactory.hpp
//  C&C++
//
//  Created by 王伟虎 on 2018/2/1.
//  Copyright © 2018年 wwh. All rights reserved.
//

#ifndef HWEncDecFactory_hpp
#define HWEncDecFactory_hpp

#include <stdio.h>
#include "JYEncDecProtocal.hpp"

class HWEncDecFactory:public JYEncDecProtocal {
public:
    HWEncDecFactory();
    
    virtual bool onEncriptData();
    virtual bool onDecriptData();
};

#endif /* HWEncDecFactory_hpp */
