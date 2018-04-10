//
//  DBSqliteViewController.m
//  DouBan
//
//  Created by 王伟虎 on 2018/4/10.
//  Copyright © 2018年 wwh. All rights reserved.
//

#import "DBSqliteViewController.h"
#import "FMDB.h"
#import "DeviceInfo.h"

@interface DBSqliteViewController ()

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;

@end

@implementation DBSqliteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self fmdbtest];
}

- (void)fmdbtest {
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [doc stringByAppendingPathComponent:@"test.sqlite"];
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:filePath];
    self.dbQueue = queue;
    
    // #1
    dispatch_async(globalQueue, ^{
        // 开辟线程，FMDatabaseQueue内部是串行队列，可以保证顺序执行
        [queue inDatabase:^(FMDatabase * _Nonnull db) {
            for (NSInteger i = 0; i < 15; i++) {
                NSLog(@"2222---%@--%@", @(i), [NSThread currentThread]);
            }
        }];
    });
    // #2
    [queue inDatabase:^(FMDatabase * _Nonnull db) {
        // 主线程调用
        NSLog(@"-----%@", [NSThread currentThread]);
        
        // 开启多线程
        // FMDB的多线程支持实现主要是依赖于FMDatabaseQueue这个类
        dispatch_async(globalQueue, ^{
            // 尽管会开辟线程，但是在子线程中也是顺序执行，WHY???
            for (NSInteger i = 0; i < 15; i++) {
                NSLog(@"1111---%@--%@", @(i), [NSThread currentThread]);
            }
        });
    }];
    // #3
    /*
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
    */
    // #4
    /*
    [queue inDatabase:^(FMDatabase * _Nonnull db) {
        NSLog(@"===========");
        NSMutableArray *users = [[NSMutableArray alloc] init];
        NSString *sql = @"select * from tbl_user";
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            [users addObject:[self rsToDeviceInfo:rs]];
        }
    }];
     */
    
    // 1、2两种情况可以保证并行执行
    // 但是第二种情况是个什么原理？？？ 这是是串行队列在作怪，串行队列线程池数量为1，只能创建1个线程
    // 3、4同时读写存在问题
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

- (void)dispatch_async_dispatch_sync_dispatch_get_global_queue {
    // dispatch_get_global_queue 会开线程 顺序执行
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // dispatch_get_global_queue 会开线程 顺序执行 死锁
    //    queue = dispatch_queue_create("com.wangweihu.serial", nil);
    dispatch_async(queue, ^{
        NSLog(@"任务0 = %@", [NSThread currentThread]);
        
        dispatch_sync(queue, ^{
            NSLog(@"任务1 = %@", [NSThread currentThread]);
            
            dispatch_sync(queue, ^{
                NSLog(@"任务10 = %@", [NSThread currentThread]);
                dispatch_async(queue, ^{
                    NSLog(@"任务11 = %@", [NSThread currentThread]);
                });
                
                dispatch_async(queue, ^{
                    NSLog(@"任务12 = %@", [NSThread currentThread]);
                });
                
                dispatch_async(queue, ^{
                    NSLog(@"任务13 = %@", [NSThread currentThread]);
                });
            });
        });
        
        dispatch_sync(queue, ^{
            NSLog(@"任务2 = %@", [NSThread currentThread]);
        });
        
        dispatch_sync(queue, ^{
            NSLog(@"任务3 = %@", [NSThread currentThread]);
        });
        
        dispatch_sync(queue, ^{
            NSLog(@"任务4 = %@", [NSThread currentThread]);
        });
        
        dispatch_sync(queue, ^{
            NSLog(@"任务5 = %@", [NSThread currentThread]);
        });
    });
}

- (void)dispatch_sync_dispatch_async {
    // dispatch_get_global_queue 会开线程 并行
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // dispatch_get_global_queue 会开线程 顺序执行
    queue = dispatch_queue_create("com.wangweihu.serial", nil);
    dispatch_sync(queue, ^{
        NSLog(@"任务0 = %@", [NSThread currentThread]);
        dispatch_async(queue, ^{
            NSLog(@"任务1 = %@", [NSThread currentThread]);
        });
        
        dispatch_async(queue, ^{
            NSLog(@"任务2 = %@", [NSThread currentThread]);
        });
        
        dispatch_async(queue, ^{
            NSLog(@"任务3 = %@", [NSThread currentThread]);
        });
    });
}

- (void)GCDLock {
    // https://www.jianshu.com/p/bbabef8aa1fe GCD死锁的解释
    dispatch_queue_t queue = dispatch_get_main_queue();
    NSLog(@"%@", [NSThread currentThread]);
    NSLog(@"before");
    // 里面的打印总是在after之后，为什么？？队列是严格的先进先出
    // queue主队列，dispatch_async函数一个特点就是立刻返回不需要等待block执行完毕，是否并行执行任务就看内部targetQueue根据系统情况进行实际的分发
    dispatch_async(queue, ^{
        NSLog(@"thread %@", [NSThread currentThread]);//主线程
        NSLog(@"queue %@", queue);
    });
    NSLog(@"after");
}

@end
