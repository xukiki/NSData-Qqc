//
//  NSData+Qqc.m
//  QqcFramework
//
//  Created by mahailin on 15/8/7.
//  Copyright (c) 2015年 admin. All rights reserved.
//
#import <CommonCrypto/CommonDigest.h>
#import "NSData+Qqc.h"

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

@implementation NSData (Qqc)

/**
 *  将base64的字符串进行解码
 *
 *  @param string base64字符串
 *
 *  @return 返回解码后的NSData
 */
+ (NSData *)dataWithBase64EncodedString:(NSString *)string
{
    if (string == nil)
    {
        [NSException raise:NSInvalidArgumentException format:@"string is null"];
    }
    
    if ([string length] == 0)
    {
        return [NSData data];
    }
    
    static char *decodingTable = NULL;
    
    if (decodingTable == NULL)
    {
        decodingTable = malloc(256);
        
        if (decodingTable == NULL)
        {
            return nil;
        }
        
        memset(decodingTable, CHAR_MAX, 256);
        NSUInteger i;
        
        for (i = 0; i < 64; i++)
        {
            decodingTable[(short)encodingTable[i]] = i;
        }
    }
    
    const char *characters = [string cStringUsingEncoding:NSASCIIStringEncoding];
    
    if (characters == NULL)//  Not an ASCII string!
    {
        return nil;
    }
    
    char *bytes = malloc((([string length] + 3) / 4) * 3);
    
    if (bytes == NULL)
    {
        return nil;
    }
    
    NSUInteger length = 0;
    NSUInteger i = 0;
    
    while (YES)
    {
        char buffer[4];
        short bufferLength;
        
        for (bufferLength = 0; bufferLength < 4; i++)
        {
            if (characters[i] == '\0')
            {
                break;
            }
            
            if (isspace(characters[i]) || characters[i] == '=')
            {
                continue;
            }
            
            buffer[bufferLength] = decodingTable[(short)characters[i]];
            
            if (buffer[bufferLength++] == CHAR_MAX)//  Illegal character!
            {
                free(bytes);
                return nil;
            }
        }
        
        if (bufferLength == 0)
        {
            break;
        }
        
        if (bufferLength == 1)//  At least two characters are needed to produce one byte!
        {
            free(bytes);
            return nil;
        }
        
        //  Decode the characters in the buffer to bytes.
        bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
        
        if (bufferLength > 2)
        {
            bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
        }
        
        if (bufferLength > 3)
        {
            bytes[length++] = (buffer[2] << 6) | buffer[3];
        }
    }
    
    bytes = realloc(bytes, length);
    return [NSData dataWithBytesNoCopy:bytes length:length];
}

/**
 *  将一般的NSData进行base64编码
 *
 *  @param data 一般的NSData
 *
 *  @return 返回编码后的base64字符串
 */
+ (NSString *)base64EncodedStringFrom:(NSData *)data
{
    if ([data length] == 0)
    {
        return @"";
    }
    
    char *characters = malloc((([data length] + 2) / 3) * 4);
    
    if (characters == NULL)
    {
        return nil;
    }
    
    NSUInteger length = 0;
    NSUInteger i = 0;
    
    while (i < [data length])
    {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        
        while (bufferLength < 3 && i < [data length])
        {
            buffer[bufferLength++] = ((char *)[data bytes])[i++];
        }
        
        //  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        
        if (bufferLength > 1)
        {
            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        }
        else
        {
            characters[length++] = '=';
        }
        
        if (bufferLength > 2)
        {
            characters[length++] = encodingTable[buffer[2] & 0x3F];
        }
        else
        {
            characters[length++] = '=';
        }
    }
    
    return [[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES];
}

/**
 *  返回MD5值
 *
 *  @return MD5字节传
 */
- (NSString *)md5HexDigest
{
    const char *str = [self bytes];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)self.length, result);
    
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02X", result[i]];
    }
    
    return [hash lowercaseString];
}

@end
