//
//  JYSocketManager.hpp
//  C&C++
//
//  Created by 王伟虎 on 2018/2/1.
//  Copyright © 2018年 wwh. All rights reserved.
//

#ifndef JYSocketManager_hpp
#define JYSocketManager_hpp

#include <stdio.h>
#include "HWSocketFactory.hpp"
#include "HWEncDecFactory.hpp"

class JYSocketManager {
public:
    JYSocketManager(HWSocketFactory *hwSocket, HWEncDecFactory *hwEncDec);
    ~JYSocketManager();
    
    void didReceiveSocketData(char *inData, unsigned long inLength);
public:
    HWSocketFactory *hwSocket;
    HWEncDecFactory *hwEncDec;
};
#endif /* JYSocketManager_hpp */
