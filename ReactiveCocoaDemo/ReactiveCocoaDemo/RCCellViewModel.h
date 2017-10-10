//
//  RCCellViewModel.h
//  ReactiveCocoaDemo
//
//  Created by 王伟虎 on 2017/10/10.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCModel.h"

@interface RCCellViewModel : NSObject

@property (nonatomic, strong) RCModel *model;

- (void)bindViewModelWithView:(id)view;

@end
