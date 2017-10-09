//
//  BroadcastCommunityModel.h
//  DouBan
//
//  Created by 王伟虎 on 2017/10/4.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BroadcastCommunityModel : NSObject
/*
 {
 "info": "\u69fd\u70b9\u6ee1\u6ee1\u7684\u793e\u4f1a\u4e8b\u4ef6 ",
 "theme_name": "\u793e\u4f1a\u65b0\u95fb",
 "image_detail": "http://img.spriteapp.cn/ugc/2017/08/cefd32d48c6111e7b08e842b2b4c75ab.png",
 "visit": 48,
 "post_num": 47826,
 "image_list": "http://img.spriteapp.cn/ugc/2017/08/cf0389c28c6111e7b08e842b2b4c75ab.png",
 "colum_set": 1,
 "is_sub": 0,
 "tail": "\u540d\u5c0f\u8bb0\u8005",
 "today_topic_num": 36,
 "sub_number": 113774,
 "theme_id": 473,
 "display_level": 0
 }
 */

@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSString *theme_name;
@property (nonatomic, copy) NSString *image_detail;
@property (nonatomic, copy) NSString *image_list;
@property (nonatomic, copy) NSString *tail;
@property (nonatomic, assign) NSInteger visit;
@property (nonatomic, assign) NSInteger post_num;
@property (nonatomic, assign) NSInteger colum_set;
@property (nonatomic, assign) NSInteger is_sub;
@property (nonatomic, assign) NSInteger today_topic_num;
@property (nonatomic, assign) NSInteger sub_number;
@property (nonatomic, assign) NSInteger theme_id;
@property (nonatomic, assign) NSInteger display_level;

+ (instancetype)communityModelWithDict:(NSDictionary *)dict;

@end
