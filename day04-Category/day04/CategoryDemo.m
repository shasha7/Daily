//
//  CategoryDemo.m
//  day04
//
//  Created by 王伟虎 on 17/2/10.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import "CategoryDemo.h"

@interface CategoryDemo ()

/**
 *  类扩展看上去像一个匿名的分类，但却是两个完全不同的东西
 *  类扩展声明必须在.m文件中，可以声明变量、添加属性、添加方法
 *  类扩展中声明的方法，不实现的话就会报警告Method definition for 'xxx' not found
 */
{
    NSInteger _varible1;
    NSInteger _varible2;
}

@property (nonatomic, assign) NSUInteger varible3;

- (void)method_extention1;
- (void)method_extention2;

@end

@implementation CategoryDemo

- (void)method1 {
    NSLog(@"CategoryDemo");
}

- (void)method2 {

}

- (void)method3 {

}

- (void)method_extention1 {
    
}

- (void)method_extention2 {
    
}
@end
