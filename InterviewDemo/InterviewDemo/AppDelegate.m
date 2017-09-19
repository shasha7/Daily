//
//  AppDelegate.m
//  InterviewDemo
//
//  Created by 王伟虎 on 2017/9/19.
//  Copyright © 2017年 wwh. All rights reserved.
//
//  https://github.com/lzyy/iOS-Developer-Interview-Questions
//  http://www.jianshu.com/p/5d2163640e26
//  http://www.jianshu.com/p/b0f5a588453d
//  http://www.jianshu.com/p/403ee06a584e

#import "AppDelegate.h"
#import "IDTabBarController.h"
#import "IDInitialize.h"
#import "IDMonitor.h"

@interface AppDelegate ()

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
