//
//  DBHomeViewController.m
//  DouBan
//
//  Created by 王伟虎 on 2017/10/2.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import "DBHomeViewController.h"
#import "DBHomeDetailViewController.h"
#import "DBWebViewController.h"
#import "DBResponderViewController.h"
#import "DBSqliteViewController.h"
#import "UINavigationController+ExchangeToTopViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AFNetworking.h"
#import "KVOController.h"
#import "Coder.h"
#import "Person.h"
#import "Student.h"
#import "Masonry.h"

/*
 第三方库中常用锁
 @synchronized关键字
 @synchronized(这里添加一个OC对象，一般使用self，必须在多个线程中都是同一对象) {
 //这里写要加锁的代码
 }
 注意点
 1.加锁的代码尽量少
 2.优点是不需要显式的创建锁对象，便可以实现锁的机制。
 3.@synchronized块会隐式的添加一个异常处理例程来保护代码，该处理例程会在异常抛出的时候自动的释放互斥锁。所以如果不想让隐式的异常处理例程带来额外的开销，你可以考虑使用锁对象。
 
 NSLock 对象锁
 NSRecursiveLock 递归锁
 NSConditionLock 条件锁
 pthread_mutex 互斥锁（C语言）
 dispatch_semaphore 信号量实现加锁（GCD）
 OSSpinLock （暂不建议使用，原因参见这里）
 
 https://www.jianshu.com/p/y5MUd2
 iOS中常用的一些线程同步手段
 YYCache里面涉及到的锁pthread_mutex(互斥锁)   dispatch_semaphore(信号量)
 SDWebImage里面涉及到的锁@synchronized关键字
 
 
 原子操作
 iOS平台下的原子操作函数都以OSAtomic开头的,在<libkern/OSAtomic.h>里面.不同线程如果通过原子操作函数对同一变量进行操作,可以保证一个线程的操作不会影响到其他线程内对此变量的操作,因为这些操作都是原子式的.因为原子操作只能对内置类型进行操作,所以原子操作能够同步的线程只能位于同一个进程的地址空间内.
 原子操作快速高效,常用的加/减/自增/自减等都有对应的API实现.主要可以应用到一些计数的同步中.
 
 
 使用GCD进行线程同步
 
 
 Objective-C中的锁
 Objective-C有一些常用的锁, 他们的接口实际上都是通过NSLocking协议定义的,它定义了lock和unlock方法.你使用这些方法来获取和释放该锁.
 常用的锁有:NSLock,NSRecursiveLock,NSCondition,NSConditionLock.
 

 Storage class specifier关键字
 包括:auto,extern,static,register,mutable,volatile,restrict以及typedef.
 对于typedef,只是说在语句构成上,typedef声明看起来象static,extern等类型的变量声明;
 对于编译器来说,多个存储类关键字不能同时用,所以typedef register int FAST_COUNTER编译通不过
 从变量的作用域角度（空间）来分，可以分为全局变量和局部变量
 从变量的存在时间角度（生存期）来分，可以分为静态存储方式和动态存储方式
 内存中供用户使用的存储空间分为三部分:程序区、静态存储区、动态存储区
 在iOS中可使用的有auto,extern,static,register,volatile,restrict,typedef
 volatile和restrict都是为了方便编译器的优化
 static指函数是内部函数，不允许外部调用
 全局变量全部存放在静态存储区中，在程序开始执行时给全局变量分配存储区，程序执行完毕就释放
 动态存储区中存放以下数据：1.函数形式参数；2.自动变量；3.函数调用时的现场保存和返回地址
 
 static NSDictionary *FillParameters(NSDictionary *parameters, NSURL *url) {
    NSLog(@"parameters=%@, url=%@",parameters, url);
    return parameters;
 }
 
 https://joeshang.github.io/2018/04/04/ios-http://t.cn/RmzQDL
 http://t.cn/RmzQDL9
 http://www.cnblogs.com/oc-bowen/p/7081146.html
 http://weslyxl.coding.me/2018/02/12/2018/2/iOS%E6%8E%A8%E9%80%81%E7%9A%84%E5%89%8D%E4%B8%96%E4%BB%8A%E7%94%9F/
 http://www.cocoachina.com/ios/20170105/18525.html
 使用DZNEmptyDataSet遇到的一个问题
 https://www.jianshu.com/p/81dd49e78358
 https://www.jianshu.com/p/594433d2b5b2
 
 引用计数问题，单步走完一个方法的调用流程，没问题，但是一旦放开断点就会crash
 https://juejin.im/post/5a3134386fb9a04500030e22
 在ARC下修改一个对象的引用计数，可以使用CoreFoundation框架的API，CFRetain和 CFRelease 函数
 
 pch 优点与缺点？
 c++编译警告的消除
 MRC/ARC处理 -fno-objc-arc
 消除Xcode CocoaPods 引入第三方库产生的编译警告
 在podfile文件中 platform之后加上inhibit-all-warings!
 
 Xcode9 自动签名更新设备列表  http://www.jianshu.com/p/af2c243c39b4
 Git 如何删除本地分支和远程分支 http://blog.csdn.net/sub_lele/article/details/52289996
 
 
 无论是哪家的聊天人列表 排序都是按照时间排序的
 
 负载均衡处理 太多的人链接统一服务器(主机)长时间socket链接 造成服务器过载 这就需要重新请求一套新的ip port，以这套 ip port来进行socket链接
 
 无论是socket获取消息列表还是http拉取下来的列表 首先是按照时间排序
 
 
 // json解析  json是非标准格式字符串  里面含有\n \r \t 等制表符
 NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
 NSError *error = nil;
 NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
 // json数据当中没有 \r\n \r \t 等制表符，当后台给出有问题时，我们需要对json数据过滤
 dataString = [dataString stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
 dataString = [dataString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
 dataString = [dataString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
 NSData *utf8Data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
 NSArray *array = [NSJSONSerialization JSONObjectWithData:utf8Data options:NSJSONReadingMutableContainers error:&error];
 
 // 面试题
 1、什么是kvo和kvc？
 2、kvo的缺陷？
 3、Swfit和Objective-C的联系，Swift比Objective-C有什么优势？
 4、举例说明Swfit里面有哪些是Objective-C中没有的？
 5、如何对iOS设备进行性能测试？
 6、使用过CocoPods吗？它是什么？CocoaPods的原理？
 7、集成三方框架有哪些方法？
 8、SDWebImage的原理实现机制，如何解决TableView卡的问题？
 9、一个动画怎么实现？
 10、iOS中常用的数据存储方式有哪些？
 11、说一说你对SQLite的认识？
 12、runloop和线程有什么关系？
 13、runloop的mode作用是什么？
 14、你一般是如何调试Bug的？
 15、描述一个ViewController的生命周期
 */

typedef void (^MyBlock)(void);

@interface DBHomeViewController ()

@property (nonatomic, copy) MyBlock myblock;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSMutableArray *books;
@property (nonatomic, strong) AVSpeechSynthesizer *synthesizer;

@end

@implementation DBHomeViewController

/*
 ObjC 对于加载的管理，主要使用了两个列表，分别是loadable_classes和loadable_categories
 load 可以说我们在日常开发中可以接触到的调用时间最靠前的方法，在主函数运行之前，load 方法就会调用。
 由于它的调用不是惰性的，且其只会在程序调用期间调用一次，最最重要的是，如果在类与分类中都实现了load方法，它们都会被调用，不像其它的在分类中实现的方法会被覆盖，这就使load方法成为了方法调剂的绝佳时机。
 注意：但是由于load方法的运行时间过早，所以这里可能不是一个理想的环境，因为某些类可能需要在在其它类之前加载，但是这是我们无法保证的。不过在这个时间点，所有的framework都已经加载到了运行时中，所以调用 framework中的方法都是安全的。
 */
//+ (void)load {
//
//}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"首页";
        self.model = [DBHomeModel new];
        self.model.name = @"wangweihu";
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        NSNumber *objc = [NSNumber numberWithInteger:10];
        NSMutableArray *array = [NSMutableArray arrayWithObjects:objc, nil];
        
//        [userDefaults setValue:[NSObject new] forKey:@"objc"];
        [userDefaults setValue:array forKey:@"objc"];
        [userDefaults synchronize];
        
        NSLog(@"%@", [userDefaults objectForKey:@"objc"]);//__NSCFArray
        
        //方法一
        NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
        [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
        //方法二
        NSDictionary *dict = [userDefaults dictionaryRepresentation];
        for (id key in dict)    {
            [userDefaults removeObjectForKey:key];
        }
        [userDefaults synchronize];
    
        NSLog(@".........");
    
//        [self.model addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
//
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(haha) name:nil object:nil];
//        [self.model addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
//        [[NSNotificationCenter defaultCenter] removeObserver:self];
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"" object:nil];
//        self.model.name = @"wangweihu";
//        [self.model setValue:@"wushanshan" forKey:@"name"];
        
//        self.secondModel = [DBHomeSecondModel new];
    }
    return self;
}

+ (void)initialize {
    // initialize方法的调用为什么是惰性的,没有显示的写明但是为什么会调用父类的initialize方法
    /*
     特点
     1.initialize的调用是惰性的，它会在第一次调用当前类的方法时被调用
     2.与load不同，initialize方法调用时，所有的类都已经加载到了内存中了
     3.initialize的运行是线程安全的
     4.子类会继承父类的initialize方法
     */
    /*
     调用栈
     0 +[DBViewController initialize]
     1 _class_initialize
     2 lookUpImpOrForward
     3 _class_lookupMethodAndLoadCache3
     4 objc_msgSend
     5 main
     6 start
     */
    if ([self class] == [DBHomeViewController class]) {
        NSLog(@"这里能干点啥");
    }
}

- (void)commonInit {
    AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc] init];
    self.synthesizer = synthesizer;
}

- (void)createVoices {
    AVSpeechSynthesisVoice *usVoice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"];
//    usVoice.quality = AVSpeechSynthesisVoiceQualityEnhanced;//只读属性
    if (@available(iOS 9.0, *)) {
        [usVoice setValue:@(AVSpeechSynthesisVoiceQualityEnhanced) forKey:@"quality"];
    } else {
        // Fallback on earlier versions
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
 
    [self commonInit];
    
    AVSpeechSynthesisVoice *usVoice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
    
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@"我就看看不说话我就看看不说话我就看看不说话我就看看不说话我就看看不说话我就看看不说话我就看看不说话我就看看不说话"];
    utterance.rate = AVSpeechUtteranceDefaultSpeechRate;
    utterance.volume = 0.6f;
    utterance.pitchMultiplier = 1;
    utterance.voice = usVoice;
    
    [self.synthesizer speakUtterance:utterance];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // pause之后可以重新开始，但是stop事后不能继续播放，只能再次调用speakUtterance:
        [self.synthesizer pauseSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.synthesizer continueSpeaking];
    });
    
    /*
     " Language: ar-SA, Name: Maged, Quality: Default [com.apple.ttsbundle.Maged-compact]",
     " Language: cs-CZ, Name: Zuzana, Quality: Default [com.apple.ttsbundle.Zuzana-compact]",
     " Language: da-DK, Name: Sara, Quality: Default [com.apple.ttsbundle.Sara-compact]",
     " Language: de-DE, Name: Anna, Quality: Default [com.apple.ttsbundle.Anna-compact]",
     " Language: el-GR, Name: Melina, Quality: Default [com.apple.ttsbundle.Melina-compact]",
     " Language: en-AU, Name: Karen, Quality: Default [com.apple.ttsbundle.Karen-compact]",
     " Language: en-GB, Name: Daniel, Quality: Default [com.apple.ttsbundle.Daniel-compact]",
     " Language: en-IE, Name: Moira, Quality: Default [com.apple.ttsbundle.Moira-compact]",
     " Language: en-US, Name: Samantha, Quality: Default [com.apple.ttsbundle.Samantha-compact]",
     " Language: en-ZA, Name: Tessa, Quality: Default [com.apple.ttsbundle.Tessa-compact]",
     " Language: es-ES, Name: Monica, Quality: Default [com.apple.ttsbundle.Monica-compact]",
     " Language: es-MX, Name: Paulina, Quality: Default [com.apple.ttsbundle.Paulina-compact]",
     " Language: fi-FI, Name: Satu, Quality: Default [com.apple.ttsbundle.Satu-compact]",
     " Language: fr-CA, Name: Amelie, Quality: Default [com.apple.ttsbundle.Amelie-compact]",
     " Language: fr-FR, Name: Thomas, Quality: Default [com.apple.ttsbundle.Thomas-compact]",
     " Language: he-IL, Name: Carmit, Quality: Default [com.apple.ttsbundle.Carmit-compact]",
     " Language: hi-IN, Name: Lekha, Quality: Default [com.apple.ttsbundle.Lekha-compact]",
     " Language: hu-HU, Name: Mariska, Quality: Default [com.apple.ttsbundle.Mariska-compact]",
     " Language: id-ID, Name: Damayanti, Quality: Default [com.apple.ttsbundle.Damayanti-compact]",
     " Language: it-IT, Name: Alice, Quality: Default [com.apple.ttsbundle.Alice-compact]",
     " Language: ja-JP, Name: Kyoko, Quality: Default [com.apple.ttsbundle.Kyoko-compact]",
     " Language: ko-KR, Name: Yuna, Quality: Default [com.apple.ttsbundle.Yuna-compact]",
     " Language: nl-BE, Name: Ellen, Quality: Default [com.apple.ttsbundle.Ellen-compact]",
     " Language: nl-NL, Name: Xander, Quality: Default [com.apple.ttsbundle.Xander-compact]",
     " Language: no-NO, Name: Nora, Quality: Default [com.apple.ttsbundle.Nora-compact]",
     " Language: pl-PL, Name: Zosia, Quality: Default [com.apple.ttsbundle.Zosia-compact]",
     " Language: pt-BR, Name: Luciana, Quality: Default [com.apple.ttsbundle.Luciana-compact]",
     " Language: pt-PT, Name: Joana, Quality: Default [com.apple.ttsbundle.Joana-compact]",
     " Language: ro-RO, Name: Ioana, Quality: Default [com.apple.ttsbundle.Ioana-compact]",
     " Language: ru-RU, Name: Milena, Quality: Default [com.apple.ttsbundle.Milena-compact]",
     " Language: sk-SK, Name: Laura, Quality: Default [com.apple.ttsbundle.Laura-compact]",
     " Language: sv-SE, Name: Alva, Quality: Default [com.apple.ttsbundle.Alva-compact]",
     " Language: th-TH, Name: Kanya, Quality: Default [com.apple.ttsbundle.Kanya-compact]",
     " Language: tr-TR, Name: Yelda, Quality: Default [com.apple.ttsbundle.Yelda-compact]",
     " Language: zh-CN, Name: Ting-Ting, Quality: Default [com.apple.ttsbundle.Ting-Ting-compact]",
     " Language: zh-HK, Name: Sin-Ji, Quality: Default [com.apple.ttsbundle.Sin-Ji-compact]",
     "Language: zh-TW, Name: Mei-Jia, Quality: Default [com.apple.ttsbundle.Mei-Jia-compact]"
     */
//    NSLog(@"%@", [AVSpeechSynthesisVoice speechVoices]);
}

- (void)sort {
    Student *stu1 = [Student studentWithFirstname:@"MingJie" lastname:@"Li"];
    Student *stu2 = [Student studentWithFirstname:@"LongHu" lastname:@"Huang"];
    Student *stu3 = [Student studentWithFirstname:@"LianJie" lastname:@"Li"];
    Student *stu4 = [Student studentWithFirstname:@"Jian" lastname:@"Xiao"];
    NSArray *array = [NSArray arrayWithObjects:stu1,stu2,stu3, stu4, nil];
    
    // 利用block进行排序
    NSArray *array2 = [array sortedArrayUsingComparator:
                       ^NSComparisonResult(Student *obj1, Student *obj2) {
                           // 先按照姓排序
                           NSComparisonResult result = [obj1.lastname compare:obj2.lastname];
                           // 如果有相同的姓，就比较名字
                           if (result == NSOrderedSame) {
                               result = [obj1.firstname compare:obj2.firstname];
                           }
                           
                           return result;
                       }];
    
    [array2 enumerateObjectsUsingBlock:^(Student *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"firstname:%@ lastname:%@", obj.firstname, obj.lastname);
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSLog(@"change = %@", change);
}

// 判断子类是否复写了父类的方法
- (void)test_inheritedAndOverrided {
    Coder *coder = [Coder new];
    SEL selector = @selector(doSomething);
    BOOL inherited = ![coder isMemberOfClass:[Person class]]; //判断对象不是由父类本身创建的
    BOOL overrided = [Coder instanceMethodForSelector:selector] == [Person instanceMethodForSelector:selector]; //判断同一个方法，子类调用的IMP跟父类调用的IMP是否一致，如果不一致则说明子类复写了父类的方法
    if (inherited && overrided) {
        NSLog(@"子类复写了父类的方法");
    }else{
        NSLog(@"子类没有复写父类的方法");
    }
    NSLog(@"inherited = %@", @(inherited));
    NSLog(@"overrided = %@", @(overrided));
}

- (void)createTheard {
    dispatch_queue_t queue = dispatch_queue_create("com.wangweihu.serialQueue", DISPATCH_QUEUE_SERIAL);
    queue = dispatch_get_main_queue();
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSLog(@"DISPATCH_QUEUE_SERIAL thread = %@", [NSThread currentThread]);
        NSLog(@"DISPATCH_QUEUE_CONCURRENT thread = %@", [NSThread currentThread]);
    });
}

// 动态方法分析
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if ([NSStringFromSelector(sel) isEqualToString:@"testMessageSendMechanism"]) {
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

- (void)UILabel_test_iOS_8_x_bug {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 0)];  //为了测试，设置高度为0
    label.backgroundColor = [UIColor blueColor];  //高度为0时背景色并不会显示,这里为了明显设置为蓝色
    label.textColor = [UIColor blackColor];
    label.text = @"测试";
    [self.view addSubview:label];
}
// 备援接受者
- (id)forwardingTargetForSelector:(SEL)aSelector {
    return nil;
//    return self.model;
}

// 完整的消息转发
// forwardingTargetForSelector 同为消息转发，但在实践层面上有什么区别？何时可以考虑把消息下放到forwardInvocation阶段转发？
// forwardingTargetForSelector 仅支持一个对象的返回，也就是说消息只能被转发给一个对象
// forwardInvocation可以将消息同时转发给任意多个对象
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if(aSelector == @selector(testMessageSendMechanism)) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return nil;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    if (anInvocation.selector == @selector(testMessageSendMechanism)) {
        [anInvocation invokeWithTarget:self.model];
        [anInvocation invokeWithTarget:self.secondModel];
    }
}

- (void)key_test {
    
    // 解决方案
    // label.clipsToBounds = YES;
    // label.hidden = YES;  //高度为0时hidden掉
    [self.KVOController observe:self keyPath:@"name" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        NSLog(@"observer = %@, object = %@, change = %@", observer, object, change);
    }];
    
    NSMutableString *mStr = [NSMutableString stringWithString:@"wushanshan"];
    self.name = mStr;
    
    NSLog(@"self.name = %@", self.name);
    
    [mStr appendString:@" love wushanshan"];
    
    NSLog(@"self.name = %@", self.name);
}

// 重写copy属性的变量的时候记得 copy操作， 这样是有必要的
- (void)setName:(NSString *)name {

//    _name = name; // 通过name外界可修改_name的值
    
    _name = [name copy];// 系统默认的操作 通过name外界不可修改_name的值
}

- (void)gcdCancel {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
     __block BOOL isCancel = NO;
    
    dispatch_async(queue, ^{
        NSLog(@"任务001 %@",[NSThread currentThread]);
        sleep(10);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"任务002 %@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"任务003 %@",[NSThread currentThread]);
         isCancel = YES;
    });
    
    dispatch_async(queue, ^{
        // 模拟：线程等待3秒，确保任务003完成 isCancel＝YES
        sleep(3);
        if(isCancel){
            NSLog(@"任务004已被取消 %@",[NSThread currentThread]);
        }else{
            NSLog(@"任务004 %@",[NSThread currentThread]);
        }
    });
}

- (void)gcdBlockCancel {
    dispatch_queue_t queue = dispatch_queue_create("com.gcdtest.www", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_block_t block1 = dispatch_block_create(0, ^{
        sleep(5);
        NSLog(@"block1 %@",[NSThread currentThread]);
    });
    
    dispatch_block_t block2 = dispatch_block_create(0, ^{
        NSLog(@"block2 %@",[NSThread currentThread]);
    });
    
    dispatch_block_t block3 = dispatch_block_create(0, ^{
        NSLog(@"block3 %@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, block1);
    dispatch_async(queue, block2);
    dispatch_block_cancel(block3);
}

- (void)viewDidLoad11111 {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self block_test];
}

- (void)block_test {
    NSObject *objc = [[NSObject alloc] init];

//    NSDictionary *dict = @{objc: @"wangweihu"};
//    NSLog(@"dict = %@", dict);
    
    
//    int aa = 10;
    self.myblock = ^{
    //        NSLog(@"aa = %d", aa);
    };

    //    [self.myblock retain];
    //    [self.myblock release];
    //    [self.myblock retain];
    //    [self.myblock retain];
    //    NSLog(@"myblock = %lu", (unsigned long)[_myblock retainCount]);
    //
    // ARC 在block不访问外界变量时，不会被copy到堆上
    NSLog(@"myblock = %@", self.myblock);

    __block int b = 10;
    void (^block)(void) = ^{
    b = 11;
    NSLog(@"b = %d", b);
    };
    NSLog(@"block == %@", block);
    // MRC block == <__NSStackBlock__: 0x7fff57eeb728>
    // ARC block == <__NSGlobalBlock__: 0x10c203610>
    block();
    //    block = [block copy];
    //    NSLog(@"[block copy] == %@", block);

//    int a = 10;
//    NSObject *objc = [[NSObject alloc] init];
    MyBlock myBlock = ^{
        NSLog(@"objc = %@", objc);
    };
    myBlock = [myBlock copy];// 对全局变量进行copy retain release没有任何变化
    NSLog(@"myBlock == %@", myBlock);
    
    // MRC myBlock == <__NSStackBlock__: 0x7fff51c476f0>
    // ARC myBlock == <__NSMallocBlock__: 0x600000246f30>

    //    myBlock = [myBlock copy];
    //    NSLog(@"[myBlock copy] == %@", myBlock);
    myBlock();

    NSLog(@"getBlockArray = %@", [self getBlockArray]);

    //    NSArray *arr = [self getBlockArray];
    //    void (^block)(void) = [arr objectAtIndex:1];
    //    block();
    //    NSLog(@"block = %@", block);
}

- (void)dispatch_queue_create_test {
    dispatch_queue_t myqueue1 =  dispatch_queue_create("myqueue.queue1",DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t myqueue2 =  dispatch_queue_create("myqueue.queue2",DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t myqueue3 =  dispatch_queue_create("myqueue.queue3",DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t myqueue4 =  dispatch_queue_create("myqueue.queue4",DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t myqueue5 =  dispatch_queue_create("myqueue.queue5",DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t myqueue6 =  dispatch_queue_create("myqueue.queue6",DISPATCH_QUEUE_SERIAL);
    
    // 将管理追加的block的C语言层实现的FIFO队列 作为dispatch_set_target_queue的第一个参数，这个函数不仅可以变更队列的优先级还可以作为队列的执行阶层
    dispatch_queue_t queue = dispatch_queue_create("com.wangweihu.serialQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_set_target_queue(myqueue1, queue);
    dispatch_set_target_queue(myqueue2, queue);
    dispatch_set_target_queue(myqueue3, queue);
    dispatch_set_target_queue(myqueue4, queue);
    dispatch_set_target_queue(myqueue5, queue);
    dispatch_set_target_queue(myqueue6, queue);
    
    dispatch_async(myqueue1, ^{
        NSLog(@"任务1");
        sleep(2);
    });
    dispatch_async(myqueue2, ^{
        NSLog(@"任务2");
        sleep(2);
    });
    dispatch_async(myqueue3, ^{
        NSLog(@"任务3");
        sleep(2);
    });
    dispatch_async(myqueue4, ^{
        NSLog(@"任务4");
        sleep(2);
    });
    dispatch_async(myqueue5, ^{
        NSLog(@"任务5");
        sleep(2);
    });
    dispatch_async(myqueue6, ^{
        NSLog(@"任务6");
    });
}

- (NSArray *)getBlockArray {
    int val = 10;
    NSArray *arr = @[^{NSLog(@"blk0:%d",val);}, ^{NSLog(@"blk1:%d",val);}, ^{NSLog(@"blk2:%d",val);}];
    return arr;
}

- (void)fetchFeedInfoWithCompletion:(void(^)(NSDictionary *feed, NSError *error))completion {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSLog(@"action 1");
        NSLog(@"线程 = %@", [NSThread currentThread]);
        sleep(3);
        completion(nil, nil);
    });
}

- (void)fetchCommentsWithCompletion:(void(^)(NSDictionary *feed, NSError *error))completion {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSLog(@"action 2");
        NSLog(@"线程 = %@", [NSThread currentThread]);
        completion(nil, nil);
    });
}

- (void)addDependency4 {
    dispatch_group_t group = dispatch_group_create();
    //请求动态信息
    dispatch_group_enter(group);
    [self fetchFeedInfoWithCompletion:^(NSDictionary *feed, NSError *error) {
        //do something with FeedInfo
        dispatch_group_leave(group);
    }];
    //请求评论信息
    dispatch_group_enter(group);
    [self fetchCommentsWithCompletion:^(NSDictionary *feed, NSError *error) {
        //do something with Comments
        dispatch_group_leave(group);
    }];
    //上面的请求都执行完毕之后在主线程刷新UI
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        //刷新UI等
        NSLog(@"主线程 = %@", [NSThread currentThread]);
    });
}

- (void)addDependency3 {
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    queue = dispatch_queue_create("com.wangweihu.customqueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_async(group, queue, ^{
        NSLog(@"action 1");
        sleep(3);
    });
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"action 2");
    });
    
    //通知主线程刷新UI或者执行其他操作
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"finish");
    });
}

- (void)addDependency2 {
    // 管理追加的block的C语言层实现的FIFO队列 myqueue 必须是自己创建的并发队列
    dispatch_queue_t myqueue =  dispatch_queue_create("myqueue.queue",DISPATCH_QUEUE_CONCURRENT);
//     myqueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(myqueue, ^{
        sleep(2);
        NSLog(@"任务1");
    });
    
    dispatch_async(myqueue, ^{
        sleep(1);
        NSLog(@"任务2");
    });
    
    dispatch_barrier_async(myqueue, ^{
        sleep(4);
    });
    
    dispatch_async(myqueue, ^{
        NSLog(@"任务4");
    });
}

- (void)addDependency1 {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSBlockOperation *blockA = [NSBlockOperation blockOperationWithBlock:^{
        sleep(2);
        NSLog(@"blockA");
    }];
    
    NSBlockOperation *blockB = [NSBlockOperation blockOperationWithBlock:^{
        sleep(3);
        NSLog(@"blockB");
    }];
    
    NSBlockOperation *blockC = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"blockC");
    }];
    
    [blockC addDependency:blockA];
    [blockC addDependency:blockB];
    
    [queue addOperation:blockA];
    [queue addOperation:blockB];
    [queue addOperation:blockC];
}

- (void)upload {
    // Do any additional setup after loading the view.
    [[AFHTTPSessionManager manager] POST:@"http://120.25.226.186:32812/upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 上传文件 在填写http请求体的时候，data采用NSDataReadingMappedIfSafe样式读取，控制内存峰值
        // 上传文件的格式 请求头 请求体
        [formData appendPartWithFileData:[NSData dataWithContentsOfFile:@"/Volumes/My Passport/小码哥拓展班/02FM/0107-FMDay1/1-项目简介.mp4" options:NSDataReadingMappedIfSafe error:nil] name:@"file" fileName:@"1-项目简介.mp4" mimeType:@"video/mp4"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"uploadProgress = %@", @(1.0f * uploadProgress.completedUnitCount/uploadProgress.totalUnitCount));
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject = %@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"");
    }];
}

- (void)_commomInit {
    if (@available(iOS 11.0, *)) {
        UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        self.navigationItem.searchController = searchController;
        
        // If this property is true (the default), the searchController’s search bar will hide as the user scrolls in the top view controller’s scroll view. If false, the search bar will remain visible and pinned underneath the navigation bar.
        self.navigationItem.hidesSearchBarWhenScrolling = NO;
    } else {
        // Fallback on earlier versions
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    /// When set to YES, the navigation bar will use a larger out-of-line title view when requested by the current navigation item. To specify when the large out-of-line title view appears, see UINavigationItem.largeTitleDisplayMode. Defaults to NO.
    if (@available(iOS 11.0, *)) {
        [self.navigationController.navigationBar setPrefersLargeTitles:true];
    } else {
        // Fallback on earlier versions
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    /// When set to YES, the navigation bar will use a larger out-of-line title view when requested by the current navigation item. To specify when the large out-of-line title view appears, see UINavigationItem.largeTitleDisplayMode. Defaults to NO.
    if (@available(iOS 11.0, *)) {
        [self.navigationController.navigationBar setPrefersLargeTitles:false];
    } else {
        // Fallback on earlier versions
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
     修饰局部变量
     保证局部变量永远只初始化一次，在程序的运行过程中永远只有一份内存，生命周期类似全局变量了，但是作用域不变。这句话怎么理解呢？还是以代码例子来讲解吧。
     */
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"cell-%ld", (long)indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DBHomeDetailViewController *deatilVC = [[DBHomeDetailViewController alloc] init];
    [self.navigationController exchangeToTopViewController:deatilVC animated:YES];
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//    NSLog(@"change = %@", change);
//}
//
//- (void)createTheard {
//    dispatch_queue_t queue = dispatch_queue_create("com.wangweihu.serialQueue", DISPATCH_QUEUE_SERIAL);
//    queue = dispatch_get_main_queue();
//    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(queue, ^{
//        NSLog(@"DISPATCH_QUEUE_SERIAL thread = %@", [NSThread currentThread]);
//        NSLog(@"DISPATCH_QUEUE_CONCURRENT thread = %@", [NSThread currentThread]);
//    });
//}
//
//// 动态方法分析
//+ (BOOL)resolveInstanceMethod:(SEL)sel {
//    if ([NSStringFromSelector(sel) isEqualToString:@"testMessageSendMechanism"]) {
//        return YES;
//    }
//    return [super resolveInstanceMethod:sel];
//}
//
//// 备援接受者
//- (id)forwardingTargetForSelector:(SEL)aSelector {
//    return nil;
//    //    return self.model;
//}

// 完整的消息转发
// forwardingTargetForSelector 同为消息转发，但在实践层面上有什么区别？何时可以考虑把消息下放到forwardInvocation阶段转发？
// forwardingTargetForSelector 仅支持一个对象的返回，也就是说消息只能被转发给一个对象
// forwardInvocation可以将消息同时转发给任意多个对象
//- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
//    if(aSelector == @selector(testMessageSendMechanism)) {
//        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
//    }
//    return nil;
//}
//
//- (void)forwardInvocation:(NSInvocation *)anInvocation {
//    if (anInvocation.selector == @selector(testMessageSendMechanism)) {
//        [anInvocation invokeWithTarget:self.model];
//        [anInvocation invokeWithTarget:self.secondModel];
//    }
//}
//
//- (void)key_test {
//
//    [self.KVOController observe:self keyPath:@"name" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
//        NSLog(@"observer = %@, object = %@, change = %@", observer, object, change);
//    }];
//
//    NSMutableString *mStr = [NSMutableString stringWithString:@"wushanshan"];
//    self.name = mStr;
//
//    NSLog(@"self.name = %@", self.name);
//
//    [mStr appendString:@" love wushanshan"];
//
//    NSLog(@"self.name = %@", self.name);
//}
//
//// 重写copy属性的变量的时候记得 copy操作， 这样是有必要的
//- (void)setName:(NSString *)name {
//
//    //    _name = name; // 通过name外界可修改_name的值
//
//    _name = [name copy];// 系统默认的操作 通过name外界不可修改_name的值
//}
//
//- (void)gcdCancel {
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    __block BOOL isCancel = NO;
//
//    dispatch_async(queue, ^{
//        NSLog(@"任务001 %@",[NSThread currentThread]);
//        sleep(10);
//    });
//
//    dispatch_async(queue, ^{
//        NSLog(@"任务002 %@",[NSThread currentThread]);
//    });
//
//    dispatch_async(queue, ^{
//        NSLog(@"任务003 %@",[NSThread currentThread]);
//        isCancel = YES;
//    });
//
//    dispatch_async(queue, ^{
//        // 模拟：线程等待3秒，确保任务003完成 isCancel＝YES
//        sleep(3);
//        if(isCancel){
//            NSLog(@"任务004已被取消 %@",[NSThread currentThread]);
//        }else{
//            NSLog(@"任务004 %@",[NSThread currentThread]);
//        }
//    });
//}
//
//- (void)gcdBlockCancel {
//    dispatch_queue_t queue = dispatch_queue_create("com.gcdtest.www", DISPATCH_QUEUE_CONCURRENT);
//
//    dispatch_block_t block1 = dispatch_block_create(0, ^{
//        sleep(5);
//        NSLog(@"block1 %@",[NSThread currentThread]);
//    });
//
//    dispatch_block_t block2 = dispatch_block_create(0, ^{
//        NSLog(@"block2 %@",[NSThread currentThread]);
//    });
//
//    dispatch_block_t block3 = dispatch_block_create(0, ^{
//        NSLog(@"block3 %@",[NSThread currentThread]);
//    });
//
//    dispatch_async(queue, block1);
//    dispatch_async(queue, block2);
//    dispatch_block_cancel(block3);
//}

- (void)masonryTest {
    __weak typeof(self) weakSelf = self; //对self进行weak化，否则造成循环引用无法释放controller
    
    UIView *tempView = [[UIView alloc] init];
    NSInteger count = 10;//设置一排view的个数
    NSInteger margin = 10;//设置相隔距离
    NSInteger height = 50;//设置view的高度
    for (int i = 0; i < count; i ++) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor brownColor];
        [self.view addSubview:view];
        if (i == 0) {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.view).offset(margin);
                make.centerY.equalTo(weakSelf.view);
                make.height.mas_equalTo(height);
            }];
        }
        else if (i == count - 1) {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(weakSelf.view).offset(-margin);
                make.left.equalTo(tempView.mas_right).offset(margin);
                make.centerY.equalTo(tempView);
                make.height.equalTo(tempView);
                make.width.equalTo(tempView);
            }];
        }
        else{
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(tempView.mas_right).offset(margin);
                make.centerY.equalTo(tempView);
                make.height.equalTo(tempView);
                make.width.equalTo(tempView);
            }];
        }
        tempView = view;
        [view layoutIfNeeded];
    }
}

- (NSString *)digView:(UIView *)view {
    if ([view isKindOfClass:[UITableViewCell class]]) return @"";
    // 1.初始化
    NSMutableString *xml = [NSMutableString string];
    
    // 2.标签开头
    [xml appendFormat:@"<%@ frame=\"%@\"", view.class, NSStringFromCGRect(view.frame)];
    if (!CGPointEqualToPoint(view.bounds.origin, CGPointZero)) {
        [xml appendFormat:@" bounds=\"%@\"", NSStringFromCGRect(view.bounds)];
    }
    
    if ([view isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scroll = (UIScrollView *)view;
        if (!UIEdgeInsetsEqualToEdgeInsets(UIEdgeInsetsZero, scroll.contentInset)) {
            [xml appendFormat:@" contentInset=\"%@\"", NSStringFromUIEdgeInsets(scroll.contentInset)];
        }
    }
    
    // 3.判断是否要结束
    if (view.subviews.count == 0) {
        [xml appendString:@" />"];
        return xml;
    } else {
        [xml appendString:@">"];
    }
    
    // 4.遍历所有的子控件
    for (UIView *child in view.subviews) {
        NSString *childXml = [self digView:child];
        [xml appendString:childXml];
    }
    
    // 5.标签结尾
    [xml appendFormat:@"<!--%@-->", view.class];
    
    return xml;
}


// 遍历父视图的所有子视图，包括嵌套的子视图
- (void)TraverseAllSubviews:(UIView *)view {
    NSMutableArray *array = [NSMutableArray array];
    NSString *str = @"";
    for (UIView *subView in view.subviews) {
        if (subView.subviews.count) {
            str = [str stringByAppendingString:@"-1"];
            [self TraverseAllSubviews:subView];
        }else {
            [array addObject:str];
        }
        //        NSLog(@"%@",subView);
    }
    NSLog(@"%@",array);
}
@end
