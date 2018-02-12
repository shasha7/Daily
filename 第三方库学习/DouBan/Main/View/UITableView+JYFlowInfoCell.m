//
//  UITableView+JYFlowInfoCell.m
//  JYFlowInfoAd
//
//  Created by 王伟虎 on 2017/11/16.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import "UITableView+JYFlowInfoCell.h"
#import <objc/runtime.h>

const char *kMonitorArrayKey = "kMonitorArrayKey";
const char *kMonitorVisibleArrayKey = "kMonitorVisibleArrayKey";

@implementation UITableView (JYFlowInfoCell)

- (void)setMonitorVisibleArray:(NSMutableArray *)monitorVisibleArray {
        objc_setAssociatedObject(self, &kMonitorVisibleArrayKey, monitorVisibleArray, OBJC_ASSOCIATION_RETAIN);
}

- (NSMutableArray *)monitorVisibleArray {
    return objc_getAssociatedObject(self, &kMonitorVisibleArrayKey);
    
}

- (void)setMonitorArray:(NSMutableArray *)monitorArray {
    objc_setAssociatedObject(self, &kMonitorArrayKey, monitorArray, OBJC_ASSOCIATION_RETAIN);
}

- (NSMutableArray *)monitorArray {
    return objc_getAssociatedObject(self, &kMonitorArrayKey);
}

- (void)jy_monitorDisplay {
    // 记录可见区域内需要统计的索引
    [self visibleCells];
    NSArray *visibleArray = [self indexPathsForVisibleRows];
    NSMutableArray *monitorVisibleArray = [NSMutableArray array];
    for (NSIndexPath *visibleIndexPath in visibleArray) {
        for (NSIndexPath *monitorIndexPath in [self monitorArray]) {
            if (visibleIndexPath == monitorIndexPath) {
                [monitorVisibleArray addObject:visibleIndexPath];
            }
        }
    }
    [self setMonitorVisibleArray:monitorVisibleArray];
}

- (void)jy_tableView:(UITableView *)tableView cellForIndexPath:(NSIndexPath *)indexPath isMonitor:(BOOL)isMonitor {
    // 记录存储需要统计的索引
    NSMutableArray *monitorArray = [self monitorArray];
    if (!monitorArray) {
        monitorArray = [NSMutableArray array];
    }
    if (isMonitor && ![monitorArray containsObject:indexPath]) {
        [monitorArray addObject:indexPath];
    }
    [self setMonitorArray:monitorArray];
}

- (void)jy_monitorDisplayWithStatisticsBlock:(void(^)(void))block {
    // 进行统计
    // 一屏cell里面的可见统计cell
    [self visibleCells];
    NSArray *visibleArray = [self indexPathsForVisibleRows];
    NSIndexPath *topLimit = visibleArray.firstObject;
    NSIndexPath *bottomLimit = visibleArray.lastObject;
    if (topLimit == bottomLimit) {
        if ([[self monitorVisibleArray] containsObject:topLimit]) {
            
        }
    }else {
        
    }
    
}

@end

