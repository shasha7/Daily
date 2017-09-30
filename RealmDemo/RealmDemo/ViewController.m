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
    [self testBaicOperation3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)testBaicOperation3 {
    // 删除数据
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    // 删除所有数据
//    [realm deleteAllObjects];
//    
//    // 删除某个数组数据
//    [realm deleteObjects:@[]];
    
    Cat *cat = [[Cat alloc] init];
    cat.cat_id = 3;
    cat.name = @"xiaowang1";
    cat.age = 4;
    cat.weight = 1.32f;
    cat.height = 1.32f;
    [realm deleteObject:cat];
}

- (void)testBaicOperation2 {
    // 查询  支持链式查询
    RLMResults *results = [Cat allObjectsInRealm:[RLMRealm defaultRealm]];
    results = [results objectsWhere:@"age > 2"];
    Cat *oneCat = results.firstObject;
    NSLog(@"oneCat.name=%@", oneCat.name);
}

- (void)testBaicOperation1 {
    Cat *cat = [[Cat alloc] init];
    cat.cat_id = 3;
    cat.name = @"xiaowang1";
    cat.age = 4;
    cat.weight = 1.32f;
    cat.height = 1.32f;
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm transactionWithBlock:^{
        // 主键一样，刷新数据条目
        [realm addOrUpdateObject:cat];
    }];
}

- (void)testBaicOperation0 {
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
