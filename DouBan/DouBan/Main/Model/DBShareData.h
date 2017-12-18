//
//  DBShareData.h
//  DouBan
//
//  Created by 王伟虎 on 2017/12/18.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceInfo.h"

@interface DBShareData : NSObject

+ (instancetype)sharedShareData;

@property (nonatomic, strong) DeviceInfo *deviceInfo;
@property (nonatomic, copy) NSString *idfa;
@end
