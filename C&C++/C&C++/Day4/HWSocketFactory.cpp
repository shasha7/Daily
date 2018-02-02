//
//  HWSocketFactory.cpp
//  C&C++
//
//  Created by 王伟虎 on 2018/2/1.
//  Copyright © 2018年 wwh. All rights reserved.
//

#include "HWSocketFactory.hpp"

HWSocketFactory::~HWSocketFactory() {
    this->s_inData = nullptr;
    this->s_inLength = 0;
    this->s_ip = 0;
    this->s_port = 0;
}

bool HWSocketFactory::onSocketConnect() {
    return true;
}

bool HWSocketFactory::onSocketReadData() {
   return true;
}

bool HWSocketFactory::onSocketReceiveData() {
    return true;
}

bool HWSocketFactory::onSocketDisConnect() {
    return true;
}

