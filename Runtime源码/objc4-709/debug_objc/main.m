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

int main(int argc, const char * argv[]) {
    // void *objc_autoreleasePoolPush(void){return AutoreleasePoolPage::push();}
    @autoreleasepool {
        // insert code here...
        TaggedPointerTest();
    }
    return 0;
}
