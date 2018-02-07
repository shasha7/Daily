//
//  main0.cpp
//  C&C++
//
//  Created by 王伟虎 on 2018/2/7.
//  Copyright © 2018年 wwh. All rights reserved.
//

#include <stdio.h>
#include <iostream>

char _NSConcreteStackBlock[2048] = "_NSConcreteStackBlock";

struct __block_impl {
    void *isa;    //指向block类型
    int Flags;    //状态
    int Reserved; //备用
    void *FuncPtr;//函数指针
};

struct __main_block_impl_0 {
    struct __block_impl impl;
    struct __main_block_desc_0 *Desc;
    
    // 含参构造函数
    __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, int flags=0) {
        impl.isa = &_NSConcreteStackBlock;
        impl.Flags = flags;
        impl.FuncPtr = fp;
        Desc = desc;
    }
};

// 保存了block大小，这是一个静态类，全局只有一份
static struct __main_block_desc_0 {
    size_t reserved;
    size_t Block_size;
} __main_block_desc_0_DATA = {0, sizeof(struct __main_block_impl_0)};


static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
    printf("Hello, World!\n");
}

int main(int argc, const char * argv[]) {
    // insert code here...
    __main_block_impl_0 *block = new __main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA);
    ((void (*)(__block_impl *))((__block_impl *)block)->FuncPtr)((__block_impl *)block);    return 0;
}
