//
//  HomeViewController.m
//  InterviewDemo
//
//  Created by 王伟虎 on 2017/9/6.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import "HomeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "HomeHeaderView.h"

#define kDegreeToRaius(x) ((x) * M_PI / 180.0f)

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource>

/*
    @property属性的本质
    自动生成下划线变量名的成员变量
    自动生成成员变量存取方法
    类别、匿名类扩展、协议区别
 */
@property (nonatomic, strong) NSMutableArray *sourceArray;


@property (nonatomic, strong) CABasicAnimation    *basicA;
@property (nonatomic, strong) CAKeyframeAnimation *keyA;
@property (nonatomic, strong) CAAnimationGroup    *groupA;
@property (nonatomic, strong) CATransition        *transitionA;
@property (nonatomic, strong) CALayer             *layer;

@property (nonatomic, strong) NSString            *target;

@end

@implementation HomeViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

/*
    控制器的生命周期
    - (void)viewWillAppear:(BOOL)animated
    - (void)viewDidAppear:(BOOL)animated
    - (void)viewWillDisappear:(BOOL)animated
    - (void)viewDidDisappear:(BOOL)animated
    - (void)viewDidLoad
    - (void)viewWillUnload(废弃)
    - (void)viewDidUnload(废弃)
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /*
     在父类.m里面声明的变量子类是无法访问的(即使给他@public),也会被认为是@private
     所以我们的对外属性都会放到.h去声明,然而由于age变量是@private,所以子类还是无法访问的
     */
    
    // 多线程并行运行崩溃问题 真正的原因是：for循环已经走完了，代码块内的局部变量i已经注销了，而异步运行的字符串format那里仍然在调用i，所以崩溃。解决方法是队列串行DISPATCH_QUEUE_SERIAL、加锁等行为阻止崩溃的产生。
    dispatch_queue_t queue = dispatch_queue_create("parallel", DISPATCH_QUEUE_CONCURRENT);
    for (int i = 0; i < 1000000 ; i++) {
        dispatch_async(queue, ^{
            @synchronized (self) {
                self.target = [NSString stringWithFormat:@"ksddkjalkjd%d",i];
                NSLog(@"%d",i);
            }
//            self.target = [NSString stringWithFormat:@"ksddkjalkjd%d",i];
//            NSLog(@"%d",i);
        });
    }
//    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
//    tableView.dataSource = self;
//    tableView.delegate = self;
//    [self.view addSubview:tableView];
//    
//    HomeHeaderView *headerView = [[HomeHeaderView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100)];
//    tableView.tableHeaderView = headerView;
    
//    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(subThreadTest) object:nil];
//    [thread start];
    
//    CALayer *layer = [CALayer layer];
//    layer.frame = CGRectMake(100, 100, 100, 100);
//    layer.backgroundColor = [UIColor yellowColor].CGColor;
//    self.layer = layer;
//    [self.view.layer addSublayer:self.layer];
    
    /*
     transform.scale         比例转化    @(0.8)
     transform.scale.x       宽的比例    @(0.8)
     transform.scale.y       高的比例    @(0.8)
     transform.rotation.x    围绕x轴旋转    @(M_PI)
     transform.rotation.y    围绕y轴旋转    @(M_PI)
     transform.rotation.z    围绕z轴旋转    @(M_PI)
     cornerRadius            圆角的设置     @(50)
     opacity                 透明度        @(0.7)
     contentsRect.size.width    横向拉伸缩放    @(0.4)最好是0~1之间的
     backgroundColor         背景颜色的变化    (id)[UIColor purpleColor].CGColor
     bounds      大小，中心不变    [NSValue valueWithCGRect:CGRectMake(0, 0, 200, 200)];
     position    位置(中心点的改变)    [NSValue valueWithCGPoint:CGPointMake(300, 300)];
     contents    内容，比如UIImageView的图片    imageAnima.toValue = (id)[UIImage imageNamed:@"to"].CGImage;
     */
//    CABasicAnimation *basicA = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    basicA.fromValue = [NSNumber numberWithFloat:1.0];
//    basicA.toValue   = [NSNumber numberWithFloat:0.1];
//    
//    basicA.removedOnCompletion = NO;
//    basicA.fillMode = kCAFillModeForwards;
//    basicA.duration = 2;
//    
//    CABasicAnimation *basicA1 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    basicA1.fromValue = [NSNumber numberWithFloat:0.1];
//    basicA1.toValue   = [NSNumber numberWithFloat:2.0];
//    
//    basicA1.removedOnCompletion = NO;
//    basicA1.fillMode = kCAFillModeForwards;
//    basicA1.duration = 2;
//    
//    CAAnimationGroup *groupA = [CAAnimationGroup animation];
//    groupA.duration = 4;
//    groupA.animations = @[basicA, basicA1];
//    groupA.removedOnCompletion = NO;
//    groupA.fillMode = kCAFillModeForwards;
//    self.groupA = groupA;
//    
//    CATransition *transitionA = [CATransition animation];
//    transitionA.duration = 1;
//    transitionA.type = kCATransitionMoveIn;
//    transitionA.subtype = kCATransitionFromLeft;
//    transitionA.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.3 :0.3 :0.7 :0.7];
//    self.transitionA = transitionA;
//    
//    [layer addAnimation:groupA forKey:nil];
}

//抖动
- (void)iconDance {
    CAKeyframeAnimation *keyA = [CAKeyframeAnimation animation];
    keyA.keyPath = @"transform.rotation";
    keyA.values = @[@kDegreeToRaius(5), @kDegreeToRaius(-5), @kDegreeToRaius(5)];
    keyA.repeatCount = MAXFLOAT;
    self.keyA = keyA;
    [_layer addAnimation:_keyA forKey:@"key"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose(清除) of any resources that can be recreated.
}

- (void)subThreadTest {
    [self performSelector:@selector(afterDelayTest) withObject:nil afterDelay:0.25];
}

- (void)afterDelayTest {
    NSLog(@"%@", [NSThread currentThread]);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = @"111111";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.text = @"222222";
        
        // 跟新数据
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    }
}

/*
 一般性问题
 ①最近这两天你有学到什么知识/技能么？
 CAShapeLayer UIBezierPath CATansaction结合应用做一些有趣的动画
 AVURLAsset AVPlayer AVPlayerLayer 自定义音视频播放界面
 ②最近有做过比较酷或者比较有挑战的项目么？
 公司海外版应用全新的架构、全新的模式
 ③最近看过的书/文章有哪些？
 ④如何向一个只接触过互联网的孩子解释「电视」？
 ⑤为什么要学习编程，编程对你而言的乐趣在哪儿？
 ⑥如果一个函数10次中有7次正确，3次错误，问题可能出现在哪里？
 ⑦自身最大优点是什么，怎么证明？
 ⑧有没有在GitHub上发布过开源代码，参与过开源项目？
 ⑨你最近遇到过的一个技术挑战是什么？怎么解决的？
 ⑩开发常用的工具有哪些？
 
 ①熟悉CocoaPods么？能大概讲一下工作原理么？
 ②最常用的版本控制工具是什么，能大概讲讲原理么？
 Git
 ③今年你最想掌握的一门技术是什么？为什么？目前已经做到了哪个程度？
 React Native简单应用
 ④你一般是怎么用Instruments的？
 ⑤你一般是如何调试Bug的？
 ⑥你在你的项目中用到了哪些设计模式？
 ⑦如何实现单例，单例会有什么弊端？
 ⑧iOS是如何管理内存的？
 之前：OC内存管理遵循“谁创建，谁释放，谁引用，谁管理”的机制，当创建或引用一个对象的时候，需要向她发送alloc、copy、retain消息，当释放该对象时需要发送release消息，当对象引用计数为0时，系统将释放该对象，这是OC的手动管理机制（MRC）。
 目前：iOS 5.0之后引用自动管理机制——自动引用计数（ARC），管理机制与手动机制一样，只是不再需要调用retain、release、autorelease；它编译时的特性，当你使用ARC时，在适当位置插入release和autorelease；它引用strong和weak关键字，strong修饰的指针变量指向对象时，当指针指向新值或者指针不复存在，相关联的对象就会自动释放，而weak修饰的指针变量指向对象，当对象的拥有者指向新值或者不存在时weak修饰的指针会自动置为nil。
 如果使用alloc、copy(mutableCopy)或者retian一个对象时,你就有义务,向它发送一条release或者autorelease消息。其他方法创建的对象,不需要由你来管理内存。
 向一个对象发送一条autorelease消息,这个对象并不会立即销毁, 而是将这个对象放入了自动释放池,待池子释放时,它会向池中每一个对象发送 一条release消息,以此来释放对象.
 向一个对象发送release消息,并不意味着这个对象被销毁了,而是当这个对象的引用计数为0时,系统才会调用dealloc方法,释放该对象和对象本身它所拥有的实例。
 
 知识性问题
 ①什么是响应链，它是怎么工作的？
 ②如何访问并修改一个类的私有属性？
 KVC
 ③KVO在不使用要删除监听，否则会报一下错误
 An instance 0x60000000ed50 of class Person was deallocated while key value observers were still registered with it. Current observation info: <NSKeyValueObservationInfo 0x60000003fd00> (
 <NSKeyValueObservance 0x600000244b90: Observer: 0x7fb82150b2d0, Key path: name, Options: <New: YES, Old: YES, Prior: NO> Context: 0x0, Property: 0x600000244cb0>
 )'
 - (void)dealloc {
    // 如果这里不写取消观察者的话程序会崩溃，崩溃理由如上所示：
    [self.p removeObserver:self forKeyPath:@"name"];
 }
 ④iOS Extension是什么？能列举几个常用的Extension么？
 ⑤如何把一个包含自定义对象的数组序列化到磁盘？
 ⑥Apple Pay是什么？它的大概工作流程是怎样的？
 ⑦iOS的沙盒目录结构是怎样的？AppBundle里面都有什么？
 ⑧iOS的签名机制大概是怎样的？
 ⑨iOS7的多任务添加了哪两个新的API? 各自的使用场景是什么？
 ⑩Objective-C的class是如何实现的？Selector是如何被转化为C语言的函数调用的？
 ①UIScrollView大概是如何实现的，它是如何捕捉、响应手势的？
 ②Objective-C如何对已有的方法，添加自己的功能代码以实现类似记录日志这样的功能？
 ③+load 和 +initialize 的区别是什么？
 ④如何让Category支持属性？
 ⑤NSOperation相比于GCD有哪些优势？
 ⑥strong/weak/unsafe_unretained的区别？
 ⑦如何为Class定义一个对外只读对内可读写的属性?
 ⑧Objective-C中，meta-class指的是什么？
 类对象、对象
 类对象isa指针指向meta-class类
 对象isa指针指向类对象
 ⑨UIView和CALayer之间的关系？
 + [UIView animateWithDuration:animations:completion:] 内部大概是如何实现的？
 什么时候会发生「隐式动画」？
 frame 和 bounds 的区别是什么？
 http://blog.csdn.net/u013282174/article/details/50215605
 在CALayer内部，它控制着两个属性：presentationLayer(以下称为P)和modelLayer（以下称为M）。P只负责显示，M只负责数据的存储和获取。我们对layer的各种属性赋值比如frame，实际上是直接对M的属性赋值，而P将在每一次屏幕刷新的时候回到M的状态。比如此时M的状态是1，P的状态也是1，然后我们把M的状态改为2，那么此时P还没有过去，也就是我们看到的状态P还是1，在下一次屏幕刷新的时候P才变为2。而我们几乎感知不到两次屏幕刷新之间的间隙，所以感觉就是我们一对M赋值，P就过去了。P就像是瞎子，M就像是瘸子，瞎子背着瘸子，瞎子每走一步（也就是每次屏幕刷新的时候）都要去问瘸子应该怎样走（这里的走路就是绘制内容到屏幕上），瘸子没法走，只能指挥瞎子背着自己走。可以简单的理解为：一般情况下，任意时刻P都会回到M的状态。而当一个CAAnimation（以下称为A）加到了layer上面后，A就把M从P身上挤下去了。现在P背着的是A，P同样在每次屏幕刷新的时候去问他背着的那个家伙，A就指挥它从fromValue到toValue来改变值。而动画结束后，A会自动被移除，这时P没有了指挥，就只能大喊“M你在哪”，M说我还在原地没动呢，于是P就顺声回到M的位置了。这就是为什么动画结束后我们看到这个视图又回到了原来的位置，是因为我们看到在移动的是P，而指挥它移动的是A，M永远停在原来的位置没有动，动画结束后A被移除，P就回到了M的怀里。
 
 动画结束后，P会回到M的状态（当然这是有前提的，因为动画已经被移除了，我们可以设置fillMode来继续影响P），但是这通常都不是我们动画想要的效果。我们通常想要的是，动画结束后，视图就停在结束的地方，并且此时我去访问该视图的属性（也就是M的属性），也应该就是当前看到的那个样子。按照官方文档的描述，我们的CAAnimation动画都可以通过设置modelLayer到动画结束的状态来实现P和M的同步。
 ⑩如何处理异步的网络请求？
 如何把一张大图缩小为1/4大小的缩略图？
 一个App会处于哪些状态？
 大致上处于三个状态
 active状态
 inactive转态
 background状态
 Push Notification是如何工作的？
 什么是Runloop？
 Toll-Free Bridging 是什么？什么情况下会使用？
 桥接 CF F框架之间的转换
 当系统出现内存警告时会发生什么？
 什么是Protocol，Delegate一般是怎么用的？
 @class xxxClass
 @protocal xxxClassDelegate
 @optional
 - (void)xxxClassMethods1;
 @required
 - (void)xxxClassMethods2;
 @end
 @interface xxxClass:NSObject
 @property (nonatomic, weak)id<xxxClassDelegate>delegate;
 @end
 autorelease对象在什么情况下会被释放？
 UIWebView有哪些性能问题？有没有可替代的方案。
 为什么NotificationCenter要removeObserver? 如何实现自动remove?
 当UITableView的Cell改变时，如何让这些改变以动画的形式呈现？
 {
    1.数据源改变：- (void)reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
    2.样式布局改变UIView 分类UIViewAnimationWithBlocks中的方法实现
 }
 什么是Method Swizzle，什么情况下会使用？
 Runtime机制下的语法糖
 直译就是交换两个方法的实现，在系统类某方法实现的基础上，需要加上特定功能，安全性检查等
 最好就是在load类方法里面实现这一功能
 
 
 经验类问题
 ①为什么UIScrollView的滚动会导致NSTimer失效？
 Runloop只能在一种模式下运行，模式切换
 NSDefaultRunLoopMode/NSRunLoopCommonModes/NSTrackingRunLoopMode(未公开)
 ②为什么当Core Animation完成时，layer又会恢复到原先的状态？
 涉及到隐式动画CALayer的presentationLayer与modelLayer
 presentationLayer负责进行绘制
 modelLayer负责数据存储(frame/center/position等)
 当发生隐式动画之后如何对presentationLayer于modelLayer进行同步
 设置动画的fillMode/removedOnCompletion可以欺骗用户
 ③你会如何存储用户的一些敏感信息，如登录的token。
 加密MD5 SHA-1等等
 ④有用过一些开源组件吧，能简单说几个么，大概说说它们的使用场景实现。
 AFNetWorking SDWebImage MBProgressHUD Masonry JSONModel
 ⑤什么时候会发生EXC BAD ACCESS异常？
 坏内存警告异常
 ⑥什么时候会使用CoreGraphics，有什么注意事项么？
 位图绘制
 ⑦NSNotification和KVO的使用场景？
 ⑧使用Block时需要注意哪些问题？
 循环引用
 不在持有对象引起的野指针错误
 ⑨performSelector:withObject:afterDelay: 内部大概是怎么实现的，有什么注意事项么？
 创建一个定时器,时间结束后系统会使用runtime通过方法名称(Selector本质就是方法名称)去方法列表中找到对应
 的方法实现并调用方法
 注意事项:
 1.调用performSelector:withObject:afterDelay:方法时,先判断希望调用的方法是否存在respondsToSelector:
 2.这个方法是异步方法,必须在主线程调用,否则在子线程调用永远不会调用到想调用的方法
 原因:
 1.performSelector如果不使用延时,程序会在子线程上直接调用该方法，方法会被调用
 2.如果使用延时,在子线程中方法不会被调用，因为该方法等待定时器去调用，而该子线程中没有定时器，所以不会调用
 3.解决2的方法就是使用dispatch_after里面会有一个定时器，来调用方法

 ⑩如何播放GIF图片，有什么优化方案么？
 大致上三种吧！
 UIWebView展示、暴力拿到GIF图片二进制数据转成UIImage数组做动画
 ⑩使用NSUserDefaults时，如何处理布尔的默认值？(比如返回NO，不知道是真的NO还是没有设置过)
 有哪几种方式可以对图片进行缩放，使用CoreGraphics缩放时有什么注意事项？
 ⑩哪些途径可以让ViewController瘦下来？
 设计模式
 MVVM Model View ViewModel
 ⑩有哪些常见的Crash场景？
 数组越界、操作不存在的指针、访问未实现的方法、tableView正在滚动的时候，如果reloadData，偶尔发生crash的情况(RIGHT WAY:
 Principle:Always change dataSource in MAIN thread and call the reloadData immediately after it.
 Option 1: If the operation to change the dataSource should be executed in background, the operation can create a temp dataSource array and pass it to main thread with notification, the main thread observes the notification,  assign the tmpDataSource to dataSource and reload the tableView by reloadData.
 Option 2: In the background, call the GDC dispatch_async to send the two methods to main thread together.
 dispatch_async(dispatch_get_main_queue(), ^{
    self.dataSourceArray= a new Array.
    [self.tableView reloadData];
 });)、
 ⑩Can we use one tableview with two different datasources? How you will achieve this?
 答案是肯定的，tableview分组展示，每个分组对应一个数据源，不同的数据源分别来自不同的网络请求，这就势必涉及到tableview执行reloadData方法的时机：
 1.无论哪个分组对应的网络请求数据返回了就执行刷新
 2.等所有的数据都返回了再刷新
 这里只说第二种情况，假设我们的tableview分三组展示，每个分组的数据源对应一个请求。这三个请求就叫a，b，c好了，子线程中等a，b，c三个数据均返回了在刷新列表
 我们这样做：
 dispatch_queue_t groupQueue = dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
 dispatch_group_t group = dispatch_group_create();
 dispatch_group_async(group, groupQueue, ^{
    //a请求
 });
 dispatch_group_async(group, groupQueue, ^{
    //b请求
 });
 dispatch_group_async(group, groupQueue, ^{
    //c请求
 });
 dispatch_group_notify(group, groupQueue, ^{
    //执行刷新操作
 });
 还可以这样做
 dispatch_queue_t groupQueue = dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
 dispatch_group_t group = dispatch_group_create();
 dispatch_group_enter(group);
 dispatch_group_enter(group);
 dispatch_group_enter(group);
 
 dispatch_async(groupQueue, ^{
    /a请求结束之后
    dispatch_group_leave(group);
 });
 dispatch_async(groupQueue, ^{
    //b请求结束之后
    dispatch_group_leave(group);
 });
 dispatch_async(groupQueue, ^{
    //c请求结束之后
    dispatch_group_leave(group);
 });
 dispatch_group_notify(group, groupQueue, ^{
    //执行刷新操作
 });
 还可以利用信号量、dispatch_barrier_async()函数来完成
 
 综合类问题
 设计一个可以无限滚动并且支持自动滚动的SlideShow。
 UICollectionView/UIScrollView与UIPageControl、NSTimer
 设计一个进度条。
 CAShapeLayer UIBezierPath 结合起来
 设计一套大文件（如上百M的视频）下载方案。
 断点下载吗？
 如果让你来实现dispatch_once，你会怎么做？
 设计一个类似iOS主屏可以下拉出现Spotlight的系统。(对UIScrollView的理解程度)
 */
@end
