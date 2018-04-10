//
//  DBHomeViewController.m
//  DouBan
//
//  Created by 王伟虎 on 2017/10/2.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import "DBHomeViewController.h"
#import "DBHomeDetailViewController.h"
#import "UINavigationController+ExchangeToTopViewController.h"
#import "AFNetworking.h"
#import "KVOController.h"
#import "DBWebViewController.h"
#import "DBResponderViewController.h"
#import "Coder.h"
#import "Person.h"

/*
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
 */

typedef void (^MyBlock)(void);

@interface DBHomeViewController ()

@property (nonatomic, copy) MyBlock myblock;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSMutableArray *books;

@end

@implementation DBHomeViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"首页";
        self.model = [DBHomeModel new];
        
//        [self.model addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
        
//        self.model.name = @"wangweihu";
//        [self.model setValue:@"wushanshan" forKey:@"name"];
        
//        self.secondModel = [DBHomeSecondModel new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self test_inheritedAndOverrided];
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

- (void)UILabel_test_iOS_8_x_bug {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 0)];  //为了测试，设置高度为0
    label.backgroundColor = [UIColor blueColor];  //高度为0时背景色并不会显示,这里为了明显设置为蓝色
    label.textColor = [UIColor blackColor];
    label.text = @"测试";
    [self.view addSubview:label];
    
    // 解决方案
    // label.clipsToBounds = YES;
    // label.hidden = YES;  //高度为0时hidden掉
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
    
    DBResponderViewController *deatilVC = [[DBResponderViewController alloc] init];
    [self.navigationController exchangeToTopViewController:deatilVC animated:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSLog(@"change = %@", change);
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

@end
