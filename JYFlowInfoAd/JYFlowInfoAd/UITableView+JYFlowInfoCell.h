//
//  UITableView+JYFlowInfoCell.h
//  JYFlowInfoAd
//
//  Created by 王伟虎 on 2017/11/16.
//  Copyright © 2017年 wwh. All rights reserved.
//

/*
 使用说明:
 ①在cellForRowAtIndexPath:方法中设置那些cell需要进行展示统计
 ②在点击cell如需进行跳转可在控制器的didSelectRowAtIndexPath:方法中进行设置
 ③需要在UIScrollViewDelegate方法中监控cell的消隐
 
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (indexPath.row == 2) {
        cell.jy_isMonitorDisplayCell = YES;//设置第三个cell需要进行展示统计
        [cell jy_tableView:tableView cellForIndexPath:indexPath determineVisible:^(BOOL isVisible) {
            if (isVisible) {
                NSLog(@"首次加载在屏幕上可见");
            }
        }];
    }
    return cell;
 }
 
 - (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 判断是否可见
    [((UITableView *)scrollView) jy_monitorDisplay];
 }
 
 - (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 手指滑动离开屏幕动画结束调用
    // called when scroll view grinds to a halt
    [((UITableView *)scrollView) jy_monitorDisplayWithStatisticsBlock:^{
        NSLog(@"展示统计");
    }];
 }
 
 - (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    // end dragging
    // decelerate is true if it will continue moving afterwards
    if (!decelerate) {
        [((UITableView *)scrollView) jy_monitorDisplayWithStatisticsBlock:^{
            NSLog(@"展示统计");
        }];
    }
 }
 */

#import <UIKit/UIKit.h>

@interface UITableView (JYFlowInfoCell)

/// Statistics behavior.
///
- (void)jy_monitorDisplayWithStatisticsBlock:(void(^)(void))block;

/// Monitor.
///
- (void)jy_monitorDisplay;

@end

@interface UITableViewCell (JYFlowInfoCell)

/// Indicate whether the cell need to monitor displayed statistics.
///
@property (nonatomic, assign) BOOL jy_isMonitorDisplayCell;

/// Indicate whether or not visible
///
@property (nonatomic, assign) BOOL jy_isVisible;

/// When the view is loaded judge the cell whether or not dispaly
///
- (void)jy_tableView:(UITableView *)tableView cellForIndexPath:(NSIndexPath *)indexPath determineVisible:(void (^)(BOOL isVisible))determineVisible;

@end
