//
//  BroadcastViewModel.m
//  DouBan
//
//  Created by 王伟虎 on 2017/10/4.
//  Copyright © 2017年 wwh. All rights reserved.
//
/**
 要使用常规的AFN网络访问
 1. AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    所有的网络请求,均有manager发起
 2. 需要注意的是,默认提交请求的数据是二进制的,返回格式是JSON
    1> 如果提交数据是JSON的,需要将请求格式设置为AFJSONRequestSerializer
    2> 如果返回格式不是JSON的,
 3. 请求格式
    AFHTTPRequestSerializer            二进制格式
    AFJSONRequestSerializer            JSON
    AFPropertyListRequestSerializer    PList(是一种特殊的XML,解析起来相对容易)
 4. 返回格式
    AFHTTPResponseSerializer           二进制格式
    AFJSONResponseSerializer           JSON
    AFXMLParserResponseSerializer      XML,只能返回XMLParser,还需要自己通过代理方法解析
    AFXMLDocumentResponseSerializer    (Mac OS X)
    AFPropertyListResponseSerializer   PList
    AFImageResponseSerializer          Image
    AFCompoundResponseSerializer       组合
 */

#import "BroadcastViewModel.h"
#import "DBRequestManager.h"
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
            // 集合的使用
            // 1.遍历字典
            NSDictionary *params = @{@"token":@"dadwadwad",
                                     @"uid":@"13123124414"};
            [params.rac_sequence.signal subscribeNext:^(RACTuple *x) {
                RACTupleUnpack(NSString *key, NSString *value) = x;
                NSLog(@"key=%@,value=%@", key, value);
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
