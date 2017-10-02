//
//  ViewController.m
//  ReactiveCocoaDemo
//
//  Created by 王伟虎 on 2017/9/30.
//  Copyright © 2017年 wwh. All rights reserved.
//  RAC高聚合，低耦合

#import "ViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <ReactiveObjC/RACReturnSignal.h>
#import "RedView.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, assign) NSInteger age;

@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *psdTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self skip];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)skip {
    /// Skips the first `skipCount` values in the receiver.
    ///
    /// Returns the receiver after skipping the first `skipCount` values. If
    /// `skipCount` is greater than the number of values in the signal, an empty
    /// signal is returned.
    RACSubject *subject = [RACSubject subject];
    [[subject skip:2] subscribeNext:^(id  _Nullable x) {
        NSLog(@"能否拿到值%@", x);
    }];
    [subject sendNext:@(1)];
    [subject sendNext:@"2"];
    [subject sendNext:@(3)];
    [subject sendNext:@(4)];
    [subject sendNext:@(5)];
}

- (void)distinctUntilChanged {
    /// Returns a signal of values for which -isEqual: returns NO when compared to the
    /// previous value.
    RACSubject *subject = [RACSubject subject];
    [[subject distinctUntilChanged] subscribeNext:^(id  _Nullable x) {
        NSLog(@"能否拿到值%@", x);
    }];
    [subject sendNext:@(1)];
    [subject sendNext:@"2"];
    [subject sendNext:@(3)];
    [subject sendNext:@(4)];
    [subject sendNext:@(5)];
}

- (void)takeUil {
    /// Takes `next`s until the `signalTrigger` sends `next` or `completed`.
    ///
    /// Returns a signal which passes through all events from the receiver until
    /// `signalTrigger` sends `next` or `completed`, at which point the returned signal
    /// will send `completed`.
    // takeUntil:只要发送信号完成 就不在接受信号发送的内容
    RACSubject *subject = [RACSubject subject];
    RACSubject *signal = [RACSubject subject];
    [[subject takeUntil:signal] subscribeNext:^(id  _Nullable x) {
        NSLog(@"能否拿到值%@", x);
    }];
    [subject sendNext:@(1)];
    [subject sendCompleted];
    [subject sendNext:@(12)];
    [subject sendNext:@(123)];
    [subject sendNext:@(1234)];
    [subject sendNext:@(12345)];
    [subject sendNext:@(123456)];
}

- (void)take {
    /// Takes the last `count` `next`s after the receiving signal completes.
    // take: 取前面几个值
    // takeLast:取后面几个值 但必须要调用sendCompleted方法  否则无法判断最后是哪一个
    RACSubject *subject = [RACSubject subject];
    [[subject takeLast:2] subscribeNext:^(id  _Nullable x) {
        NSLog(@"能否拿到值%@", x);
    }];
    [subject sendNext:@(1)];
    [subject sendNext:@(12)];
    [subject sendNext:@(123)];
    [subject sendNext:@(1234)];
    [subject sendNext:@(12345)];
    [subject sendNext:@(123456)];
    [subject sendCompleted];
}

- (void)ignore {
    // ignore:忽略某些值
    // ignoreValues忽略所有值
    RACSubject *subject = [RACSubject subject];
    RACSignal *ignoreSignal = [subject ignoreValues];
    [ignoreSignal subscribeNext:^(id x) {
        NSLog(@"能否拿到值%@", x);
    }];
    [subject sendNext:@(1)];
}

- (void)filler {
    [[self.accountTextField.rac_textSignal filter:^BOOL(NSString *value) {
        return value.length > 5;
    }] subscribeNext:^(NSString *account) {
        NSLog(@"账号：%@", account);
    }];
}

- (IBAction)loginBtnClick:(UIButton *)sender {
    NSLog(@"进行登录");
}

- (void)combineReduce {
    // 常用于登录界面业务逻辑处理  只有账号、密码都存在是 登录按钮才可以点击
    [[RACSignal combineLatest:@[self.accountTextField.rac_textSignal, self.psdTextField.rac_textSignal] reduce:^id(NSString *account, NSString *pwd){
        return @(self.accountTextField.text.length && self.psdTextField.text.length);
    }] subscribeNext:^(id x) {
        self.loginBtn.enabled = [x boolValue];
    }];
}

- (void)zipWith {
    // 压缩信号
    // 应用场景:当一个界面有多个数据源的时候，当所有的数据源都返回时才会刷新UI
    RACSubject *signalA = [RACSubject subject];
    RACSubject *signalB = [RACSubject subject];
    RACSignal *mergeSignal = [signalA zipWith:signalB];
    [mergeSignal subscribeNext:^(id x) {
        // 这里的数据类型是RACTwoTuple元组
        NSLog(@"获取数据%@", x);
    }];
    
    [signalA sendNext:@"上"];
    [signalB sendNext:@"下"];
}

- (void)merge {
    // 无顺序的  任意信号有数据返回  就会有打印
    RACSubject *signalA = [RACSubject subject];
    RACSubject *signalB = [RACSubject subject];
    
    // 组合顺序A-B  也可以[signalB merge:signalA] B-A
    RACSignal *mergeSignal = [signalA merge:signalB];
    [mergeSignal subscribeNext:^(id x) {
        NSLog(@"获取数据%@", x);
    }];
    
    [signalA sendNext:@"上"];
//    [signalB sendNext:@"下"];
}

- (void)map {
    RACSubject *subject = [RACSubject subject];
    
    RACSignal *signal = [subject map:^id(id value) {
        return [NSString stringWithFormat:@"wwh:%@", value];
    }];
    
    [signal subscribeNext:^(id  x) {
        NSLog(@"绑定信号接收到的数据%@", x); 
    }];
    
    [subject sendNext:@(123)];
}

- (void)flattenMap {
    RACSubject *subject = [RACSubject subject];
    RACSignal *signal = [subject flattenMap:^RACSignal *(id value) {
        NSLog(@"原信号subject发送内容这里就会收到%@", value);
        return [RACReturnSignal return:@{@"wwh":value}];
    }];
    [signal subscribeNext:^(id x) {
        NSLog(@"绑定信号接收到的数据%@", x);
    }];
    
    [subject sendNext:@(123)];
}

- (void)bind {
    RACSubject *subject = [RACSubject subject];
    /*
     _disposable = [RACCompoundDisposable compoundDisposable];//保存取消订阅操作的数组
     
     _subscribers = [[NSMutableArray alloc] initWithCapacity:1];//保存订阅者的数组
     */
    
    // 这是一个返回值为block的block
    // 该返回值为block的block的参数id value, BOOL *stop 返回值是RACSignal类型实例
    RACSignalBindBlock (^block)(void) = ^{
        return ^RACSignal *(id value, BOOL *stop) {
            NSLog(@"原信号subject接受到的数据%@", value);
            return [RACReturnSignal return:value];
        };
    };
    
    // 保存block  并未执行
    RACSignal *bindSignal = [subject bind:block];
    
    // 订阅绑定信号时才会执行block
    /*
     // 创建订阅者
     RACSubscriber *o = [RACSubscriber subscriberWithNext:nextBlock error:NULL completed:NULL];
     subscriberWithNext:error:completed:方法执行就是保存nextBlock error completed三个block
     subscriber->_next = [next copy];
     subscriber->_error = [error copy];
     subscriber->_completed = [completed copy];
     
     // 真正的去执行订阅
     return [self subscribe:o];
     
     [subscribers addObject:subscriber];
     [self.innerSubscriber didSubscribeWithDisposable:self.disposable];
     这里实际上还是在存储一些block
     */
    // - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock {
    [bindSignal subscribeNext:^(id x) {
        // 调用完[RACReturnSignal return:value];这段代码就会来到这里
        NSLog(@"绑定信号接收到的数据%@", x);
    }];
    
    /*
     // 拿到subject初始化创建的_subscribers数组进行遍历
     @synchronized (self.subscribers) {
     subscribers = [self.subscribers copy];
     }
     
     for (id<RACSubscriber> subscriber in subscribers) {
     block(subscriber);
     
     block去真正执行[subscriber sendNext:value]方法
     暨：当初创建的RACSubscriber订阅者保存起来的nextBlock
     - (void)sendNext:(id)value {
     @synchronized (self) {
     void (^nextBlock)(id) = [self.next copy];
     if (nextBlock == nil) return;
     nextBlock(value);
     }
     }
     }
     */
    [subject sendNext:@(123)];
}

- (void)command {
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        // input是execute:方法参数的值
        NSLog(@"input=%@", input);
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@"创建信号传出来的数据"];
            return nil;
        }];
    }];
    
    RACSignal *signal = [command execute:@(1)];
    
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
}

- (void)connection {
    // 信号被订阅不止一次,单只执行一次block的内容
    RACDisposable *(^didSubscribe)(id<RACSubscriber> subscriber) = ^RACDisposable *(id<RACSubscriber> subscriber){
        NSLog(@"创建信号");
        [subscriber sendNext:@(1)];
        //        return [RACDisposable disposableWithBlock:^{
        //            NSLog(@"取消订阅");
        //        }];
        return nil;
    };
    
    // RACSignal的createSignal方法 是首选的创建信号的方式
    // 保存传进来的 didSubscribe block
    RACSignal *signal = [RACSignal createSignal:didSubscribe];
    RACMulticastConnection *connection = [signal publish];
    
    [connection.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅者1=%@", x);
    }];
    [connection.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅者2=%@", x);
    }];
    
    [connection connect];
}

- (void)subjectDemo {
    RedView *redView = [RedView new];
    redView.frame = CGRectMake(0 , 40, self.view.bounds.size.width, 200);
    redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:redView];
    
    [redView.subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
}

- (void)replaySubject {
    RACReplaySubject *replaySubject = [RACReplaySubject subject];
    // _valuesReceived
    [replaySubject sendNext:@(1)];
    
    [replaySubject subscribeNext:^(id  _Nullable x) {
        NSLog(@"subject1=%@", x);
    }];
    // RACReplaySubject  sendNext发信号可以放到前面
}

- (void)subject {
    RACSubject *subject = [RACSubject subject];
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"subject1=%@", x);
    }];
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"subject2=%@", x);
    }];
    [subject sendNext:@(1)];
}

- (void)signal {
    // RACSubscriber协议
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        // 进行网络请求 拿到数据之后 进行发送
        [subscriber sendNext:@(1)];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"取消订阅");
        }];
    }];
    
    RACDisposable *disposable = [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
    
    [disposable dispose];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.age ++;
}

- (void)mutipleDataSourceSyncReturnAndReloadData {
    RACSignal *sigalOne = [RACSignal createSignal:^RACDisposable * (id<RACSubscriber>subscriber) {
        NSLog(@"处理信号");
        [subscriber sendNext:@{@"retcode":@(1)}];
        return nil;
    }];
    
    RACSignal *sigalTwo = [RACSignal createSignal:^RACDisposable * (id<RACSubscriber>subscriber) {
        NSLog(@"处理信号");
        [subscriber sendNext:@{@"retcode":@(-1)}];
        return nil;
    }];
    
    [self rac_liftSelector:@selector(reloadDataOne:two:) withSignalsFromArray:@[sigalOne, sigalTwo]];
}

- (void)reloadDataOne:(NSDictionary *)one two:(NSDictionary *)two {
    NSLog(@"%@-%@", one, two);
}

- (void)kvo {
    [[self rac_valuesForKeyPath:@"age" observer:self] subscribeNext:^(id  _Nullable x) {
        NSLog(@"监听到属性值的改变");
    }];
}

// 通知
- (void)notification {
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(100, 300, 100, 100)];
    textField.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:textField];
    
    // 通知
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        NSLog(@"监听键盘弹出");
    }];
}

- (void)monitorTextFieldTextChange {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    label.textColor = [UIColor blueColor];
    [self.view addSubview:label];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(100, 300, 100, 100)];
    textField.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:textField];
    
    [textField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        label.text = x;
    }];
}

- (void)monitorBtnClick {
    RedView *redView = [RedView new];
    redView.frame = CGRectMake(0 , 40, self.view.bounds.size.width, 200);
    redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:redView];

    [[redView rac_signalForSelector:NSSelectorFromString(@"btnClick:")] subscribeNext:^(RACTuple * _Nullable x) {
        NSLog(@"监听到了按钮点击");
    }];
    
    [[redView.btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"按钮被点击");
    }];
    
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn.backgroundColor = [UIColor redColor];
    self.btn.frame = CGRectMake(100, 100, 100, 100);
    [self.btn setTitle:@"Button" forState:UIControlStateNormal];
    [self.view addSubview:self.btn];
    
    [[self.btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"按钮被点击");
    }];
}

@end
