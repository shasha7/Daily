//
//  AESCrypt.h
//  Gurpartap Singh
//
//  Created by Gurpartap Singh on 06/05/12.
//  Copyright (c) 2012 Gurpartap Singh

#import <Foundation/Foundation.h>

@interface AES : NSObject

+ (NSString *)encrypt:(NSString *)message password:(NSString *)password;
+ (NSString *)decrypt:(NSString *)base64EncodedString password:(NSString *)password;

@end
