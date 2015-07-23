//
//  Base64.h
//  education
//
//  Created by zhujun on 15/7/23.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Base64 : NSObject
+(int)char2Int:(char)c;
+(NSData *)decode:(NSString *)data;
+(NSString *)encode:(NSData *)data;
@end
