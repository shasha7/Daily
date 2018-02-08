//
//  main4.cpp
//  C&C++
//
//  Created by 王伟虎 on 2018/2/8.
//  Copyright © 2018年 wwh. All rights reserved.
//

#include <stdio.h>
#include "WWHList.hpp"

class Teacher {
public:
    WWHListNode *node;
    int  age;
    char *name;
};

int main(int argc, const char * argv[]) {
    WWHList *list = nullptr;
    WWHErrorCode code = CreateList(&list);
    if (code == WWHErrorCodeSuccess) {
        printf("创建链表成功 \n");
    }
    
    int length = 0;
    GetListLength(list, &length);
    printf("链表长度：%d \n", length);
    
    Teacher t1, t2, t3, t4;
    t1.age = 31;
    t1.name = (char *)"laoshi1";
    
    t2.age = 32;
    t2.name = (char *)"laoshi2";
    
    t3.age = 33;
    t3.name = (char *)"laoshi3";
    
    t4.age = 34;
    t4.name = (char *)"laoshi4";
    
    ListInsertNode(list, 0, (WWHListNode *)&t1);
    ListInsertNode(list, 0, (WWHListNode *)&t2);
    ListInsertNode(list, 0, (WWHListNode *)&t3);
    ListInsertNode(list, 0, (WWHListNode *)&t4);
    
    GetListLength(list, &length);
    printf("链表长度：%d \n", length);
    
    WWHListNode *node = nullptr;
    GetListNode(list, 3, &node);
    
    Teacher *teacher2 = (Teacher *)node;
    printf("链表位置2处的老师名字：%s, 年龄：%d \n", teacher2->name, teacher2->age);
    
    DeleteListNode(list, 3, &node);
    Teacher *teacher = (Teacher *)node;
    printf("删除位置0的老师名字：%s, 年龄：%d \n", teacher->name, teacher->age);
    
    ClearList(list);
    DestoryList(&list);
    return 0;
}
