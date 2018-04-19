//
//  DBTabBarController.m
//  DouBan
//
//  Created by 王伟虎 on 2017/10/2.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import "DBTabBarController.h"
#import "DBNavigationController.h"

#import "DBHomeViewController.h"
#import "DBBroadcastViewController.h"
#import "DBVideoViewController.h"

typedef struct DBTabBarItem {
    __unsafe_unretained NSString *title;
    __unsafe_unretained NSString *image;
    __unsafe_unretained NSString *selectedImage;
}DBTabBarItem;

static DBTabBarItem tabBarList[] = {
    {@"首页", @"db_tab_home", @"db_tab_home_selected"},
    {@"广播", @"db_tab_broadcast", @"db_tab_broadcast_selected"},
    {@"音频", @"db_tab_home", @"db_tab_home_selected"}
};

@interface DBTabBarController ()

@end

@implementation DBTabBarController

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 设置UITabBar标签选中颜色
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:55/255.0f green:173/255.0f blue:66/255.0f alpha:1]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 加载自控制器
    [self addChildViewControllers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addChildViewControllers {
    DBHomeViewController *homeVC = [DBHomeViewController new];
    [self addChildViewController:homeVC title:tabBarList[0].title image:tabBarList[0].image selectedImage:tabBarList[0].selectedImage];

    DBBroadcastViewController *broadcastVC = [DBBroadcastViewController new];
    [self addChildViewController:broadcastVC title:tabBarList[1].title image:tabBarList[1].image selectedImage:tabBarList[1].selectedImage];
    
    DBVideoViewController *videoVC = [DBVideoViewController new];
    [self addChildViewController:videoVC title:tabBarList[2].title image:tabBarList[2].image selectedImage:tabBarList[2].selectedImage];
}

- (void)addChildViewController:(UIViewController *)childController title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage {
    if (!childController) return;
    DBNavigationController *dbNC = [[DBNavigationController alloc] initWithRootViewController:childController];
    dbNC.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    dbNC.title = title;
    [self addChildViewController:dbNC];
}

@end
