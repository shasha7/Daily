//
//  JYSocketManager.cpp
//  C&C++
//
//  Created by 王伟虎 on 2018/2/1.
//  Copyright © 2018年 wwh. All rights reserved.
//

#include "JYSocketManager.hpp"

JYSocketManager::JYSocketManager(HWSocketFactory *hwSocket, HWEncDecFactory *hwEncDec) {
    this->hwSocket = hwSocket;
    this->hwEncDec = hwEncDec;
}

JYSocketManager::~JYSocketManager() {
    this->hwSocket = nullptr;
}

void JYSocketManager::didReceiveSocketData(char *inData, unsigned long inLength) {
    this->hwSocket->onSocketReceiveData();
}
