//
//  RedView.h
//  ReactiveCocoaDemo
//
//  Created by 王伟虎 on 2017/9/30.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface RedView : UIView

@property (nonatomic, strong) RACSubject *subject; 
@property (nonatomic, strong) UIButton *btn; 
    
@end
