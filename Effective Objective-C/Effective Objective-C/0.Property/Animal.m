//
//  Animal.m
//  property
//
//  Created by 王伟虎 on 2018/1/8.
//  Copyright © 2018年 wwh. All rights reserved.
//

#import "Animal.h"
#import <objc/runtime.h>

@implementation Animal

// +initialize 只会在对应类的方法第一次被使用时，才会被调用
// 未初始化的类发送 +initialize 消息，不过会强制父类先发送 +initialize
+ (void)initialize {
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (instancetype)init {
    self = [super init];
    if (self) {
        struct objc_object *objct = (__bridge struct objc_object *)([NSObject new]);
        // 使用整个指针大小的内存来存储isa指针有些浪费，尤其在64位的CPU上。在ARM64运行的iOS只使用了 33位作为指针(与结构体中的33位无关，Mac OS上为34位)，而剩下的31位用于其它目的。类的指针也同样根据字节对齐了，每一个类指针的地址都能够被8整除，也就是使最后3bits为0，为isa留下34位用于性能的优化。
        NSLog(@"%@", binaryWithInter(objct->isa));
        NSLog(@"%@", binaryWithInter((uintptr_t)[NSObject class]));
        // 0000000001011101111111111111111110010000110100100000000101000001补全64位
        // 11111111111111110010000110100100000000101000000
    }
    return self;
}

NSString *binaryWithInter(NSUInteger decInt) {
    NSString *str = @"";
    NSUInteger x = decInt;
    while (x > 0) {
        str = [[NSString stringWithFormat:@"%lu", x&1] stringByAppendingString:str];
        x = x >> 1;
    }
    return str;
}

#pragma mark - 消除重复数据

- (void)deleteRepeateData1 {
    NSArray *mutipleArray = @[@"wang", @"li", @"zhou", @"wang", @"zou"];
    NSMutableSet *singleSet = [NSMutableSet set];
    for (NSString *firstName in mutipleArray) {
        [singleSet addObject:firstName];
    }
    NSLog(@"%@", singleSet);
}

- (void)deleteRepeateData2 {
    NSArray *mutipleArray = @[@"wang", @"li", @"zhou", @"wang", @"zou"];
    NSMutableSet *singleSet = [NSMutableSet setWithArray:mutipleArray];
    NSLog(@"%@", singleSet);
}

/**
 * method swizzling
 */
+ (void)load {
    /*
     load 与 Initialize的区别
     正常情况下(即没有在 load 方法中调用相关类方法)，load 和 Initialize 方法都在实例化对象之前调用，load相当于装载方法，都在main()函数之前调用，Initialize方法都在main() 函数之后调用。
     如果在A类的 load 方法中调用 B 类的类方法，那么在调用A的Load 方法之前，会先调用一下B类的initialize 方法，但是B类的load 方法还是按照 Compile Source 顺序进行加载
     所有类的 load 方法都会被调用，先调用父类、再调用子类，多个分类会按照Compile Sources 顺序加载。但是Initialize 方法会被覆盖，子类父类分类中只会执行一个
     load 方法内部一般用来实现 Method Swizzle，Initialize方法一般用来初始化全局变量或者静态变量
     两个方法都不能主动调用，也不需要通过 super 继承父类方法，但是 Initialize 方法会在子类没有实现的时候调用父类的该方法，而 load 不会
     */
    // http://nshipster.cn/method-swizzling/
    // When swizzling a class method, use the following:
    // Class class = object_getClass((id)self);
    // ...
    // Method originalMethod = class_getClassMethod(class, originalSelector);
    // Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
    // swizzling 应该只在 dispatch_once 中完成
    // swizzling 应该只在 +load 中完成
    // 很多人认为交换方法实现会带来无法预料的结果。然而采取了以下预防措施后, method swizzling 会变得很可靠：
    // 1.在交换方法实现后记得要调用原生方法的实现（除非你非常确定可以不用调用原生方法的实现）
    // 2.避免冲突
    // 3.理解实现原理
    // 4.持续的预防
    
    // IDConfig或其子类的实例对象在调用 description 的时候会有 特殊 的输出。
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        /*
         Selector（typedef struct objc_selector *SEL）:在运行时 Selectors 用来代表一个方法的名字。Selector 是一个在运行时被注册（或映射）的C类型字符串。Selector由编译器产生并且在当类被加载进内存时由运行时自动进行名字和实现的映射。
         Method（typedef struct objc_method *Method）:方法是一个不透明的用来代表一个方法的定义的类型。
         Implementation（typedef id (*IMP)(id, SEL,...)）:这个数据类型指向一个方法的实现的最开始的地方。该方法为当前CPU架构使用标准的C方法调用来实现。该方法的第一个参数指向调用方法的自身（即内存中类的实例对象，若是调用类方法，该指针则是指向元类对象metaclass）。第二个参数是这个方法的名字selector，该方法的真正参数紧随其后。
         理解 Selector, Method, Implementation 这三个概念之间关系的最好方式是：在运行时，类（Class）维护了一个消息分发列表来解决消息的正确发送。每一个消息列表的入口是一个方法（Method），这个方法映射了一对键值对，其中键值是这个方法的名字 selector（SEL），值是指向这个方法实现的函数指针 implementation（IMP）。 Method swizzling 修改了类的消息分发列表使得已经存在的 selector 映射了另一个实现 implementation，同时重命名了原生方法的实现为一个新的 selector。
         */
        Class class = [self class];
        
        SEL oldDescription = @selector(description);
        SEL newDescription = @selector(config_description);
        
        Method oldDescriptionMethod = class_getInstanceMethod(class, oldDescription);
        Method newDescriptionMethod = class_getInstanceMethod(class, newDescription);
        
        BOOL didAddMethod = class_addMethod(class, oldDescription, method_getImplementation(newDescriptionMethod), method_getTypeEncoding(newDescriptionMethod));
        if (didAddMethod) {
            class_replaceMethod(class, newDescription, method_getImplementation(oldDescriptionMethod), method_getTypeEncoding(oldDescriptionMethod));
        }else {
            method_exchangeImplementations(oldDescriptionMethod, newDescriptionMethod);
        }
    });
}

- (NSString *)config_description {
    return [self config_description];
}

- (NSString *)description {
    Class class = [self class];
    return [NSString stringWithFormat:@"class=%@", class];
}


@end
