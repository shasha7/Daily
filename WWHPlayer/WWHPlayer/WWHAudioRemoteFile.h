//
//  WWHAudioRemoteFile.h
//  WWHPlayer
//
//  Created by wangweihu on 2018/3/27.
//  Copyright © 2018年 wangweihu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WWHAudioRemoteFile : NSObject

+ (NSString *)cachePathWithURL:(NSURL *)url;
+ (BOOL)cacheIsExists:(NSURL *)url;
+ (long long)cacheSizeWithURL:(NSURL *)url;

+ (NSString *)contentTypeWithURL:(NSURL *)url;
+ (BOOL)moveToCachePath:(NSURL *)url;
+ (BOOL)clearTmpPath:(NSURL *)url;

+ (NSString *)tmpPathWithURL:(NSURL *)url;
+ (BOOL)tmpIsExists:(NSURL *)url;
+ (long long)tmpSizeWithURL:(NSURL *)url;

@end
