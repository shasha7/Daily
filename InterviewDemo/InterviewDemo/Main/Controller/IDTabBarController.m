//
//  IDTabBarController.m
//  InterviewDemo
//
//  Created by 王伟虎 on 2017/9/6.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import "IDTabBarController.h"
#import "IDNavigationController.h"
#import "HomeViewController.h"
#import "SearchViewController.h"
#import "MessageViewController.h"
#import "SquareViewController.h"
#import "ProfileViewController.h"

@interface IDTabBarController ()

@end

@implementation IDTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBar.backgroundImage = [UIImage imageNamed:@"tabbar-bg"];
    [self setupChildControllers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupChildControllers {
    // 首页
    HomeViewController *home = [HomeViewController new];
    /*
        由于我们没有在IDViewController或他的子类里面,所以只能访问.h中@public修饰的变量,也就是id,由于class是@protrcted在外部是不能被访问的!
     */
    [self setupChildController:home title:@"首页" image:@"tabbar-heart" selectedImage:@"tabbar-heart-s"];
    
    // 搜索
    [self setupChildController:[SearchViewController new] title:@"搜索" image:@"tabbar-search" selectedImage:@"tabbar-search-s"];
    
    // 消息
    [self setupChildController:[MessageViewController new] title:@"消息" image:@"tabbar-mail" selectedImage:@"tabbar-mail-s"];
    
    // 广场
    [self setupChildController:[SquareViewController new] title:@"广场" image:@"tabbar-square" selectedImage:@"tabbar-square-s"];
    
    // 我
    [self setupChildController:[ProfileViewController new] title:@"我" image:@"tabbar-more" selectedImage:@"tabbar-more-s"];
}

- (void)setupChildController:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage {
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    IDNavigationController *navc = [[IDNavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:navc];
}

@end
