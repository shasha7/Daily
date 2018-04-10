//
//  AppDelegate.m
//  DouBan
//
//  Created by 王伟虎 on 2017/10/1.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import "AppDelegate.h"
#import "DBTabBarController.h"
#import "PAirSandbox.h"

#define DEBUG 1

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [DBTabBarController new];
    [self.window makeKeyAndVisible];
#ifdef DEBUG
    [[PAirSandbox sharedInstance] enableSwipe];
#endif
    return YES;
}

@end
