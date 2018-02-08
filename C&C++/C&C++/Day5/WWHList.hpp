//
//  WWHList.hpp
//  C&C++
//
//  Created by 王伟虎 on 2018/2/8.
//  Copyright © 2018年 wwh. All rights reserved.
//

#ifndef WWHList_hpp
#define WWHList_hpp

#include <stdio.h>

// 节点 ，万事万物包括节点
typedef struct _tag_list_node {
    struct _tag_seqList *next;
}WWHListNode;

// 链表信息，头结点，长度等信息
typedef struct _tag_list {
    WWHListNode *header;
    int length;
}WWHList;

typedef enum error_code {
    WWHErrorCodeNullptr = -3,
    WWHErrorCodeInsetPositionIsNegative = -2,
    WWHErrorCodeMallocFailure = -1,
    WWHErrorCodeSuccess = 0
}WWHErrorCode;

// 创建链表
WWHErrorCode CreateList(WWHList **list);

// 获取链表长度
WWHErrorCode GetListLength(WWHList *list, int *length);

// 往链表中插入节点
WWHErrorCode ListInsertNode(WWHList *list, int pos, WWHListNode *node);

// 获取指定位置的节点
WWHErrorCode GetListNode(WWHList *list, int pos, WWHListNode **node);

// 删除指定节点
WWHErrorCode DeleteListNode(WWHList *list, int pos, WWHListNode **node);

// 删除链表
WWHErrorCode DestoryList(WWHList **list);

// 清空链表
WWHErrorCode ClearList(WWHList *list);

#endif /* WWHList_hpp */
