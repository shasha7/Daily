//
//  WWHAudioDownLoader.m
//  WWHPlayer
//
//  Created by wangweihu on 2018/3/27.
//  Copyright © 2018年 wangweihu. All rights reserved.
//

#import "WWHAudioDownLoader.h"
#import "WWHAudioRemoteFile.h"

@interface WWHAudioDownLoader ()<NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSOutputStream *outputStream;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, assign) long long totalSize;
@property (nonatomic, assign, readwrite) long long loadedSize;

@end

@implementation WWHAudioDownLoader

- (void)downloadWithURL:(NSURL *)url offset:(long long)offset {
    self.url = url;
    [self cleanAndCancel];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    self.session = session;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:0];
    [request setValue:[NSString stringWithFormat:@"bytes=%lld-", offset] forHTTPHeaderField:@"Range"];
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request];
    
    [task resume];
}

- (void)cleanAndCancel {
    [self.session invalidateAndCancel];
    self.session = nil;
    
    [WWHAudioRemoteFile clearTmpPath:self.url];
    self.loadedSize = 0;
}

#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSHTTPURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    self.totalSize = [[response.allHeaderFields objectForKey:@"Content-length"] longLongValue];
    if (!self.totalSize) {
        self.totalSize = [[response.allHeaderFields objectForKey:@"Content-Range"] longLongValue];
    }
    self.outputStream = [NSOutputStream outputStreamToFileAtPath:[WWHAudioRemoteFile tmpPathWithURL:dataTask.response.URL] append:YES];
    [self.outputStream open];
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    if (data.length) {
        self.loadedSize += data.length;
        [self.outputStream write:data.bytes maxLength:data.length];
    }
    
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error {
    if (error) {
        NSLog(@"error = %@", error);
    }else {
        // 只有当临时缓存的文件大小 == 请求数据总大小时才能将文件移动到caches文件夹中
        if ([WWHAudioRemoteFile tmpSizeWithURL:task.response.URL] == self.totalSize) {
            [WWHAudioRemoteFile moveToCachePath:task.response.URL];
        }
    }
}

@end
