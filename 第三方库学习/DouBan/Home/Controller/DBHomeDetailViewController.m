//
//  DBHomeDetailViewController.m
//  DouBan
//
//  Created by 王伟虎 on 2017/12/18.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import "DBHomeDetailViewController.h"

@interface DBHomeDetailViewController ()

@property (nonatomic, assign) int age;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *height;
@property (nonatomic, copy) NSArray *books;
@property (nonatomic, strong) NSMutableArray *cars;
@property (nonatomic, strong) NSMutableDictionary *dict;

@end

@implementation DBHomeDetailViewController


- (void)dealloc {
    // 移除监听属性时不能重复删除？？
    [self removeObserver:self forKeyPath:@"name"];
//    [self removeObserver:self forKeyPath:@"name"];
}


- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"详情";
        self.hidesBottomBarWhenPushed = YES;
        
        self.name = @"dwadadaw";
        self.age = 10;
        self.books = @[@"wangweihu", @"wushanshan"];
        self.cars = [NSMutableArray array];
        self.dict = [NSMutableDictionary dictionary];

        [self.dict setObject:@(90) forKey:self.books];
        NSLog(@"self.dict = %@", self.dict);
        
        [self addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
//        [self addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew context:nil];
//        [self addObserver:self forKeyPath:@"books" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"cars" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"dict" options:NSKeyValueObservingOptionNew context:nil];
        
        self.dict = [NSMutableDictionary dictionaryWithObject:@(19) forKey:@"age"];
        
//        [self.dict setObject:@"28" forKey:@"age"];
//        [self.dict setObject:@"wangweihu" forKey:@"name"];
//        [self mutableDictionaryValueForKey:@"cars"];
        NSString *str = @"WANGWEIHU";
        [[self mutableArrayValueForKey:@"cars"] addObject:str];
        self.name = @"dawdawdawddawdaw";
        self.age = 110;
        self.books = @[@"wangweihu", @"wushanshan", @"wangxiaoshan"];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"name"]) {
        NSLog(@"change = %@", change);
    }else if ([keyPath isEqualToString:@"dict"]) {
        NSLog(@"change = %@", change);
    }
}

#pragma mark - Throttle消息频率限制

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(doSomething) object:nil];
    [self performSelector:@selector(doSomething) withObject:nil afterDelay:.5];
}

- (void)doSomething {
    NSLog(@"doSomething");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    
    [self jumpToOtherApplication];
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 200)];
//    label.backgroundColor = [UIColor whiteColor];
//    label.numberOfLines = -1;
//    label.font = [UIFont systemFontOfSize:13];
//
//    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
//    style.lineSpacing = 10 - (label.font.lineHeight - label.font.pointSize);
//
//    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"设置动画重复的时间 设置动画重复的时间 设置动画重复的时间 设置动画重复的时间 设置动画重复的时间 设置动画重复的时间 设置动画重复的时间 设置动画重复的时间 设置动画重复的时间" attributes:@{NSParagraphStyleAttributeName:style}];
//
//    label.attributedText = str;
//    [self.view addSubview:label];
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
//            NSDictionary *dict = @{@"go":@(4)};
//            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
//            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//
//            NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
//            NSRange range = {0,jsonString.length};
//            //去掉字符串中的空格
//            [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
//            NSRange range2 = {0,mutStr.length};
//            //去掉字符串中的换行符
//            [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
            
            //转码
//            mutStr = [[mutStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] mutableCopy];
            
//            jsonString = [jsonString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
//            NSString *json = [NSString stringWithFormat:@"jiayuan://xxx?jsonValue=1&jsonParams=%@",jsonString];
//            [application openURL:[NSURL URLWithString:json] options:@{} completionHandler:^(BOOL success) {
//                NSLog(@"success = %@", @(success));
//            }];
        } else {
            // Fallback on earlier versions
        }
    }else {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"sorry the application is not load" delegate:self cancelButtonTitle:@"Cacell" otherButtonTitles:nil, nil];
//        [alert show];
    }
}

@end
