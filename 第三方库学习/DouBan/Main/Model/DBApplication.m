//
//  DBApplication.m
//  DouBan
//
//  Created by 王伟虎 on 2018/4/21.
//  Copyright © 2018年 wwh. All rights reserved.
//

#import "DBApplication.h"

@implementation DBApplication

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    /*
    typedef NS_ENUM(NSInteger, UIEventSubtype) {
        // available in iPhone OS 3.0
        UIEventSubtypeNone                              = 0,
        
        // for UIEventTypeMotion, available in iPhone OS 3.0
        UIEventSubtypeMotionShake                       = 1,
        
        // for UIEventTypeRemoteControl, available in iOS 4.0
        UIEventSubtypeRemoteControlPlay                 = 100,
        UIEventSubtypeRemoteControlPause                = 101,
        UIEventSubtypeRemoteControlStop                 = 102,
        UIEventSubtypeRemoteControlTogglePlayPause      = 103,
        UIEventSubtypeRemoteControlNextTrack            = 104,
        UIEventSubtypeRemoteControlPreviousTrack        = 105,
        UIEventSubtypeRemoteControlBeginSeekingBackward = 106,
        UIEventSubtypeRemoteControlEndSeekingBackward   = 107,
        UIEventSubtypeRemoteControlBeginSeekingForward  = 108,
        UIEventSubtypeRemoteControlEndSeekingForward    = 109,
    };
     */
    UIEventSubtype subType = event.subtype;
    
    switch (subType) {
        case UIEventSubtypeRemoteControlPlay:
            NSLog(@"");
        break;
        
        default:
        break;
    }
}

@end
