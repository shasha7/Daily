//
//  WWHAudioRemoteFile.m
//  WWHPlayer
//
//  Created by wangweihu on 2018/3/27.
//  Copyright © 2018年 wangweihu. All rights reserved.
//

#import "WWHAudioRemoteFile.h"
#import <MobileCoreServices/MobileCoreServices.h>
@implementation WWHAudioRemoteFile

+ (NSString *)cachePathWithURL:(NSURL *)url {
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    return [docPath stringByAppendingPathComponent:url.absoluteString];
}

+ (BOOL)cacheIsExists:(NSURL *)url {
    if (![self cachePathWithURL:url]) {
        return NO;
    }
    return [[NSFileManager defaultManager] fileExistsAtPath:[self cachePathWithURL:url]];
}

+ (long long)cacheSizeWithURL:(NSURL *)url {
    if (![self cacheIsExists:url]) {
        return 0;
    }
    NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:[self cachePathWithURL:url] error:nil];
    return [[dict objectForKey:NSFileSize] longLongValue];
}

+ (NSString *)contentTypeWithURL:(NSURL *)url {
    NSString *strPath = [self cachePathWithURL:url];
    CFStringRef str = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef _Nonnull)(strPath.pathExtension), NULL);
    return CFBridgingRelease(str);
}

+ (NSString *)tmpPathWithURL:(NSURL *)url {
    return [NSTemporaryDirectory() stringByAppendingPathComponent:url.absoluteString];
}

+ (BOOL)tmpIsExists:(NSURL *)url {
    if (![self tmpPathWithURL:url]) {
        return NO;
    }
    return [[NSFileManager defaultManager] fileExistsAtPath:[self tmpPathWithURL:url]];
}

+ (long long)tmpSizeWithURL:(NSURL *)url {
    if (![self tmpIsExists:url]) {
        return 0;
    }
    NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:[self tmpPathWithURL:url] error:nil];
    return [[dict objectForKey:NSFileSize] longLongValue];
}

+ (BOOL)moveToCachePath:(NSURL *)url {
    return [[NSFileManager defaultManager] moveItemAtPath:[self tmpPathWithURL:url] toPath:[self cachePathWithURL:url] error:nil];
}

+ (BOOL)clearTmpPath:(NSURL *)url {
    return [[NSFileManager defaultManager] removeItemAtPath:[self tmpPathWithURL:url] error:nil];
}
@end
