//
//  main.cpp
//  C&C++
//
//  Created by 王伟虎 on 2018/2/5.
//  Copyright © 2018年 wwh. All rights reserved.
//

#include <iostream>
#include <string>
#include <iterator>

using namespace std;

int main(int argc, const char * argv[]) {
    // insert code here...
    // char *===>string
    string s1 = "wangweihu";
    cout << s1 << endl;
    
    //string ===>char *
    string s2("wushanshan");
    cout << s2.c_str() << endl;
    
    // 迭代器遍历
    string s3 = s1 + s2;
    for (string::iterator it = s3.begin(); it != s3.end(); it++) {
        cout << *it;
    }
    cout << endl;
    
    // 容错
    try {
        for (int i = 0; i < s3.length(); i++) {
            cout << s3.at(i);
        }
    } catch (string s3) {
        cout << "错误异常" << endl;
    }
    
    return 0;
}
