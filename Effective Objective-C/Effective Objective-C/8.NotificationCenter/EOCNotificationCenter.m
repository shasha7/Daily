//
//  EOCNotificationCenter.m
//  EOCNotificationCenter
//
//  Created by steve on 09/04/2018.
//

#import "EOCNotificationCenter.h"
#import <pthread/pthread.h>

// 注册通知的对象、需要执行的方法、监听指定对象发出的通知等信息
@interface ObserverModel : NSObject

@property (nonatomic, weak, nullable) id target;//注册通知的对象

@property (nonatomic, assign) SEL sel;//收到通知需要执行的方法

@property (nonatomic, weak, nullable) id object;//监听指定对象发出的通知

@property (nonatomic, copy) void(^block)(id);//回调block

@property (nonatomic, strong, nullable) NSOperationQueue *operationQueue;//需要在子线程执行吗

@end

// 通知 保存所有的 通知的对象信息
@interface EOCNote : NSObject

@property (nonatomic, strong) NSMutableArray<ObserverModel *> *observers;

@end

@implementation ObserverModel

@end

@implementation EOCNote

@end

@interface EOCNotificationCenter()

@property (nonatomic, strong) NSMutableDictionary<NSString *, EOCNote *> *store;

@end

@implementation EOCNotificationCenter {
    pthread_mutexattr_t attr;
    pthread_mutex_t mutex;
}

+ (instancetype)defaultCenter {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _store = [NSMutableDictionary dictionary];
        pthread_mutexattr_init(&attr);
        pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_NORMAL);  // 定义锁的属性
        pthread_mutex_init(&mutex, &attr); // 创建锁
    }
    return self;
}

- (void)addObserver:(nonnull id)observer selector:(nonnull SEL)sel name:(nullable NSNotificationName)aName object:(nullable id)object {
    @autoreleasepool {
        pthread_mutex_lock(&mutex); // 申请锁
        EOCNote *note = [self.store objectForKey:aName];
        if (!note) {
            note = [[EOCNote alloc] init];
            note.observers = [NSMutableArray array];
        }
        
        ObserverModel *observerModel = [[ObserverModel alloc] init];
        observerModel.target = observer;
        observerModel.sel = sel;
        observerModel.object = object;
        
        [note.observers addObject:observerModel];
        
        [self.store setObject:note forKey:aName];
        
        pthread_mutex_unlock(&mutex); // 释放锁
    }
}

- (void)addObserverForName:(nullable NSNotificationName)aName object:(nullable id)object queue:(nullable NSOperationQueue *)queue usingBlock:(void(^)(id))block{
    @autoreleasepool {
        pthread_mutex_lock(&mutex); // 申请锁
        EOCNote *note = [self.store objectForKey:aName];
        if (!note) {
            note = [[EOCNote alloc] init];
            note.observers = [NSMutableArray array];
        }
        ObserverModel *observerModel = [[ObserverModel alloc] init];
        observerModel.target = object;
        observerModel.block = block;
        observerModel.object = object;
        observerModel.operationQueue = queue;
        [note.observers addObject:observerModel];
        [self.store setObject:note forKey:aName];
        pthread_mutex_unlock(&mutex); // 释放锁
    }
}

- (void)postNotificationName:(nonnull NSNotificationName)aName object:(nullable id)object {
    EOCNote *note = (EOCNote *)[self.store valueForKey:aName];
    [[note.observers copy] enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(ObserverModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        if ([obj.target respondsToSelector:obj.sel]) {
            [obj.target performSelector:obj.sel withObject:obj.object];
        }
        if (obj.block) {
            if (obj.operationQueue) {
                NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
                    obj.block(obj.object);
                }];
                NSOperationQueue *operationQueue = obj.operationQueue;
                [operationQueue addOperation:operation];
            } else {
               obj.block(obj.object);
            }
        }
#pragma clang diagnostic pop
    }];
}

- (void)removeObserver:(nonnull id)observer name:(nullable NSNotificationName)aName object:(nullable id)object {
    __block EOCNote *note = (EOCNote *)[self.store valueForKey:aName];
    pthread_mutex_lock(&mutex); // 申请锁
    [note.observers enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(ObserverModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        if ([obj.target isEqual:observer]) {
            [note.observers removeObject:obj];
        }
#pragma clang diagnostic pop
    }];
    pthread_mutex_unlock(&mutex); // 释放锁
}

@end
