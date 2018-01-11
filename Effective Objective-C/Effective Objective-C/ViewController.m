//
//  ViewController.m
//  Effective Objective-C
//
//  Created by 王伟虎 on 2018/1/11.
//  Copyright © 2018年 wwh. All rights reserved.
//

#import "ViewController.h"
#import "CategoryDemo.h"
#import "CategoryDemo+attribute.h"
#import "CategoryDemo+attribute1.h"
#import <objc/runtime.h>
#include "DataType.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    int a = 10;
    testPointerNoParameter();
    testPointer(&a);
    NSLog(@"A value equal to %d", a);
}

// 分类覆盖原有类的方法测试
- (void)coverMethodTest {
    CategoryDemo *categoryDemo = [[CategoryDemo alloc] init];
    [categoryDemo method1]; // 打印结果：CategoryDemo+attribute
    
    // 如何调用被分类覆盖了的原类已有的方法？？？
    unsigned int methodCount = 0;
    SEL lastSel = NULL;
    IMP lastImp = NULL;
    Method *methods = class_copyMethodList([CategoryDemo class], &methodCount);
    for (int i = 0; i < methodCount; i++) {
        Method method = methods[i];
        const char *name = sel_getName(method_getName(method));
        NSString *methodName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        if ([@"method1" isEqualToString:methodName]) {
            lastSel = method_getName(method);
            lastImp = method_getImplementation(method);
        }
    }
    
    typedef void (*fn)(id,SEL);
    
    if (lastImp != NULL) {
        fn f = (fn)lastImp;
        f(categoryDemo,lastSel);
        // 打印结果：CategoryDemo
    }
    
    free(methods);
}

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
