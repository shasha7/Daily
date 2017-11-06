//
//  JYADTableViewCell.h
//  JYFlowInfoAd
//
//  Created by 王伟虎 on 2017/11/6.
//  Copyright © 2017年 wwh. All rights reserved.
//
/*
 使用说明:
 ①在cellForRowAtIndexPath:方法中正确设置cell的delegete为当前控制器之后需在UIScrollView代理方法中设置cell是否可见、是否进行统计
 ②在点击cell如需进行跳转可在控制器的didSelectRowAtIndexPath:方法中进行设置

 - (void)scrollViewDidScroll:(UIScrollView *)scrollView {
     // 判断是否可见
     [JYADTableViewCell flowCell:self.flowInfoCell judgeVisible:self.tableView];
 }
 
 - (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
     // 手指滑动离开屏幕动画结束调用
     // called when scroll view grinds to a halt
     [JYADTableViewCell flowCell:self.flowInfoCell statistics:^{
         NSLog(@"展示统计");
     }];
 }
 
 - (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
     // end dragging
     // decelerate is true if it will continue moving afterwards
     if (!decelerate) {
         [JYADTableViewCell flowCell:self.flowInfoCell statistics:^{
             NSLog(@"展示统计");
         }];
     }
 }
 */

#import <UIKit/UIKit.h>

@class JYADTableViewCell;

@protocol JYADTableViewCellDelegate<NSObject>

/**
 * 代理方法
 * 初始化时是否可见
 */
- (void)adTableViewCell:(JYADTableViewCell *)cell initIsDispalyFlowInfo:(BOOL)isDisplay;

@end

@interface JYADTableViewCell : UITableViewCell

/**
 * 是否可见
 */
@property (nonatomic, readonly, assign) BOOL isVisible;

/**
 * 是否进行统计
 */
@property (nonatomic, readonly, assign) BOOL isStatistics;

/**
 * 代理
 */
@property (nonatomic, weak) id<JYADTableViewCellDelegate>delegate;

/**
 * 判断cell是否可见
 * @param    cell       信息流广告cell
 * @param    tableView  信息流广告cell的父视图
 */
+ (void)flowCell:(JYADTableViewCell *)cell judgeVisible:(UITableView *)tableView;

/**
 * 判断cell是否可见
 * @param    cell        信息流广告cell
 * @param    statistics  统计行为回调
 */
+ (void)flowCell:(JYADTableViewCell *)cell statistics:(void(^)(void))statistics;

/**
 * 初始化方法
 * @param    style            信息流广告cell样式
 * @param    reuseIdentifier  cell重用标识
 * @param    indexPath        cell在tableView中的位置
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier indexPath:(NSIndexPath *)indexPath;

@end
