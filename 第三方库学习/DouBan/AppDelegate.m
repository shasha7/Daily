//
//  AppDelegate.m
//  DouBan
//
//  Created by 王伟虎 on 2017/10/1.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import "AppDelegate.h"
#import "DBTabBarController.h"
#import "PAirSandbox.h"
#import "FMDB.h"
#import "DeviceInfo.h"

#define DEBUG 1

@interface AppDelegate ()

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [DBTabBarController new];
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [doc stringByAppendingPathComponent:@"test.sqlite"];
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:filePath];
    self.dbQueue = queue;
    
    // #1
//    dispatch_async(globalQueue, ^{
//        // 开辟线程，FMDatabaseQueue内部是串行队列，可以保证顺序执行
//        [queue inDatabase:^(FMDatabase * _Nonnull db) {
//            for (NSInteger i = 0; i < 15; i++) {
//                NSLog(@"---%@--%@", @(i), [NSThread currentThread]);
//            }
//        }];
//    });
    // #2
//    [queue inDatabase:^(FMDatabase * _Nonnull db) {
//        // 主线程调用
//        NSLog(@"-----%@", [NSThread currentThread]);
//
//        // 开启多线程
//        // FMDB的多线程支持实现主要是依赖于FMDatabaseQueue这个类
//        dispatch_async(globalQueue, ^{
//            // 尽管会开辟线程，但是在子线程中也是顺序执行，WHY???
//            for (NSInteger i = 0; i < 15; i++) {
//                NSLog(@"---%@--%@", @(i), [NSThread currentThread]);
//            }
//        });
//    }];
    // #3
    [queue inDatabase:^(FMDatabase * _Nonnull db) {
        BOOL create = [db executeUpdate:@"create table if not exists \"tbl_user\" (\"_id\" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL , \"name\" VARCHAR(30))"];
        if (create) {
            for (NSInteger i = 0; i < 100; i++) {
                DeviceInfo *info = [[DeviceInfo alloc] init];
                info.appVer = [NSString stringWithFormat:@"wddawwh%@", @(i)];
                info.deviceID = i;
                
                NSDictionary *arguments = @{@"name": info.appVer, @"_id": @(info.deviceID)};
                [db executeUpdate:@"INSERT INTO tbl_user (name, _id) VALUES (:name, :_id)" withParameterDictionary:arguments];
            }
        }
    }];
    
    // #4
    [queue inDatabase:^(FMDatabase * _Nonnull db) {
        NSLog(@"===========");
        NSMutableArray *users = [[NSMutableArray alloc] init];
        NSString *sql = @"select * from tbl_user";
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            [users addObject:[self rsToDeviceInfo:rs]];
        }
    }];
    
    // 1、2两种情况可以保证并行执行
    // 但是第二种情况是个什么原理？？？ 这是是串行队列在作怪，串行队列线程池数量为1，只能创建1个线程
    // 3、4同时读写存在问题
    [self.window makeKeyAndVisible];
#ifdef DEBUG
    [[PAirSandbox sharedInstance] enableSwipe];
#endif
    return YES;
}

- (void)addDeviceInfo:(DeviceInfo *)deviceInfo {
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db open];
        NSString *sql = @"insert into tbl_user(name, password) values (?, ?)";
        [db executeUpdate:sql,deviceInfo.appVer, deviceInfo.deviceID];
        [db close];
    }];
}

- (NSArray *)getUsers; {
    __block NSMutableArray *users = [[NSMutableArray alloc] init];
    [self.dbQueue inDatabase:^(FMDatabase *db)   {
        [db open];
        NSString *sql = @"select * from tbl_user";
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            [users addObject:[self rsToDeviceInfo:rs]];
        }
        [db close];
    }];
    return users;
}

- (DeviceInfo *)rsToDeviceInfo:(FMResultSet *)rs {
    DeviceInfo *deviceInfo = [[DeviceInfo alloc] init];
    deviceInfo.deviceID = [rs intForColumn:@"_id"];
    deviceInfo.appVer = [rs stringForColumn:@"name"];
    return deviceInfo;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
