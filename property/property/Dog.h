//
//  Dog.h
//  property
//
//  Created by 王伟虎 on 2018/1/6.
//  Copyright © 2018年 wwh. All rights reserved.
//  https://github.com/Draveness/analyze/blob/master/contents/objc/%E4%BB%8E%20NSObject%20%E7%9A%84%E5%88%9D%E5%A7%8B%E5%8C%96%E4%BA%86%E8%A7%A3%20isa.md#arm64

#import <Foundation/Foundation.h>
/**
 // 待了解
 #define ISA_MASK        0x0000000ffffffff8ULL
 #define ISA_MAGIC_MASK  0x000003f000000001ULL
 #define ISA_MAGIC_VALUE 0x000001a000000001ULL
 #define RC_ONE          (1ULL<<45)
 #define RC_HALF         (1ULL<<18)
 union isa_t {
    // 构造方法1
    isa_t() { }
    // 构造方法2 通过方法参数列表初始化
    isa_t(uintptr_t value) : bits(value) { }
    Class cls;
    uintptr_t bits;
    struct {
        uintptr_t indexed           : 1;
        uintptr_t has_assoc         : 1;
        uintptr_t has_cxx_dtor      : 1;
        uintptr_t shiftcls          : 33;
        uintptr_t magic             : 6;
        uintptr_t weakly_referenced : 1;
        uintptr_t deallocating      : 1;
        uintptr_t has_sidetable_rc  : 1;
        uintptr_t extra_rc          : 19;
    };
 }
 cls bits 和结构体共用同一块内存区域
 其中indexed表示isa_t的类型，0表示raw isa，也就是没有结构体的部分，访问对象的isa会直接返回一个指向 cls的指针，也就是在iPhone迁移到64位系统之前时isa的类型，1 表示当前 isa 不是指针，但是其中也有 cls 的信息，只是其中关于类的指针都是保存在shiftcls中。
 magic的值为0x3b用于调试器判断当前对象是真的对象还是没有初始化的空间
 在设置indexed和magic值之后，会设置isa的has_cxx_dtor，这一位表示当前对象有C++或者ObjC的析构器(destructor)，如果没有析构器就会快速释放内存。
 在为 indexed、 magic 和 has_cxx_dtor 设置之后，我们就要将当前对象对应的类指针存入isa结构体中了。
 将当前地址右移三位的主要原因是用于将Class指针中无用的后三位清除减小内存的消耗，因为类的指针要按照字节（8 bits）对齐内存，其指针后三位都是没有意义的0。
 编译器对直接访问 isa 的操作会有警告，因为直接访问 isa 已经不会返回类指针了，这种行为已经被弃用了，取而代之的是使用 ISA() 方法来获取类指针
 
 这里通过掩码的方式获取类指针
 #define ISA_MASK 0x00007ffffffffff8ULL
 11111111111111111111111111111111111111111111000
 inline Class objc_object::ISA() {
    return (Class)(isa.bits & ISA_MASK);
 }
 has_assoc 对象含有或者曾经含有关联引用，没有关联引用的可以更快地释放内存
 weakly_referenced 对象被指向或者曾经指向一个 ARC 的弱变量，没有弱引用的对象可以更快释放
 deallocating 对象正在释放内存
 has_sidetable_rc 对象的引用计数太大了，存不下
 extra_rc 对象的引用计数超过 1，会存在这个这个里面，如果引用计数为 10，extra_rc 的值就为 9
 
 // Represents an instance of a class.
 struct objc_object {
    isa_t isa;
 }

 // An opaque type that represents an Objective-C class.
 struct objc_class : objc_object {
    isa_t isa;//继承自objc_object
    Class superclass;
    cache_t cache;
    class_data_bits_t bits;
 };
 
 * Objective-C中类也是一个对象
 * OC中的对象是一个指向类对象地址的变量,而对象的实例变量实际上是距存放对象内存区域一定偏移量的内存区域
 * 对象方法、类方法为何不在对象的结构体里面呢？因为在Objective-C中，对象的方法并没有存储于对象的结构体中（如果每一个对象都保存了自己能执行的方法，那么对内存的占用有极大的影响）
 *
 * 当实例方法被调用时，它要通过自己持有的isa来查找对应的类(类对象)，然后在这里的class_data_bits_t结构体中查找对应方法的实现。同时，每一个objc_class也有一个指向自己的父类的指针super_class用来查找继承的方法。
 * 类方法的实现又是如何查找并且调用的呢？这时，就需要引入“元类“来保证无论是类还是对象都能通过相同的机制查找方法的实现。
 */

@interface Dog : NSObject

// 在64位架构芯片上，指针的大小为8字节即64位
@property (nonatomic, copy) NSString *hostLastName;
@property (nonatomic, copy) NSString *hostFirstName;
@property (nonatomic, copy) NSString *name;

// The most important feature of objects in Objective-C is that you can send messages to them
// 无论是类方法，还是对象方法， 调用者都必须是对象，就是说类其实也是一种对象
- (void)eat;
+ (void)eat;

@end
