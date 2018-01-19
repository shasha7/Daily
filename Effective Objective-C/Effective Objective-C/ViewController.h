//
//  ViewController.h
//  Effective Objective-C
//
//  Created by 王伟虎 on 2018/1/11.
//  Copyright © 2018年 wwh. All rights reserved.
//

#import <UIKit/UIKit.h>

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

@end

