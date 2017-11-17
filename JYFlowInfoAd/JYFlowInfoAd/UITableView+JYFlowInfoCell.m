//
//  UITableView+JYFlowInfoCell.m
//  JYFlowInfoAd
//
//  Created by 王伟虎 on 2017/11/16.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import "UITableView+JYFlowInfoCell.h"
#import <objc/runtime.h>

@implementation UITableView (JYFlowInfoCell)

- (void)jy_monitorDisplay {
    [self visibleCells];
    NSArray *visibleArray = [self indexPathsForVisibleRows];
    NSMutableArray *adArray = [NSMutableArray array];
    for (NSIndexPath *indexPath in visibleArray) {
        UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
        if (cell.jy_isMonitorDisplayCell) {
            [adArray addObject:cell];
        }
    }
    if (adArray.count) {
        UITableViewCell *cell = [adArray firstObject];
        cell.jy_isVisible = YES;
    }else {
        UITableViewCell *cell = [adArray firstObject];
        cell.jy_isVisible = NO;
    }
    [adArray removeAllObjects];
}

- (void)jy_monitorDisplayWithStatisticsBlock:(void(^)(void))block {
    [self visibleCells];
    NSArray *visibleArray = [self indexPathsForVisibleRows];
    NSMutableArray *adArray = [NSMutableArray array];
    for (NSIndexPath *indexPath in visibleArray) {
        UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
        if (cell.jy_isMonitorDisplayCell) {
            [adArray addObject:cell];
        }
    }
    
    UITableViewCell *cell = [adArray firstObject];
    if (cell.jy_isVisible && cell.jy_isMonitorDisplayCell) {
        cell.jy_isVisible = NO;
        if (block) {
            block();
        }
    }
}

@end

@implementation UITableViewCell (FDTemplateLayoutCell)

- (BOOL)jy_isMonitorDisplayCell {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setJy_isMonitorDisplayCell:(BOOL)jy_isMonitorDisplayCell {
    objc_setAssociatedObject(self, @selector(jy_isMonitorDisplayCell), @(jy_isMonitorDisplayCell), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)jy_isVisible {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setJy_isVisible:(BOOL)jy_isVisible {
    objc_setAssociatedObject(self, @selector(jy_isVisible), @(jy_isVisible), OBJC_ASSOCIATION_RETAIN);
}

- (void)jy_tableView:(UITableView *)tableView cellForIndexPath:(NSIndexPath *)indexPath determineVisible:(void (^)(BOOL isVisible))determineVisible  {
    NSAssert(tableView, @"Expect a existence UITableView instance");
    
    [tableView visibleCells];
    NSArray *indexPathsArray = [tableView indexPathsForVisibleRows];
    NSMutableArray *adArray = [NSMutableArray array];
    for (NSIndexPath *indexP in indexPathsArray) {
        if (indexPath == indexP) {
            [adArray addObject:indexP];
        }
    }
    if (adArray.count) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            determineVisible(YES);
        });
    }else {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            determineVisible(NO);
        });
    }
}

@end

