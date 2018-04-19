//
//  Student.m
//  DouBan
//
//  Created by 王伟虎 on 2018/4/19.
//  Copyright © 2018年 wwh. All rights reserved.
//

#import "Student.h"

@implementation Student

+ (instancetype)studentWithFirstname:(NSString *)firstname lastname:(NSString *)lastname {
    Student *stu = [Student new];
    stu.firstname = firstname;
    stu.lastname = lastname;
    return stu;
}

@end
