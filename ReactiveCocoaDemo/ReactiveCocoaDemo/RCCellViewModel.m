//
//  RCCellViewModel.m
//  ReactiveCocoaDemo
//
//  Created by 王伟虎 on 2017/10/10.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import "RCCellViewModel.h"
#import "RCTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation RCCellViewModel

- (void)bindViewModelWithView:(id)view {
    RCTableViewCell *cell = (RCTableViewCell *)view;
    cell.textLabel.text = _model.theme_name;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:_model.image_detail]];
}

@end
