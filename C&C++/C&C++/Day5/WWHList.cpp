//
//  WWHList.cpp
//  C&C++
//
//  Created by 王伟虎 on 2018/2/8.
//  Copyright © 2018年 wwh. All rights reserved.
//

#include "WWHList.hpp"
#include <ostream>

WWHErrorCode CreateList(WWHList **list) {
    WWHErrorCode code = WWHErrorCodeNullptr;
    if (list == nullptr) {
        printf("CreateList() error code %d: msg:%s \n", code, "list == nullptr");
        return code;
    }
    WWHList *tmp = (WWHList *)malloc(sizeof(WWHList *));
    if (tmp == nullptr) {
        code = WWHErrorCodeMallocFailure;
        printf("CreateList() error code %d: msg:%s \n", code, "malloc failure");
        return code;
    }
    code = WWHErrorCodeSuccess;
    tmp->header = nullptr;
    tmp->length = 0;
    *list = tmp;
    return code;
}

WWHErrorCode GetListLength(WWHList *list, int *length) {
    WWHErrorCode code = WWHErrorCodeNullptr;
    if (list == nullptr) {
        printf("GetListLength() error code %d: msg:%s \n", code, "list == nullptr");
        return code;
    }
    if (length == nullptr) {
        printf("GetListLength() error code %d: msg:%s \n", code, "length == nullptr");
        return code;
    }
    code = WWHErrorCodeSuccess;
    *length = list->length;
    return code;
}

WWHErrorCode ListInsertNode(WWHList *list, int pos, WWHListNode *node) {
    WWHErrorCode code = WWHErrorCodeNullptr;
    if (list == nullptr) {
        printf("ListInsertNode() error code %d: msg:%s \n", code, "list == nullptr");
        return code;
    }
    
    if (node == nullptr) {
        printf("ListInsertNode() error code %d: msg:%s \n", code, "node == nullptr");
        return code;
    }
    
    if (pos < 0) {
        code = WWHErrorCodeInsetPositionIsNegative;
        printf("ListInsertNode() error code %d: msg:%s \n", code, "The pos is a negative");
        return code;
    }
    // 0   1   2   3   4   5
    //        cur
    //          node
    // 当插入的位置大于链表的长度的时候，在链表的尾部插入
    if (pos >= list->length) {
        pos = list->length;
    }
    WWHListNode *current = (WWHListNode *)list;
    for (int i = 0; i < pos; i++) {
        current = (WWHListNode *)current->next;
    }
    code = WWHErrorCodeSuccess;
    node->next = current->next;
    current->next = (struct _tag_seqList *)node;
    list->length ++;
    return code;
}

WWHErrorCode GetListNode(WWHList *list, int pos, WWHListNode **node) {
    WWHErrorCode code = WWHErrorCodeNullptr;
    if (list == nullptr) {
        printf("ListInsertNode() error code %d: msg:%s \n", code, "list == nullptr");
        return code;
    }
    
    if (node == nullptr) {
        printf("ListInsertNode() error code %d: msg:%s \n", code, "node == nullptr");
        return code;
    }
    
    if (pos < 0) {
        code = WWHErrorCodeInsetPositionIsNegative;
        printf("ListInsertNode() error code %d: msg:%s \n", code, "The pos is a negative");
        return code;
    }
    code = WWHErrorCodeSuccess;
    if (pos >=list->length) {
        pos = list->length;
    }
    
    WWHListNode *current = (WWHListNode *)list;
    for (int i = 0; i < pos; i++) {
        current = (WWHListNode *)current->next;
    }
    *node = (WWHListNode *)current->next;
    return code;
}

WWHErrorCode DeleteListNode(WWHList *list, int pos, WWHListNode **node) {
    WWHErrorCode code = WWHErrorCodeNullptr;
    if (list == nullptr) {
        printf("DeleteListNode() error code %d: msg:%s \n", code, "list == nullptr");
        return code;
    }
    
    if (node == nullptr) {
        printf("DeleteListNode() error code %d: msg:%s \n", code, "node == nullptr");
        return code;
    }
    
    if (pos < 0) {
        code = WWHErrorCodeInsetPositionIsNegative;
        printf("DeleteListNode() error code %d: msg:%s \n", code, "The pos is a negative");
        return code;
    }
    code = WWHErrorCodeSuccess;
    if (pos >=list->length) {
        pos = list->length;
    }
    // 0   1   2   3   4   5
    //        cur
    WWHListNode *current = (WWHListNode *)list;
    for (int i = 0; i < pos; i++) {
        current = (WWHListNode *)current->next;
    }
    WWHListNode *deleteNode = (WWHListNode *)current->next;
    current->next = deleteNode->next;
    *node = deleteNode;
    return code;
}

// 删除链表
WWHErrorCode DestoryList(WWHList **list) {
    WWHErrorCode code = WWHErrorCodeNullptr;
    if (list == nullptr) {
        printf("DestoryList() error code %d: msg:%s \n", code, "list == nullptr");
        return code;
    }
    code = WWHErrorCodeSuccess;
    WWHList *tmp = *list;
    if (tmp != nullptr) {
        free(tmp);
        tmp = nullptr;
    }
    return code;
}

// 清空链表
WWHErrorCode ClearList(WWHList *list) {
    WWHErrorCode code = WWHErrorCodeNullptr;
    if (list == nullptr) {
        printf("ClearList() error code %d: msg:%s \n", code, "list == nullptr");
        return code;
    }
    code = WWHErrorCodeSuccess;
    list->header = nullptr;
    list->length = 0;
    return code;
}
