//
//  WWHAssetResourceLoader.m
//  WWHPlayer
//
//  Created by wangweihu on 2018/3/27.
//  Copyright © 2018年 wangweihu. All rights reserved.
//

#import "WWHAssetResourceLoader.h"
#import "WWHAudioRemoteFile.h"
#import "WWHAudioDownLoader.h"


@interface WWHAssetResourceLoader ()

@property (nonatomic, strong) WWHAudioDownLoader *audioDownLoader;

@end

@implementation WWHAssetResourceLoader

- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest {
    
    NSLog(@"loadingRequest = %@", loadingRequest);
    
    // 1.先看缓存中是否存在文件
    if ([WWHAudioRemoteFile cacheIsExists:loadingRequest.request.URL]) {
        loadingRequest.contentInformationRequest.contentLength = [WWHAudioRemoteFile cacheSizeWithURL:loadingRequest.request.URL];
        loadingRequest.contentInformationRequest.contentType = [WWHAudioRemoteFile contentTypeWithURL:loadingRequest.request.URL];
        loadingRequest.contentInformationRequest.byteRangeAccessSupported = YES;
        
        NSData *date = [NSData dataWithContentsOfFile:[WWHAudioRemoteFile cachePathWithURL:loadingRequest.request.URL] options:NSDataReadingMappedIfSafe error:nil];
        
        [loadingRequest.dataRequest respondWithData:[date subdataWithRange:NSMakeRange(loadingRequest.dataRequest.requestedOffset, loadingRequest.dataRequest.requestedLength)]];

        [loadingRequest finishLoading];
        return YES;
    }
    
    // 2.缓存不存在，查看是否有正在下载的任务
    self.audioDownLoader = [WWHAudioDownLoader new];
    if (self.audioDownLoader.loadedSize == 0) {
        [self.audioDownLoader downloadWithURL:loadingRequest.request.URL offset:loadingRequest.dataRequest.requestedOffset];
        return YES;
    }
    
    return YES;
}


@end
