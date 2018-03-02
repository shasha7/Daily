//
//  ViewController.h
//  Effective Objective-C
//
//  Created by 王伟虎 on 2018/1/11.
//  Copyright © 2018年 wwh. All rights reserved.
//

#import <UIKit/UIKit.h>

// 声明一个类的可用性也很简单，并且无需给类中的每个方法再次声明可用性，只需要用到 API_AVAILABLE 宏：
API_AVAILABLE(ios(11.0))

@interface MyClassForiOS11OrNewer : NSObject

- (void)foo;

@end

@interface ViewController : UIViewController
{
@private
    NSInteger _edu;
@public
    NSInteger _sex;
@protected
    NSInteger _income;
    @package
    NSInteger _married;
}

// __kindof : 告诉编译器返回值可能是NSString,也可能是NSMutableString
- (__kindof NSString *)dequeueXXX;

/*
 * foo 方法内部的实现中调用iOS11的API时无需再用@available检查
 */
- (void)foo API_AVAILABLE(ios(11.0));

@end

