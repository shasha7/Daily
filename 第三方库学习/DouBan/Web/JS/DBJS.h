//
//  DBJS.h
//  DouBan
//
//  Created by wangweihu on 2018/4/6.
//  Copyright © 2018年 wwh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol DBJSMethods <JSExport>

- (NSString *)getClientId;
- (NSString *)getVersionId;
- (NSString *)getChannelId;

@end

@interface DBJS : NSObject <DBJSMethods>

@end
