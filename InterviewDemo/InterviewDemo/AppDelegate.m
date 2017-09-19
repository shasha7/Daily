//
//  AppDelegate.m
//  InterviewDemo
//
//  Created by 王伟虎 on 2017/9/6.
//  Copyright © 2017年 wwh. All rights reserved.
//  https://github.com/lzyy/iOS-Developer-Interview-Questions
//  http://www.jianshu.com/p/5d2163640e26
//  http://www.jianshu.com/p/b0f5a588453d
//  http://www.jianshu.com/p/403ee06a584e

#import "AppDelegate.h"
#import "IDTabBarController.h"
#import "IDInitialize.h"
#import "IDMonitor.h"

@interface AppDelegate ()
/*
 面向对象的语言特性：封装、继承、多态 Java C++ OC
 Objective-C具有相当多的动态特性，表现为三方面：动态类型（Dynamic typing）、动态绑定(Dynamic binding)和动态加载(Dynamic loading)
 动态必须到运行时(runtime)才会做的一些事情。
 动态类型：即运行时再决定对象的类型，这种动态特性在日常的应用中非常常见，简单来说就是id类型。事实上，由于静态类型的固定性和可预知性，从而使用的更加广泛。静态类型是强类型，而动态类型属于弱类型，运行时决定接受者。
 动态绑定：基于动态类型，在某个实例对象被确定后，其类型便被确定了，该对象对应的属性和响应消息也被完全确定。
 动态加载：根据需求加载所需要的资源，最基本就是不同机型的适配，例如，在Retina设备上加载@2x的图片，而在老一些的普通苹设备上加载原图，让程序在运行时添加代码模块以及其他资源，用户可根据需要加载一些可执行代码和资源，而不是在启动时就加载所有组件，可执行代码可以含有和程序运行时整合的新类。
 */
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [IDTabBarController new];
    
    IDConfig *config = [IDConfig new];
    config.version = @"1.0";
    config.identifier = @"wangweihu.InterviewDemo";
    NSLog(@"%@", config);
    [IDMonitor setupConfiguration:config];
    [IDMonitor startMonitor];
    
    [IDInitialize setupNavigationBarAppearance];
    [IDInitialize setupTabBarAppearance];
    [self.window makeKeyAndVisible];
    return YES;
}

/*
    应用状态
    活跃状态：UIApplicationStateActive
            The app is running in the foreground and currently receiving events.
    非活跃状态：UIApplicationStateInactive
              The app is running in the foreground but is not receiving events. This might happen as a result of an interruption or because the app is transitioning to or from the background.
    后台状态：UIApplicationStateBackground
            The app is running in the background.
 */
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    NSLog(@"%@", NSStringFromSelector(_cmd));
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"%@", NSStringFromSelector(_cmd));
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    NSLog(@"%@", NSStringFromSelector(_cmd));
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"%@", NSStringFromSelector(_cmd));
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"%@", NSStringFromSelector(_cmd));
}


@end
