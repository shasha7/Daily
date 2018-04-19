//
//  Student.h
//  DouBan
//
//  Created by 王伟虎 on 2018/4/19.
//  Copyright © 2018年 wwh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Student : NSObject

@property (nonatomic, copy) NSString *firstname;
@property (nonatomic, copy) NSString *lastname;

+ (instancetype)studentWithFirstname:(NSString *)firstname lastname:(NSString *)lastname;

@end
