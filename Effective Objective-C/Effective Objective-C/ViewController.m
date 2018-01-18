//
//  ViewController.m
//  Effective Objective-C
//
//  Created by 王伟虎 on 2018/1/11.
//  Copyright © 2018年 wwh. All rights reserved.
//

#import "ViewController.h"
#import "CategoryDemo.h"
#import "CategoryDemo+attribute.h"
#import "CategoryDemo+attribute1.h"
#import <objc/runtime.h>
#include "DataType.h"
#import "Enumerating.h"
#import "WWHCache.h"
#import "Dog.h"
#import "Person.h"
#import <objc/runtime.h>

@interface ViewController ()
/*
 无论父类是在@interface还是@implementation声明的成员变量子类都能拥有；
 但是子类能不能直接通过变量名来访问父类中定义的成员变量是需要看父类中定义的成员变量是由什么修饰符来修饰的。
 @public:在任何地方都能直接访问对象的成员变量
 @private:只能在当前类的对象方法中直接访问,如果子类要访问需要调用父类的get/set方法
 @protected:可以在当前类及其子类对象方法中直接访问(系统默认下是用它来修饰的)
 @package:在同一个包下就可以直接访问，比如说在同一个框架
 */
{
@private
    NSInteger _age;
@public
    NSInteger _id;
@protected
    NSInteger _class;
    @package
    NSInteger _height;
}
@property (nonatomic, strong) NSCache *cache;
@property (nonatomic, strong) WWHCache *wwhCache;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, assign, getter=isOn) BOOL on;
- (NSString *)fullName;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSCache *cache = [[NSCache alloc] init];
    cache.name = @"com.wangweihu.cache";
    cache.countLimit = 5;
    cache.totalCostLimit = 5 * 1024 *1024;
    self.cache = cache;
    
    WWHCache *wwhCache = [WWHCache new];
    cache.delegate = wwhCache;
    self.wwhCache = wwhCache;

    for (NSInteger i = 0; i < 10; i++) {
        [cache setObject:[NSString stringWithFormat:@"JiaYuan_%ld", (long)i] forKey:[NSString stringWithFormat:@"wwh_%ld", (long)i]];
    }
    
    
    for (NSInteger i = 0; i < 10; i++) {
        NSLog(@"Value class = %@", [[cache objectForKey:[NSString stringWithFormat:@"wwh_%ld", (long)i]] class]);
    }
}

// 按位掩码枚举测试
- (void)EnumeratingTest {
    Enumerating *obj = [Enumerating new];
    obj.roundedMakType = WWHAutoRoundedMakTypeLT | WWHAutoRoundedMakTypeLB;
    obj.connectStateType = WWHNetConnectStateTypeWIFI;
}

// 指针间接修改实参的值测试
- (void)pointerTest {
    int a = 10;
    testPointerNoParameter();
    testPointer(&a);
    NSLog(@"A value equal to %d", a);
}

// 分类覆盖原有类的方法测试
- (void)coverMethodTest {
    CategoryDemo *categoryDemo = [[CategoryDemo alloc] init];
    [categoryDemo method1]; // 打印结果：CategoryDemo+attribute
    
    // 如何调用被分类覆盖了的原类已有的方法？？？
    unsigned int methodCount = 0;
    SEL lastSel = NULL;
    IMP lastImp = NULL;
    Method *methods = class_copyMethodList([CategoryDemo class], &methodCount);
    for (int i = 0; i < methodCount; i++) {
        Method method = methods[i];
        const char *name = sel_getName(method_getName(method));
        NSString *methodName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        if ([@"method1" isEqualToString:methodName]) {
            lastSel = method_getName(method);
            lastImp = method_getImplementation(method);
        }
    }
    
    typedef void (*fn)(id,SEL);
    
    if (lastImp != NULL) {
        fn f = (fn)lastImp;
        f(categoryDemo,lastSel);
        // 打印结果：CategoryDemo
    }
    
    free(methods);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    // 获取成员变量 @property声明的属性 生成的成员变量带下划线_  即  _xxxxx
    unsigned int ivarCount = 0;
    Ivar *ivars = class_copyIvarList([CategoryDemo class], &ivarCount);
    
    for (int i = 0; i < ivarCount; i++) {
        Ivar ivar = ivars[i];
        NSLog(@"第%d个成员变量：%s",i,ivar_getName(ivar));
    }
    free(ivars);
    
    // 获取属性
    unsigned int propertyCount = 0;
    objc_property_t *propertyList = class_copyPropertyList([CategoryDemo class], &propertyCount);
    for (int i = 0; i < propertyCount; i++) {
        objc_property_t property = propertyList[i];
        NSLog(@"第%d个属性：%s",i,property_getName(property));
    }
    free(propertyList);
    
    // 获取方法列表
    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList([CategoryDemo class], &methodCount);
    for (int i = 0; i < methodCount; i++) {
        Method method = methods[i];
        NSLog(@"第%d个方法：%s",i, sel_getName(method_getName(method)));
    }
    
    CategoryDemo *demo = [[CategoryDemo alloc] init];
    demo.attribute4 = @"wangweihu";
    
    NSLog(@"%@", demo.attribute4);
}

void TestClass() {
    NSLog(@"123");
}

- (void)viewDidLoad2 {
    [super viewDidLoad];
    
    __unused Person *p = [Person new];
    //    Class cls = objc_allocateClassPair([NSObject class], "Animal", 0);
    //
    //    class_addMethod(cls, @selector(TestClass), (IMP)TestClass, "v@:");
    //
    //    objc_registerClassPair(cls);
    
    
    //    NSLog(@"self = %@", self);
    //
    //    NSLog(@"ViewController类对象 = %p", [ViewController class]);
    //
    //    Person *person = [Person new];
    //    NSLog(@"person = %@", person);
    
    //    Person *person1 = [Person new];
    //    NSLog(@"person = %@", person1);
    
    //    id cls = [Dog class];
    
    //    void *obj = &cls;
    
    //    [(__bridge Dog *)obj eat];
    
    /*
     self
     _cmd
     super_class
     self
     person
     person1
     obj
     */
}

- (void)viewDidLoad1 {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 为NSString类型的属性声明特质时，内存管理语义如果是strong时，传递给设置方法的值很可能是一个指向NSMutableString *类型的可变字符串，在不知情的时候，有人改变了可变字符串的值，那么很可能拿到的NSString类型的字符串不是我们想要的值
    NSMutableString *nameStr = [[NSMutableString alloc] initWithString:@"wangweihu"];
    self.name = nameStr;
    [nameStr appendString:@"wushanshan"];
    NSLog(@"name = %@", self.name);
    // strong 结果为name = wangweihuwushanshan
    // copy 结果为name = wangweihu
    
    BOOL isOn = self.isOn;
    isOn = self.on;
    NSLog(@"isOn = %@", @(self.isOn));
    
    // 如何判断两个对象的等同性
    // == 操作符 比较的两个指针本身，是否指向同一个对象(内存块)
    NSString *foo = @"123";
    NSString *bar = [NSString stringWithFormat:@"%@", @"123"];
    
    BOOL isEqual = [foo isEqualToString:bar];
    NSLog(@"isEqual = %@", @(isEqual));
    
    [self test];
    
    TestMetaClass(self, @selector(viewDidLoad));
    //    [self performSelector:@selector(hello) withObject:nil];
}

- (void)test {
    Dog *dog = [[Dog alloc] init];
    
    /**
     * Returns the class definition of a specified class.
     * 获取指定类的类对象
     * param name The name of the class to look up.
     *
     * return The Class object for the named class, or \c nil
     *  if the class is not registered with the Objective-C runtime.
     *
     * @note \c objc_getClass is different from \c objc_lookUpClass in that if the class
     *  is not registered, \c objc_getClass calls the class handler callback and then checks
     *  a second time to see whether the class is registered. \c objc_lookUpClass does
     *  not call the class handler callback.
     *
     * @warning Earlier implementations of this function (prior to OS X v10.0)
     *  terminate the program if the class does not exist.
     */
    Class definition = objc_getClass("Dog");// [Dog class]是一样的
    NSLog(@"definition=%@", definition);
    
    
    /**
     * Returns the class of an object.
     * NSObject 类对象的元类
     * param obj The object you want to inspect.
     *
     * return The class object of which \e object is an instance,
     *  or \c Nil if \e object is \c nil.
     */
    Class metaClass = object_getClass(dog);
    NSLog(@"metaClass=%@", metaClass);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 在对象内部直接访问实例变量的好处就是不经过方法派发，直接到变量指向的内存块读取值
- (NSString *)fullName {
    return [NSString stringWithFormat:@"%@ %@", _firstName, _lastName];
}

void TestMetaClass(id self, SEL _cmd) {
    NSLog(@"This objcet is %p", self);
    NSLog(@"Class is %@, super class is %@", [self class], [self superclass]);
    Class currentClass = [self class];// 获取类对象即类本身
    //[self class]->ViewController
    for (int i = 0; i < 10; i++) {
        NSLog(@"Following the isa pointer %d times gives %p", i, currentClass);
        currentClass = object_getClass(currentClass);
    }
    // currentClass->ViewController
    // Following the isa pointer 0 times gives 0x10048e1f0
    
    // currentClass->UIViewController
    // Following the isa pointer 1 times gives 0x10048e220
    
    // currentClass->NSObject
    // Following the isa pointer 2 times gives 0x7fff8c8e50f0
    
    // currentClass->NSObject
    // Following the isa pointer 3 times gives 0x7fff8c8e50f0
    NSLog(@"NSObject's class is %p", [NSObject class]);
    NSLog(@"NSObject's meta class is %p", object_getClass([NSObject class]));
    
    // NSObject's class is 0x7fff8c8e5140
    
    // for循环中的输出结果也印证了NSObject元类的isa指向的是其本身。
    // NSObject's meta class is 0x7fff8c8e50f0
    
    // Conclusion
    /*
     类对象的类是元类，每一个类都有着它独有的元类(因为每一个类都可以有它自己特有的类方法)。这意味着所有的类对象本身都不是同一个类
     
     元类将始终确保类对象具有层次结构中基类的所有实例和类方法，以及中间的所有类方法。
     对于来自NSObject的子类，这意味着所有的类（和元类）对象都定义了所有的NSObject实例和协议方法
     
     所有元类本身都使用基类的元类（NSObject元类为NSObject层次结构类）作为它们的类，包括基本级元类，它是运行时中唯一的自定义类
     */
}

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

@end
