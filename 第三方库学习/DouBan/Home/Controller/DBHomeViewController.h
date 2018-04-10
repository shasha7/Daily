//
//  DBHomeViewController.h
//  DouBan
//
//  Created by 王伟虎 on 2017/10/2.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import "DBTableViewController.h"
#import "DBHomeModel.h"
#import "DBHomeSecondModel.h"

@interface DBHomeViewController : DBTableViewController

@property (nonatomic, strong) DBHomeModel *model;
@property (nonatomic, strong) DBHomeSecondModel *secondModel;

//- (void)testMessageSendMechanism;

@end
