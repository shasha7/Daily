//
//  CategoryDemo+attribute.m
//  day04
//
//  Created by 王伟虎 on 17/2/10.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import "CategoryDemo+attribute.h"
#import <objc/runtime.h>

const static char loadOperationKey;
static const NSString *attributeKey = @"attribute4";

@implementation CategoryDemo (attribute)

- (NSString *)attribute4 {
    return objc_getAssociatedObject(self, (__bridge const void *)(attributeKey));
}

- (void)setAttribute4:(NSString *)attribute4 {
    /*
     参数1:关联对象
     参数2:关联属性值
     参数3:关联值
     参数4:关联策略
     */
    objc_setAssociatedObject(self, (__bridge const void *)(attributeKey), attribute4, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

/**
 *  应用经典案例
 *  SDWebImage经典案例
 */
- (NSMutableDictionary *)operationDictionary {
    /*
     objc_setAssociatedObject作用是对已存在的类在扩展中添加自定义的属性
     这个loadOperationKey 的定义是:static char loadOperationKey;
     它对应的绑定在UIImage扩展中的属性是operations(NSMutableDictionary类型)
     */
    NSMutableDictionary *operations = objc_getAssociatedObject(self, &loadOperationKey);
    if (operations) {
        return operations;
    }
    operations = [NSMutableDictionary dictionary];
    objc_setAssociatedObject(self, &loadOperationKey, operations, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return operations;
}

@end
