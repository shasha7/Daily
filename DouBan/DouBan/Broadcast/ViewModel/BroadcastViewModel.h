//
//  BroadcastViewModel.h
//  DouBan
//
//  Created by 王伟虎 on 2017/10/4.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface BroadcastViewModel : NSObject

@property (nonatomic, strong, readonly) RACCommand *communityRequest;

@end
