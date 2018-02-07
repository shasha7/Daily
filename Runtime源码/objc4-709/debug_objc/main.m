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

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
    }
    return 0;
}
