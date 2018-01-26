//
//  Name.hpp
//  C&C++
//
//  Created by 王伟虎 on 2018/1/26.
//  Copyright © 2018年 wwh. All rights reserved.
//

#ifndef Name_hpp
#define Name_hpp

#include <stdio.h>
#include <string>
#include <ostream>

using namespace std;

class Name
{
public:
    Name(const char *pname)
    {
        size_t size = 0;
        size = strlen(pname);
        pName = (char *)malloc(size + 1);
        strcpy(pName, pname);
    }
    Name(const Name &obj)
    {
        //用obj来初始化自己
        pName = (char *)malloc(obj.size + 1);
        strcpy(pName, obj.pName);
        size = obj.size;
    }
    ~Name()
    {
        if (pName!=NULL)
        {
            free(pName);
            pName = NULL;
            size = 0;
        }
    }
    
//    void operator=(Name &obj3) {
//        if (pName != NULL)
//        {
//            free(pName);
//            pName = NULL;
//            size = 0;
//        }
//        //用obj3来=自己
//        pName = (char *)malloc(obj3.size + 1);
//        strcpy(pName, obj3.pName);
//        size = obj3.size;
//    }
private:
    char *pName;
    int size;
};

#endif /* Name_hpp */
