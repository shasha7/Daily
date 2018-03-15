//
//  WWHViewController.m
//  Effective Objective-C
//
//  Created by 王伟虎 on 2018/3/12.
//  Copyright © 2018年 wwh. All rights reserved.
//

#import "WWHViewController.h"
#import "EOCWeakProxy.h"
#import "NSTimer+BlocksSupport.h"
#import <pthread/pthread.h>
#import "WWHCache.h"

@interface WWHViewController ()<NSCacheDelegate>

@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, strong) dispatch_source_t dtimer;
@property (nonatomic, strong) WWHCache *cache;

@end

@implementation WWHViewController

- (void)dealloc {
    NSLog(@"销毁了控制器");
    [_timer invalidate];
}

/**
 * 当NSCache中有对象删除的时候就会调用这个回调方法
 * cache这个是不被允许修改的，obj是删除的对象
 */
- (void)cache:(NSCache *)cache willEvictObject:(id)obj {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"定时器";
    
    WWHCache *cache = [[WWHCache alloc] init];
    [cache setCountLimit:10];
    for (NSInteger i = 0; i < 20; i++) {
        NSObject *o = [[NSObject alloc] init];
        [cache setValue:o forKey:[NSString stringWithFormat:@"第%@个对象", @(i)]];
    }
    
    /*
     self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f repeats:NO block:^(NSTimer * _Nonnull timer) {
     NSLog(@"------");
     }];
     */
    
    /*
    // 这种方式一共有两个对象引用这个计时器，控制器以及RunLoop，只有两个对象都取消对timer的引用，timer才能销毁
    // block中使用self的时候，为了避免循环，使用weakSelf
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer timerWithTimeInterval:1.0f repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"------");
        __weak typeof(weakSelf) strongSelf = weakSelf;
        NSLog(@"%@", strongSelf);
    }];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
     */
    
    // timer的属性是weak、strong貌似都没啥区别，这是为什么呢？WWHViewController需要NSTimer同生共死。NSTimer需要在WWHViewController的dealloc方法被invalidate。NSTimer被 invalidate的前提是WWHViewController被dealloc。而NSTimer一直强引用着 WWHViewController导致WWHViewController无法调用dealloc方法。
    // 两种解决方案 一种是用另外一个对象充当target 一种是timer自己来充当target
    /*
    NSTimer *timer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:1] interval:1 target:[EOCWeakProxy proxyWithTarget:self] selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
     */
    /*
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer eoc_scheduledTimerWithTimeInterval:1.0f repeats:YES block:^{
        NSLog(@"%@", weakSelf);
    }];
     */
    
    /*
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, NULL);
    self.dtimer = timer;
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        NSLog(@"--------");
    });
    dispatch_resume(timer);
     */

    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(pthreadGetSpecific) object:nil];
    [thread start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)timerAction {// 这个默认参数就是self _cmd  所以会强引用self
    NSLog(@"%@", self);
}

void (*worker1)(void *arg);
void (*worker2)(void *arg);

- (void)pthreadGetSpecific {

    pthread_key_t key;
    pthread_key_create(&key, worker1);
    
    NSString *str = @"wangweihu";
    pthread_setspecific(key, CFBridgingRetain([NSString stringWithFormat:@"%@_wwh", str]));
    
    NSLog(@"str = %@", pthread_getspecific(key));
    
    NSLog(@"str_org = %@", str);
}

@end
