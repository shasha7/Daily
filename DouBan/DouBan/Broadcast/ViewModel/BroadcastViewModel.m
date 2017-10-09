//
//  BroadcastViewModel.m
//  DouBan
//
//  Created by 王伟虎 on 2017/10/4.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import "BroadcastViewModel.h"
#import <AFNetworking/AFNetworking.h>
#import "BroadcastCommunityModel.h"

@interface BroadcastViewModel ()

@property (nonatomic, strong, readwrite) RACCommand *communityRequest;

@end
@implementation BroadcastViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _communityRequest = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [[AFHTTPSessionManager manager] GET:@"http://d.api.budejie.com/forum/subscribe/bs0315-iphone-4.5.7.json" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * responseObject) {
                NSArray *communityArray = [responseObject objectForKey:@"list"];
                [subscriber sendNext:communityArray];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [subscriber sendNext:error];
            }];
            return nil;
        }];
        return signal;
    }];
}

@end
