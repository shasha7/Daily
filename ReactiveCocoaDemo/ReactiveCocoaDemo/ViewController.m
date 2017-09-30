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
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"age" object:self] subscribeNext:^(NSNotification * _Nullable x) {
        NSLog(@"属性发生变化=%@", x);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.age ++;
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
