//
//  WWHTableViewController.m
//  JYFlowInfoAd
//
//  Created by 王伟虎 on 2017/11/6.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import "WWHTableViewController.h"
#import "WWHTableViewCell.h"
#import "UITableView+JYFlowInfoCell.h"
#import "JYApplication.h"

static NSString *const kNormalIdentifier = @"Custom";

@interface WWHTableViewController ()

@end

@implementation WWHTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.tableView registerClass:[WWHTableViewCell class] forCellReuseIdentifier:kNormalIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WWHTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNormalIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"wwh-%ld", (long)indexPath.row];
    if (indexPath.row == 1) {
        cell.jy_isMonitorDisplayCell = YES;
        [cell jy_tableView:tableView cellForIndexPath:indexPath determineVisible:^(BOOL isVisible) {
            if (isVisible) {
                NSLog(@"首次加载在屏幕上可见");
            }
        }];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 判断是否可见
    [[JYApplication sharedApplication] sendAction:@selector(scrollViewDidScroll:) to:self from:scrollView forEvent:nil];
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

@end
