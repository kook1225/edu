//
//  SEUtils.h
//  pacificios
//
//  Created by zhu jun on 14-5-14.
//  Copyright (c) 2014年 SportsExp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface SEUtils : NSObject

/*
+(UserModel *)getUserInfo;
+(void)setUserInfo:(UserModel *)userInfo;
 */
+(NSString *)formatMatchWithStartDate:(NSString *)startStr
                                andEndDate:(NSString *)endStr;

+(BOOL) isValidateMobile:(NSString *)mobile;

+ (NSDate *)dateFromStr:(NSString *)dateStr andFormatter:(NSString *)formatter;


//+(BOOL)isRequestSuccessWithStatusCode:(int)statusCode;
//+(BOOL)checkNetworkWithRequest:(ASIHTTPRequest *)request;


@end
