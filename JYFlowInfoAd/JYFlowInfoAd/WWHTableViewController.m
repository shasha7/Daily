//
//  WWHTableViewController.m
//  JYFlowInfoAd
//
//  Created by 王伟虎 on 2017/11/6.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import "WWHTableViewController.h"
#import "JYADTableViewCell.h"
#import "WWHTableViewCell.h"
#import "JYFlowInfoManager.h"

@interface WWHTableViewController ()<JYADTableViewCellDelegate>

@property (nonatomic, strong) JYADTableViewCell *flowInfoCell;

@end

@implementation WWHTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.tableView registerClass:[WWHTableViewCell class] forCellReuseIdentifier:@"Custom"];
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
    if (indexPath.row == 2) {
        static NSString *identifier = @"AD";
        JYADTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[JYADTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier indexPath:indexPath];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"wwh-%ld-ad", (long)indexPath.row];
        cell.delegate = self;
        self.flowInfoCell = cell;
        return cell;
    }
    WWHTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Custom" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"wwh-%ld", (long)indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 2) {
        NSLog(@"点击广告统计");
    }
}

- (void)adTableViewCell:(JYADTableViewCell *)cell initIsDispalyFlowInfo:(BOOL)isDisplay {
    if (isDisplay) {
        NSLog(@"初次展示");
    }
}

#pragma mark UIScrollViewDelegate

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

@end
