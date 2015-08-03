//
//  SEUtils.m
//  pacificios
//
//  Created by zhu jun on 14-5-14.
//  Copyright (c) 2014年 SportsExp. All rights reserved.
//

#import "SEUtils.h"

#define USERINFO @"userinfo"

@implementation SEUtils

+(UserModel *)getUserInfo
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *userData = [userDefaults objectForKey:USERINFO];
    if(userData == nil){
        return nil;
    }else{
        NSDictionary *userInfo = [[NSKeyedUnarchiver unarchiveObjectWithData:userData] mutableCopy];
        NSError *error = nil;
        UserModel *user = [[UserModel alloc] initWithDictionary:userInfo error:&error];
        //        NSLog(@"token:%@",userInfo[@"token"]);
        return user;
    }
}


+(void)setUserInfo:(UserModel *)userInfo
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults  setObject:[NSKeyedArchiver archivedDataWithRootObject:[userInfo toDictionary]] forKey:USERINFO];
    [userDefaults synchronize];
}


+ (NSString *)formatMatchWithDate:(NSString *)dateStr {
    NSDateFormatter *startDateFromatter = [[NSDateFormatter alloc] init];
    
    [startDateFromatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startDate = [startDateFromatter dateFromString:dateStr];
    [startDateFromatter setDateFormat:@"ddMM月"];
    NSString *startFormatStr = [startDateFromatter stringFromDate:startDate];
    return  [NSString stringWithFormat:@"%@",startFormatStr];
}

+ (NSString *)formatDateWithString:(NSString *)str {
    NSString *dateStrWithoutT = [str stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSString *dateStr = [dateStrWithoutT componentsSeparatedByString:@"."][0];
    return dateStr;
}

+(BOOL) isValidateMobile:(NSString *)str{
    
    //1[0-9]{10}
    
    //^((13[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$
    
    //    NSString *regex = @"[0-9]{11}";
    
    NSString *regex = @"^[1][3-8]\\d{9}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:str];
    
    if (!isMatch) {
        
        return NO;
        
    }
    return YES;
}



+ (NSDate *)dateFromStr:(NSString *)dateStr andFormatter:(NSString *)formatter
{
    NSDateFormatter *fm = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [fm setTimeZone:timeZone];
    [fm setDateFormat : formatter];
    NSDate *date = [fm dateFromString:dateStr];
    return date;
}

/*
+(NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key
{
    
    NSString *ciphertext = nil;
    NSData *textData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [textData length];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String], kCCKeySizeDES,
                                          (Byte *)[[key dataUsingEncoding:NSUTF8StringEncoding] bytes],
                                          [textData bytes], dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        ciphertext = [Base64 encode:data];
    }
    return ciphertext;
}

+(NSString *)decryptUseDES:(NSString *)cipherText key:(NSString *)key
{
    NSString *plaintext = nil;
    
    NSData *cipherdata = [Base64 decode:cipherText];
    
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String], kCCKeySizeDES,
                                          (Byte *)[[key dataUsingEncoding:NSUTF8StringEncoding] bytes],
                                          [cipherdata bytes], [cipherdata length],
                                          buffer, 1024,
                                          &numBytesDecrypted);
    if(cryptStatus == kCCSuccess) {
        NSData *plaindata = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        plaintext = [[NSString alloc]initWithData:plaindata encoding:NSUTF8StringEncoding];
    }
    return plaintext;
}
*/

// 加密
+ (NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key
{
    NSString *ciphertext = nil;
    const char *textBytes = [plainText UTF8String];
    NSUInteger dataLength = [plainText length];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    Byte iv[] = {1,2,3,4,5,6,7,8};
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String], kCCKeySizeDES,
                                          iv,
                                          textBytes, dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        
        ciphertext = [[NSString alloc] initWithData:[GTMBase64 encodeData:data] encoding:NSUTF8StringEncoding];
    }
    return ciphertext;
}

//DES加密
+ (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeDES,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer);
    return nil;
}

+ (NSString *)setXQ:(NSString *)xq {
    if ([xq  isEqual: @"Monday"]) {
        return @"星期一";
    }
    else if ([xq  isEqual: @"Tuesday"]) {
        return @"星期二";
    }
    else if ([xq  isEqual: @"Wednesday"]) {
        return @"星期三";
    }
    else if ([xq  isEqual: @"Thursday"]) {
        return @"星期四";
    }
    else if ([xq  isEqual: @"Friday"]) {
        return @"星期五";
    }
    else if ([xq  isEqual: @"Saturday"]) {
        return @"星期六";
    }
    else {
        return @"星期天";
    }
}

+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}

@end

