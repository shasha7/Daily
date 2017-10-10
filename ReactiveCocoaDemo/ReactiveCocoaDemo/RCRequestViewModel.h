//
//  RCRequestViewModel.h
//  ReactiveCocoaDemo
//
//  Created by 王伟虎 on 2017/10/10.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACCommand;

@interface RCRequestViewModel : NSObject

@property (nonatomic, strong, readonly) RACCommand *requestCommand;

- (void)bindViewModelWithView:(id)view;

@end
