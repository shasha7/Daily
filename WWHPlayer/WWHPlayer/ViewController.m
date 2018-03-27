//
//  ViewController.m
//  WWHPlayer
//
//  Created by wangweihu on 2018/3/27.
//  Copyright © 2018年 wangweihu. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "WWHAssetResourceLoader.h"

@interface ViewController ()

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) WWHAssetResourceLoader *assetResourceLoader;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    AVURLAsset *asset = [AVURLAsset assetWithURL:[NSURL URLWithString:@"xxx"]];
    
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
    AVPlayer *player = [AVPlayer playerWithPlayerItem:item];
    self.player = player;
    
    WWHAssetResourceLoader *assetResourceLoader = [[WWHAssetResourceLoader alloc] init];
    self.assetResourceLoader = assetResourceLoader;
    [asset.resourceLoader setDelegate:assetResourceLoader queue:dispatch_get_main_queue()];
    
//    if (player.currentItem) {
//        [player.currentItem removeObserver:self forKeyPath:@"status"];
//        [player.currentItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
//    }
    
    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
//
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    /*
    typedef NS_ENUM(NSInteger, AVPlayerItemStatus) {
        AVPlayerItemStatusUnknown,
        AVPlayerItemStatusReadyToPlay,
        AVPlayerItemStatusFailed
    };
     */
    AVPlayerItemStatus status = [[change objectForKey:@"new"] integerValue];
    if ([keyPath isEqualToString:@"status"] ) {
        if (status == AVPlayerItemStatusReadyToPlay) {
            [self.player play];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
