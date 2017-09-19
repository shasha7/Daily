//
//  ViewController.m
//  day04
//
//  Created by 王伟虎 on 17/2/10.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import "ViewController.h"
#import "CategoryDemo.h"
#import "CategoryDemo+attribute.h"
#import <objc/runtime.h>

/**
 *  类扩展就像匿名的分类一样,但是类扩展声明必须在.m文件中;可以声明变量、添加属性、添加方法
 *  在类扩展中声明的方法，不实现的话就会报警告Method definition for 'xxx' not found
 */
@interface ViewController ()

@end

@implementation ViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    // 获取成员变量 @property声明的属性 生成的成员变量带下划线_  即  _xxxxx
    unsigned int ivarCount = 0;
    Ivar *ivars = class_copyIvarList([CategoryDemo class], &ivarCount);
    
    for (int i = 0; i < ivarCount; i++) {
        Ivar ivar = ivars[i];
        NSLog(@"第%d个成员变量：%s",i,ivar_getName(ivar));
    }
    free(ivars);
    
    // 获取属性
    unsigned int propertyCount = 0;
    objc_property_t *propertyList = class_copyPropertyList([CategoryDemo class], &propertyCount);
    for (int i = 0; i < propertyCount; i++) {
        objc_property_t property = propertyList[i];
        NSLog(@"第%d个属性：%s",i,property_getName(property));
    }
    free(propertyList);
    
    // 获取方法列表
    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList([CategoryDemo class], &methodCount);
    for (int i = 0; i < methodCount; i++) {
        Method method = methods[i];
        NSLog(@"第%d个方法：%s",i, sel_getName(method_getName(method)));
    }
    
    CategoryDemo *demo = [[CategoryDemo alloc] init];
    demo.attribute4 = @"wangweihu";
    
    NSLog(@"%@", demo.attribute4);
}

@end
