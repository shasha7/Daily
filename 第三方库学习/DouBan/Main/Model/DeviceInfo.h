//
//  DeviceInfo.h
//  DouBan
//
//  Created by 王伟虎 on 2017/12/18.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceInfo : NSObject

@property (nonatomic, copy) NSString *appVer;
@property (nonatomic, copy) NSString *appLang;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, assign) NSInteger deviceID;

@end
