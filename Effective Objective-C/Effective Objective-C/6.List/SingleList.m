//
//  SingleList.m
//  Effective Objective-C
//
//  Created by 王伟虎 on 2018/1/19.
//  Copyright © 2018年 wwh. All rights reserved.
//

#import "SingleList.h"

//定义了一个Employee结构体
typedef struct Employee {
    char name[32];
    unsigned char age;
}Employee;

@implementation SingleList

int CompareEmployee(Employee *m1, Employee *m2){
    return strcmp(m1->name, m2->name);
}

void DisplayEmployee(Employee *emp){
    printf("Employee name:%s age:%c",emp->name, emp->age);
}

void InitializeList(LinkedList *list){
    list->head = NULL;
    list->tail = NULL;
    list->current = NULL;
}

//单链表创建方式-尾插法
void AddHead(LinkedList *list, void *data){
    //节点分配内存
    Node *node = (Node *)malloc(sizeof(node));
    node->data = data;
    //查看链表head
    if (list->head == NULL) {
        list->tail = node;
        node->next = NULL;
    }else {
        node->next = list->head;
    }
    list->head = node;
}

//单链表创建方式-头插法
void AddTail(LinkedList *list, void *data){
    Node *node = (Node *)malloc(sizeof(node));
    node->data = data;
    node->next = NULL;
    if (list->head == NULL) {
        list->head = node;
    }else {
        list->tail->next = node;
    }
    list->tail = node;
}

void Delete(LinkedList *list, Node *node){
    if (node == list->head) {
        if (list->head->next == NULL) {
            list->head = list->tail = NULL;
        }else {
            list->head = list->head->next;
        }
    }else {
        Node *tmp = list->head;
        while (tmp != NULL && tmp->next != node) {
            tmp = tmp->next;
        }
        if (tmp != NULL) {
            tmp->next = node->next;
        }
    }
    free(node);
}

Node *GetNode(LinkedList *list, COMPARE compare, DISPLAY display, void *data){
    Node *node = list->head;
    while (node != NULL) {
        if (compare(node->data, data) == 0) {
            return node;
        }
        node = node->next;
    }
    return NULL;
}

void DisplayLinkedList(LinkedList *list, DISPLAY display) {
    printf("\nLinked List\n");
    Node *current = list->head;
    while (current != NULL) {
        display(current->data);
        current = current->next;
    }
}

@end
