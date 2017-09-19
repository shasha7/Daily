//
//  IDViewController.h
//  InterviewDemo
//
//  Created by 王伟虎 on 2017/9/6.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDViewController : UIViewController

/*
 无论父类是在@interface还是@implementation声明的成员变量子类都能拥有；
 但是子类能不能直接通过变量名来访问父类中定义的成员变量是需要看父类中定义的成员变量是由什么修饰符来修饰的。
 @public:在任何地方都能直接访问对象的成员变量
 @private:只能在当前类的对象方法中直接访问,如果子类要访问需要调用父类的get/set方法
 @protected:可以在当前类及其子类对象方法中直接访问(系统默认下是用它来修饰的)
 @package:在同一个包下就可以直接访问，比如说在同一个框架
 */
{
    @private
    NSInteger _age;
    @public
    NSInteger _id;
    @protected
    NSInteger _class;
    @package
    NSInteger _height;
}
@end
