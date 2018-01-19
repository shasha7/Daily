//
//  SingleList.h
//  Effective Objective-C
//
//  Created by 王伟虎 on 2018/1/19.
//  Copyright © 2018年 wwh. All rights reserved.
//

#import <Foundation/Foundation.h>

//定义了一个Node结构体-链表节点
typedef struct Node {
    void *data;//数据域
    struct Node *next;//指针域--指向后继结点的指针
}Node;

//定义了一个Node结构体-链表节点
typedef struct LinkedList {
    Node *head;
    Node *tail;
    Node *current;
}LinkedList;

typedef void(*DISPLAY)(void *);
typedef int(*COMPARE)(void *, void *);

@interface SingleList : NSObject

/**
 * 初始化链表
 */
void InitializeList(LinkedList *list);

/**
 * 单链表创建方式-尾插法
 */
void AddHead(LinkedList *list, void *data);

/**
 * 单链表创建方式-头插法
 */
void AddTail(LinkedList *list, void *data);

/**
 * 删除节点
 */
void Delete(LinkedList *list, Node *node);

/**
 * 获取节点
 */
Node *GetNode(LinkedList *list, COMPARE compare, DISPLAY display, void *data);

/**
 * 展示节点信息
 */
void DisplayLinkedList(LinkedList *list, DISPLAY display);

@end
