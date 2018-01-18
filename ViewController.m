//
//  ViewController.m
//  MasonryDemo
//
//  Created by 王伟虎 on 2017/9/30.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+Calculate.h"
#import "Masonry.h"
#import "Person.h"
#import "NSObject+KVO.h"

@interface ViewController ()

@property (nonatomic, strong) Person *person;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    Person *person = [Person new];
    self.person = person;
    [person wwh_addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew context:nil];
    
    
    // 链式编程思想
    NSInteger result = [NSObject wwh_makeCaculate:^(CalculateMaker *make) {
        make.add(10).add(20);
        make.add(30).add(40);
        make.minus(50);
    }];
    
    NSLog(@"结果=%ld", (long)result);
    
    UIView *redView = [[UIView alloc] init];
    redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:redView];
    
    
    // 红色View距父视图上下左右边距均为10像素
    [redView mas_makeConstraints:^(MASConstraintMaker *make) {
        /*
         make.top 执行的是这个方法
         - (MASConstraint *)top {
            return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTop];
         }
         最终会这么调用：
         // 拿到maker记录的所需添加约束的视图View以及约束
         MASViewAttribute *viewAttribute = [[MASViewAttribute alloc] initWithView:self.view layoutAttribute:layoutAttribute];
         
         MASViewConstraint *newConstraint = [[MASViewConstraint alloc] initWithFirstViewAttribute:viewAttribute];
         
         
         newConstraint.delegate = self;
         
         // 把约束放到数组当中
         [self.constraints addObject:newConstraint];
         
         // 返回MASConstraint子类MASViewConstraint实例对象，供链式循环调用
         return newConstraint;
         */
        /*
         make.top.left执行的这个方法
         - (MASConstraint *)left {
            return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeft];
         }
         - (MASConstraint *)addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute {
            NSAssert(!self.hasLayoutRelation, @"Attributes should be chained before defining the constraint relation");
            // 这个里的delegate就是上面make.top执行时设置的maker了
            return [self.delegate constraint:self addConstraintWithLayoutAttribute:layoutAttribute];
         }
         */
        /*
         make.top.left.mas_equalTo
         - (MASConstraint * (^)(id))equalTo {
            return ^id(id attribute) {
                return self.equalToWithRelation(attribute, NSLayoutRelationEqual);
            };
         }
         */
        make.top.left.mas_equalTo(10);
        make.right.bottom.mas_equalTo(-10);
    }];
    
    // 链式编程思想
    // 首先返回值为block,block有返回值有参数，返回值为调用者本身、参数是执行是的具体操作
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"监听到了值改变=%@", keyPath);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.person.age ++;
}
@end
