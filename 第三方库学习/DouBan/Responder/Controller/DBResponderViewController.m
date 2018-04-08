//
//  DBResponderViewController.m
//  DouBan
//
//  Created by 王伟虎 on 2018/4/8.
//  Copyright © 2018年 wwh. All rights reserved.
//

/*
 发生触摸事件后，系统会将该事件加入到一个由UIApplication管理的事件队列中,为什么是队列而不是栈？
 因为队列的特点是FIFO，即先进先出，先产生的事件先处理才符合常理，所以把事件添加到队列。
 UIApplication会从事件队列中取出最前面的事件，并将事件分发下去以便处理，通常，先发送事件给应用程序的主窗口（keyWindow）。
 主窗口会在视图层次结构中找到一个最合适的视图来处理触摸事件，这也是整个事件处理过程的第一步。
 找到合适的视图控件后，就会调用视图控件的touches方法来作具体的事件处理
 UIApplication->keyWindow->lookup View->touches系列方法
 
 应用如何找到最合适的控件来处理事件？
 1.首先判断主窗口（keyWindow）自己是否能接受触摸事件
 2.判断触摸点是否在自己身上
 3.子控件数组中从后往前遍历子控件，重复前面的两个步骤（所谓从后往前遍历子控件，就是首先查找子控件数组中最后一个元素，然后执行1、2步骤）
 4.view，比如叫做fitView，那么会把这个事件交给这个fitView，再遍历这个fitView的子控件，直至没有更合适的view为止。
 5.如果没有符合条件的子控件，那么就认为自己最合适处理这个事件，也就是自己是最合适的view
 */

#import "DBResponderViewController.h"
#import "DBViewOne.h"
#import "DBViewTwo.h"
#import "DBViewThree.h"

@interface DBResponderViewController ()

@end

@implementation DBResponderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    DBViewOne *one = [DBViewOne new];
    one.backgroundColor = [UIColor redColor];
    one.frame = CGRectMake(10, 40, self.view.bounds.size.width - 20, self.view.bounds.size.height - 80);
    [self.view addSubview:one];
    
    DBViewTwo *two = [DBViewTwo new];
    two.userInteractionEnabled = NO;
    two.backgroundColor = [UIColor blueColor];
    two.frame = CGRectMake(30, 80, 200, 200);
    [one addSubview:two];
    
    DBViewThree *three = [DBViewThree new];
    three.backgroundColor = [UIColor orangeColor];
    three.frame = CGRectMake(50, 120, 100, 50);
    [self.view addSubview:three];
}

@end
