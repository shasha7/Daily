//
//  DBBroadcastViewController.m
//  DouBan
//
//  Created by 王伟虎 on 2017/10/2.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import "DBBroadcastViewController.h"
#import "BroadcastViewModel.h"
#import "BroadcastCommunityModel.h"
#import "DBBroadcastCell.h"

@interface DBBroadcastViewController ()

@property (nonatomic, strong) BroadcastViewModel *viewModel;
@property (nonatomic, strong) NSArray *source;

@end

@implementation DBBroadcastViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"广播";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupTableView];
    [self getData];
}

- (void)setupTableView {
    self.tableView.rowHeight = 80.0f;
}

- (void)getData {
    self.viewModel = [[BroadcastViewModel alloc] init];
    RACSignal *signal = [self.viewModel.communityRequest execute:nil];
    [signal subscribeNext:^(NSArray *communityDictArray) {
        self.source = [communityDictArray copy];
        [self.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.source.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    DBBroadcastCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell) {
        cell = [[DBBroadcastCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    BroadcastCommunityModel *model = [self.source objectAtIndex:indexPath.row];
    cell.model = model;
    [cell.subject subscribeNext:^(id x) {
        NSLog(@"按钮被点击了");
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
