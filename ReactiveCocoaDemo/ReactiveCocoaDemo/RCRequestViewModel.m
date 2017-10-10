//
//  RCRequestViewModel.m
//  ReactiveCocoaDemo
//
//  Created by 王伟虎 on 2017/10/10.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import "RCRequestViewModel.h"
#import <AFNetworking/AFNetworking.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "RCTableViewCell.h"
#import "RCCellViewModel.h"

static NSString *const ID = @"ReuseIdentifier";

@interface RCRequestViewModel ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong, readwrite) RACCommand *requestCommand;
@property (nonatomic, strong) NSArray *cellVM;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation RCRequestViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [self requestWithSubscriber:subscriber params:nil];
            return nil;
        }];
    }];
    
    [[_requestCommand execute:@(1)] subscribeNext:^(id x) {
        if ([x isKindOfClass:[NSArray class]]) {
            self.cellVM = x;
        }else {
            // 展示错误
            self.cellVM = nil;
        }
        // 刷新tableView
        [self.tableView reloadData];
    }];
}

- (void)bindViewModelWithView:(id)view {
    self.tableView = ((UITableView *)view);
    self.tableView.rowHeight = 100.0f;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[RCTableViewCell class] forCellReuseIdentifier:ID];
}

- (void)requestWithSubscriber:(id)subscriber params:(NSDictionary *)params {
    [[AFHTTPSessionManager manager] GET:@"http://d.api.budejie.com/forum/subscribe/bs0315-iphone-4.5.7.json" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * responseObject) {
        NSArray *communityArray = [responseObject objectForKey:@"list"];
        // 字典转模型
        [subscriber sendNext:[[communityArray.rac_sequence map:^RCCellViewModel *(NSDictionary *value) {
            RCCellViewModel *cellViewModel = [[RCCellViewModel alloc] init];
            cellViewModel.model = [RCModel communityModelWithDict:value];
            return cellViewModel;
        }] array]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [subscriber sendNext:error];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellVM.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    RCCellViewModel *cellViewModel = [self.cellVM objectAtIndex:indexPath.row];
    [cellViewModel bindViewModelWithView:cell];
    return cell;
}

@end
