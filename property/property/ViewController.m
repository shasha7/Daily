//
//  ViewController.m
//  property
//
//  Created by 王伟虎 on 2018/1/6.
//  Copyright © 2018年 wwh. All rights reserved.
//

#import "ViewController.h"
#import "Dog.h"
#import <objc/runtime.h>
#import "Person.h"

@interface ViewController ()

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, assign, getter=isOn) BOOL on;
- (NSString *)fullName;

@end

@implementation ViewController

void TestClass() {
    NSLog(@"123");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Class cls = objc_allocateClassPair([NSObject class], "Animal", 0);
    
    class_addMethod(cls, @selector(TestClass), (IMP)TestClass, "v@:");
    
    objc_registerClassPair(cls);
    
    
//    NSLog(@"self = %@", self);
//
//    NSLog(@"ViewController类对象 = %p", [ViewController class]);
//
//    Person *person = [Person new];
//    NSLog(@"person = %@", person);
    
//    Person *person1 = [Person new];
//    NSLog(@"person = %@", person1);
    
//    id cls = [Dog class];

//    void *obj = &cls;
    
//    [(__bridge Dog *)obj eat];
    
    /*
     self
     _cmd
     super_class
     self
     person
     person1
     obj
     */
}

- (void)viewDidLoad1 {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 为NSString类型的属性声明特质时，内存管理语义如果是strong时，传递给设置方法的值很可能是一个指向NSMutableString *类型的可变字符串，在不知情的时候，有人改变了可变字符串的值，那么很可能拿到的NSString类型的字符串不是我们想要的值
    NSMutableString *nameStr = [[NSMutableString alloc] initWithString:@"wangweihu"];
    self.name = nameStr;
    [nameStr appendString:@"wushanshan"];
    NSLog(@"name = %@", self.name);
    // strong 结果为name = wangweihuwushanshan
    // copy 结果为name = wangweihu
    
    BOOL isOn = self.isOn;
    isOn = self.on;
    NSLog(@"isOn = %@", @(self.isOn));
    
    // 如何判断两个对象的等同性
    // == 操作符 比较的两个指针本身，是否指向同一个对象(内存块)
    NSString *foo = @"123";
    NSString *bar = [NSString stringWithFormat:@"%@", @"123"];
    
    BOOL isEqual = [foo isEqualToString:bar];
    NSLog(@"isEqual = %@", @(isEqual));
    
    [self test];
    
    TestMetaClass(self, @selector(viewDidLoad));
//    [self performSelector:@selector(hello) withObject:nil];
}

- (void)test {
    Dog *dog = [[Dog alloc] init];
    
    /**
     * Returns the class definition of a specified class.
     * 获取指定类的类对象
     * param name The name of the class to look up.
     *
     * return The Class object for the named class, or \c nil
     *  if the class is not registered with the Objective-C runtime.
     *
     * @note \c objc_getClass is different from \c objc_lookUpClass in that if the class
     *  is not registered, \c objc_getClass calls the class handler callback and then checks
     *  a second time to see whether the class is registered. \c objc_lookUpClass does
     *  not call the class handler callback.
     *
     * @warning Earlier implementations of this function (prior to OS X v10.0)
     *  terminate the program if the class does not exist.
     */
    Class definition = objc_getClass("Dog");// [Dog class]是一样的
    NSLog(@"definition=%@", definition);
    
    
    /**
     * Returns the class of an object.
     * NSObject 类对象的元类
     * param obj The object you want to inspect.
     *
     * return The class object of which \e object is an instance,
     *  or \c Nil if \e object is \c nil.
     */
    Class metaClass = object_getClass(dog);
    NSLog(@"metaClass=%@", metaClass);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 在对象内部直接访问实例变量的好处就是不经过方法派发，直接到变量指向的内存块读取值
- (NSString *)fullName {
    return [NSString stringWithFormat:@"%@ %@", _firstName, _lastName];
}

void TestMetaClass(id self, SEL _cmd) {
    NSLog(@"This objcet is %p", self);
    NSLog(@"Class is %@, super class is %@", [self class], [self superclass]);
    Class currentClass = [self class];// 获取类对象即类本身
    //[self class]->ViewController
    for (int i = 0; i < 10; i++) {
        NSLog(@"Following the isa pointer %d times gives %p", i, currentClass);
        currentClass = object_getClass(currentClass);
    }
    // currentClass->ViewController
    // Following the isa pointer 0 times gives 0x10048e1f0
    
    // currentClass->UIViewController
    // Following the isa pointer 1 times gives 0x10048e220
    
    // currentClass->NSObject
    // Following the isa pointer 2 times gives 0x7fff8c8e50f0
    
    // currentClass->NSObject
    // Following the isa pointer 3 times gives 0x7fff8c8e50f0
    NSLog(@"NSObject's class is %p", [NSObject class]);
    NSLog(@"NSObject's meta class is %p", object_getClass([NSObject class]));
    
    // NSObject's class is 0x7fff8c8e5140
    
    // for循环中的输出结果也印证了NSObject元类的isa指向的是其本身。
    // NSObject's meta class is 0x7fff8c8e50f0
    
    // Conclusion
    /*
     类对象的类是元类，每一个类都有着它独有的元类(因为每一个类都可以有它自己特有的类方法)。这意味着所有的类对象本身都不是同一个类
     
     元类将始终确保类对象具有层次结构中基类的所有实例和类方法，以及中间的所有类方法。
     对于来自NSObject的子类，这意味着所有的类（和元类）对象都定义了所有的NSObject实例和协议方法

     所有元类本身都使用基类的元类（NSObject元类为NSObject层次结构类）作为它们的类，包括基本级元类，它是运行时中唯一的自定义类
     */
}

@end
