//
//  HomeHeaderView.m
//  InterviewDemo
//
//  Created by 王伟虎 on 2017/9/13.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import "HomeHeaderView.h"

@interface HomeHeaderLayer : CALayer

@end

@implementation HomeHeaderLayer

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

- (void)setPosition:(CGPoint)position
{
    [super setPosition:position];
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
}

- (CGPoint)position
{
    return [super position];
}

@end

@interface HomeHeaderView ()

@property (nonatomic, strong) CALayer *m_layer;

@end

@implementation HomeHeaderView

+ (Class)layerClass {
    return [HomeHeaderLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // UIView与CALayer的关系
        /*
         结论
         UIView是iOS开发的核心类，在我们看来，它负责几乎所有的界面展示和用户交互
         CALayer是属于QuartzCore框架，在iOS中使用了UIResponder类来响应交互
         UIKit将CALayer封装进了UIView中，让开发者们感觉到UIView既能绘制又能处理交互，而实际上负责绘制的是UIView中的CALayer。
         我们访问和设置UIView的一些负责绘制规则的属性比如frame、center、backgroundColor等，在其持有的CALayer中都存在对应的属性，UIView只是简单的返回它自己CALayer的属性以及对自己的CALayer的这些对应的属性赋值而已。
         UIView负责处理用户交互，负责绘制内容的则是它持有的那个CALayer，我们访问和设置UIView的这些负责显示的属性实际上访问和设置的都是这个CALayer对应的属性，UIView只是将这些操作封装起来了而已。
         */
//        _m_layer = [CALayer layer];
//        _m_layer.frame = frame;
//        _m_layer.backgroundColor = [UIColor redColor].CGColor;
//        [self.layer addSublayer:_m_layer];
//        
//        NSLog(@"%@", _m_layer.delegate);//返回(null)
        
        /*
         UIView+block动画实现原理
         动画是怎样被加到CALayer上的。
         总结
         CALayer中有大量属性在注释的时候标记了Animatable，表示这个属性是可动画的。可动画的属性具有两个特点：1、直接对它赋值可能产生隐式动画；2、我们的CAAnimation的keyPath可以设置为这个属性的名字。
         
         当我们对这些属性赋值的时候，layer会让它的delegate调用actionForLayer:forKey:方法获取一个返回值，这个返回值可能是这样几种情况：1、是一个nil，则layer会走自己的隐式动画；2、是一个NSNull，则layer不会做任何动画；3、是一个实现了CAAction协议的对象，则layer会用这个对象生成一个CABasicAnimation加到自己身上执行动画。
         
         有趣的是，如果一个UIView持有一个CALayer，那么这个layer的delegate就是这个view。当我们对view的一个属性，比如center赋值的时候，view同时会去对layer的position赋值。这时layer会让它的delegate（就是这个view）调用actionForLayer:forKey:方法，UIView在这个方法中是这样实现的：如果这次调用发生在[UIView animateWithDuration:animations:]的动画block里面，则UIView生成一个CAAction对象，返回给layer。如果没有发生在这个block外面，则返回NSNull。这也就说明了为什么我们对一个view的center赋值，如果这行代码在动画block里面，就会有动画，在block外面则没有动画。
         */
    }
    return self;
}

- (CGPoint)center
{
    return [super center];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}
- (void)setCenter:(CGPoint)center
{
    [super setCenter:center];
}
- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
}
@end
