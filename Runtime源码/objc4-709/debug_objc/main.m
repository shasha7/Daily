//
//  main.m
//  debug_objc
//
//  Created by Holy_Han on 19/09/2017.
//
//

#import <Foundation/Foundation.h>
#import "objc-runtime.h"

static char *kTeacherAgeKey = "kTeacherAgeKey";
static char *kTeacherNameKey = "kTeacherNameKey";
static char *kTeacherSchoolKey = "kTeacherSchoolKey";

@interface Teacher: NSObject

@end

@implementation Teacher

@end

void objc_associatedObjectTest() {
    Teacher *teacher = [Teacher new];
    
    objc_setAssociatedObject(teacher, kTeacherAgeKey, @(28), OBJC_ASSOCIATION_RETAIN);
    
    objc_setAssociatedObject(teacher, kTeacherNameKey, @"王伟虎", OBJC_ASSOCIATION_COPY);
    
    objc_setAssociatedObject(teacher, kTeacherSchoolKey, @"河北科技大学", OBJC_ASSOCIATION_COPY);
    
    objc_setAssociatedObject(teacher, kTeacherSchoolKey, @"北京大学", OBJC_ASSOCIATION_COPY);
    
    NSString *name = (NSString *)objc_getAssociatedObject(teacher, kTeacherNameKey);
    NSString *school = (NSString *)objc_getAssociatedObject(teacher, kTeacherSchoolKey);
    NSNumber *age = (NSNumber *)objc_getAssociatedObject(teacher, kTeacherAgeKey);
    NSLog(@"name=%@,age=%@,school=%@", name, age, school);
}

void TaggedPointerTest() {
    // http://blog.sunnyxx.com/2014/10/15/behind-autorelease/
    // https://www.cnblogs.com/xiaosong666/p/5045494.html
    // http://www.360doc.com/content/16/0824/17/12278201_585635115.shtml
    // http://www.infoq.com/cn/articles/deep-understanding-of-tagged-pointer
    // https://www.cnblogs.com/bbqzsl/p/5118905.html
    // http://blog.csdn.net/Xiejunyi12/article/details/61195716
    // (2^60-1)
    NSNumber *number1 = @11;
    NSNumber *number2 = @22;
    NSNumber *number3 = @33;
    NSNumber *numberFFFF = @(0xFFFF);
    
    NSNumber *numberLager = @(MAXFLOAT);
    NSString *string1 = [NSString stringWithUTF8String:"ab"];
    NSString *string2 = [NSString stringWithUTF8String:"bc"];
    NSString *string3 = [NSString stringWithUTF8String:"cd"];
    
    NSLog(@"string1 pointer is %p", string1);
    NSLog(@"string2 pointer is %p", string2);
    NSLog(@"string3 pointer is %p", string3);
    
    NSLog(@"number1 pointer is %p", number1);
    NSLog(@"number2 pointer is %p", number2);
    NSLog(@"number3 pointer is %p", number3);
    NSLog(@"numberFFFF pointer is %p", numberFFFF);
    NSLog(@"numberLager pointer is %p", numberLager);
}

NSString *binaryithInteger(NSUInteger decInt) {
    NSString *string = @"";
    NSUInteger dec = decInt;
    while (dec > 0) {
        string = [[NSString stringWithFormat:@"%lu", dec&1] stringByAppendingString:string];
        dec = dec >> 1;
    }
    return string;
}

void binaryithIntegertest() {
    struct objc_object *test = (__bridge struct objc_object *)([Teacher new]);
    NSLog(@"%@", binaryithInteger(test->isa));
    NSLog(@"%@", binaryithInteger((uintptr_t)[Teacher class]));
}

struct ISA {
    uintptr_t nonpointer        : 1;
    uintptr_t has_assoc         : 1;
    uintptr_t has_cxx_dtor      : 1;
    uintptr_t shiftcls          : 33;
    uintptr_t magic             : 6;
    uintptr_t weakly_referenced : 1;
    uintptr_t deallocating      : 1;
    uintptr_t has_sidetable_rc  : 1;
    uintptr_t extra_rc          : 19;
};

union hold {
    Class cls;
    long bits;
    struct ISA isa;
};

void unionTest() {
    union hold hold;
    hold.isa.nonpointer = 1;
    hold.isa.has_assoc = 1;
    hold.cls = [Teacher class];
    NSLog(@"%lu", (uintptr_t)hold.cls>>3);
    hold.bits = 0x00007ffffffffff8ULL;
}

struct B {
    uint32_t flags;
    uint32_t instanceStart;
    uint32_t instanceSize;

    uint32_t reserved;
    const uint8_t * ivarLayout;
    const char * name;
};

struct A {
    uint32_t flags;
    uint32_t version;
    
    const struct B *ro;
    
    Class firstSubclass;
    Class nextSiblingClass;
    
    char *demangledName;
    
    uint32_t index;
};

void structChange() {
    struct A a = {1, 2, NULL, [Teacher class], [Teacher class], NULL, 32};
    struct B *b = (struct B*)&a;
}

// XXObject.h 文件
@interface XXObject : NSObject

- (void)hello;

@end

// XXObject.m 文件
@implementation XXObject

- (void)hello {
    NSLog(@"Hello");
}

@end

int main(int argc, const char * argv[]) {
    // void *objc_autoreleasePoolPush(void){return AutoreleasePoolPage::push();}
    @autoreleasepool {
        // 附有__weak修饰符的变量所引用的对象被销毁的时候，则将nil赋值给该变量
        // 使用附有__weak修饰符的变量即是使用注册到autoreleasepool中的对象
        NSObject *objc = [NSObject new];
        id __weak objc1 = objc;
        id __weak objc2 = objc;
        id __weak objc3 = objc;
        id __weak objc4 = objc;
        id __weak objc5 = objc;
        /*
         id objc1;
         objc_initWeak(&objc1, objc);//初始化objc1变量·
         objc_destroyWeak(&objc1);//释放变量objc1
         */
        
        // block是一个带有自动变量值的匿名函数、是一个Objective-C的对象、是一个C语言的结构体
    }
    return 0;
}
