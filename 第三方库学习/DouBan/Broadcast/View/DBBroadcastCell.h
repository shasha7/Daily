//
//  DBBroadcastCell.h
//  DouBan
//
//  Created by 王伟虎 on 2018/4/18.
//  Copyright © 2018年 wwh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBHeader.h"

@class BroadcastCommunityModel;

@interface DBBroadcastCell : UITableViewCell

@property (nonatomic, strong) BroadcastCommunityModel *model;
@property (nonatomic, strong) RACSubject *subject;

@end
