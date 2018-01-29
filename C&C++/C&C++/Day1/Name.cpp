//
//  Name.cpp
//  C&C++
//
//  Created by 王伟虎 on 2018/1/26.
//  Copyright © 2018年 wwh. All rights reserved.
//

#include "Name.hpp"
#include <string>

Name::~Name()
{
    if (pName!=NULL)
    {
        free(pName);
        pName = NULL;
        size = 0;
    }
}

Name::Name(const char *pname)
{
    size_t size = 0;
    size = strlen(pname);
    pName = (char *)malloc(size + 1);
    strcpy(pName, pname);
}

Name::Name(const Name &obj)
{
    //用obj来初始化自己
    pName = (char *)malloc(obj.size + 1);
    strcpy(pName, obj.pName);
    size = obj.size;
}

void Name::operator=(Name &obj) {
    if (pName != NULL)
    {
        free(pName);
        pName = NULL;
        size = 0;
    }
    //用obj来=自己
    pName = (char *)malloc(obj.size + 1);
    strcpy(pName, obj.pName);
    size = obj.size;
}
