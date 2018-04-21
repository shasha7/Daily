//
//  DBVideoViewController.m
//  DouBan
//
//  Created by wangweihu on 2018/4/19.
//  Copyright © 2018年 wwh. All rights reserved.
//

#import "DBVideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>

@interface DBVideoViewController ()<AVAudioPlayerDelegate>

@property (nonatomic) AVURLAsset *asset;
@property (nonatomic, strong) AVSpeechSynthesizer *synthesizer;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, copy) NSArray *metaDataArray;
@property (nonatomic, copy) NSDictionary *metaDataDict;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation DBVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Little Bit Better.mp3" withExtension:nil];
    
    // 封面
    [self createUI];
    
    // 获取元数据
    [self getMetaData:url];
    
    // 播放音乐
    [self createMP3:url];
}

- (void)createUI {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    self.imageView = imageView;
}

- (void)createMP3:(NSURL *)url {
    if (!url) {
        return;
    }
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    NSError *error;
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url fileTypeHint:AVFileTypeMPEGLayer3 error:&error];
    player.delegate = self;
    player.numberOfLoops = -1;
    [player play];
    self.player = player;
    
    // 监听打断事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(interruption:) name:AVAudioSessionInterruptionNotification object:nil];
    
    // 锁屏信息显示
    UIImage *image = (UIImage *)self.metaDataDict[@"artwork"];
    if (!image) {
        image = [UIImage imageNamed:@"db_tab_broadcast_selected"];
    }
    self.imageView.image = image;
    
    // 注意：这里设置的图片太大会造成无法显示远程控制控件
    MPMediaItemArtwork *artWork = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"db_tab_broadcast_selected"]];
    /*
     MPMediaItemPropertyAlbumTitle
     MPMediaItemPropertyAlbumTrackCount
     MPMediaItemPropertyAlbumTrackNumber
     MPMediaItemPropertyArtist
     MPMediaItemPropertyArtwork
     MPMediaItemPropertyComposer
     MPMediaItemPropertyDiscCount
     MPMediaItemPropertyDiscNumber
     MPMediaItemPropertyGenre
     MPMediaItemPropertyPersistentID
     MPMediaItemPropertyPlaybackDuration
     MPMediaItemPropertyTitle
     */
    NSDictionary *mediaDict = @{
        MPMediaItemPropertyTitle:self.metaDataDict[@"title"],
        MPMediaItemPropertyMediaType:@(MPMediaTypeAnyAudio),
        MPMediaItemPropertyPlaybackDuration:@(self.player.duration),
        MPNowPlayingInfoPropertyPlaybackRate:@1.0,
        MPNowPlayingInfoPropertyElapsedPlaybackTime:@(self.player.currentTime),
        MPMediaItemPropertyAlbumArtist:self.metaDataDict[@"artist"]?:@"",
        MPMediaItemPropertyArtist:self.metaDataDict[@"artist"]?:@"",
        MPMediaItemPropertyArtwork:artWork
                                };
    NSLog(@"mediaDict = %@", mediaDict);
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:mediaDict];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

#pragma mark - NSNotification

- (void)interruption:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    AVAudioSessionInterruptionOptions shouldResume = [userInfo[AVAudioSessionInterruptionOptionKey] unsignedIntegerValue];
    AVAudioSessionInterruptionType type = [userInfo[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
    
    if (shouldResume == AVAudioSessionInterruptionOptionShouldResume) {
        
    }
    
    switch (type) {
        case AVAudioSessionInterruptionTypeBegan:{
            NSLog(@"AVAudioSessionInterruptionTypeBegan");
            // 暂停播放
            if (self.player.isPlaying) {
                [self.player pause];
            }
        }
        break;
        case AVAudioSessionInterruptionTypeEnded:{
            NSLog(@"AVAudioSessionInterruptionTypeEnded");
            // 继续播放
            if (!self.player.isPlaying) {
                [self.player play];
            }
        }
        break;
        default:
        break;
    }
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSLog(@"audioPlayerDidFinishPlaying");
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error {
    NSLog(@"error = %@", error.description);
}

#pragma mark - override UIResponder Methods

- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent {
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        switch (receivedEvent.subtype) {
            case UIEventSubtypeRemoteControlPlay:
                [self.player play];
                break;
            case UIEventSubtypeRemoteControlPause:
                [self.player pause];
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                NSLog(@"播放下一首");
                break;
            default:
                NSLog(@"没有处理过这个事件------receivedEvent.subtype == %ld",(long)receivedEvent.subtype);
                break;
        }
    }
}

#pragma mark - 获取音视频元数据

- (void)getMetaData:(NSURL *)url {
    if (!url) {
        return;
    }
    AVURLAsset *asset = [AVURLAsset assetWithURL:url];
    
    /*
     options字典可用的key值
     AVURLAssetPreferPreciseDurationAndTimingKey 对应的value值是BOOL值 是否准确提供时长与当前播放时间
     AVURLAssetReferenceRestrictionsKey 对应的值是一下NS_OPTIONS枚举值
         typedef NS_OPTIONS(NSUInteger, AVAssetReferenceRestrictions) {
             AVAssetReferenceRestrictionForbidNone = 0UL,
             AVAssetReferenceRestrictionForbidRemoteReferenceToLocal = (1UL << 0),
             AVAssetReferenceRestrictionForbidLocalReferenceToRemote = (1UL << 1),
             AVAssetReferenceRestrictionForbidCrossSiteReference = (1UL << 2),
             AVAssetReferenceRestrictionForbidLocalReferenceToLocal = (1UL << 3),
             AVAssetReferenceRestrictionForbidAll = 0xFFFFUL,
         };含义是当资源引用了外部的其他资源时是否要禁止访问
     AVURLAssetHTTPCookiesKey 当从HTTP加载资源时，https请求需要的额外cookies
     AVURLAssetAllowsCellularAccessKey 对应的value值是BOOL值 默认YES 是否允许使用移动网络 iOS10之后可以使用
     */
    asset = [AVURLAsset URLAssetWithURL:url options:@{AVURLAssetPreferPreciseDurationAndTimingKey:@(YES)}];
    self.asset = asset;
    NSArray *keys = @[@"availableMetadataFormats", @"duration", @"commonMetadata"];
    NSMutableArray *metaDataItems = [NSMutableArray array];
    [asset loadValuesAsynchronouslyForKeys:keys completionHandler:^{
        AVKeyValueStatus status0 = [asset statusOfValueForKey:@"duration" error:nil];
        if (status0 == AVKeyValueStatusLoaded) {
            NSLog(@"duration = %@", @(1.0 * asset.duration.value/asset.duration.timescale/60));
        }
        
        AVKeyValueStatus commonStatus = [asset statusOfValueForKey:@"commonMetadata" error:nil];
        if (commonStatus == AVKeyValueStatusLoaded) {
            [metaDataItems addObjectsFromArray:asset.commonMetadata];
        }
        
        AVKeyValueStatus formatsStatus = [asset statusOfValueForKey:@"availableMetadataFormats" error:nil];
        if (formatsStatus == AVKeyValueStatusLoaded) {
            for (AVMetadataFormat format in asset.availableMetadataFormats) {
                [metaDataItems addObjectsFromArray:[asset metadataForFormat:format]];
            }
        }
        
        NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
        for (AVMetadataItem *item in metaDataItems) {
            AVMetadataItem *item1 = [[AVMetadataItem metadataItemsFromArray:metaDataItems withKey:item.commonKey keySpace:AVMetadataKeySpaceCommon] firstObject];
            
            // AVMetadataCommonKeyTitle 字符串 Little Bit Better
            //
            UIImage *image = nil;
            if ([item.commonKey isEqualToString:@"artwork"]) {
                if ([item1.value isKindOfClass:[NSData class]]) {                        // 1
                    image = [[UIImage alloc] initWithData:item.dataValue];
                } else if ([item.value isKindOfClass:[NSDictionary class]]) {             // 2
                    NSDictionary *dict = (NSDictionary *)item.value;
                    image = [[UIImage alloc] initWithData:dict[@"data"]];
                }
                [mutableDict setObject:image?:[NSNull null] forKey:item.commonKey?:@"nil_key"];
                NSLog(@"key = %@,item = %@", item.commonKey, image);
                continue;
            }
            [mutableDict setObject:item1.value?:[NSNull null] forKey:item.commonKey?:@"nil_key"];
            NSLog(@"key = %@,item = %@", item.commonKey, item1.value);
        }
        self.metaDataDict = [mutableDict copy];
    }];
}

#pragma mark - 文本转语音

- (void)textToAudio {
    [self speechInit];
    
    [self startSpeech];
}

- (void)speechInit {
    AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc] init];
    self.synthesizer = synthesizer;
}

- (void)startSpeech {
    AVSpeechSynthesisVoice *usVoice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
    
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@"我就看看不说话我就看看不说话我就看看不说话我就看看不说话我就看看不说话我就看看不说话我就看看不说话我就看看不说话"];
    utterance.rate = AVSpeechUtteranceDefaultSpeechRate;
    utterance.volume = 0.6f;
    utterance.pitchMultiplier = 1;
    utterance.voice = usVoice;
    
    [self.synthesizer speakUtterance:utterance];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // pause之后可以重新开始，但是stop事后不能继续播放，只能再次调用speakUtterance:
        [self.synthesizer pauseSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.synthesizer continueSpeaking];
    });
    // 查看支持的语种
//    NSLog(@"%@", [AVSpeechSynthesisVoice speechVoices]);
}

- (void)createVoices {
    AVSpeechSynthesisVoice *usVoice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"];
    //    usVoice.quality = AVSpeechSynthesisVoiceQualityEnhanced;//只读属性
    if (@available(iOS 9.0, *)) {
        [usVoice setValue:@(AVSpeechSynthesisVoiceQualityEnhanced) forKey:@"quality"];
    } else {
        // Fallback on earlier versions
    }
}

@end
