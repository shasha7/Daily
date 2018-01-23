//
//  CategoryDemo+attribute.h
//  day04
//
//  Created by 王伟虎 on 17/2/10.
//  Copyright © 2017年 wwh. All rights reserved.
//  参考资料
//  https://tech.meituan.com/?l=320&pos=0
//  https://tech.meituan.com/DiveIntoCategory.html
//  https://www.jianshu.com/p/3b219ab86b09
//  https://bestswifter.com/runtime-category/
//  https://tech.meituan.com/DiveIntoCategory.html
//  https://www.jianshu.com/p/9d649ce6d0b8
//  https://github.com/Draveness/analyze/blob/master/contents/objc/%E6%B7%B1%E5%85%A5%E8%A7%A3%E6%9E%90%20ObjC%20%E4%B8%AD%E6%96%B9%E6%B3%95%E7%9A%84%E7%BB%93%E6%9E%84.md

#import "CategoryDemo.h"

@interface CategoryDemo (attribute)

/**
 *  Category:即使在你不知道一个类的源码情况下,可以向这个类添加扩展的方法和属性
 *  使用Category可以很方便地为现有的类增加方法,但却无法直接添加实例变量
 *  在Category.h中声明的方法，在.m中不实现的话就会报警告
 *  Method definition for 'xxx' not found
 */

@property (nonatomic, copy) NSString *attribute4;

//- (void)method1;

@end
