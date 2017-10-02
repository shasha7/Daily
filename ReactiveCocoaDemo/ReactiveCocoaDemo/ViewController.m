//
//  ViewController.m
//  ReactiveCocoaDemo
//
//  Created by 王伟虎 on 2017/9/30.
//  Copyright © 2017年 wwh. All rights reserved.
//  RAC高聚合，低耦合

#import "ViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "RedView.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, assign) NSInteger age;
    
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
