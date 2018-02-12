//
//  DBViewController.h
//  DouBan
//
//  Created by 王伟虎 on 2017/10/2.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBRequestManager.h"

@interface DBViewController : UIViewController

/**
 * 网络请求管理类
 */
@property (nonatomic, strong) DBRequestManager *requestManager;

@end
