//
//  NSData+Qqc.h
//  QqcFramework
//
//  Created by mahailin on 15/8/7.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  NSData类别
 */
@interface NSData (Qqc)

/**
 *  将base64的字符串进行解码
 *
 *  @param string base64字符串
 *
 *  @return 返回解码后的NSData
 */
+ (NSData *)dataWithBase64EncodedString:(NSString *)string;

/**
 *  将一般的NSData进行base64编码
 *
 *  @param data 一般的NSData
 *
 *  @return 返回编码后的base64字符串
 */
+ (NSString *)base64EncodedStringFrom:(NSData *)data;

/**
 *  返回MD5值
 *
 *  @return MD5字节传
 */
- (NSString *)md5HexDigest;

@end
