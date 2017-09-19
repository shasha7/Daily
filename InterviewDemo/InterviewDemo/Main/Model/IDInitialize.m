//
//  IDInitialize.m
//  InterviewDemo
//
//  Created by 王伟虎 on 2017/9/6.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import "IDInitialize.h"

@implementation IDInitialize

/*
    单例命名规范:sharedClassType
    Several Cocoa framework classes are singletons. They include NSFileManager, NSWorkspace, and, in UIKit, UIApplication and UIAccelerometer. The name of the factory method returning the singleton instance has, by convention, the form sharedClassType. Examples from the Cocoa frameworks are sharedFileManager, sharedColorPanel, and sharedWorkspace.
 */
+ (instancetype)sharedInitialize {
    static IDInitialize *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [IDInitialize new];
    });
    return _instance;
}

+ (void)setupTabBarAppearance {
    [[UITabBar appearance] setTintColor:[UIColor redColor]];
}

+ (void)setupNavigationBarAppearance {
    // delete NavigationBar shadowImage
    [UINavigationBar appearance].shadowImage = [UIImage new];
    
    // setup NavigationBar background color
    [UINavigationBar appearance].barTintColor = [UIColor redColor];
    
    // setup NavigationBar title color, font, etc.
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor yellowColor], NSFontAttributeName:[UIFont systemFontOfSize:15.0f]}];
    
    /*
     如何支持系统自带的左测滑回到上一界面
     self.interactivePopGestureRecognizer.delegate = self;
     - (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
        //当导航控制器的子控制器个数 大于1 手势才有效
        return viewcontrollers.count > 1;
     }
     
     edgesForExtendedLayout 在iOS7以后默认设置是UIRectEdgeAll,translucent的默认值是true，这个组合会使rootView的布局从(0, 0)开始，就会造成rootView被NavigationBar遮挡住一部分，将 edgesForExtendedLayout设置为UIRectEdgeNone即可解决问题
     automaticallyAdjustsScrollViewInsets 默认值是YES，表示在全屏下会自动将第一个添加到rootVC 的ScrollView的contentInset设置为(64, 0, 0, 0)，这样scrollView就不会被导航栏遮挡住了
     
     // 导航栏返回按钮跳转至自定义栈顶控制器
     if (!newTopVC) {
        return;
     }
     NSMutableArray *newViewControllers = [NSMutableArray arrayWithArray:self.viewControllers];
     [newViewControllers replaceObjectAtIndex:self.viewControllers.count - 1 withObject:newTopVC];
     [self setViewControllers:newViewControllers animated:animated];
     */
}

@end
