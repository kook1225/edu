//
//  Tools.h
//  manor_User_ios
//
//  Created by MR.L on 15/5/27.
//  Copyright (c) 2015年 LinQ_Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tools : NSObject
+ (UIBarButtonItem *)getNavBarItem:(id)delegate
                       clickAction:(SEL)clickAction;

+ (void)getNavBarColor:(UIView *)view;
@end
