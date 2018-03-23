#import <Foundation/Foundation.h>

FOUNDATION_EXPORT double FMDBVersionNumber;
FOUNDATION_EXPORT const unsigned char FMDBVersionString[];

#import "FMDatabase.h"
#import "FMResultSet.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabaseQueue.h"
#import "FMDatabasePool.h"

/*
 FMResultSet 表示FMDatabase执行查询之后的结果集
 FMDatabase 表示一个单独的SQLite数据库操作实例，通过它可以对数据库进行增删改查等等操作
 FMDatabaseAdditions 扩展FMDatabase类，新增对查询结果只返回单个值的方法进行简化，对表、列是否存在，版本号，校验SQL等等功能。
 FMDatabaseQueue 使用串行队列，对多线程的操作进行了支持
 */
