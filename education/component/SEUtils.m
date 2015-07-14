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


+(NSString *)formatMatchWithStartDate:(NSString *)startStr
                                andEndDate:(NSString *)endStr{
    NSDateFormatter *startDateFromatter = [[NSDateFormatter alloc] init];
    //yyyy-MM-dd
    [startDateFromatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [startDateFromatter dateFromString:startStr];
    [startDateFromatter setDateFormat:@"yyyy/MM/dd"];
    NSString *startFormatStr = [startDateFromatter stringFromDate:startDate];
    
    NSDateFormatter *endDateFromatter = [[NSDateFormatter alloc] init];
    [endDateFromatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *endDate = [endDateFromatter dateFromString:endStr];
    [endDateFromatter setDateFormat:@"yyyy/MM/dd"];
    NSString *endFormatStr = [endDateFromatter stringFromDate:endDate];
    
    return  [NSString stringWithFormat:@"%@-%@",startFormatStr,endFormatStr];
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




@end

