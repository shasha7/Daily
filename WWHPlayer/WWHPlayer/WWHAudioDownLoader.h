//
//  WWHAudioDownLoader.h
//  WWHPlayer
//
//  Created by wangweihu on 2018/3/27.
//  Copyright © 2018年 wangweihu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WWHAudioDownLoader : NSObject

- (void)downloadWithURL:(NSURL *)url offset:(long long)offset;
@property (nonatomic, assign, readonly) long long loadedSize;

@end
