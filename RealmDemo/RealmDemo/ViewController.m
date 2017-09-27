//
//  ViewController.m
//  RealmDemo
//
//  Created by 王伟虎 on 2017/9/27.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import "ViewController.h"
#import "Cat.h"
#import <Realm/Realm.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self testBaicOperation];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)testBaicOperation {
    
    Cat *cat = [[Cat alloc] init];
    cat.cat_id = 1;
    cat.name = @"xiaowang";
    cat.age = 2;
    cat.weight = 1.32f;
    cat.height = 1.32f;
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    // 必须在事务当中操作
    [realm beginWriteTransaction];
    // 执行更新必须要有主键
    [realm addOrUpdateObject:cat];
    [realm commitWriteTransaction];
}

@end
