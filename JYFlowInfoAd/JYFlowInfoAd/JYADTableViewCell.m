//
//  JYADTableViewCell.m
//  JYFlowInfoAd
//
//  Created by 王伟虎 on 2017/11/6.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import "JYADTableViewCell.h"

@interface JYADTableViewCell ()

@property (nonatomic, readwrite, assign) BOOL isDisplay;
@property (nonatomic, readwrite, assign) BOOL isStatistics;

@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation JYADTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier indexPath:(NSIndexPath *)indexPath {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 广告位置
        self.indexPath = indexPath;
        
        // 默认无统计行为
        self.isStatistics = NO;
        
        // 默认初始化
        [self commonInit];
    }
    return self;
}

- (void)setDelegate:(id<JYADTableViewCellDelegate>)delegate {
    _delegate = delegate;
    if ([delegate isKindOfClass:[UIViewController class]]
        ) {
        UITableView *tableView = nil;
        UIViewController *vc = (UIViewController *)delegate;
        if ([vc.view isKindOfClass:[UITableView class]]) {
            tableView = (UITableView *)vc.view;
        }
        
        if (!tableView) {
            return;
        }
        
        // 初始化是否展示了cell在可见区域
        [tableView visibleCells];
        NSArray *visibleArray = [tableView indexPathsForVisibleRows];
        NSMutableArray *adArray = [NSMutableArray array];
        for (NSIndexPath *indexPath in visibleArray) {
            if (indexPath == self.indexPath) {
                [adArray addObject:indexPath];
            }
        }
        if (adArray.count) {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                if (self.delegate && [self.delegate respondsToSelector:@selector(adTableViewCell:initIsDispalyFlowInfo:)]) {
                    [self.delegate adTableViewCell:self initIsDispalyFlowInfo:YES];
                }
            });
        }else {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                if (self.delegate && [self.delegate respondsToSelector:@selector(adTableViewCell:initIsDispalyFlowInfo:)]) {
                    [self.delegate adTableViewCell:self initIsDispalyFlowInfo:NO];
                }
            });
        }
        [adArray removeAllObjects];
    }
}

+ (void)flowCell:(JYADTableViewCell *)cell judgeVisible:(UITableView *)tableView {
    [tableView visibleCells];
    NSArray *visibleArray = [tableView indexPathsForVisibleRows];
    NSMutableArray *adArray = [NSMutableArray array];
    for (NSIndexPath *indexPath in visibleArray) {
        if (indexPath == cell.indexPath) {
            [adArray addObject:indexPath];
        }
    }
    if (adArray.count) {
        cell.isDisplay = YES;
        [adArray removeAllObjects];
    }else {
        cell.isDisplay = NO;
        cell.isStatistics = YES;
        [adArray removeAllObjects];
    }
}

+ (void)flowCell:(JYADTableViewCell *)cell statistics:(void(^)(void))statistics {
    if (cell.isDisplay && cell.isStatistics) {
        cell.isStatistics = NO;
        if (statistics) {
            statistics();
        }
    }
}

#pragma mark - 供子类调用

- (void)commonInit {
    
}

@end
