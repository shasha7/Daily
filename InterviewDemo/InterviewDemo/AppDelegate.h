//
//  AppDelegate.h
//  InterviewDemo
//
//  Created by 王伟虎 on 2017/9/6.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

/*
 这里不禁要问@到底是什么东西？？
 苹果官方建议两个字母作为前缀的类名是为官方的库和框架准备的，而对于作为第三方开发者的我们，官方建议使用3个或者更多的字母作为前缀去命名我们的类。
 苹果官方建议所有category方法都要使用前缀，这个建议比类名需要加前缀的规定更加广为人知和接受。
 category的主要功能是通过语法糖将一些有用的功能包裹进原来的类中。任何一个category方法都可以被选择性实现
 当我在编译器的环境参数中将OBJC_PRINT_REPLACED_METHODS这个参数设置为YES，那我们就能在编译的时候检测方法名是否有冲突。实际上，方法名的冲突是很少发生的，而且在发生的时候，他们通常会得到一个needlessly duplicated across dependencies的提示
 */
@property (strong, nonatomic) UIWindow *window;


@end

