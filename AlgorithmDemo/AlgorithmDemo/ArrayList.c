//
//  ArrayList.c
//  AlgorithmDemo
//
//  Created by 王伟虎 on 2017/10/10.
//  Copyright © 2017年 wwh. All rights reserved.
//

#include "ArrayList.h"
#include <Malloc/malloc.h>
#include <stdlib.h>

ArrayList *List_Create(int capacity) {
    // 在这里创建的内存区要在堆上，否则创建完就会被删除回收
    if (capacity < 0) {
        return NULL;
    }
    ArrayList *list = (ArrayList *)malloc(sizeof(ArrayList));
    if (list) {
        list->length = 0;
        list->capacity = capacity;
        list->value = malloc(capacity * sizeof(ArrayListNodeValue));
    }
    return list;
}

void List_Dealloc(ArrayList *list) {
    if (!list) return;
    free(list->value);
    free(list);
}

void List_Clear(ArrayList *list) {
    if (!list) return;
    list->length = 0;
}

int List_Length(ArrayList *list) {
    if (!list) return 0;
    return list->length;
}
