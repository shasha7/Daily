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

using namespace std;

class Name
{
public:
    // 有参构造函数
    Name(const char *pname);
    
    // copy构造函数
    Name(const Name &obj);
    
    // 重载等号操作符
    void operator=(Name &obj);
    
    // 析构函数
    ~Name();
private:
    // 私有成员变量
    char *pName;
    int size;
};

#endif /* Name_hpp */
