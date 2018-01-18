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

- (void)addAnimation:(CAAnimation *)anim forKey:(NSString *)key
{
    [super addAnimation:anim forKey:key];
    NSLog(@"%@",[anim debugDescription]);
}

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

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
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

- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event
{
    id<CAAction> obj = [super actionForLayer:layer forKey:event];
    NSLog(@"%@",obj);
    return obj;
}

@end
