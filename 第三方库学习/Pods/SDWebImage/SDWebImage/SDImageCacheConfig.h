/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <Foundation/Foundation.h>
#import "SDWebImageCompat.h"

@interface SDImageCacheConfig : NSObject

/**
 * Decompressing images that are downloaded and cached can improve performance but can consume lot of memory.
 * Defaults to YES. Set this to NO if you are experiencing a crash due to excessive memory consumption.
 * 属性设置为YES后缓存在内存中的图片是经过解压的源文件二进制数据
 * 是否在缓存之前解压图片，此项操作可以提升性能，但是会消耗较多的内存，默认是YES。注意:如果内存不足，可以置为NO
 */
@property (assign, nonatomic) BOOL shouldDecompressImages;

/**
 * disable iCloud backup [defaults to YES]
 * 是否禁止iCloud备份，默认是YES，禁止备份
 */
@property (assign, nonatomic) BOOL shouldDisableiCloud;

/**
 * use memory cache [defaults to YES]
 * 是否启用内存缓存 默认是YES
 */
@property (assign, nonatomic) BOOL shouldCacheImagesInMemory;

/**
 * The reading options while reading cache from disk.
 * Defaults to 0. You can set this to mapped file to improve performance.
 typedef NS_OPTIONS(NSUInteger, NSDataReadingOptions) {
     // iOS不会把整个文件全部读取的内存，而是将文件映射到进程的地址空间中
     NSDataReadingMappedIfSafe = 1UL << 0,
     // 数据将不会存入内存中，对于只会使用一次的数据，这么做会提高性能
     NSDataReadingUncached = 1UL << 1,
     // 数据始终会被存储在内存中
     // 如果用户定义了NSDataReadingMappedIfSafe和这个枚举，那么这个枚举会优先起作用
     NSDataReadingMappedAlways = 1UL << 3,
 }
 */
@property (assign, nonatomic) NSDataReadingOptions diskCacheReadingOptions;

/**
 * The maximum length of time to keep an image in the cache, in seconds.
 * 缓存保留的最长时间，默认为1周
 */
@property (assign, nonatomic) NSInteger maxCacheAge;

/**
 * The maximum size of the cache, in bytes.
 * 缓存最大容量，以字节为单位，默认为0，表示不做限制
 */
@property (assign, nonatomic) NSUInteger maxCacheSize;

@end
