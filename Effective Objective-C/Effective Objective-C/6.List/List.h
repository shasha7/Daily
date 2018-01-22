//
//  List.h
//  Effective Objective-C
//
//  Created by 王伟虎 on 2018/1/22.
//  Copyright © 2018年 wwh. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct NodeList {
    int data;              //整形 8字节
    struct NodeList *pNext;//指针 8字节
}NodeList;

@interface List : NSObject

/**
 * 创建链表
 * return 返回链表 创建失败返回NULL
 */
NodeList *CreateList(void);

/**
 * 往链表中插入数据
 * @param list 链表
 * @param data 插入的数据
 * @param position 插入位置
 * return 返回插入结果 true 成功 false 失败
 */
bool InsertNode(NodeList *list, int data, int position);

/**
 * 往链表尾插入数据
 * @param list 链表
 * @param data 插入的数据
 * return 返回插入结果 true 成功 false 失败
 */
bool InsertNodeTail(NodeList *list, int data);

/**
 * 往链表尾插入数据
 * @param list 链表
 * @param data 要查询的数据
 * @param position 要查询的数据所在位置
 * return 返回查询结果 true 成功 false 失败
 */
bool GetNodeData(NodeList *list, int data, int *position, NodeList *node);

/**
 * 打印链表数据
 */
void PrintList(NodeList *list);

/**
 * 销毁链表
 * @param list 链表地址
 * return 返回销毁结果 true 成功 false 失败
 */
bool DestoryList(NodeList **list);

@end
