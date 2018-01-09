//
//  main.m
//  Algorithm
//
//  Created by 王伟虎 on 2018/1/9.
//  Copyright © 2018年 wwh. All rights reserved.
//

#import <Foundation/Foundation.h>

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

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        char first = getFirstSingleElement(NULL);
        printf("first = %c\n",first);
    }
    return 0;
}
