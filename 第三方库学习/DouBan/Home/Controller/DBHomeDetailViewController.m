//
//  DBHomeDetailViewController.m
//  DouBan
//
//  Created by 王伟虎 on 2017/12/18.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import "DBHomeDetailViewController.h"

@interface DBHomeDetailViewController ()

@end

@implementation DBHomeDetailViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"详情";
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 200)];
    label.backgroundColor = [UIColor whiteColor];
    label.numberOfLines = -1;
    label.font = [UIFont systemFontOfSize:13];
    
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.lineSpacing = 10 - (label.font.lineHeight - label.font.pointSize);
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"设置动画重复的时间 设置动画重复的时间 设置动画重复的时间 设置动画重复的时间 设置动画重复的时间 设置动画重复的时间 设置动画重复的时间 设置动画重复的时间 设置动画重复的时间" attributes:@{NSParagraphStyleAttributeName:style}];

    label.attributedText = str;
    [self.view addSubview:label];
//    [self basicAnimation];
}

- (void)basicAnimation {
    /*
     duration           动画的时间
     repeatCount        重复的次数 不停重复设置为HUGE_VALF
     repeatDuration     设置动画重复的时间
     beginTime          指定动画开始的时间
     timingFunction     设置动画的速度变化
     autoreverses       动画结束时是否执行逆动画
     fromValue          所改变属性的起始值
     toValue            所改变属性的结束时的值
     byValue            所改变属性相同起始值的改变量
     */
    UIView *customView = [[UIView alloc] init];
    customView.backgroundColor = [UIColor whiteColor];
    customView.frame = CGRectMake(100, 100, 100, 100);
    [self.view addSubview:customView];
    
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    basicAnimation.duration = 2;
    basicAnimation.repeatCount = HUGE_VALF;
    basicAnimation.beginTime = CACurrentMediaTime() + 1;
    basicAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(100, 30)];
    basicAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(50, 300)];
    
    /* Attach an animation object to the layer. Typically this is implicitly
     * invoked through an action that is an CAAnimation object.
     *
     * 'key' may be any string such that only one animation per unique key
     * is added per layer. The special key 'transition' is automatically
     * used for transition animations. The nil pointer is also a valid key.
     *
     * If the `duration' property of the animation is zero or negative it
     * is given the default duration, either the value of the
     * `animationDuration' transaction property or .25 seconds otherwise.
     *
     * The animation is copied before being added to the layer, so any
     * subsequent modifications to `anim' will have no affect unless it is
     * added to another layer. */
    [customView.layer addAnimation:basicAnimation forKey:@"transition"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        /* Remove any animation attached to the layer for 'key'. */
        [customView.layer removeAnimationForKey:@"transition"];
        
        /* Remove all animations attached to the layer. */
//        [customView.layer removeAllAnimations];
    });
    NSLog(@"animationKeys = %@", customView.layer.animationKeys);
}

// 应用间的跳转 iOS9的新特性
- (void)jumpToOtherApplication {
    UIApplication *application = [UIApplication sharedApplication];
    // 打开其他家应用 前提是手机上有安装需要打开的应用
    if ([application canOpenURL:[NSURL URLWithString:@"jiayuan://"]]) {
        if (@available(iOS 10.0, *)) {
            NSDictionary *dict = @{@"go":@(4)};
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
            NSRange range = {0,jsonString.length};
            //去掉字符串中的空格
            [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
            NSRange range2 = {0,mutStr.length};
            //去掉字符串中的换行符
            [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
            NSString *json = [NSString stringWithFormat:@"jiayuan://xxx?jsonValue=1&jsonParams=%@",mutStr];
            [application openURL:[NSURL URLWithString:json] options:@{} completionHandler:^(BOOL success) {
                NSLog(@"success = %@", @(success));
            }];
        } else {
            // Fallback on earlier versions
        }
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"sorry the application is not load" delegate:self cancelButtonTitle:@"Cacell" otherButtonTitles:nil, nil];
        [alert show];
    }
}

@end
