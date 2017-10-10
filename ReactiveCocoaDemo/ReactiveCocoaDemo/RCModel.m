//
//  RCModel.m
//  ReactiveCocoaDemo
//
//  Created by 王伟虎 on 2017/10/10.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import "RCModel.h"

@implementation RCModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.info = [dict objectForKey:@"info"];
        self.theme_name = [dict objectForKey:@"theme_name"];
        self.image_detail = [dict objectForKey:@"image_detail"];
        self.image_list = [dict objectForKey:@"image_list"];
        self.tail = [dict objectForKey:@"tail"];
        
        self.visit = [[dict objectForKey:@"tail"] integerValue];
        self.post_num = [[dict objectForKey:@"post_num"] integerValue];
        self.colum_set = [[dict objectForKey:@"colum_set"] integerValue];
        self.is_sub = [[dict objectForKey:@"is_sub"] integerValue];
        self.today_topic_num = [[dict objectForKey:@"today_topic_num"] integerValue];
        self.sub_number = [[dict objectForKey:@"sub_number"] integerValue];
        self.theme_id = [[dict objectForKey:@"theme_id"] integerValue];
        self.display_level = [[dict objectForKey:@"display_level"] integerValue];
    }
    return self;
}

+ (instancetype)communityModelWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end
