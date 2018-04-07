//
//  main.m
//  Algorithm
//
//  Created by 王伟虎 on 2018/1/9.
//  Copyright © 2018年 wwh. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <string.h>

// 获取一串字符串中第一次出现一次的字母(数字、字母)如果被检查字符串包含中文怎么办???
// https://wenku.baidu.com/view/11e99207bed5b9f3f90f1cff.html

char getFirstSingleElement(char * string) {
    // 检查非空性
    if (string == NULL) {
        return '\0';
    }
    const int hashTableSize = 256;
    unsigned int HashTable[hashTableSize];
    for (int i = 0; i < hashTableSize; i++) {
        HashTable[i] = 0;
    }
    
    char *pHashKey = string;
    while ((*pHashKey) != '\0') {
        HashTable[*pHashKey] ++;
        pHashKey++;
    }
    pHashKey = string;
    while ((*pHashKey) != '\0') {
        if (HashTable[(*pHashKey)] == 1) {
            return *pHashKey;
        }
        pHashKey++;
    }
    return '\0';
}

// 反转字符串
// 递归算法
void inverseStr(char *sourceStr, char *destinationStr) {
    if (sourceStr == NULL || destinationStr == NULL) {
        return;
    }
    if (*sourceStr == '\0') {
        return;
    }
    sourceStr++;
    inverseStr(sourceStr, destinationStr);
    printf("sourceStr = %c \n", *sourceStr);
    // 拼接字符传
    strncat(destinationStr, sourceStr, 1);
}

//快速排序 https://blog.csdn.net/morewindows/article/details/6684558
void quick_sort(int *array, int begin, int end) {
    if (begin < end)
    {
        //Swap(s[l], s[(l + r) / 2]); //将中间的这个数和第一个数交换 参见注1
        int i = begin, j = end, x = array[begin];
        while (i < j) {
            while(i < j && array[j] >= x) // 从右向左找第一个小于x的数
                j--;
            if(i < j)
                array[i++] = array[j];
            
            while(i < j && array[i] < x) // 从左向右找第一个大于等于x的数
                i++;
            if(i < j)
                array[j--] = array[i];
        }
        array[i] = x;
        quick_sort(array, begin, i - 1); // 递归调用
        quick_sort(array, i + 1, end);
    }
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
    }
    return 0;
}
