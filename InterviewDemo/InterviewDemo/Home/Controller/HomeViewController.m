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

@interface Dog : NSObject
{
    NSString *toSetName;
    NSString *isName;
    //    NSInteger name;
    NSString *_name;
    NSString *_isName;
}
@property (nonatomic, assign) NSInteger age;

@end

@implementation Dog


//-(void)setName:(NSString*)name{
// toSetName = name;
//}
//-(NSString*)getName{
//    return toSetName;
//}

/*
 eg:
 Dog *dog = [[Dog alloc] init];
 [dog setValue:@"newName" forKey:@"name"];
 当调用setValue:属性值 forKey:@"name"的代码时，底层的执行机制如下:
 
 大致流程:
 + accessInstanceVariablesDirectly方法返回YES时
 set<Key>:方法-->_<key>成员变量-->_is<Key>成员变量--><key>成员变量-->is<Key>成员变量-->setValue:forUNdefinedKey:方法-->异常
 + accessInstanceVariablesDirectly方法返回NO时
 set<Key>:方法-->setValue:forUNdefinedKey:方法-->异常
 
 Step1.程序优先调用setName:方法，代码通过setter方法完成设置。注意，这里的<key>是指成员变量名，首字母大写要符合KVC的全名规则，下同
 Step2.如果没有找到setName:方法，KVC机制会检查+ (BOOL)accessInstanceVariablesDirectly方法有没有返回YES，默认该方法会返回YES，如果你重写了该方法让其返回NO的话，那么在这一步KVC会执行setValue：forUNdefinedKey：方法，不过一般开发者不会这么做。所以KVC机制会搜索该类里面有没有名为_<key>的成员变量，无论该变量是在类接口部分定义，还是在类实现部分定义，也无论用了什么样的访问修饰符，只在存在以_<key>命名的变量，KVC都可以对该成员变量赋值。
 Step3.如果该类即没有set<Key>：方法，也没有_<key>成员变量，KVC机制会搜索_is<Key>的成员变量，
 Step4.和上面一样，如果该类即没有set<Key>：方法，也没有_<key>和_is<Key>成员变量，KVC机制再会继续搜索<key>和is<Key>的成员变量。再给它们赋值。
 Step5.如果上面列出的方法或者成员变量都不存在，系统将会执行该对象的setValue:forUNdefinedKey:方法，默认是抛出异常。
 Step6.如果开发者想让这个类禁用KVC里，那么重写+ (BOOL)accessInstanceVariablesDirectly方法让其返回NO即可，这样的话如果KVC没有找到set<Key>:属性名时，会直接用setValue:forUNdefinedKey:方法
 
 eg:
 Dog *dog = [[Dog alloc] init];
 [dog valueForKey:@"name"];
 
 大致流程:
 get<Key>:方法--><key>方法-->is<Key>方法-->countOf<Key>方法-->objectIn<Key>AtIndex方法--><Key>AtIndex方法-->
 + accessInstanceVariablesDirectly方法返回YES时
 与先前的设值一样，会按_<key>,_is<Key>,<key>,is<Key>的顺序搜索成员变量名
 + accessInstanceVariablesDirectly方法返回NO时
 valueForUndefinedKey:方法-->异常
 
 Step1.首先按get<Key>,<key>,is<Key>的顺序方法查找getter方法，找到的话会直接调用。如果是BOOL或者int等值类型， 会做NSNumber转换
 Step2.如果上面的getter没有找到，KVC则会查找countOf<Key>,objectIn<Key>AtIndex,<Key>AtIndex格式的方法。如果countOf<Key>和另外两个方法中的一个被找到，那么就会返回一个可以响应NSArray所的方法的代理集合(它是NSKeyValueArray，是NSArray的子类)，调用这个代理集合的方法，或者说给这个代理集合发送NSArray的方法，就会以countOf<Key>,objectIn<Key>AtIndex,<Key>AtIndex这几个方法组合的形式调用。还有一个可选的get<Ket>:range:方法。所以你想重新定义KVC的一些功能，你可以添加这些方法，需要注意的是你的方法名要符合KVC的标准命名方法，包括方法签名。
 Step3.如果上面的方法没有找到，那么会查找countOf<Key>，enumeratorOf<Key>,memberOf<Key>格式的方法。如果这三个方法都找到，那么就返回一个可以响应NSSet所的方法的代理集合，发送给这个代理集合消息方法，就会以countOf<Key>，enumeratorOf<Key>,memberOf<Key>组合的形式调用。
 Step4.如果还没有找到，再检查类方法+ (BOOL)accessInstanceVariablesDirectly,如果返回YES(默认行为)，那么和先前的设值一样，会按_<key>,_is<Key>,<key>,is<Key>的顺序搜索成员变量名，这里不推荐这么做，因为这样直接访问实例变量破坏了封装性，使代码更脆弱。如果重写了类方法+ (BOOL)accessInstanceVariablesDirectly返回NO的话，那么会直接调用valueForUndefinedKey:
 Step5.还没有找到的话，调用valueForUndefinedKey:
 */


//默认该方法会返回YES
//+ (BOOL)accessInstanceVariablesDirectly {
//    return YES;
//}
//
//- (id)valueForUndefinedKey:(NSString *)key{
//    NSLog(@"出现异常，该key不存在%@:",key);
//    return nil;
//}
//
//- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
//    NSLog(@"出现异常，该key不存在%@:",key);
//}

-(void)setNilValueForKey:(NSString *)key{
    NSLog(@"不能将%@设成nil",key);
}

@end

typedef struct {
    char *name;
    int age;
}Student;

#define kDegreeToRaius(x) ((x) * M_PI / 180.0f)

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource>


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
        self.title = @"佳缘";
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 结构体返回null  自定义类、系统类没问题
    Class student = NSClassFromString(@"Student");
    NSLog(@"%@", student);
    
    
    /*
     在父类.m里面声明的变量子类是无法访问的(即使给他@public),也会被认为是@private
     所以我们的对外属性都会放到.h去声明,然而由于age变量是@private,所以子类还是无法访问的
     */
    
    // 多线程并行运行崩溃问题 真正的原因是：for循环已经走完了，代码块内的局部变量i已经注销了，而异步运行的字符串format那里仍然在调用i，所以崩溃。解决方法是队列串行DISPATCH_QUEUE_SERIAL、加锁等行为阻止崩溃的产生。
//    dispatch_queue_t queue = dispatch_queue_create("parallel", DISPATCH_QUEUE_CONCURRENT);
//    for (int i = 0; i < 1000000 ; i++) {
//        dispatch_async(queue, ^{
//            @synchronized (self) {
//                self.target = [NSString stringWithFormat:@"ksddkjalkjd%d",i];
//                NSLog(@"%d",i);
//            }
////            self.target = [NSString stringWithFormat:@"ksddkjalkjd%d",i];
////            NSLog(@"%d",i);
//        });
//    }
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

@end
