//
//  SearchViewController.m
//  InterviewDemo
//
//  Created by 王伟虎 on 2017/9/6.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"搜索";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self deleteRepeateData2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 消除重复数据

- (void)deleteRepeateData1 {
    NSArray *mutipleArray = @[@"wang", @"li", @"zhou", @"wang", @"zou"];
    NSMutableSet *singleSet = [NSMutableSet set];
    for (NSString *firstName in mutipleArray) {
        [singleSet addObject:firstName];
    }
    NSLog(@"%@", singleSet);
}

- (void)deleteRepeateData2 {
    NSArray *mutipleArray = @[@"wang", @"li", @"zhou", @"wang", @"zou"];
    NSMutableSet *singleSet = [NSMutableSet setWithArray:mutipleArray];
    NSLog(@"%@", singleSet);
}

@end
