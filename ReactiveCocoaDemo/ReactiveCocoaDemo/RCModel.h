//
//  RCModel.h
//  ReactiveCocoaDemo
//
//  Created by 王伟虎 on 2017/10/10.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCModel : NSObject

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
