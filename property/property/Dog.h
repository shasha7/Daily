//
//  Dog.h
//  property
//
//  Created by 王伟虎 on 2018/1/6.
//  Copyright © 2018年 wwh. All rights reserved.
//

#import <Foundation/Foundation.h>

/*OC中的对象是一个指向类对象地址的变量,而对象的实例变量实际上是距存放对象内存区域一定偏移量的内存区域*/

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
