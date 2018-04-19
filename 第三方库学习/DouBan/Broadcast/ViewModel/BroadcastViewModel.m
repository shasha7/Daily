//
//  BroadcastViewModel.m
//  DouBan
//
//  Created by 王伟虎 on 2017/10/4.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import "BroadcastViewModel.h"
#import "DBRequestManager.h"
#import "BroadcastCommunityModel.h"

@interface BroadcastViewModel ()

@property (nonatomic, strong) RACCommand *communityRequest;

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
            // 集合的使用
            // 1.遍历字典
            NSDictionary *params = @{@"token":@"dadwadwad",
                                     @"uid":@"13123124414"};
            // RACTuple使用以及params.rac_sequence.signal的好处
            [params.rac_sequence.signal subscribeNext:^(RACTuple *x) {
//                RACTupleUnpack(NSString *key, NSString *value) = x;
                // NSLog(@"key=%@,value=%@", key, value);
            }];
            
            [[DBRequestManager manager] GET:@"http://d.api.budejie.com/forum/subscribe/bs0315-iphone-4.5.7.json" requestID:@"" parameters:nil success:^(id  _Nullable result) {
                NSArray *communityArray = [result objectForKey:@"list"];
                // 2.字典转模型
                [subscriber sendNext:[[communityArray.rac_sequence map:^BroadcastCommunityModel *(NSDictionary *value) {
                    return [BroadcastCommunityModel communityModelWithDict:value];
                }] array]];
            } failure:^(NSString * _Nonnull errorDesc) {
                [subscriber sendNext:errorDesc];
            }];
            return nil;
        }];
        return signal;
    }];
}

@end
