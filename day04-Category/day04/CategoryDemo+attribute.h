//
//  CategoryDemo+attribute.h
//  day04
//
//  Created by 王伟虎 on 17/2/10.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import "CategoryDemo.h"

@interface CategoryDemo (attribute)

/**
 *  Category:即使在你不知道一个类的源码情况下,向这个类添加扩展的方法和属性
 *  使用Category可以很方便地为现有的类增加方法,但却无法直接增加实例变量，只能关联上
 *  在Category.h中声明的方法，在.m中不实现的话就会报警告
 *  Method definition for 'xxx' not found
 */
@property (nonatomic, copy) NSString *attribute4;

@end
