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
#import <YYCache/YYCache.h>

@interface DBBroadcastViewController ()

@property (nonatomic, strong) BroadcastViewModel *viewModel;
@property (nonatomic, strong) NSArray *source;
@property (nonatomic, strong) YYCache *yyCache;

@end

@implementation DBBroadcastViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"广播";
        self.yyCache = [[YYCache alloc] initWithName:@"广播"];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.viewModel = [[BroadcastViewModel alloc] init];
    RACSignal *signal = [self.viewModel.communityRequest execute:nil];
    [signal subscribeNext:^(NSArray *communityDictArray) {
        self.source = [communityDictArray copy];
        for (BroadcastCommunityModel *model in [communityDictArray copy]) {
            [self.yyCache setObject:model.info forKey:model.theme_name];
        }
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.source.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    BroadcastCommunityModel *model = [self.source objectAtIndex:indexPath.row];
    cell.textLabel.text = model.theme_name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
