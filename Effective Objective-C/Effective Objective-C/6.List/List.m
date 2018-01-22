//
//  List.m
//  Effective Objective-C
//
//  Created by 王伟虎 on 2018/1/22.
//  Copyright © 2018年 wwh. All rights reserved.
//

#import "List.h"

@implementation List

NodeList *CreateList(void) {
    NodeList *head = NULL;
    head = (NodeList *)malloc(sizeof(NodeList));
    if (head == NULL) {//分配内存失败
        return NULL;
    }
    // 初始化
    head->data = 0;
    head->pNext = NULL;
    return head;
}

bool GetNodeData(NodeList *list, int data, int *position, NodeList *node) {
    if (list == NULL) {
        return false;
    }
    
    int tmpPos = 0;
    NodeList *pre = NULL;
    NodeList *cur;
    
    pre = list;
    cur = pre->pNext;
    
    while (pre->pNext) {
        if (data == cur->data) {
            if (node != NULL) {
                node = cur;
            }
            break;
        }
        tmpPos ++;
        pre = pre->pNext;
        cur = pre->pNext;
    }
    *position = tmpPos;
    return true;
}

bool InsertNodeTail(NodeList *list, int data) {
    if (list == NULL) {
        return false;
    }
    
    // 辅助指针
    NodeList *node;
    NodeList *cur;
    
    cur = list;
    
    while (cur->pNext) {
        cur = cur->pNext;
    }
    
    // 1   2   3   4
    //            cur
    node = (NodeList *)malloc(sizeof(NodeList));
    node->data = data;
    node->pNext = NULL;
    
    cur->pNext = node;
    return true;
}

bool InsertNode(NodeList *list, int data, int position) {
    if (list == NULL) {
        return false;
    }
    // 辅助指针
    NodeList *node;
    NodeList *pre;
    NodeList *cur;
    
    pre = list;
    cur = list->pNext;

    // 查询位置
    // 0
    //pre cur
    // 0   1   2   3   4   5
    //        pre cur
    // 0   1   2   3   4   5
    //                    pre cur
    while (pre->pNext) {
        if (position == cur->data) {
            break;
        }
        pre = pre->pNext;
        cur = pre->pNext;
    }
    // 插入数据
    node = (NodeList *)malloc(sizeof(NodeList));
    node->data = data;
    
    node->pNext = cur;
    pre->pNext = node;
    return true;
}

void PrintList(NodeList *list) {
    do {
        list = list->pNext;
        printf("NodeList data %d \n", list->data);
    } while (list->pNext);
}

bool DestoryList(NodeList **list) {
    if (list == NULL) {
        return false;
    }
    NodeList *tmpList = *list;
    if (tmpList == NULL) {
        return false;
    }
    free(tmpList);
    *list = NULL;
    return true;
}

@end
