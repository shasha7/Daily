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

/**
 类结构体
 struct objc_class {
    Class isa                                                OBJC_ISA_AVAILABILITY;
 #if !__OBJC2__
    Class super_class                                        OBJC2_UNAVAILABLE;
    const char *name                                         OBJC2_UNAVAILABLE;
    long version                                             OBJC2_UNAVAILABLE;
    long info                                                OBJC2_UNAVAILABLE;
    long instance_size                                       OBJC2_UNAVAILABLE;
    struct objc_ivar_list *ivars                             OBJC2_UNAVAILABLE;
    struct objc_method_list **methodLists                    OBJC2_UNAVAILABLE;
    struct objc_cache *cache                                 OBJC2_UNAVAILABLE;
    struct objc_protocol_list *protocols                     OBJC2_UNAVAILABLE;
 #endif
 } OBJC2_UNAVAILABLE;
 
 OBJC2_UNAVAILABLE这个宏代表着该属性或方法只有在objc1.0是有效的
 
 struct objc_method_list **methodLists为什么是一个二维数组？？[[],[],[]]
 在objc-class.mm源文件中就有解释
 * cls->methodLists may be in one of three forms:
 * 1. nil: The class has no methods.这个类没有成员方法
 * 2. non-nil, with CLS_NO_METHOD_ARRAY set: cls->methodLists points
 *    to a single method list, which is the class's only method list.这个类只有一个方法数组，也就是说这个类没有分类
 * 3. non-nil, with CLS_NO_METHOD_ARRAY clear: cls->methodLists points to
 *    an array of method list pointers. The end of the array's block
 *    is set to -1. If the actual number of method lists is smaller
 *    than that, the rest of the array is nil.这个类不只有一个方法数组，也就是说这个类存在分类，分类个数为methodLists的大小
 * 当一个类刚创建时，它可能处于状态1或2，但如果使用class_addMethod或者category来添加方法，就会进入状态3，而且一旦进入状态3就再也不可能回到其他状态，即使新增的方法后来又被移除掉
 * 这里如果动态修改*methodLists的值来添加成员方法，这也是Category实现的原理。
 * Category不能添加属性的原因：分类是在主类之后被加载到runtime的,这时候类结构已经确定下来了.如果这时进行成员变量的添加,那么当子类加载的时候,就会出现文章之前描述的内存覆盖的现象
 * 在类的+load方法调用的时候，我们可以调用category中声明的方法，因为附加category到类的工作会先于+load方法的执行
 * objc2.0时代最重要的特性是成员变量(ivar)在modern runtime中是non-fragile(二进制兼容性ABI稳定性).
 * 所谓“二进制兼容性”指的就是在升级（也可能是 bug fix）库文件的时候，不必重新编译，直接使用这个库的可执行文件或使用这个库的其他库文件，程序的功能不被破坏。我的理解是：我们平时做开发,要引入许多系统提供的库,比如UIKit,Foundation之类的,这些库并不会集成在我们打包的app中,而是在iOS的系统中以动态库的形式存在,如果用户升级了iOS系统并且苹果在新系统中给类增加了新的成员变量,那么在开发者用新的SDK给app更新之前手机上所有的应用都会出问题
 
 * 所有的OC类和对象，在runtime层都是用struct表示的，category也不例外，在runtime层，category用结构体category_t（在objc-runtime-new.h中可以找到此定义），它包含了
 1)、类的名字（name）
 2)、类（cls）
 3)、category中所有给类添加的实例方法的列表（instanceMethods）
 4)、category中所有添加的类方法的列表（classMethods）
 5)、category实现的所有协议的列表（protocols）
 6)、category中添加的所有属性（instanceProperties）
 typedef struct category_t {
    const char *name;
    classref_t cls;
    struct method_list_t *instanceMethods;
    struct method_list_t *classMethods;
    struct protocol_list_t *protocols;
    struct property_list_t *instanceProperties;
 } category_t;
 * 从category的定义也可以看出category的可为（可以添加实例方法，类方法，甚至可以实现协议，添加属性）和不可为（无法添加实例变量）。
 1)、把category的实例方法、协议以及属性添加到类上
 2)、把category的类方法和协议添加到类的metaclass上
*/

@property (nonatomic, copy) NSString *attribute4;

- (void)method1;

@end
