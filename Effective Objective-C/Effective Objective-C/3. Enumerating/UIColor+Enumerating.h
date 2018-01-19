//
//  UIColor+Enumerating.h
//  Effective Objective-C
//
//  Created by 王伟虎 on 2018/1/19.
//  Copyright © 2018年 wwh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Enumerating)

/**
 * 传进来十六进制的色值，转化成RGB颜色
 * @param hexColor 十六进制的色值
 */
+ (UIColor *)colorWithHex:(long)hexColor;

/**
 * 传进来十六进制的色值，转化成RGB颜色
 * @param hexColor 十六进制的色值
 * @param opacity 透明度
 */
+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity;

/**
 * 传进来十六进制的色值字符串，转化成RGB颜色
 * @param stringToConvert 十六进制的色值字符串
 */
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

@end
