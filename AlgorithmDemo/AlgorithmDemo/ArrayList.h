//
//  ArrayList.h
//  AlgorithmDemo
//
//  Created by 王伟虎 on 2017/10/10.
//  Copyright © 2017年 wwh. All rights reserved.
//

#ifndef ArrayList_h
#define ArrayList_h

#include <stdio.h>

/*
 如何设计
 1.先想外界如何使用，反推需要暴露的方法，进而实现细节
 2.细节考虑，通用性、测试是否健壮、边界值检查
 */
// 节点存储的数据
typedef int ArrayListNodeValue;

// 线性表
typedef struct {
    int capacity;
    int length;
    ArrayListNodeValue *value;
}ArrayList;

/**
 * 创建线性表
 * Creates and returns an ArrayList object with enough allocated memory to initially hold a given number of objects.
 */
ArrayList *List_Create(int capacity);

/**
 * 销毁线性表
 */
void List_Dealloc(ArrayList *list);

/**
 * 清空线性表
 */
void List_Clear(ArrayList *list);

/**
 * 获取线性表长度
 */
int List_Length(ArrayList *list);

/**
 * 在某个节点插入一个节点
 */
void List_Insert(int index);

/**
 * 删除在某个节点
 */
void List_Delete(int index);


#endif /* ArrayList_h */
