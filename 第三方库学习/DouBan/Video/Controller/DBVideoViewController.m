//
//  DBVideoViewController.m
//  DouBan
//
//  Created by wangweihu on 2018/4/19.
//  Copyright © 2018年 wwh. All rights reserved.
//

#import "DBVideoViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface DBVideoViewController ()

@property (nonatomic) AVURLAsset *asset;

@end

@implementation DBVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Little Bit Better" ofType:@"mp3"];
    
    AVURLAsset *asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:path]];
    self.asset = asset;
    NSArray *keys = @[@"availableMetadataFormats", @"duration", @"commonMetadata"];
    
    [asset loadValuesAsynchronouslyForKeys:keys completionHandler:^{
        AVKeyValueStatus status0 = [asset statusOfValueForKey:@"duration" error:nil];
        if (status0 == AVKeyValueStatusLoaded) {
//            NSLog(@"duration = %@", @(1.0 * asset.duration.value/asset.duration.timescale/60));
        }
        
        AVKeyValueStatus status1 = [asset statusOfValueForKey:@"commonMetadata" error:nil];
        if (status1 == AVKeyValueStatusLoaded) {
//            NSLog(@"commonMetadata = %@", asset.commonMetadata);
        }
        
        AVKeyValueStatus status = [asset statusOfValueForKey:@"availableMetadataFormats" error:nil];
        switch (status) {
                /*
                 AVKeyValueStatusUnknown,
                 AVKeyValueStatusLoading,
                 AVKeyValueStatusLoaded,
                 AVKeyValueStatusFailed,
                 AVKeyValueStatusCancelled
                 */
            case AVKeyValueStatusUnknown:
                
                break;
            case AVKeyValueStatusLoading:
                
                break;
            case AVKeyValueStatusLoaded:{
                
                NSArray *array = asset.availableMetadataFormats;
                AVMetadataFormat format = array.firstObject;
                
                [asset loadValuesAsynchronouslyForKeys:@[format] completionHandler:^{
                    AVKeyValueStatus status = [asset statusOfValueForKey:format error:nil];
                    if (status == AVKeyValueStatusLoaded) {
                        NSArray *metaDataItems = [asset metadataForFormat:format];
                        NSLog(@"qqqqqq = %@", [AVMetadataItem metadataItemsFromArray:metaDataItems withKey:AVMetadataCommonKeyTitle keySpace:AVMetadataKeySpaceID3]);
                    }
                }];
            }
                break;
            case AVKeyValueStatusFailed:
                
                break;
            case AVKeyValueStatusCancelled:
                
                break;
                
            default:
                break;
        }
    }];
}

@end
